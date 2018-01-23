--Time, in seconds, to wait before respawning the door
CreateConVar( "doorbreach_respawntime", 30 )

--Classname for doors
local entityType = "prop_door_rotating"

function Breach( ent, force, hitpos )
	local self = ent

	if not IsValid( ent ) then return end

	if ( ent:GetClass() != entityType ) then
		return false
	end

	-- If the door hasn't been breached already
	if ( not self.DoorBreachExploded ) then
		
		--Stores where the damage hit
		local damPos = self:OBBCenter()
			
		--Set it as having died
		self.DoorBreachExploded = true
		
		--Set the door to be, as far as the player knows, non-existant
		self:SetNotSolid( true )
		self:SetNoDraw( true )
		
		--Create the fake, exploded "prop door" and make sure it matches the original door as closely as possible
		local propDoor = ents.Create( "prop_physics" )
		propDoor:SetModel( self:GetModel() )
		propDoor:SetMaterial( self:GetMaterial() )
		propDoor:SetColor( self:GetColor() )
		propDoor:SetPos( self:GetPos() )
		propDoor:SetAngles( self:GetAngles() )
		propDoor:SetSkin( self:GetSkin() )
		
		--Ensures that the handle on the prop door is the same as the one on the real door
		local bodyGroupID = self:FindBodygroupByName( "handle01" )
		propDoor:SetBodygroup( bodyGroupID, self:GetBodygroup( bodyGroupID ) )
		
		propDoor:Spawn()
		
		--Unlock the door
		self:Fire( "unlock", "", 0 )
		
		--Set the door's velocity on the prop door like it was the original door
		propDoor:GetPhysicsObject():ApplyForceOffset( force, self:OBBCenter() )
		
		--Set a timer to respawn the door after the appropriate time
		timer.Simple( GetConVar( "doorbreach_respawntime"):GetFloat(), function()
			if not IsValid( self ) then return end
				
			--Start sending information to players again
			for k,v in pairs( player.GetAll() ) do
				self:SetPreventTransmit( v, false )
			end
		
			--Set the door to alive
			self.DoorBreachExploded = nil
			
			--"respawn" the door by resetting it to it's standard values
			self:SetNotSolid( false )
			self:SetNoDraw( false )
			
			--If it exists, remove the prop door
			if IsValid( propDoor ) then
				propDoor:Remove()
			end
			
		end)

		return true
		
	end
end

--Handles players trying to use breached doors
hook.Add( "PlayerUse", "DoorBreachSuppressUse", function( ply, ent )
	if not IsValid( ent ) then return end
	
	--If the door has been destroyed already, stop the player from trying to open or close it
	if ent.DoorBreachExploded then
		return false
	end
end)