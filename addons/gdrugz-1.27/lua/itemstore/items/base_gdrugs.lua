ITEM.Base = "base_darkrp";
ITEM.Stackable = true;

function ITEM:SaveData( ent )
	
	self:SetData( "Model", ent.DrugModel );
	self:SetData( "DrugID", ent.DrugID );
	self:SetData( "DrugName", ent:GetDrugName() );
	self:SetData( "DrugQuality", ent:GetDrugQuality() );
	
end
function ITEM:LoadData( ent )
	
	ent.DrugModel 		= self:GetData( "Model" );
	ent.DrugID 			= self:GetData( "DrugID" );
	ent:SetDrugName( self:GetData( "DrugName" ) );
	ent:SetDrugQuality( self:GetData( "DrugQuality" ) );
	
end
