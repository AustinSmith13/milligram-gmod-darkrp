DRUG.ID = "lsd";
DRUG.Name = "LSD";
DRUG.Model = "models/props_junk/garbage_newspaper001a.mdl";
DRUG.Ingredients = {
	{ 50, "Benzoyl Chloride", "models/props_junk/garbage_plasticbottle002a.mdl" },
	{ 10, "Sodium Hydroxide", "models/props_junk/garbage_plasticbottle001a.mdl" },
	{ 60, "3-Indolepropionic Acid", "models/props_junk/garbage_plasticbottle001a.mdl" },
	{ 20, "Hydrochloric Acid", "models/props_junk/glassjug01.mdl" },
};
DRUG.LabTime = 120;
DRUG.LabType = GD_DRUGLAB_LAB;
DRUG.SellPrice = 300;
DRUG.Purity = { 0.5, 1.0 };

DRUG.Duration = 300;
DRUG.DurationCurve = GD_CURVE_POLY;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.Bloom.DrawBloom( 1 - 0.27 * mul, 3.26, 20, 20, 3, 2.69, 1, 1, 1 );
	GD.MotionBlur.Draw( 0.08, 0.61 * mul, 0 );
	GD.Overlay.Draw( "gdrugs/lsd", 0.5 * math.sin( CurTime() * 3 ) * mul, mul );
	
end
