AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( self.DrugModel );
	
	self:SetCustomCollisionCheck( true );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local phys = self:GetPhysicsObject();
	
	if( phys and phys:IsValid() ) then
		
		phys:Wake();
		
	end
	
	self.SpawnTime = CurTime();
	
end

function ENT:SpawnFunction( ply, tr, class )
	
	if( !tr.Hit ) then return end
	
	local pos = tr.HitPos + tr.HitNormal * 16;
	
	local ent = ents.Create( class );
	ent:SetPos( pos );
	ent:SetDrugName( "" );
	if( self.DrugQualityMin and self.DrugQualityMax ) then
		ent:SetDrugQuality( math.Rand( self.DrugQualityMin, self.DrugQualityMax ) );
	end
	ent:Spawn();
	ent:Activate();
	
	return ent;
	
end

function ENT:Use( ply, caller, ut, val )
	
	if( GD.CanOverdose ) then
		
		if( #ply.GDrugs >= GD.OverdoseCount - 1 ) then
			
			ply:Kill();
			self:Remove();
			return;
			
		end
		
	end
	
	local k = table.insert( ply.GDrugs, self.DrugID );
	ply.GDrugStarts[k] = CurTime();
	ply.GDrugQualities[k] = self:GetDrugQuality();
	
	net.Start( "nGDStartDrug" );
		net.WriteString( self.DrugID );
		net.WriteFloat( self:GetDrugQuality() );
	net.Send( ply );
	
	local drug = GD.Drugs[self.DrugID];
	
	if( drug.OnStart ) then
		
		drug:OnStart( ply, self:GetDrugQuality() );
		
	end
	
	self:Remove();
	
end

function ENT:PhysicsCollide( data, phys )
	
	if( self.Player and self.Player:IsValid() and data.HitEntity and data.HitEntity:IsValid() and ( data.HitEntity:GetClass() == "gd_buyer" or ( data.HitEntity:GetClass() == "gd_dealer" and GD.DealersTakeDrugs ) ) ) then
		
		local p = math.floor( math.Rand( GD.NPCMultiplierMin, GD.NPCMultiplierMax ) * GD.RevenueMultiplier * self:GetDrugQuality() * GD.Drugs[self.DrugID].SellPrice );
		
		net.Start( "nGDNPCGiven" );
			net.WriteUInt( p, 32 );
		net.Send( self.Player );
		
		GD.AddMoney( self.Player, p );
		
		self:Remove();
		
	end
	
end

function ENT:Think()
	
	if( self.SpawnTime and CurTime() > self.SpawnTime + ( GD.DrugDespawnTime * 60 * 60 ) ) then
		
		self:Remove();
		
	end
	
end
