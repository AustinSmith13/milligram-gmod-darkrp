DRUG.ID = "ket";
DRUG.Name = "Ketamine";
DRUG.Model = "models/gdrugs/cocaine/cocaine.mdl";
DRUG.Ingredients = {
	{ 40, "Cyclopentyl Bromide", "models/props_junk/garbage_plasticbottle002a.mdl" },
	{ 10, "Bromine", "models/props_junk/metalgascan.mdl" },
	{ 200, "Methylamine", "models/props_borealis/bluebarrel001.mdl" },
	{ 20, "Hydrochloric Acid", "models/props_junk/glassjug01.mdl" },
};
DRUG.LabTime = 210;
DRUG.LabType = GD_DRUGLAB_LAB;
DRUG.SellPrice = 550;
DRUG.Purity = { 0.5, 1.0 };

DRUG.Duration = 160;
DRUG.DurationCurve = GD_CURVE_POLY;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.MotionBlur.Draw( 0.05, 0.32, 0.02 );
	
	local tab = { };
	tab["$pp_colour_addr"] 			= 0;
	tab["$pp_colour_addg"] 			= 0;
	tab["$pp_colour_addb"] 			= 0;
	tab["$pp_colour_brightness"] 	= 0.09 * mul;
	tab["$pp_colour_contrast"]		= 1 + 0.8 * mul;
	tab["$pp_colour_colour"] 		= 1 + 0.5 * mul * math.sin( CurTime() / 3 );
	tab["$pp_colour_mulr"] 			= 00;
	tab["$pp_colour_mulg"] 			= 0;
	tab["$pp_colour_mulb"] 			= 0;
	GD.Colormod.Draw( tab );
	
	GD.Overlay.Draw( "gdrugs/mdma", 0.07 * math.sin( CurTime() / 5 ) * mul, mul );
	
end

function DRUG:GetFOV( fov, mul )
	
	return fov + 20 * mul;
	
end
