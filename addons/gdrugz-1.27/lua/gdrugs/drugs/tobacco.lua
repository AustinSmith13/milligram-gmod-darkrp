DRUG.ID = "tobacco";
DRUG.Name = "Tobacco";
DRUG.Model = "models/gdrugs/weed/weed.mdl";
DRUG.Ingredients = {
	{ 10, "Tobacco", "models/props_lab/cactus.mdl" }
};
DRUG.LabTime = 45;
DRUG.LabType = GD_DRUGLAB_POT;
DRUG.SellPrice = 70;
DRUG.ActionText = "Grow";
DRUG.ActionTextPresent = "Growing";
DRUG.ActionTextPast = "Grown";
DRUG.Purity = { 0.5, 1.0 };

DRUG.Duration = 1;
DRUG.DurationCurve = GD_CURVE_LINEAR;

function DRUG:RenderScreenspaceEffects( mul )
	
	
	
end
