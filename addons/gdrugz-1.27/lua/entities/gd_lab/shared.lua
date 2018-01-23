ENT.Type = "anim";
ENT.Base = "base_anim";

ENT.PrintName		= "Drug Lab";
ENT.Author			= "disseminate";
ENT.Contact			= "";
ENT.Purpose			= "";
ENT.Instructions	= "";

ENT.Spawnable			= false;
ENT.AdminSpawnable		= false;

function ENT:SetupDataTables()
	
	self:NetworkVar( "Int", 0, "DrugLabType" );
	self:NetworkVar( "Int", 1, "LabHealth" );
	self:NetworkVar( "Float", 0, "DrugStartTime" );
	self:NetworkVar( "Float", 1, "DrugCompleteTime" );
	self:NetworkVar( "Float", 2, "DrugQuality" );
	self:NetworkVar( "String", 0, "DrugInProgress" );
	self:NetworkVar( "Entity", 0, "User" );
	self:NetworkVar( "Entity", 1, "Cook" );
	
end

function ENT:Cooking()
	
	if( CurTime() < self:GetDrugCompleteTime() ) then return true end
	return false;
	
end

function ENT:Cooked()
	
	if( CurTime() >= self:GetDrugCompleteTime() and self:GetDrugCompleteTime() > 0 ) then return true end
	return false;
	
end

function ENT:GetBaseHealth()
	
	if( self:GetDrugLabType() == GD_DRUGLAB_LAB ) then
		
		return GD.DrugLabHealth;
		
	elseif( self:GetDrugLabType() == GD_DRUGLAB_POT ) then
		
		return GD.DrugPotHealth;
		
	elseif( self:GetDrugLabType() == GD_DRUGLAB_BREWERY ) then
		
		return GD.BreweryHealth;
		
	end
	
	return -1;
	
end

function ENT:ProgressMul()
	
	local d = CurTime() - self:GetDrugStartTime();
	local m = d / ( self:GetDrugCompleteTime() - self:GetDrugStartTime() );
	
	return math.Clamp( m, 0, 1 );
	
end
