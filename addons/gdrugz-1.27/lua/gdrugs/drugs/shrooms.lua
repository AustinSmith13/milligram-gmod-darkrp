DRUG.ID = "shrooms";
DRUG.Name = "Mushrooms";
DRUG.Model = "models/gdrugs/shrooms/shrooms.mdl";
DRUG.Ingredients = {
	{ 80, "Psilocybin Spores", "models/props_lab/box01a.mdl" }
};
DRUG.LabTime = 200;
DRUG.LabType = GD_DRUGLAB_POT;
DRUG.SellPrice = 300;
DRUG.ActionText = "Grow";
DRUG.ActionTextPresent = "Growing";
DRUG.ActionTextPast = "Grown";
DRUG.Purity = { 0.9, 1.0 };

DRUG.Duration = 120;
DRUG.DurationCurve = GD_CURVE_POLY;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.MotionBlur.Draw( 0.1, mul, 0 );
	GD.Sharpen.Draw( ( 1.81 + 2 * math.sin( CurTime() * 1 ) ) * mul, 1 + 0.76 * mul );
	GD.Overlay.Draw( "effects/water_warp01", ( 0.06 + 0.03 * math.sin( CurTime() * 7 ) ) * mul, mul );
	
end
