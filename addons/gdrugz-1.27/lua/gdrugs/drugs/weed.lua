DRUG.ID = "weed";
DRUG.Name = "Weed";
DRUG.Model = "models/gdrugs/weed/weed.mdl";
DRUG.Ingredients = {
	{ 40, "Cannabis", "models/props_lab/cactus.mdl" }
};
DRUG.LabTime = 180;
DRUG.LabType = GD_DRUGLAB_POT;
DRUG.SellPrice = 230;
DRUG.ActionText = "Grow";
DRUG.ActionTextPresent = "Growing";
DRUG.ActionTextPast = "Grown";
DRUG.Purity = { 0.9, 1.0 };

DRUG.Duration = 180;
DRUG.DurationCurve = GD_CURVE_LINEAR;

function DRUG:RenderScreenspaceEffects( mul )
	
	GD.MotionBlur.Draw( 0.1, 0.9 * mul, 0 );
	
end

function DRUG:OnStart( ply, q )
	
	GAMEMODE:SetPlayerSpeed( ply, GAMEMODE.Config.walkspeed * ( 1 - 0.2 * q ), GAMEMODE.Config.runspeed * ( 1 - 0.2 * q ) );
	
end

function DRUG:OnEnd( ply, q )
	
	GAMEMODE:SetPlayerSpeed( ply, GAMEMODE.Config.walkspeed, GAMEMODE.Config.runspeed );
	
end

function DRUG:GetFOV( fov, mul )
	
	return fov - 5 * mul;
	
end
