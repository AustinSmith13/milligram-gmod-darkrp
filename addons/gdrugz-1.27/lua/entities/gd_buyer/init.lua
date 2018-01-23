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
		
		GD.NPCUsed( self, activator );
		
	end
	
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
