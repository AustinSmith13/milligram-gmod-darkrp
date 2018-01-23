DRUG.ID = "meth";
DRUG.Name = "Meth";
DRUG.Model = "models/gdrugs/meth/meth.mdl";
DRUG.Ingredients = {
	{ 10, "Iodine", "models/props_junk/garbage_milkcarton001a.mdl" },
	{ 10, "Red Phosphorus", "models/props_lab/box01a.mdl" },
	{ 20, "Pseudoephedrine", "models/props_lab/jar01a.mdl" },
	{ 100, "Methanol", "models/props_c17/oildrum001.mdl" },
	{ 75, "Methylamine", "models/props_borealis/bluebarrel001.mdl" },
};
DRUG.LabTime = 300;
DRUG.LabType = GD_DRUGLAB_LAB;
DRUG.SellPrice = 600;
DRUG.Purity = { 0.5, 1.0 };

DRUG.Duration = 120;
DRUG.DurationCurve = GD_CURVE_POLY;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.MotionBlur.Draw( 0.2, 1 * mul, 0 );
	GD.Sharpen.Draw( ( 1.39 + 0.5 * math.sin( CurTime() * 5 ) ) * mul, 1 + 0.62 * mul );
	GD.Overlay.Draw( "effects/strider_pinch_dudv", 0.1 * mul, mul );
	
end

function DRUG:OnStart( ply, q )
	
	GAMEMODE:SetPlayerSpeed( ply, GAMEMODE.Config.walkspeed * ( 1 + 0.2 * q ), GAMEMODE.Config.runspeed * ( 1 + 0.5 * q ) );
	ply:SetJumpPower( 190 + 80 * q );
	
end

function DRUG:OnEnd( ply, q )
	
	GAMEMODE:SetPlayerSpeed( ply, GAMEMODE.Config.walkspeed, GAMEMODE.Config.runspeed );
	ply:SetJumpPower( 190 );
	
end
