DRUG.ID = "coke";
DRUG.Name = "Cocaine";
DRUG.Model = "models/gdrugs/cocaine/cocaine.mdl";
DRUG.Ingredients = {
	{ 290, "Coca Leaf", "models/props_lab/cactus.mdl" }
};
DRUG.LabTime = 215;
DRUG.LabType = GD_DRUGLAB_POT;
DRUG.SellPrice = 580;
DRUG.Purity = { 0.5, 1.0 };

DRUG.ActionText = "Grow";
DRUG.ActionTextPresent = "Growing";
DRUG.ActionTextPast = "Grown";

DRUG.Duration = 120;
DRUG.DurationCurve = GD_CURVE_POLY;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.Sharpen.Draw( 3.80 * mul, 1 + ( 3 * ( 1 + math.min( math.cos( CurTime() * 4 ), 10 ) ) ) * mul );
	
	local tab = { };
	tab["$pp_colour_addr"] 			= 0;
	tab["$pp_colour_addg"] 			= 0;
	tab["$pp_colour_addb"] 			= 0;
	tab["$pp_colour_brightness"] 	= 0.02 * mul;
	tab["$pp_colour_contrast"]		= 1 + 0.06 * mul;
	tab["$pp_colour_colour"] 		= 1 - 0.33 * mul;
	tab["$pp_colour_mulr"] 			= 0;
	tab["$pp_colour_mulg"] 			= 0;
	tab["$pp_colour_mulb"] 			= 0;
	GD.Colormod.Draw( tab );
	
end

function DRUG:OnStart( ply, q )
	
	if( SERVER ) then
		
		ply.GDDamageMul = 1 - 0.7 * q;
		
	end
	
end

function DRUG:OnEnd( ply, q )
	
	if( SERVER ) then
		
		ply.GDDamageMul = nil;
		
	end
	
end
