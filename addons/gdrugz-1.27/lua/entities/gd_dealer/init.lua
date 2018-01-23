AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( table.Random( GD.NPCModels ) );
	
	self:SetMoveType( MOVETYPE_STEP );
	self:SetSolid( SOLID_BBOX );
	
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
	
	self:CapabilitiesAdd( bit.bor( CAP_TURN_HEAD, CAP_ANIMATEDFACE ) );
	
	self:SetUseType( SIMPLE_USE );
	
end

function ENT:AcceptInput( input, activator, caller )
	
	if( input == "Use" ) then
		
		GD.DealerNPCUsed( self, activator );
		
	end
	
end

function ENT:SpawnDrug( t )
	
	local p = self:EyePos() + self:GetForward() * 20;
	
	local ent = ents.Create( "gd_" .. t );
	ent:SetPos( p );
	ent:SetAngles( self:GetAngles() );
	ent:SetDrugName( "" );
	ent:SetDrugQuality( math.Rand( GD.Drugs[t].Purity[1], GD.Drugs[t].Purity[2] ) );
	ent:Spawn();
	ent:Activate();
	
end

function ENT:UpdateTransmitState()
	
	return TRANSMIT_ALWAYS;
	
end

function ENT:Think()

	if( self.SpawnedPosition and GD.FreezeNPCs ) then

		local dist = self:GetPos():Distance( self.SpawnedPosition );
		if( dist > 16 ) then
			self:SetPos( self.SpawnedPosition );
			self:SetAngles( self.SpawnedAngles );
		end

	end

end

function ENT:SelectSchedule( state )
	
	
	
end
