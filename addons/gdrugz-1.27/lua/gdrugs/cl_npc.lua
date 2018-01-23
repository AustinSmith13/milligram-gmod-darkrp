local function nGDNPCUsed( len )
	
	chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "Bring this NPC a drug and they'll buy it off you for above market price." );
	
end
net.Receive( "nGDNPCUsed", nGDNPCUsed );

local function nGDNPCGiven( len )
	
	local amt = net.ReadUInt( 32 );
	chat.AddText( GD.AccentColor, "[GD] ", Color( 210, 200, 80, 255 ), "NPC", Color( 255, 255, 255, 255 ), ": " .. string.gsub( table.Random( GD.NPCLines ), "$money", "$" .. amt ) );
	
end
net.Receive( "nGDNPCGiven", nGDNPCGiven );

function GD.NPCOpenDealerDrug( ent, id, sidew )
	
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
	
	local tcost = math.floor( GD.Drugs[id].SellPrice * GD.DealerMultiplier );
	
	GD.DrugPanel.Drug.DrugName = vgui.Create( "DLabel", GD.DrugPanel.Drug );
	GD.DrugPanel.Drug.DrugName:SetText( GD.Drugs[id].Name .. "? It's yours for $" .. tcost .. "." );
	GD.DrugPanel.Drug.DrugName:SetFont( "GD.GUISmall" );
	GD.DrugPanel.Drug.DrugName:SizeToContents();
	GD.DrugPanel.Drug.DrugName:SetPos( x, y );
	
	y = y + 24;
	
	GD.DrugPanel.Drug.BuyBut = vgui.Create( "DButton", GD.DrugPanel.Drug );
	GD.DrugPanel.Drug.BuyBut:SetPos( x, y );
	GD.DrugPanel.Drug.BuyBut:SetSize( 300, 60 );
	GD.DrugPanel.Drug.BuyBut:SetFont( "GD.GUIButton" );
	GD.DrugPanel.Drug.BuyBut:SetText( "Buy ($" .. tcost .. ")" );
	GD.DrugPanel.Drug.BuyBut:PerformLayout();
	GD.DrugPanel.Drug.BuyBut:SetSkin( "GD" );
	GD.DrugPanel.Drug.BuyBut.ID = id;
	function GD.DrugPanel.Drug.BuyBut:DoClick()
		
		if( GD.GetMoney( LocalPlayer() ) < tcost ) then
			
			GD.DrugLabPopup( "You can't afford this!" );
			return;
			
		end
		
		self:SetDisabled( true );
		GD.DrugPanel:SetMouseInputEnabled( false );
		GD.DrugPanel:SetKeyboardInputEnabled( false );
		GD.DrugPanel:AlphaTo( 0, GD.FadeDelay, 0, function()
			
			GD.DrugPanel:Remove();
			GD.DrugPanel = nil;
			
		end );
		
		net.Start( "nGDDealerNPCBuy" );
			net.WriteEntity( ent );
			net.WriteString( self.ID );
		net.SendToServer();
		
		chat.AddText( GD.AccentColor, "[GD] ", Color( 255, 255, 255, 255 ), "You spent ", Color( 100, 255, 100, 255 ), "$" .. tcost, Color( 255, 255, 255, 255 ), " on ", Color( 255, 100, 0, 255 ), GD.Drugs[self.ID].Name, Color( 255, 255, 255, 255 ), "." );
		
	end
	
end

function GD.NPCOpenDealerDrugInit( ent, id, sidew )
	
	if( !GD.DrugPanel or !GD.DrugPanel:IsValid() ) then return end
	
	if( GD.DrugPanel.Drug and GD.DrugPanel.Drug:IsValid() ) then
		
		GD.DrugPanel.Drug:AlphaTo( 0, GD.FadeDelay, 0, function()
			
			GD.DrugPanel.Drug:Remove();
			GD.DrugPanel.Drug = nil;
			GD.NPCOpenDealerDrug( ent, id, sidew );
			
		end );
		
	else
		
		GD.NPCOpenDealerDrug( ent, id, sidew );
		
	end
	
end

local function nGDDealerNPCUsed( len )
	
	local ent = net.ReadEntity();
	
	GD.OpenMainPanel();
	
	surface.SetFont( "GD.GUITitle" );
	local w, h = surface.GetTextSize( "Dealer" );
	
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
	GD.DrugPanel.Side.Title:SetText( "Dealer" );
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
		
	end
	
	local y = 100;
	
	GD.DrugPanel.Side.Title = vgui.Create( "DLabel", GD.DrugPanel.Side );
	GD.DrugPanel.Side.Title:SetPos( 20, y );
	GD.DrugPanel.Side.Title:SetFont( "GD.GUISmall" );
	GD.DrugPanel.Side.Title:SetText( "Psst. Wanna buy something?" );
	GD.DrugPanel.Side.Title:SizeToContents();
	
	y = y + 34;
	
	local sidescroll = vgui.Create( "DScrollPanel", GD.DrugPanel.Side );
	sidescroll:SetPos( 0, y );
	sidescroll:SetSize( sidew, ScrH() - y - buttonheight - 100 - 20 );
	sidescroll:PerformLayout();
	sidescroll:SetSkin( "GD" );
	
	y = 0;
	
	local tbl = table.Copy( GD.Drugs );
	table.sort( tbl, function( a, b ) return a.Name < b.Name; end );
	
	for _, v in pairs( tbl ) do
		
		local b = vgui.Create( "DButton", sidescroll );
		b:SetPos( 0, y );
		b:SetSize( GD.DrugPanel.Side:GetWide(), buttonheight );
		b:SetFont( "GD.GUIButton" );
		b:SetText( v.Name );
		b:PerformLayout();
		b:SetSkin( "GD" );
		b.ID = v.ID;
		function b:DoClick()
			
			GD.NPCOpenDealerDrugInit( ent, self.ID, sidew );
			
		end
		
		y = y + buttonheight;
		
	end
	
	GD.CreateRankInfo( GD.DrugPanel.Side, GD.DrugPanel.Side:GetTall() - buttonheight - 100 );
	
end
net.Receive( "nGDDealerNPCUsed", nGDDealerNPCUsed );