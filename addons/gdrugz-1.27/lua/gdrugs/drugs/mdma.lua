DRUG.ID = "mdma";
DRUG.Name = "MDMA";
DRUG.Model = "models/gdrugs/mdma/mdma.mdl";
DRUG.Ingredients = {
	{ 150, "Methylene Chloride", "models/props_junk/metal_paintcan001a.mdl" },
	{ 100, "Dimethylformamide", "models/props_junk/garbage_plasticbottle001a.mdl" },
	{ 10, "Sassafras", "models/props_lab/cactus.mdl" },
	{ 60, "Benzoquinone", "models/props_junk/garbage_plasticbottle002a.mdl" },
};
DRUG.LabTime = 200;
DRUG.LabType = GD_DRUGLAB_LAB;
DRUG.SellPrice = 575;
DRUG.Purity = { 0.6, 1.0 };

DRUG.Duration = 180;
DRUG.DurationCurve = GD_CURVE_POLY;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.Bloom.DrawBloom( 1 - 0.2 * mul, 6, 4, 4, 3, 5, 1, 1, 1 );
	GD.MotionBlur.Draw( 0.1, 0.6 * mul, 0 );
	
	local tab = { };
	tab["$pp_colour_addr"] 			= 0;
	tab["$pp_colour_addg"] 			= 0;
	tab["$pp_colour_addb"] 			= 0;
	tab["$pp_colour_brightness"] 	= 0.09 * mul;
	tab["$pp_colour_contrast"]		= 1 + 0.06 * mul;
	tab["$pp_colour_colour"] 		= 1 + 0.32 * mul;
	tab["$pp_colour_mulr"] 			= 0.6 * mul;
	tab["$pp_colour_mulg"] 			= 0;
	tab["$pp_colour_mulb"] 			= 0;
	GD.Colormod.Draw( tab );
	
	GD.Overlay.Draw( "gdrugs/mdma", ( 0.04 + 0.003 * math.sin( CurTime() * 3 ) ) * mul, mul );
	
end
--[[
function DRUG:RenderHalos( mul )
	
	if( mul <= 0 ) then return end
	
	for _, v in pairs( player.GetAll() ) do
		
		local h = v:Health();
		local col = Color( 0, 255, 0, 255 * mul );
		if( h < 30 ) then
			col = Color( 255, 0, 0, 255 * mul );
		elseif( h < 70 ) then
			col = Color( 255, 255, 0, 255 * mul );
		end
		
		halo.Add( { v }, col, 2 / mul, 2 / mul, 1, true, false );
		
	end
	
end
--]]
