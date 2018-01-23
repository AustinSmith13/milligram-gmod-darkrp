GD = GD or { };

include( "sh_enum.lua" );
include( "gdrugs_config.lua" );
include( "sh_init.lua" );
include( "cl_gui.lua" );
include( "cl_npc.lua" );
include( "cl_skin.lua" );

GD.MotionBlur = { };
GD.MotionBlur.mat_MotionBlur	= Material( "pp/motionblur" );
GD.MotionBlur.mat_Screen		= Material( "pp/fb" );
GD.MotionBlur.tex_MotionBlur	= render.GetMoBlurTex0();
GD.MotionBlur.NextDraw 		= 0;
GD.MotionBlur.LastDraw 		= 0;
function GD.MotionBlur.Draw( addalpha, drawalpha, delay )
	
	if( !GD.DrawMotionBlur ) then return end
	if( drawalpha == 0 ) then return end
	
	render.UpdateScreenEffectTexture();
	
	if( CurTime() - GD.MotionBlur.LastDraw > 0.5 ) then
		
		GD.MotionBlur.mat_Screen:SetFloat( "$alpha", 1 );
		
		local OldRT = render.GetRenderTarget();
		render.SetRenderTarget( GD.MotionBlur.tex_MotionBlur );
			render.SetMaterial( GD.MotionBlur.mat_Screen );
			render.DrawScreenQuad();
		render.SetRenderTarget( OldRT );
		
	end
	
	GD.MotionBlur.mat_MotionBlur:SetFloat( "$alpha", drawalpha );
	GD.MotionBlur.mat_MotionBlur:SetTexture( "$basetexture", GD.MotionBlur.tex_MotionBlur );
	
	if( GD.MotionBlur.NextDraw < CurTime() and addalpha > 0 ) then
		
		GD.MotionBlur.NextDraw = CurTime() + delay;
		
		GD.MotionBlur.mat_Screen:SetFloat( "$alpha", addalpha );
		local OldRT = render.GetRenderTarget();
		render.SetRenderTarget( GD.MotionBlur.tex_MotionBlur );
		
		render.SetMaterial( GD.MotionBlur.mat_Screen );
		render.DrawScreenQuad();
		
		render.SetRenderTarget( OldRT );
		
	end
	
	render.SetMaterial( GD.MotionBlur.mat_MotionBlur );
	render.DrawScreenQuad();
	
	GD.MotionBlur.LastDraw = CurTime();
	
end

GD.Overlay = { };
GD.Overlay.lastTexture = nil
GD.Overlay.mat_Overlay = nil
function GD.Overlay.Draw( texture, refractamount, alpha )
	
	if( !GD.DrawOverlays ) then return end
	
	if( texture != GD.Overlay.lastTexture or GD.Overlay.mat_Overlay == nil ) then
		GD.Overlay.mat_Overlay = Material( texture );
		GD.Overlay.lastTexture = texture;
	end

	if( GD.Overlay.mat_Overlay == nil or GD.Overlay.mat_Overlay:IsError() ) then return end
	
	render.UpdateScreenEffectTexture();
	
	GD.Overlay.mat_Overlay:SetFloat( "$alpha", alpha );
	GD.Overlay.mat_Overlay:SetFloat( "$envmap", 0 );
	GD.Overlay.mat_Overlay:SetFloat( "$envmaptint", 0 );
	GD.Overlay.mat_Overlay:SetFloat( "$refractamount", refractamount );
	GD.Overlay.mat_Overlay:SetInt( "$ignorez", 1 );
	
	render.SetMaterial( GD.Overlay.mat_Overlay );
	render.DrawScreenQuad();

end

GD.Bloom = { };
GD.Bloom.mat_Downsample	= Material( "pp/downsample" );
GD.Bloom.mat_Bloom		= Material( "pp/bloom" );
GD.Bloom.tex_Bloom0		= render.GetBloomTex0();
GD.Bloom.mat_Downsample:SetTexture( "$fbtexture", render.GetScreenEffectTexture() );
function GD.Bloom.DrawBloom( darken, multiply, sizex, sizey, passes, color, colr, colg, colb )
	
	if( !GD.DrawBloom ) then return end
	
	if( !render.SupportsPixelShaders_2_0() ) then return end
	
	local w = ScrW();
	local h = ScrH();
	
	render.UpdateScreenEffectTexture();
	
	local OldRT = render.GetRenderTarget();
	
	GD.Bloom.mat_Downsample:SetFloat( "$darken", darken );
	GD.Bloom.mat_Downsample:SetFloat( "$multiply", multiply );
	
	render.SetRenderTarget( GD.Bloom.tex_Bloom0 );
	
	render.SetMaterial( GD.Bloom.mat_Downsample );
	render.DrawScreenQuad();
	
	render.BlurRenderTarget( GD.Bloom.tex_Bloom0, sizex, sizey, passes );
	
	render.SetRenderTarget( OldRT );
	
	GD.Bloom.mat_Bloom:SetFloat( "$levelr", colr );
	GD.Bloom.mat_Bloom:SetFloat( "$levelg", colg );
	GD.Bloom.mat_Bloom:SetFloat( "$levelb", colb );
	GD.Bloom.mat_Bloom:SetFloat( "$colormul", color );
	GD.Bloom.mat_Bloom:SetTexture( "$basetexture", GD.Bloom.tex_Bloom0 );
	
	render.SetMaterial( GD.Bloom.mat_Bloom );
	render.DrawScreenQuad();
	
end

GD.Colormod = { };
GD.Colormod.mat_ColorMod = Material( "pp/colour" );
GD.Colormod.mat_ColorMod:SetTexture( "$fbtexture", render.GetScreenEffectTexture() );
function GD.Colormod.Draw( tab )
	
	if( !GD.DrawColormod ) then return end
	
	render.UpdateScreenEffectTexture();
	
	for k, v in pairs( tab ) do
		GD.Colormod.mat_ColorMod:SetFloat( k, v );
	end
	
	render.SetMaterial( GD.Colormod.mat_ColorMod );
	render.DrawScreenQuad();
	
end

GD.Sharpen = { };
GD.Sharpen._Material = Material( "pp/sharpen" );
GD.Sharpen._Material:SetTexture( "$fbtexture", render.GetScreenEffectTexture() );
function GD.Sharpen.Draw( contrast, distance )
	
	if( !GD.DrawSharpen ) then return end
	
	render.UpdateScreenEffectTexture();
	
	GD.Sharpen._Material:SetFloat( "$contrast", contrast );
	GD.Sharpen._Material:SetFloat( "$distance", distance / ScrW() );
	
	render.SetMaterial( GD.Sharpen._Material );
	render.DrawScreenQuad();
	
end

function GD.RenderScreenspaceEffects()
	
	local t = GD.UnderTheInfluence( LocalPlayer() );
	
	for k, v in pairs( t ) do
		
		local mul = GD.DrugMul( LocalPlayer(), k );
		
		if( mul > 0 ) then
			
			GD.Drugs[v]:RenderScreenspaceEffects( mul );
			
		end
		
	end
	
end
hook.Add( "RenderScreenspaceEffects", "GD.RenderScreenspaceEffects", GD.RenderScreenspaceEffects );

function GD.CalcView( ply, pos, ang, fov, near, far )
	
	if( GD.ThirdPersonCook ) then
		
		for _, v in pairs( ents.FindByClass( "gd_lab" ) ) do
			
			if( v.GetUser and v:GetUser() and v:GetUser():IsValid() ) then
				
				if( v:GetUser() == LocalPlayer() ) then
					
					local a = Angle( 0, CurTime() * 5, 0 );
					local dpos = a:Up() * 70 + a:Forward() * 100;
					
					local trace = { };
					trace.start = v:GetPos();
					trace.endpos = trace.start + dpos;
					trace.filter = { v, LocalPlayer() };
					local tr = util.TraceLine( trace );
					
					local tab = { };
					tab.origin = trace.start + ( trace.endpos - trace.start ) * ( tr.Fraction * 0.95 );
					tab.angles = ( trace.start - tab.origin ):Angle();
					tab.fov = fov;
					tab.drawviewer = true;
					return tab;
					
				end
				
			end
			
		end
		
	end
	
	local d = GD.UnderTheInfluence( ply );
	
	for k, v in pairs( d ) do
		
		local mul = GD.DrugMul( ply, k );
		
		if( mul > 0 ) then
			
			if( GD.Drugs[v].GetFOV ) then
				
				fov = GD.Drugs[v]:GetFOV( fov, mul );
				local tab = { };
				tab.origin = pos;
				tab.angles = ang;
				tab.fov = fov;
				return tab;
				
			end
			
		end
		
	end
	
end
hook.Add( "CalcView", "GD.CalcView", GD.CalcView );

function GD.PreDrawHalos()
	
	if( GD.DrawHalos ) then
		
		local d = GD.UnderTheInfluence( LocalPlayer() );
		
		for k, v in pairs( d ) do
			
			if( GD.Drugs[v].RenderHalos ) then
				
				local mul = GD.DrugMul( LocalPlayer(), k );
				GD.Drugs[v]:RenderHalos( mul );
				
			end
			
		end
		
	end
	
end
hook.Add( "PreDrawHalos", "GD.PreDrawHalos", GD.PreDrawHalos );

local function nGDStartDrug( len )
	
	local str = net.ReadString();
	local q = net.ReadFloat();
	
	if( !LocalPlayer().GDrugs ) then LocalPlayer().GDrugs = { } end
	if( !LocalPlayer().GDrugStarts ) then LocalPlayer().GDrugStarts = { } end
	if( !LocalPlayer().GDrugQualities ) then LocalPlayer().GDrugQualities = { } end
	
	local k = table.insert( LocalPlayer().GDrugs, str );
	LocalPlayer().GDrugStarts[k] = CurTime();
	LocalPlayer().GDrugQualities[k] = q;
	
	if( GD.Drugs[str] and GD.Drugs[str].OnStart ) then
		
		GD.Drugs[str]:OnStart( LocalPlayer(), q );
		
	end
	
end
net.Receive( "nGDStartDrug", nGDStartDrug );

local function nGDEndDrug( len )
	
	local str = net.ReadString();
	local q = net.ReadFloat();
	
	if( !LocalPlayer().GDrugs ) then LocalPlayer().GDrugs = { } end
	if( !LocalPlayer().GDrugStarts ) then LocalPlayer().GDrugStarts = { } end
	if( !LocalPlayer().GDrugQualities ) then LocalPlayer().GDrugQualities = { } end
	
	local k = table.KeyFromValue( LocalPlayer().GDrugs, str );
	
	if( k and k > 0 ) then
		
		table.remove( LocalPlayer().GDrugs, k );
		table.remove( LocalPlayer().GDrugStarts, k );
		table.remove( LocalPlayer().GDrugQualities, k );
		
		if( GD.Drugs[str] and GD.Drugs[str].OnEnd ) then
			
			GD.Drugs[str]:OnEnd( LocalPlayer(), q );
			
		end
		
	end
	
end
net.Receive( "nGDEndDrug", nGDEndDrug );

local function nGDEndDrugs( len )
	
	LocalPlayer().GDrugs = { };
	LocalPlayer().GDrugStarts = { };
	LocalPlayer().GDrugQualities = { };
	
end
net.Receive( "nGDEndDrugs", nGDEndDrugs );

local function nGDDisallowedLabUse( len )
	
	chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You can't use this - you didn't buy it." );
	
end
net.Receive( "nGDDisallowedLabUse", nGDDisallowedLabUse );

local function nGDDisallowedLabCooked( len )
	
	chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You can't use this - you didn't cook the drug." );
	
end
net.Receive( "nGDDisallowedLabCooked", nGDDisallowedLabCooked );

local function nGDTestKitInstructions( len )
	
	chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "Touch this to a drug to get its quality. The kit will be consumed in the process!" );
	
end
net.Receive( "nGDTestKitInstructions", nGDTestKitInstructions );

local function nGDTestKit( len )
	
	local f = math.floor( net.ReadFloat() * 100 );
	local idx = net.ReadString();
	
	chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "The quality of this ", Color( 255, 100, 0, 255 ), GD.Drugs[idx].Name, Color( 255, 255, 255, 255 ), " is ", Color( 100, 255, 100, 255 ), f .. "%", Color( 255, 255, 255, 255 ), "." );
	
end
net.Receive( "nGDTestKit", nGDTestKit );

function GD.InitPostEntity()
	
	if( GD.DisplayAtStart ) then
		
		chat.AddText( Color( 255, 255, 255, 255 ), "This server is running ", GD.AccentColor, "GDrugs 1.27", Color( 255, 255, 255, 255 ), "." );
		
	end
	
end
hook.Add( "InitPostEntity", "GD.InitPostEntity", GD.InitPostEntity );

local function ccGDNPCPosition()
	
	local pos = LocalPlayer():GetPos();
	local ang = LocalPlayer():GetAngles();
	
	MsgC( GD.AccentColor, "[GD] ", Color( 128, 128, 128, 255 ), "Copy the following into GD.NPCSpawns or GD.DealerNPCSpawns:\n" );
	MsgC( Color( 255, 255, 255, 255 ), "\t{ Vector( " .. math.Round( pos.x ) .. ", " .. math.Round( pos.y ) .. "," .. math.ceil( pos.z ) .. " ), Angle( 0, " .. math.Round( ang.y ) .. ", 0 ) },\n" );
	
end
concommand.Add( "gd_npc", ccGDNPCPosition );

function GD.PostDrawOpaqueRenderables( depth, sky )
	
	if( GD.ShowNPCTitles ) then
		
		local a = LocalPlayer():EyeAngles();
		a:RotateAroundAxis( a:Forward(), 90 );
		a:RotateAroundAxis( a:Right(), 90 );
		
		for _, v in pairs( ents.FindByClass( "gd_buyer" ) ) do
			
			local o = v:OBBMaxs().z + 10;
			local p = v:GetPos() + Vector( 0, 0, o );
			
			cam.Start3D2D( p, a, 0.07 );
				local alpha = 1;
				local d = LocalPlayer():EyePos():Distance( p );
				if( d > GD.NPCFadeStart ) then
					alpha = 1 - ( ( d - GD.NPCFadeStart ) / ( GD.NPCFadeEnd - GD.NPCFadeStart ) );
				end
				
				if( alpha > 0 ) then
					
					surface.SetFont( "GD.LabEntitySmall" );
					local w, h = surface.GetTextSize( "Drug Buyer" );
					
					local y = 0;
					
					surface.SetTextColor( Color( 255, 255, 255, 255 * alpha ) );
					surface.SetTextPos( -w / 2, y );
					surface.DrawText( "Drug Buyer" );
					
				end
				
			cam.End3D2D();
			
		end
		
		for _, v in pairs( ents.FindByClass( "gd_dealer" ) ) do
			
			local o = v:OBBMaxs().z + 10;
			local p = v:GetPos() + Vector( 0, 0, o );
			
			cam.Start3D2D( p, a, 0.07 );
				local alpha = 1;
				local d = LocalPlayer():EyePos():Distance( p );
				if( d > GD.NPCFadeStart ) then
					alpha = 1 - ( ( d - GD.NPCFadeStart ) / ( GD.NPCFadeEnd - GD.NPCFadeStart ) );
				end
				
				if( alpha > 0 ) then
					
					surface.SetFont( "GD.LabEntitySmall" );
					local w, h = surface.GetTextSize( "Drug Dealer" );
					
					local y = 0;
					
					surface.SetTextColor( Color( 255, 255, 255, 255 * alpha ) );
					surface.SetTextPos( -w / 2, y );
					surface.DrawText( "Drug Dealer" );
					
				end
				
			cam.End3D2D();
			
		end
		
	end
	
end
hook.Add( "PostDrawOpaqueRenderables", "GD.PostDrawOpaqueRenderables", GD.PostDrawOpaqueRenderables );