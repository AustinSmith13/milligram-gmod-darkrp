local meta = FindMetaTable( "Panel" );

GD.FadeDelay = 0.3;

function meta:LayoutModelViewer()
	
	local mn, mx = self.Entity:GetRenderBounds();
	local middle = ( mn + mx ) * 0.5;
	local size = 0;
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) );
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) );
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) );
	
	if( size < 900 ) then
		size = size * ( 1 - ( size / 900 ) );
	else
		size = size * ( 1 - ( size / 4096 ) );
	end
	
	size = math.Clamp( size, 5, 1000 );
	
	local ViewAngle = Angle( 25, 40, 0 );
	local ViewPos = ViewAngle:Forward() * size * -15;
	local view = { };
	
	self:SetFOV( 4 + size * 0.04 );
	self:SetCamPos( ViewPos + middle );
	self:SetLookAt( ViewPos + middle + ViewAngle:Forward() );
	
	function self:DrawModel()
		
		local curparent = self;
		local rightx = self:GetWide();
		local leftx = 0;
		local topy = 0;
		local bottomy = self:GetTall();
		local previous = curparent;
		
		while( curparent:GetParent() != nil ) do
			
			curparent = curparent:GetParent();
			local x, y = previous:GetPos();
			topy = math.Max( y, topy + y );
			leftx = math.Max( x, leftx + x );
			bottomy = math.Min( y + previous:GetTall(), bottomy + y );
			rightx = math.Min( x + previous:GetWide(), rightx + x );
			previous = curparent;
			
		end
		
		render.SetScissorRect( leftx, topy, rightx, bottomy, true );
			render.SetBlend( self:GetAlpha() / 255 );
				self.Entity:DrawModel();
			render.SetBlend( 1.0 );
		render.SetScissorRect( 0, 0, 0, 0, false );
		
	end
	
end

local matBlurScreen = Material( "pp/blurscreen" );

function GD.DrugLabPopup( text )
	
	local vb = vgui.Create( "EditablePanel" );
	vb:SetPos( 0, 0 );
	vb:SetSize( ScrW(), ScrH() );
	function vb:Paint() end
	vb:MakePopup();
	
	local v = vgui.Create( "DFrame", vb );
	v:SetSize( 300, 100 );
	v:Center();
	v:SetTitle( "" );
	v:ShowCloseButton( false );
	v:SetDraggable( false );
	v:SetSkin( "GD" );
	v:SetAlpha( 0 );
	v:AlphaTo( 255, GD.FadeDelay, 0, function() end );
	
	local cb = vgui.Create( "DButton", v );
	cb:SetSize( 80, 30 );
	cb:SetPos( v:GetWide() - 80 - 10, v:GetTall() - 30 - 10 );
	cb:SetText( "OK" );
	cb:SetFont( "GD.GUIButtonSmall" );
	cb:PerformLayout();
	function cb:DoClick()
		
		self:SetDisabled( true );
		self:GetParent():GetParent():SetMouseInputEnabled( false );
		self:GetParent():GetParent():SetKeyboardInputEnabled( false );
		self:GetParent():GetParent():AlphaTo( 0, GD.FadeDelay, 0, function()
			
			self:GetParent():GetParent():Remove();
			
		end );
		
	end
	
	local l = vgui.Create( "DLabel", v );
	l:SetPos( 10, 10 );
	l:SetFont( "GD.GUISmall" );
	l:SetText( text );
	l:SetWide( v:GetWide() - 20 );
	l:SetAutoStretchVertical( true );
	l:PerformLayout();
	
end

function GD.DrugLabPopupConfirm( text, callback )
	
	local vb = vgui.Create( "EditablePanel" );
	vb:SetPos( 0, 0 );
	vb:SetSize( ScrW(), ScrH() );
	function vb:Paint() end
	vb:MakePopup();
	
	local v = vgui.Create( "DFrame", vb );
	v:SetSkin( "GD" );
	v:SetSize( 300, 100 );
	v:Center();
	v:SetTitle( "" );
	v:ShowCloseButton( false );
	v:SetDraggable( false );
	v:SetAlpha( 0 );
	v:AlphaTo( 255, 0.3, 0, function() end );
	
	local cb = vgui.Create( "DButton", v );
	cb:SetSkin( "GD" );
	cb:SetSize( 80, 30 );
	cb:SetPos( v:GetWide() - 80 - 10 - 80 - 10, v:GetTall() - 30 - 10 );
	cb:SetText( "OK" );
	cb:SetTextColor( Color( 255, 0, 0, 255 ) );
	cb:SetFont( "GD.GUIButtonSmall" );
	cb:PerformLayout();
	function cb:DoClick()
		
		callback();
		
		self:GetParent():GetParent():SetMouseInputEnabled( false );
		self:GetParent():GetParent():SetKeyboardInputEnabled( false );
		self:GetParent():GetParent():AlphaTo( 0, GD.FadeDelay, 0, function()
			
			self:GetParent():GetParent():Remove();
			
		end );
		
	end
	
	local cb = vgui.Create( "DButton", v );
	cb:SetSkin( "GD" );
	cb:SetSize( 80, 30 );
	cb:SetPos( v:GetWide() - 80 - 10, v:GetTall() - 30 - 10 );
	cb:SetText( "Cancel" );
	cb:SetFont( "GD.GUIButtonSmall" );
	cb:PerformLayout();
	function cb:DoClick()
		
		self:SetDisabled( true );
		self:GetParent():GetParent():SetMouseInputEnabled( false );
		self:GetParent():GetParent():SetKeyboardInputEnabled( false );
		self:GetParent():GetParent():AlphaTo( 0, GD.FadeDelay, 0, function()
			
			self:GetParent():GetParent():Remove();
			
		end );
		
	end
	
	local l = vgui.Create( "DLabel", v );
	l:SetSkin( "GD" );
	l:SetPos( 10, 10 );
	l:SetFont( "GD.GUISmall" );
	l:SetWide( v:GetWide() - 20 );
	l:SetAutoStretchVertical( true );
	l:SetWrap( true );
	l:SetText( text );
	l:PerformLayout();
	
end

function GD.DrugLabPopupEntry( text, maxlen, maxwarn, callback )
	
	local vb = vgui.Create( "EditablePanel" );
	vb:SetPos( 0, 0 );
	vb:SetSize( ScrW(), ScrH() );
	function vb:Paint() end
	vb:MakePopup();
	
	local v = vgui.Create( "DFrame", vb );
	v:SetSkin( "GD" );
	v:SetSize( 300, 100 );
	v:Center();
	v:SetTitle( "" );
	v:ShowCloseButton( false );
	v:SetDraggable( false );
	v:SetAlpha( 0 );
	v:AlphaTo( 255, GD.FadeDelay, 0, function() end );
	
	local l = vgui.Create( "DLabel", v );
	l:SetSkin( "GD" );
	l:SetPos( 10, 10 );
	l:SetFont( "GD.GUISmall" );
	l:SetWide( v:GetWide() - 20 );
	l:SetAutoStretchVertical( true );
	l:SetWrap( true );
	l:SetText( text );
	l:PerformLayout();
	
	local cb = vgui.Create( "DButton", v );
	cb:SetSkin( "GD" );
	cb:SetSize( 80, 30 );
	cb:SetPos( v:GetWide() - 80 - 10 - 80 - 10, v:GetTall() - 30 - 10 );
	cb:SetText( "OK" );
	cb:SetFont( "GD.GUIButtonSmall" );
	cb:PerformLayout();
	function cb:DoClick()
		
		local val = string.Trim( v.t:GetValue() );
		
		if( string.len( val ) > maxlen ) then
			
			GD.DrugLabPopup( maxwarn );
			
		else
			
			callback( v.t:GetValue() );
			
			self:GetParent():GetParent():SetMouseInputEnabled( false );
			self:GetParent():GetParent():SetKeyboardInputEnabled( false );
			self:GetParent():GetParent():AlphaTo( 0, GD.FadeDelay, 0, function()
				
				self:GetParent():GetParent():Remove();
				
			end );
			
		end
		
	end
	
	local cbc = vgui.Create( "DButton", v );
	cbc:SetSkin( "GD" );
	cbc:SetSize( 80, 30 );
	cbc:SetPos( v:GetWide() - 80 - 10, v:GetTall() - 30 - 10 );
	cbc:SetText( "Cancel" );
	cbc:SetFont( "GD.GUIButtonSmall" );
	cbc:PerformLayout();
	function cbc:DoClick()
		
		self:GetParent():GetParent():SetMouseInputEnabled( false );
		self:GetParent():GetParent():SetKeyboardInputEnabled( false );
		self:GetParent():GetParent():AlphaTo( 0, GD.FadeDelay, 0, function()
			
			self:GetParent():GetParent():Remove();
			
		end );
		
	end
	
	v.t = vgui.Create( "DTextEntry", v );
	v.t:SetSkin( "GD" );
	v.t:SetPos( 10, 30 );
	v.t:SetSize( v:GetWide() - 20, 20 );
	v.t:SetFont( "GD.GUISmall" );
	function v.t:OnEnter()
		
		cb:DoClick();
		
	end
	
	v.t:RequestFocus();
	
end

function GD.OpenDrugLabDrug( ent, id, sidew )
	
	GD.DrugPanel.Drug = vgui.Create( "EditablePanel", GD.DrugPanel );
	GD.DrugPanel.Drug:SetPos( sidew, 0 );
	GD.DrugPanel.Drug:SetSize( ScrW() - sidew, ScrH() );
	function GD.DrugPanel.Drug:Paint( w, h )
		
		surface.SetDrawColor( Color( 0, 0, 0, 100 ) );
		surface.DrawRect( 0, 0, w, h );
		
	end
	GD.DrugPanel.Drug:SetAlpha( 0 );
	GD.DrugPanel.Drug:AlphaTo( 255, GD.FadeDelay, 0, function() end );
	
	local padding = 100;
	local iconsize = 150;
	
	if( ScrW() < 1280 ) then
		
		padding = 20;
		iconsize = 100;
		
	end
	
	local x = padding;
	local y = padding;
	
	GD.DrugPanel.Drug.Model = vgui.Create( "DModelPanel", GD.DrugPanel.Drug );
	GD.DrugPanel.Drug.Model:SetPos( x, y );
	GD.DrugPanel.Drug.Model:SetSize( iconsize, iconsize );
	GD.DrugPanel.Drug.Model:SetModel( GD.Drugs[id].Model );
	GD.DrugPanel.Drug.Model:LayoutModelViewer();
	
	x = x + GD.DrugPanel.Drug.Model:GetWide() + padding;
	
	GD.DrugPanel.Drug.DrugName = vgui.Create( "DLabel", GD.DrugPanel.Drug );
	GD.DrugPanel.Drug.DrugName:SetText( GD.Drugs[id].Name );
	GD.DrugPanel.Drug.DrugName:SetFont( "GD.GUITitle" );
	GD.DrugPanel.Drug.DrugName:SizeToContents();
	GD.DrugPanel.Drug.DrugName:SetPos( x, y + ( GD.DrugPanel.Drug.Model:GetTall() / 2 ) - 30 );
	
	y = y + ( GD.DrugPanel.Drug.Model:GetTall() / 2 ) - 30 + 70;
	
	local t = "Cook";
	
	if( GD.Drugs[id].ActionText ) then
		t = GD.Drugs[id].ActionText;
	end
	
	GD.DrugPanel.Drug.DrugTime = vgui.Create( "DLabel", GD.DrugPanel.Drug );
	GD.DrugPanel.Drug.DrugTime:SetText( t .. " Time: " .. string.ToMinutesSeconds( math.ceil( GD.Drugs[id].LabTime * GD.TimeMultiplier ) ) );
	GD.DrugPanel.Drug.DrugTime:SetFont( "GD.GUITitle40" );
	GD.DrugPanel.Drug.DrugTime:SizeToContents();
	GD.DrugPanel.Drug.DrugTime:SetPos( x, y );
	
	y = y + 95;
	
	GD.DrugPanel.Drug.DrugIngredients = vgui.Create( "DLabel", GD.DrugPanel.Drug );
	GD.DrugPanel.Drug.DrugIngredients:SetText( "Ingredients" );
	GD.DrugPanel.Drug.DrugIngredients:SetFont( "GD.GUITitle30" );
	GD.DrugPanel.Drug.DrugIngredients:SizeToContents();
	GD.DrugPanel.Drug.DrugIngredients:SetPos( x, y );
	
	local y = y + 40 + 10;
	
	local n = #GD.Drugs[id].Ingredients;
	
	local wavailable = ScrW() - sidew - x;
	local ingw = math.min( wavailable / n - 20, 150 );
	
	local tcost = 0;
	
	local ox = x;
	
	for _, v in pairs( GD.Drugs[id].Ingredients ) do
		
		local l = vgui.Create( "DLabel", GD.DrugPanel.Drug );
		l:SetPos( x, y + ingw );
		l:SetFont( "GD.GUISmall" );
		l:SetText( v[2] );
		l:SizeToContents();
		l:InvalidateParent( true );
		
		local wd = l:GetWide() - ingw;
		
		local xtra = 0;
		local txtra = 0;
		if( wd > 0 ) then
			xtra = wd / 2;
		else
			txtra = -wd / 2;
			l:SetPos( x + txtra, y + ingw );
		end
		
		local p = vgui.Create( "DModelPanel", GD.DrugPanel.Drug );
		p:SetPos( x + xtra, y );
		p:SetSize( ingw, ingw );
		p:SetModel( v[3] );
		p:LayoutModelViewer();
		
		local pricetext = "$" .. v[1];
		
		surface.SetFont( "GD.GUISmall" );
		local w, h = surface.GetTextSize( pricetext );
		
		local lp = vgui.Create( "DLabel", GD.DrugPanel.Drug );
		lp:SetPos( x - w / 2 + l:GetWide() / 2 + txtra, y + ingw + l:GetTall() );
		lp:SetFont( "GD.GUISmall" );
		lp:SetColor( Color( 100, 255, 100, 255 ) );
		lp:SetText( pricetext );
		lp:SizeToContents();
		lp:InvalidateParent( true );
		
		tcost = tcost + v[1];
		
		x = x + math.max( p:GetWide(), l:GetWide() );
		x = x + 20;
		
	end
	
	GD.DrugPanel.Drug.CookBut = vgui.Create( "DButton", GD.DrugPanel.Drug );
	GD.DrugPanel.Drug.CookBut:SetPos( math.max( ox, x - 20 - 300 ), y + ingw + 70 );
	GD.DrugPanel.Drug.CookBut:SetSize( 300, 60 );
	GD.DrugPanel.Drug.CookBut:SetFont( "GD.GUIButton" );
	GD.DrugPanel.Drug.CookBut:SetText( t .. " ($" .. tcost .. ")" );
	GD.DrugPanel.Drug.CookBut:PerformLayout();
	GD.DrugPanel.Drug.CookBut:SetSkin( "GD" );
	GD.DrugPanel.Drug.CookBut.ID = id;
	function GD.DrugPanel.Drug.CookBut:DoClick()
		
		if( GD.GetMoney( LocalPlayer() ) < tcost ) then
			
			GD.DrugLabPopup( "You can't afford the ingredients!" );
			return;
			
		end
		
		self:SetDisabled( true );
		GD.DrugPanel:SetMouseInputEnabled( false );
		GD.DrugPanel:SetKeyboardInputEnabled( false );
		GD.DrugPanel:AlphaTo( 0, GD.FadeDelay, 0, function()
			
			GD.DrugPanel:Remove();
			GD.DrugPanel = nil;
			
		end );
		
		net.Start( "nGDStartCook" );
			net.WriteEntity( ent );
			net.WriteString( self.ID );
		net.SendToServer();
		
		chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You spent ", Color( 100, 255, 100, 255 ), "$" .. tcost, Color( 255, 255, 255, 255 ), " on ingredients for ", Color( 255, 100, 0, 255 ), GD.Drugs[self.ID].Name, Color( 255, 255, 255, 255 ), "." );
		
	end
	
end

function GD.OpenDrugLabDrugInit( ent, id, sidew )
	
	if( !GD.DrugPanel or !GD.DrugPanel:IsValid() ) then return end
	
	if( GD.DrugPanel.Drug and GD.DrugPanel.Drug:IsValid() ) then
		
		GD.DrugPanel.Drug:AlphaTo( 0, GD.FadeDelay, 0, function()
			
			GD.DrugPanel.Drug:Remove();
			GD.DrugPanel.Drug = nil;
			GD.OpenDrugLabDrug( ent, id, sidew );
			
		end );
		
	else
		
		GD.OpenDrugLabDrug( ent, id, sidew );
		
	end
	
end

function GD.OpenDrugLabFull( ent, lbl )
	
	local y = 100;
	
	local l = vgui.Create( "DLabel", GD.DrugPanel );
	l:SetSkin( "GD" );
	l:SetText( lbl );
	l:SetFont( "GD.GUITitle40" );
	l:SizeToContents();
	l:InvalidateParent( true );
	l:SetPos( ScrW() / 2 - l:GetWide() / 2, y );
	
	y = y + 50;
	
	local d = vgui.Create( "DLabel", GD.DrugPanel );
	d:SetSkin( "GD" );
	d:SetText( GD.Drugs[ent:GetDrugInProgress()].Name );
	d:SetFont( "GD.GUITitle" );
	d:SizeToContents();
	d:InvalidateParent( true );
	d:SetPos( ScrW() / 2 - d:GetWide() / 2, y );
	
	y = y + 70;
	
	local m = vgui.Create( "DModelPanel", GD.DrugPanel );
	m:SetSkin( "GD" );
	m:SetSize( 250, 250 );
	m:SetPos( ScrW() / 2 - m:GetWide() / 2, y );
	m:SetModel( GD.Drugs[ent:GetDrugInProgress()].Model );
	m:LayoutModelViewer();
	
	y = y + m:GetTall() + 10;
	
	local buttonheight = 60;
	local buttonwidth = 300;
	
	GD.DrugPanel.CloseBut = vgui.Create( "DButton", GD.DrugPanel );
	GD.DrugPanel.CloseBut:SetPos( ScrW() / 2 - buttonwidth / 2, GD.DrugPanel:GetTall() - buttonheight - 20 );
	GD.DrugPanel.CloseBut:SetSize( buttonwidth, buttonheight );
	GD.DrugPanel.CloseBut:SetFont( "GD.GUIButton" );
	GD.DrugPanel.CloseBut:SetText( "Close" );
	GD.DrugPanel.CloseBut:PerformLayout();
	GD.DrugPanel.CloseBut:SetSkin( "GD" );
	function GD.DrugPanel.CloseBut:DoClick()
		
		self:SetDisabled( true );
		GD.DrugPanel:SetMouseInputEnabled( false );
		GD.DrugPanel:SetKeyboardInputEnabled( false );
		GD.DrugPanel:AlphaTo( 0, GD.FadeDelay, 0, function()
			
			GD.DrugPanel:Remove();
			GD.DrugPanel = nil;
			
		end );
		
		net.Start( "nGDCloseMenu" );
			net.WriteEntity( ent );
		net.SendToServer();
		
	end
	
	return y;
	
end

function GD.OpenDrugLabCooking( ent )
	
	if( !GD.DrugPanel or !GD.DrugPanel:IsValid() ) then return end
	
	local y = GD.OpenDrugLabFull( ent, GD.Drugs[ent:GetDrugInProgress()].ActionTextPresent or "Cooking" );
	
	local t = vgui.Create( "DLabel", GD.DrugPanel );
	t:SetSkin( "GD" );
	t:SetText( string.ToMinutesSeconds( math.max( math.floor( ent:GetDrugCompleteTime() - CurTime() ), 0 ) ) );
	t:SetFont( "GD.GUITitle40" );
	t:SizeToContents();
	t:InvalidateParent( true );
	t:SetPos( ScrW() / 2 - t:GetWide() / 2, y );
	t.Y = y;
	function t:Think()
		
		self:SetText( string.ToMinutesSeconds( math.max( math.floor( ent:GetDrugCompleteTime() - CurTime() ), 0 ) ) );
		self:SizeToContents();
		self:SetPos( ScrW() / 2 - self:GetWide() / 2, self.Y );
		
	end
	
	y = y + t:GetTall() + 10;
	
	local buttonheight = 60;
	local buttonwidth = 300;
	
	if( GD.CanCancelCooks ) then
		
		if( !GD.RestrictDrugToCook or ent:GetCook() == LocalPlayer() ) then
			
			GD.DrugPanel.CancelBut = vgui.Create( "DButton", GD.DrugPanel );
			GD.DrugPanel.CancelBut:SetSkin( "GD" );
			GD.DrugPanel.CancelBut:SetPos( ScrW() / 2 - buttonwidth / 2, GD.DrugPanel:GetTall() - buttonheight - 20 - buttonheight - 20 );
			GD.DrugPanel.CancelBut:SetSize( buttonwidth, buttonheight );
			GD.DrugPanel.CancelBut:SetFont( "GD.GUIButton" );
			GD.DrugPanel.CancelBut:SetText( "Cancel " .. ( GD.Drugs[ent:GetDrugInProgress()].ActionText or "Cook" ) );
			GD.DrugPanel.CancelBut:PerformLayout();
			function GD.DrugPanel.CancelBut:DoClick()
				
				GD.DrugLabPopupConfirm( "Are you sure you want to do this? You don't get your money back!", function()
					
					self:SetDisabled( true );
					GD.DrugPanel:SetMouseInputEnabled( false );
					GD.DrugPanel:SetKeyboardInputEnabled( false );
					GD.DrugPanel:AlphaTo( 0, GD.FadeDelay, 0, function()
						
						GD.DrugPanel:Remove();
						GD.DrugPanel = nil;
						
					end );
					
					chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You ", Color( 255, 0, 0, 255 ), "cancelled ", Color( 255, 255, 255, 255 ), "the " .. string.lower( GD.Drugs[ent:GetDrugInProgress()].ActionText or "Cook" ) .. " for ", Color( 255, 100, 0, 255 ), GD.Drugs[ent:GetDrugInProgress()].Name, Color( 255, 255, 255, 255 ), "." );
					
					net.Start( "nGDCancelCook" );
						net.WriteEntity( ent );
					net.SendToServer();
					
				end );
				
			end
			
		end
		
	end
	
end

function GD.OpenDrugLabCooked( ent )
	
	if( !GD.DrugPanel or !GD.DrugPanel:IsValid() ) then return end
	if( !ent or !ent:IsValid() ) then return end
	
	local y = GD.OpenDrugLabFull( ent, GD.Drugs[ent:GetDrugInProgress()].ActionTextPast or "Cooked" );
	
	local t = vgui.Create( "DLabel", GD.DrugPanel );
	t:SetSkin( "GD" );
	t:SetText( math.floor( ent:GetDrugQuality() * 100 ) .. "% Purity" );
	t:SetFont( "GD.GUITitle40" );
	t:SizeToContents();
	t:InvalidateParent( true );
	t:SetPos( ScrW() / 2 - t:GetWide() / 2, y );
	
	y = y + t:GetTall() + 10;
	
	local buttonheight = 60;
	local buttonwidth = 300;
	
	y = GD.DrugPanel:GetTall() - buttonheight - 20 - buttonheight - 20;
	
	if( GD.CanSellDirectly ) then
		
		local p = math.floor( GD.RevenueMultiplier * ent:GetDrugQuality() * GD.Drugs[ent:GetDrugInProgress()].SellPrice );
		
		GD.DrugPanel.SellBut = vgui.Create( "DButton", GD.DrugPanel );
		GD.DrugPanel.SellBut:SetSkin( "GD" );
		GD.DrugPanel.SellBut:SetPos( ScrW() / 2 - buttonwidth / 2, y );
		GD.DrugPanel.SellBut:SetSize( buttonwidth, buttonheight );
		GD.DrugPanel.SellBut:SetFont( "GD.GUIButton" );
		GD.DrugPanel.SellBut:SetText( "Sell Directly ($" .. p .. ")" );
		GD.DrugPanel.SellBut:PerformLayout();
		function GD.DrugPanel.SellBut:DoClick()
			
			GD.DrugLabPopupConfirm( "Are you sure you want to do this?", function()
				
				self:SetDisabled( true );
				GD.DrugPanel:SetMouseInputEnabled( false );
				GD.DrugPanel:SetKeyboardInputEnabled( false );
				GD.DrugPanel:AlphaTo( 0, GD.FadeDelay, 0, function()
					
					GD.DrugPanel:Remove();
					GD.DrugPanel = nil;
					
				end );

				if( !ent or !ent:IsValid() ) then return end
				
				chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You sold ", Color( 255, 100, 0, 255 ), GD.Drugs[ent:GetDrugInProgress()].Name, Color( 255, 255, 255, 255 ), " for ", Color( 100, 255, 100, 255 ), "$" .. p, Color( 255, 255, 255, 255 ), "." );
				if( GD.Levelling ) then
					chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You have received ", Color( 100, 100, 255, 255 ), tostring( GD.Drugs[ent:GetDrugInProgress()].LabTime ), Color( 255, 255, 255, 255 ), " XP." );
					if( GD.GetLevel( LocalPlayer() ) != #GD.Levels and GD.Drugs[ent:GetDrugInProgress()].LabTime + GD.XP( LocalPlayer() ) >= GD.Levels[GD.GetLevel( LocalPlayer() ) + 1][1] ) then
						chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You have levelled up! Your new rank is ", Color( 100, 100, 255, 255 ), GD.Levels[GD.GetLevel( LocalPlayer() ) + 1][2], Color( 255, 255, 255, 255 ), "." );
					end
				end
				
				net.Start( "nGDSellCook" );
					net.WriteEntity( ent );
				net.SendToServer();
				
			end );
			
		end
		
		y = y - buttonheight - 20;
		
	end
	
	GD.DrugPanel.TakeBut = vgui.Create( "DButton", GD.DrugPanel );
	GD.DrugPanel.TakeBut:SetSkin( "GD" );
	GD.DrugPanel.TakeBut:SetPos( ScrW() / 2 - buttonwidth / 2, y );
	GD.DrugPanel.TakeBut:SetSize( buttonwidth, buttonheight );
	GD.DrugPanel.TakeBut:SetFont( "GD.GUIButton" );
	GD.DrugPanel.TakeBut:SetText( "Retrieve Drug" );
	GD.DrugPanel.TakeBut:PerformLayout();
	function GD.DrugPanel.TakeBut:DoClick()
		
		local function submit( val )
			
			self:SetDisabled( true );
			GD.DrugPanel:SetMouseInputEnabled( false );
			GD.DrugPanel:SetKeyboardInputEnabled( false );
			GD.DrugPanel:AlphaTo( 0, GD.FadeDelay, 0, function()
				
				GD.DrugPanel:Remove();
				GD.DrugPanel = nil;
				
			end );
			
			chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You retrieved ", Color( 255, 100, 0, 255 ), GD.Drugs[ent:GetDrugInProgress()].Name, Color( 255, 255, 255, 255 ), "." );
			if( GD.Levelling ) then
				chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You have received ", Color( 100, 100, 255, 255 ), tostring( GD.Drugs[ent:GetDrugInProgress()].LabTime ), Color( 255, 255, 255, 255 ), " XP." );
				if( GD.GetLevel( LocalPlayer() ) != #GD.Levels and GD.Drugs[ent:GetDrugInProgress()].LabTime + GD.XP( LocalPlayer() ) >= GD.Levels[GD.GetLevel( LocalPlayer() ) + 1][1] ) then
					chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You have levelled up! Your new rank is ", Color( 100, 100, 255, 255 ), GD.Levels[GD.GetLevel( LocalPlayer() ) + 1][2], Color( 255, 255, 255, 255 ), "." );
				end
			end
			
			net.Start( "nGDTakeDrug" );
				net.WriteEntity( ent );
				net.WriteString( string.sub( val, 0, 32 ) );
			net.SendToServer();
			
		end
		
		if( GD.CanNameDrugs ) then
			
			GD.DrugLabPopupEntry( "Name your drug:", 32, "Name must be at most 32 characters!", submit );
			
		else
			
			submit( "" );
			
		end
		
	end
	
end

function GD.OpenMainPanel()
	
	if( GD.DrugPanel and GD.DrugPanel:IsValid() ) then
		GD.DrugPanel:Remove();
	end
	
	GD.DrugPanel = vgui.Create( "EditablePanel" );
	GD.DrugPanel:SetPos( 0, 0 );
	GD.DrugPanel:SetSize( ScrW(), ScrH() );
	GD.DrugPanel:MakePopup();
	function GD.DrugPanel:Paint( w, h )
		
		local x, y = self:LocalToScreen( 0, 0 );
		
		DisableClipping( true );
		
		surface.SetMaterial( matBlurScreen );
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) );
		
		for i = 0.2, 1, 0.2 do
			
			matBlurScreen:SetFloat( "$blur", 8 * i );
			matBlurScreen:Recompute();
			if( render ) then render.UpdateScreenEffectTexture(); end
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() );
			
		end
		
		DisableClipping( false );
		
	end
	GD.DrugPanel:SetAlpha( 0 );
	GD.DrugPanel:AlphaTo( 255, GD.FadeDelay, 0, function() end );
	
	GD.DrugPanel.Version = vgui.Create( "DLabel", GD.DrugPanel );
	GD.DrugPanel.Version:SetFont( "GD.GUISmall" );
	GD.DrugPanel.Version:SetText( "v1.27" );
	GD.DrugPanel.Version:SizeToContents();
	GD.DrugPanel.Version:InvalidateParent( true );
	GD.DrugPanel.Version:SetPos( GD.DrugPanel:GetWide() - GD.DrugPanel.Version:GetWide() - 10, GD.DrugPanel:GetTall() - GD.DrugPanel.Version:GetTall() - 10 );
	
end

function GD.CreateRankInfo( parent, y )
	
	if( GD.Levelling ) then
		
		parent.Rank = vgui.Create( "DLabel", parent );
		parent.Rank:SetPos( 20, y );
		parent.Rank:SetFont( "GD.GUITitle30" );
		parent.Rank:SetText( "Rank" );
		parent.Rank:SizeToContents();
		
		y = y + 30;
		
		local lvl = GD.GetLevel( LocalPlayer() );
		
		parent.RankName = vgui.Create( "DLabel", parent );
		parent.RankName:SetPos( 20, y );
		parent.RankName:SetFont( "GD.GUITitle40" );
		parent.RankName:SetText( GD.Levels[lvl][2] );
		parent.RankName:SizeToContents();
		
		y = y + 40;
		
		if( lvl != #GD.Levels ) then
			
			local xpremain = GD.Levels[lvl + 1][1] - GD.XP( LocalPlayer() );
			
			parent.XPLeft = vgui.Create( "DLabel", parent );
			parent.XPLeft:SetPos( 20, y );
			parent.XPLeft:SetFont( "GD.GUISmall" );
			parent.XPLeft:SetText( xpremain .. " XP until next level" );
			parent.XPLeft:SizeToContents();
			
			y = y + 14;
			
		else
			
			parent.XPLeft = vgui.Create( "DLabel", parent );
			parent.XPLeft:SetPos( 20, y );
			parent.XPLeft:SetFont( "GD.GUISmall" );
			parent.XPLeft:SetText( GD.XP( LocalPlayer() ) .. " XP" );
			parent.XPLeft:SizeToContents();
			
			y = y + 14;
			
		end
		
	end
	
	return y;
	
end

function GD.OpenDrugLab( len )
	
	local ent = net.ReadEntity();
	
	GD.OpenMainPanel();
	
	if( ent:Cooked() ) then
		
		GD.OpenDrugLabCooked( ent );
		
	elseif( !ent:Cooking() ) then
		
		surface.SetFont( "GD.GUITitle" );
		local w, h = surface.GetTextSize( "GDrugs" );
		
		local sidew = math.max( ScreenScale( 100 ), 20 + w + 20 );
		
		GD.DrugPanel.Side = vgui.Create( "EditablePanel", GD.DrugPanel );
		GD.DrugPanel.Side:SetPos( 0, 0 );
		GD.DrugPanel.Side:SetSize( sidew, GD.DrugPanel:GetTall() );
		function GD.DrugPanel.Side:Paint( w, h )
			
			surface.SetDrawColor( Color( 0, 0, 0, 150 ) );
			surface.DrawRect( 0, 0, w, h );
			
		end
		
		GD.DrugPanel.Side.Title = vgui.Create( "DLabel", GD.DrugPanel.Side );
		GD.DrugPanel.Side.Title:SetPos( 20, 20 );
		GD.DrugPanel.Side.Title:SetFont( "GD.GUITitle" );
		GD.DrugPanel.Side.Title:SetText( "GDrugs" );
		GD.DrugPanel.Side.Title:SizeToContents();
		
		local buttonheight = 60;
		local y = GD.DrugPanel.Side:GetTall() - buttonheight;
		
		GD.DrugPanel.Side.CloseBut = vgui.Create( "DButton", GD.DrugPanel.Side );
		GD.DrugPanel.Side.CloseBut:SetPos( 0, y );
		GD.DrugPanel.Side.CloseBut:SetSize( GD.DrugPanel.Side:GetWide(), buttonheight );
		GD.DrugPanel.Side.CloseBut:SetFont( "GD.GUIButton" );
		GD.DrugPanel.Side.CloseBut:SetText( "Close" );
		GD.DrugPanel.Side.CloseBut:PerformLayout();
		GD.DrugPanel.Side.CloseBut:SetSkin( "GD" );
		function GD.DrugPanel.Side.CloseBut:DoClick()
			
			self:SetDisabled( true );
			GD.DrugPanel:SetMouseInputEnabled( false );
			GD.DrugPanel:SetKeyboardInputEnabled( false );
			GD.DrugPanel:AlphaTo( 0, GD.FadeDelay, 0, function()
				
				GD.DrugPanel:Remove();
				GD.DrugPanel = nil;
				
			end );
			
			net.Start( "nGDCloseMenu" );
				net.WriteEntity( ent );
			net.SendToServer();
			
		end
		
		y = y - 100;
		
		GD.CreateRankInfo( GD.DrugPanel.Side, y );
		
		local y = 100;
		
		local sidescroll = vgui.Create( "DScrollPanel", GD.DrugPanel.Side );
		sidescroll:SetPos( 0, y );
		sidescroll:SetSize( sidew, ScrH() - y - buttonheight - 100 - 20 );
		sidescroll:PerformLayout();
		sidescroll:SetSkin( "GD" );
		
		local y = 0;
		
		local tbl = table.Copy( GD.Drugs );
		table.sort( tbl, function( a, b ) return a.Name < b.Name; end );
		
		for _, v in pairs( tbl ) do
			
			if( v.LabType == ent:GetDrugLabType() ) then
				
				if( !v.MinLevel or ( GD.Levelling and v.MinLevel and GD.GetLevel( LocalPlayer() ) >= v.MinLevel ) ) then
					
					local b = vgui.Create( "DButton", sidescroll );
					b:SetPos( 0, y );
					b:SetSize( GD.DrugPanel.Side:GetWide(), buttonheight );
					b:SetFont( "GD.GUIButton" );
					b:SetText( v.Name );
					b:PerformLayout();
					b:SetSkin( "GD" );
					b.ID = v.ID;
					function b:DoClick()
						
						GD.OpenDrugLabDrugInit( ent, self.ID, sidew );
						
					end
					
					y = y + buttonheight;

				end
				
			end
			
		end
		
	else
		
		GD.OpenDrugLabCooking( ent );
		
	end
	
end
net.Receive( "GD.OpenDrugLab", GD.OpenDrugLab );

local function nGDForceGUIClose( len )
	
	if( !GD.DrugPanel or !GD.DrugPanel:IsValid() ) then return end
	
	GD.DrugPanel:SetMouseInputEnabled( false );
	GD.DrugPanel:SetKeyboardInputEnabled( false );
	GD.DrugPanel:AlphaTo( 0, GD.FadeDelay, 0, function()
		
		GD.DrugPanel:Remove();
		GD.DrugPanel = nil;
		
	end );
	
end
net.Receive( "nGDForceGUIClose", nGDForceGUIClose );
