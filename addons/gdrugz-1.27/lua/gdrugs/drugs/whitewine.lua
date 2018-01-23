DRUG.ID = "whitewine";
DRUG.Name = "White Wine";
DRUG.Model = "models/gdrugs/whitewine/whitewine.mdl";
DRUG.Ingredients = {
	{ 25, "White Grapes", "models/props_junk/metal_paintcan001a.mdl" },
	{ 5, "Yeast", "models/props_junk/MetalBucket01a.mdl" }
};
DRUG.LabTime = 60;
DRUG.LabType = GD_DRUGLAB_BREWERY;
DRUG.SellPrice = 100;
DRUG.ActionText = "Ferment";
DRUG.ActionTextPresent = "Fermenting";
DRUG.ActionTextPast = "Fermented";
DRUG.Purity = { 0.7, 1.0 };

DRUG.Duration = 50;
DRUG.DurationCurve = GD_CURVE_LINEAR;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.MotionBlur.Draw( 0.045, 0.7 * mul, 0.05 );
	
end
