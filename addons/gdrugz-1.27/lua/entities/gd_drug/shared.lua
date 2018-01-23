ENT.Type = "anim";
ENT.Base = "base_anim";

ENT.PrintName		= "Drug";
ENT.Author			= "disseminate";
ENT.Contact			= "";
ENT.Purpose			= "";
ENT.Instructions	= "";

ENT.Spawnable			= false;
ENT.AdminSpawnable		= false;

function ENT:SetupDataTables()
	
	self:NetworkVar( "String", 0, "DrugName" );
	self:NetworkVar( "Float", 0, "DrugQuality" );
	
end
