AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( "models/props_lab/jar01b.mdl" );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local phys = self:GetPhysicsObject();
	
	if( phys and phys:IsValid() ) then
		
		phys:Wake();
		
	end
	
	self:SetUseType( SIMPLE_USE );
	
end

function ENT:Use( ply, caller, type, val )
	
	net.Start( "nGDTestKitInstructions" );
	net.Send( ply );
	
	self.Player = ply;
	
end

function ENT:Think()
	
	if( self.Player and !self.Player:IsValid() ) then
		
		self:Remove();
		
	end
	
end

function ENT:PhysicsCollide( data, phys )
	
	if( data.HitEntity and data.HitEntity:IsValid() and data.HitEntity.GDrug ) then
		
		net.Start( "nGDTestKit" );
			net.WriteFloat( data.HitEntity:GetDrugQuality() );
			net.WriteString( data.HitEntity.DrugID );
		net.Send( self.Player );
		
		self:Remove();
		
	end
	
end
