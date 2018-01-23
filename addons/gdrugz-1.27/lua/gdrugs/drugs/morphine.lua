DRUG.ID = "morphine";
DRUG.Name = "Morphine";
DRUG.Model = "models/props_lab/jar01b.mdl";
DRUG.Ingredients = {
	{ 50, "Poppy Seed", "models/props_lab/cactus.mdl" },
	{ 30, "Ethanol", "models/props_junk/metal_paintcan001a.mdl" },
	{ 60, "Ammonia", "models/props_c17/oildrum001.mdl" },
	{ 10, "Sodium Hydroxide", "models/props_borealis/bluebarrel001.mdl" },
};
DRUG.LabTime = 180;
DRUG.LabType = GD_DRUGLAB_LAB;
DRUG.SellPrice = 400;
DRUG.Purity = { 0.5, 1.0 };

DRUG.Duration = 10;
DRUG.DurationCurve = GD_CURVE_POLY;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.MotionBlur.Draw( 0.5, 1 * mul, 0 );
	GD.Overlay.Draw( "effects/strider_pinch_dudv", 0.3 * mul, mul );
	
end

function DRUG:OnStart( ply, q )
	
	ply:SetHealth( math.Clamp( ply:Health() + 50, 0, 100 ) );
	
end
