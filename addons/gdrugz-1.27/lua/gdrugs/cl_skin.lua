local f = GD.Font;

surface.CreateFont( "GD.LabEntity", {
	font = f,
	size = 100,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.LabEntitySmall", {
	font = f,
	size = 70,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.LabEntitySmaller", {
	font = f,
	size = 50,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.LabEntity30", {
	font = f,
	size = 30,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.GUITitle", {
	font = f,
	size = 60,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.GUITitle40", {
	font = f,
	size = 40,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.GUITitle30", {
	font = f,
	size = 30,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.GUIButton", {
	font = f,
	size = 30,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.GUIButtonSmall", {
	font = f,
	size = 20,
	weight = 500,
	outline = true
} );

surface.CreateFont( "GD.GUISmall", {
	font = "Verdana",
	size = 14,
	weight = 500,
	outline = true
} );

local SKIN = { };

SKIN.PrintName 		= "Stunsticks";
SKIN.Author			= "disseminate";

SKIN.fontFrame		= "Verdana"
SKIN.fontTab		= "Verdana"

SKIN.Colours = { };

SKIN.Colours.Window = {}
SKIN.Colours.Window.TitleActive			= Color( 255, 255, 255, 255 );
SKIN.Colours.Window.TitleInactive		= Color( 255, 255, 255, 255 );

SKIN.Colours.Button = { }
SKIN.Colours.Button.Normal				= Color( 255, 255, 255, 255 );
SKIN.Colours.Button.Hover				= Color( 255, 255, 255, 255 );
SKIN.Colours.Button.Down				= GD.AccentColor;
SKIN.Colours.Button.Disabled			= Color( 200, 200, 200, 255 );

SKIN.Colours.Label = { }
SKIN.Colours.Label.Default				= Color( 255, 255, 255, 255 );
SKIN.Colours.Label.Bright				= Color( 255, 255, 255, 255 );
SKIN.Colours.Label.Dark					= Color( 100, 100, 100, 255 );
SKIN.Colours.Label.Highlight			= Color( 255, 100, 100, 255 );

SKIN.Colours.TooltipText = Color( 255, 255, 255, 255 );

function SKIN:PaintFrame( panel, w, h )
	
	if( !panel.StartTime ) then
		panel.StartTime = CurTime();
	end
	Derma_DrawBackgroundBlur( panel, panel.StartTime );
	
	local m;
	
	for i = 0, h do
		m = 40 * ( 1 - i / h ) + 20 * ( i / h );
		surface.SetDrawColor( Color( m, m, m, 255 ) );
		surface.DrawRect( 0, i, w, 1 );
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	
end

function SKIN:PaintButton( panel, w, h )
	
	if( !panel.E ) then
		panel.E = 10;
	end
	
	if( !panel.S ) then
		panel.S = 20;
	end
	
	if( panel.IsDown and panel:IsDown() ) then
		
		panel.E = math.Approach( panel.E, 0, 0.4 );
		panel.S = math.Approach( panel.S, 15, 0.4 );
		
	elseif( panel.Hovered ) then
		
		panel.E = math.Approach( panel.E, 13, 0.2 );
		panel.S = math.Approach( panel.S, 25, 0.2 );
		
	else
		
		panel.E = math.Approach( panel.E, 10, 0.2 );
		panel.S = math.Approach( panel.S, 20, 0.2 );
		
	end
	
	local m;
	
	for i = 0, h do
		m = panel.S * ( 1 - i / h ) + panel.E * ( i / h );
		surface.SetDrawColor( Color( m, m, m, 255 ) );
		surface.DrawRect( 0, i, w, 1 );
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	
end

function SKIN:PaintTextEntry( panel, w, h )
	
	if( !panel.E ) then
		panel.E = 10;
	end
	
	if( !panel.S ) then
		panel.S = 20;
	end
	
	if( panel:HasFocus() ) then
		
		panel.E = math.Approach( panel.E, 13, 0.4 );
		panel.S = math.Approach( panel.S, 25, 0.4 );
		
	else
		
		panel.E = math.Approach( panel.E, 10, 0.2 );
		panel.S = math.Approach( panel.S, 20, 0.2 );
		
	end
	
	local m;
	
	for i = 0, h do
		m = panel.S * ( 1 - i / h ) + panel.E * ( i / h );
		surface.SetDrawColor( Color( m, m, m, 255 ) );
		surface.DrawRect( 0, i, w, 1 );
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	
	panel:DrawTextEntryText( Color( 255, 255, 255, 255 ), Color( 255, 0, 0, 255 ), Color( 255, 255, 255, 255 ) );
	
end

function SKIN:PaintButtonDown( panel, w, h )
	
	if( !panel.LaidOut ) then
		
		panel.LaidOut = true;
		panel:SetText( "u" );
		panel:SetFont( "marlett" );
		panel.CustomFont = "marlett";
		
	end
	
	self:PaintButton( panel, w, h );

end

function SKIN:PaintButtonUp( panel, w, h )
	
	if( !panel.LaidOut ) then
		
		panel.LaidOut = true;
		panel:SetText( "t" );
		panel:SetFont( "marlett" );
		panel.CustomFont = "marlett";
		
	end
	
	self:PaintButton( panel, w, h );

end

function SKIN:PaintVScrollBar( panel, w, h )
	
	surface.SetDrawColor( Color( 0, 0, 0, 200 ) );
	surface.DrawRect( 0, 0, w, h );
	
end

function SKIN:PaintScrollBarGrip( panel, w, h )
	
	self:PaintButton( panel, w, h );
	
end

derma.DefineSkin( "GD", "GDrugs", SKIN );
derma.RefreshSkins();
