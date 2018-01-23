DRUG.ID = "vodka";
DRUG.Name = "Vodka";
DRUG.Model = "models/props_junk/glassjug01.mdl";
DRUG.Ingredients = {
	{ 10, "Potatoes", "models/props_junk/garbage_bag001a.mdl" },
	{ 10, "Malt Barley", "models/props_junk/plasticbucket001a.mdl" },
	{ 5, "Yeast", "models/props_junk/MetalBucket01a.mdl" }
};
DRUG.LabTime = 30;
DRUG.LabType = GD_DRUGLAB_BREWERY;
DRUG.SellPrice = 60;
DRUG.ActionText = "Distill";
DRUG.ActionTextPresent = "Distilling";
DRUG.ActionTextPast = "Distilled";
DRUG.Purity = { 0.7, 1.0 };

DRUG.Duration = 60;
DRUG.DurationCurve = GD_CURVE_LINEAR;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.MotionBlur.Draw( 0.05, 0.9 * mul, 0.06 );
	
end
