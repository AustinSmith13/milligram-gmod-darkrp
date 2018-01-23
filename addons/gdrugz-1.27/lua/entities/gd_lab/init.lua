AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	
	if( self:GetDrugLabType() == GD_DRUGLAB_LAB ) then
		self:SetModel( GD.DrugLabModel );
	elseif( self:GetDrugLabType() == GD_DRUGLAB_POT ) then
		self:SetModel( GD.DrugPotModel );
	elseif( self:GetDrugLabType() == GD_DRUGLAB_BREWERY ) then
		self:SetModel( GD.BreweryModel );
	end
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local phys = self:GetPhysicsObject();
	
	if( phys and phys:IsValid() ) then
		
		phys:Wake();
		
		if( phys:GetMass() > 250 ) then
			
			phys:SetMass( 250 );
			
		end
		
	end
	
	self:SetUseType( SIMPLE_USE );
	
	if( GD.DrugLabsDamageable ) then
		
		self:SetLabHealth( self:GetBaseHealth() );
		
	end
	
	for _, v in pairs( self:GetBodyGroups() ) do
		
		if( v.name == "grow" ) then
			
			self.BodygroupID = v.id;
			self.BodygroupNum = v.num;
			break;
			
		end
		
	end
	
	if( GD.LabSounds and self:GetDrugLabType() == GD_DRUGLAB_LAB ) then
		
		self.LabSound = CreateSound( self, "ambient/machines/electric_machine.wav" );
		self.LabSound:SetSoundLevel( 60 );
		
	end
	
end

function ENT:SpawnDrug( name )
	
	local m = string.lower( self:GetModel() );
	local o = self:OBBMaxs().z + 15;
	local p = self:GetPos() + self:GetUp() * o;
	
	if( m == "models/props_c17/furnitureboiler001a.mdl" ) then
		
		p = self:GetPos() + self:GetUp() * -30 + self:GetForward() * 22 + self:GetRight() * 6;
		
	end
	
	local ent = ents.Create( "gd_" .. self:GetDrugInProgress() );
	ent:SetPos( self:GetPos() + self:GetUp() * 80 );
	ent:SetAngles( self:GetAngles() );
	if( name != "" ) then
		ent:SetDrugName( name );
	else
		ent:SetDrugName( "" );
	end
	ent:SetDrugQuality( self:GetDrugQuality() );
	ent:Spawn();
	ent:Activate();
	
end

function ENT:OnTakeDamage( dmginfo )
	
	if( GD.DrugLabsDamageable ) then
		
		self:SetLabHealth( self:GetLabHealth() - dmginfo:GetDamage() );
		
		if( self:GetLabHealth() <= 0 ) then
			
			self:Destroy();
			
		end
		
	end
	
end

function ENT:Destroy()
	
	if( self:GetDrugLabType() == GD_DRUGLAB_LAB or self:GetDrugLabType() == GD_DRUGLAB_BREWERY ) then
		
		local ed = EffectData();
		ed:SetStart( self:GetPos() );
		ed:SetOrigin( self:GetPos() );
		util.Effect( "Explosion", ed );
		
	elseif( self:GetDrugLabType() == GD_DRUGLAB_POT ) then
		
		self:EmitSound( Sound( "physics/surfaces/tile_impact_bullet" .. math.random( 1, 4 ) .. ".wav" ) );
		
	end
	
	self:Remove();
	
end

function ENT:OnRemove()
	
	if( self.LabSound ) then
		
		self.LabSound:Stop();
		
	end
	
	self.LabSound = nil;
	
end

function ENT:Think()
	
	if( self:GetUser() and self:GetUser():IsValid() ) then
		
		if( self.UserTime and CurTime() >= self.UserTime + GD.CookTimeout ) then
			
			net.Start( "nGDForceGUIClose" );
			net.Send( self:GetUser() );
			
			self:SetUser( NULL );
			self.UserTime = nil;
			
		elseif( self:GetUser():GetPos():Distance( self:GetPos() ) > 128 ) then
			
			net.Start( "nGDForceGUIClose" );
			net.Send( self:GetUser() );
			
			self:SetUser( NULL );
			self.UserTime = nil;
			
		end
		
	end
	
	if( self:GetCook() ) then
		
		if( !self:GetCook():IsValid() and self:GetDrugInProgress() != "" ) then
			
			self:SetUser( NULL );
			self.UserTime = nil;
			
			self:SetDrugInProgress( "" );
			self:SetCook( NULL );
			self:SetDrugStartTime( -1 );
			self:SetDrugCompleteTime( -1 );
			self:SetDrugQuality( -1 );
			
		end
		
	end
	
	if( self.LabSound and GD.LabSounds and ( self:GetDrugLabType() == GD_DRUGLAB_LAB or self:GetDrugLabType() == GD_DRUGLAB_BREWERY ) ) then
		
		if( self:Cooked() and self.PlayingLabSound ) then
			
			self.LabSound:FadeOut( 1 );
			self.PlayingLabSound = false;
			
		elseif( self:Cooking() and !self.PlayingLabSound ) then
			
			self.LabSound:PlayEx( 0, 100 );
			self.LabSound:ChangeVolume( 0.6, 1 );
			self.PlayingLabSound = true;
			
		end
		
	end
	
	if( self.BodygroupID ) then
		
		local b = self:GetBodygroup( self.BodygroupID );
		local targ = b;
		
		if( self:Cooking() ) then
			
			local f = self:ProgressMul();
			targ = math.floor( f * ( self.BodygroupNum - 1 ) );
			
		elseif( self:Cooked() ) then
			
			targ = self.BodygroupNum - 1;
			
		else
			
			targ = 0;
			
		end
		
		if( targ != b ) then
			
			self:SetBodygroup( self.BodygroupID, targ );
			
		end
		
	end
	
end

function ENT:Use( ply, caller, type, val )
	
	if( self:GetUser() and self:GetUser():IsValid() ) then
		
		if( self:GetUser() != ply and self:GetUser():GetPos():Distance( self:GetPos() ) <= 128 ) then
			
			return;
			
		end
		
	end
	
	if( GD.RestrictUseToCook ) then
		
		if( ply.SID != self.SID ) then
			
			net.Start( "nGDDisallowedLabUse" );
			net.Send( ply );
			return;
			
		end
		
	end
	
	if( GD.RestrictDrugToCook ) then
		
		if( self:Cooked() and self:GetCook() != ply ) then
			
			net.Start( "nGDDisallowedLabCooked" );
			net.Send( ply );
			return;
			
		end
		
	end
	
	self:SetUser( ply );
	self.UserTime = CurTime();
	
	net.Start( "GD.OpenDrugLab" );
		net.WriteEntity( self );
	net.Send( ply );
	
end
