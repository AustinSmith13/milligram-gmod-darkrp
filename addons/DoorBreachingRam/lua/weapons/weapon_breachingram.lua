
AddCSLuaFile()

SWEP.PrintName = "Breaching Ram"
SWEP.Author = "A1steaksa"
SWEP.Purpose = "Left click to relieve doors of their hinges, props of their constraints, and people of their freedom"

SWEP.Slot = 5
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_rpg.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rocket_launcher.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Range = 45
SWEP.Force = 25000

//Delay between fires, in seconds.
SWEP.FireDelay = 10
//How long, in seconds, should fading doors remain faded after being rammed?
SWEP.FadeTime = 10

sound.Add( {
	name = "breaching_sound",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "physics/wood/wood_panel_break1.wav"
} )

function SWEP:Initialize()
	self:SetHoldType( "rpg" )
	self:SetNextPrimaryFire( CurTime() )
	
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:Deploy()
	self:SetMaterial( "phoenix_storms/gear" )
	return true
end

function SWEP:PreDrawViewModel(vm)
    if not IsValid(vm) then return end
    vm:SetMaterial( "phoenix_storms/gear" )
end

function SWEP:ViewModelDrawn(vm)
    if not IsValid(vm) then return end
    vm:SetMaterial()
end

function SWEP:Holster()
	self:SetMaterial()
	return true
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() - CurTime() >=  self.FireDelay then
		return
	end

	local tr = util.TraceLine({
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * self.Range,
		filter = self.Owner,
	})

	local ent = tr.Entity
	if not IsValid( ent ) then return end

	local success = false

	if ( ent:GetClass() == "func_door" or ent:GetClass() == "func_movelinear" ) then
		if ( SERVER ) then
			ent:Fire( "unlock", "", 0 )
			ent:Fire( "open", "", 0 )
			self:SetNextPrimaryFire( CurTime() + self.FireDelay )
		end
		success = true
	elseif ( ent:GetClass() == "prop_door_rotating" ) then
		if ( SERVER ) then
			local force = tr.Normal
			force:Mul( self.Force )
			Breach( ent, force, tr.HitPos )
		end
		success = true
	elseif ( ent:GetClass() == "prop_physics" ) then
		if ( SERVER ) then
				
			if ( isfunction( ent.Fade ) ) then
				ent:Fade( true )
				timer.Simple( self.FadeTime, function()
					if ( not IsValid( ent ) ) then return end
					ent:Fade( false )
				end)
			else
				local phys = ent:GetPhysicsObject()
				if IsValid( phys ) then phys:EnableMotion( true ) end
				constraint.RemoveConstraints( ent, "Weld" )
				if ( not IsValid( self ) or not IsValid( ent ) ) then return end
			end
			success = true
		end
	elseif ( ent:IsVehicle() ) then
		if ( SERVER ) then
			local ply = ent:GetDriver()
			if ( IsValid( ply ) ) then
				ply:ExitVehicle()
				ent:Fire( "lock" )
			end
		end
		success = true
	end

	if success then
		self:EmitSound( "breaching_sound" )
		self:SetNextPrimaryFire( CurTime() + self.FireDelay )
		self.Owner:ViewPunch( Angle( -60, math.random(), 0 ) )
	end
end

function SWEP:SecondaryAttack()
	if self:GetNextPrimaryFire() - CurTime() >=  self.FireDelay then
		return
	end

	local tr = util.TraceLine({
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * self.Range,
		filter = self.Owner,
	})

	local ent = tr.Entity
	if not IsValid( ent ) then return end

	local success = false

	if ( ent:GetClass() == "player" and self.Owner:IsSuperAdmin() ) then
		local force = tr.Normal
		force:Mul( self.Force )
		ent:SetVelocity( force/2 )
		success = true
	end

	if success then
		self:EmitSound( "breaching_sound" )
		self:SetNextPrimaryFire( CurTime() + self.FireDelay )
		self.Owner:ViewPunch( Angle( -60, math.random(), 0 ) )
	end
end