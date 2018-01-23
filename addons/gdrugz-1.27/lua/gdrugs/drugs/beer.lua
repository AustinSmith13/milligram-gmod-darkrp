DRUG.ID = "beer";
DRUG.Name = "Beer";
DRUG.Model = "models/props_junk/GlassBottle01a.mdl";
DRUG.Ingredients = {
	{ 5, "Hops", "models/props_junk/metal_paintcan001a.mdl" },
	{ 8, "Malt Barley", "models/props_junk/plasticbucket001a.mdl" },
	{ 5, "Yeast", "models/props_junk/MetalBucket01a.mdl" }
};
DRUG.LabTime = 20;
DRUG.LabType = GD_DRUGLAB_BREWERY;
DRUG.SellPrice = 40;
DRUG.ActionText = "Brew";
DRUG.ActionTextPresent = "Brewing";
DRUG.ActionTextPast = "Brewed";
DRUG.Purity = { 0.8, 1.0 };

DRUG.Duration = 60;
DRUG.DurationCurve = GD_CURVE_LINEAR;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.MotionBlur.Draw( 0.04, 0.7 * mul, 0.05 );
	
end
