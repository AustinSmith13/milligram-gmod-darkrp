include( "shared.lua" );

ENT.RenderGroup = RENDERGROUP_BOTH;

function ENT:Draw3D2D( x, y, p )
	
	local a = 1;
	local d = LocalPlayer():EyePos():Distance( p );
	if( d > GD.LabFadeStart ) then
		a = 1 - ( ( d - GD.LabFadeStart ) / ( GD.LabFadeEnd - GD.LabFadeStart ) );
	end
	
	if( a <= 0 ) then return end
	
	surface.SetFont( "GD.LabEntity" );
	surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
	
	local t = "Drug Lab";
	if( self:GetDrugLabType() == GD_DRUGLAB_POT ) then
		t = "Drug Pot";
	elseif( self:GetDrugLabType() == GD_DRUGLAB_BREWERY ) then
		t = "Brewery";
	end
	
	local w, _ = surface.GetTextSize( t );
	surface.SetTextPos( x + -w / 2, y );
	surface.DrawText( t );
	
	local by = y;
	
	if( self:GetDrugCompleteTime() > 0 ) then
		
		local w = 200;
		local h = 50;
		
		local m;
		
		for i = 0, h do
			m = 40 * ( 1 - i / h ) + 20 * ( i / h );
			surface.SetDrawColor( Color( m, m, m, 255 * a ) );
			surface.DrawRect( x - w, by + 120 + i, 2 * w, 1 );
		end
		
		local m = self:ProgressMul();
		
		local c = table.Copy( GD.AccentColor );
		c.a = c.a * a;
		surface.SetDrawColor( c );
		surface.DrawRect( x - w + 5, by + 120 + 5, ( 2 * w - 10 ) * m, h - 10 );
		
		local ti = math.max( math.ceil( self:GetDrugCompleteTime() - CurTime() ), 0 );
		
		surface.SetFont( "GD.LabEntitySmaller" );
		
		local t = "Cooked";
		
		if( GD.Drugs[self:GetDrugInProgress()].ActionTextPast ) then
			t = GD.Drugs[self:GetDrugInProgress()].ActionTextPast;
		end
		
		if( ti > 0 ) then
			t = string.ToMinutesSeconds( ti );
		end
		
		local w, _ = surface.GetTextSize( t );
		surface.SetTextPos( x - w / 2, by + 120 );
		surface.DrawText( t );
		
		by = by + 60;
		
	end
	
	if( GD.DrugLabsDamageable ) then
		
		local m = self:GetBaseHealth();
		
		if( m > 0 ) then
			
			local h = self:GetLabHealth();
			
			if( !self.CurHealthHUD ) then
				self.CurHealthHUD = h;
			end
			
			self.CurHealthHUD = math.Approach( self.CurHealthHUD, h, 0.5 );
			
			if( self.CurHealthHUD < m and self.CurHealthHUD > 0 ) then
				
				local mul = self.CurHealthHUD / m;
				
				local w = 100;
				local h = 30;
				
				local gc;
				
				for i = 0, h do
					gc = 40 * ( 1 - i / h ) + 20 * ( i / h );
					surface.SetDrawColor( Color( gc, gc, gc, 255 * a ) );
					surface.DrawRect( x - w, by + 120 + i, 2 * w, 1 );
				end
				
				surface.SetDrawColor( Color( 255, 0, 0, 255 ) );
				surface.DrawRect( x - w + 5, by + 120 + 5, ( 2 * w - 10 ) * mul, h - 10 );
				
				by = by + 40;
				
			end
			
		end
		
	end
	
end

ENT.SpriteMat = Material( "effects/blueflare1" );

function ENT:Steam( size, pos )
	
	if( GD.LabParticles ) then
		
		if( !self.Emitter ) then
			
			self.Emitter = ParticleEmitter( self:GetPos(), false );
			
		end
		
		if( self.Emitter ) then
			
			local v = pos;
			
			local p = self.Emitter:Add( "particle/warp1_warp", v );
			
			if( p ) then
				
				p:SetAngles( Angle( math.random( -180, 180 ), math.random( -180, 180 ), math.random( -180, 180 ) ) );
				p:SetAngleVelocity( Angle( math.Rand( -5, 5 ), math.Rand( -5, 5 ), math.Rand( -5, 5 ) ) );
				p:SetCollide( false );
				p:SetColor( 255, 255, 255 );
				p:SetDieTime( math.Rand( 0.3, 1 ) );
				p:SetEndAlpha( 0 );
				p:SetEndSize( 0 );
				p:SetLifeTime( 0 );
				p:SetStartAlpha( 255 );
				p:SetStartSize( size );
				p:SetVelocity( Vector( math.random( -10, 10 ), math.random( -10, 10 ), math.random( 20, 40 ) ) );
				
			end
			
		end
		
	end
	
end

function ENT:Draw()
	
	local a = LocalPlayer():EyeAngles();
	a:RotateAroundAxis( a:Forward(), 90 );
	a:RotateAroundAxis( a:Right(), 90 );
	
	local o = self:OBBMaxs().z + 15;
	local p = self:GetPos() + self:GetUp() * o;
	
	render.PushFlashlightMode( false );
	cam.Start3D2D( p, a, 0.07 );
		self:Draw3D2D( 0, 0, p );
	cam.End3D2D();
	render.PopFlashlightMode();
	
	if( self:GetDrugLabType() == GD_DRUGLAB_LAB and self:Cooking() ) then
		
		local m = string.lower( self:GetModel() );
		
		if( m == "models/props_wasteland/kitchen_stove001a.mdl" ) then
			
			render.SetMaterial( self.SpriteMat );
			render.DrawSprite( self:GetPos() + self:GetUp() * 35 + self:GetForward() * 15 + self:GetRight() * -9.7, 10, 10, Color( 255, 0, 0, 255 ) );
			
			self:Steam( 16, self:GetPos() + self:GetUp() * 35 + self:GetForward() * 0 + self:GetRight() * -18 );
			
		elseif( m == "models/props_wasteland/kitchen_stove002a.mdl" ) then
			
			render.SetMaterial( self.SpriteMat );
			render.DrawSprite( self:GetPos() + self:GetUp() * 82 + self:GetForward() * 18 + self:GetRight() * 13, 10, 10, Color( 0, 100, 255, 255 ) );
			render.DrawSprite( self:GetPos() + self:GetUp() * 82 + self:GetForward() * 18 + self:GetRight() * 8, 10, 10, Color( 0, 100, 255, 255 ) );
			
			render.DrawSprite( self:GetPos() + self:GetUp() * 82 + self:GetForward() * 16 + self:GetRight() * -10, 10, 10, Color( 255, 0, 0, 255 ) );
			render.DrawSprite( self:GetPos() + self:GetUp() * 82 + self:GetForward() * 16 + self:GetRight() * -12, 10, 10, Color( 255, 0, 0, 255 ) );
			render.DrawSprite( self:GetPos() + self:GetUp() * 82 + self:GetForward() * 16 + self:GetRight() * -14, 10, 10, Color( 255, 0, 0, 255 ) );
			
		elseif( m == "models/props_c17/furnitureboiler001a.mdl" ) then
			
			render.SetMaterial( self.SpriteMat );
			render.DrawSprite( self:GetPos() + self:GetUp() * 45 + self:GetRight() * 6 + self:GetForward() * 1, 32, 32, Color( 255, 0, 0, 255 ) );
			
		elseif( m == "models/props_wasteland/laundry_washer003.mdl" ) then
			
			self:Steam( 10, self:GetPos() + self:GetUp() * 15 + self:GetRight() * -10 + self:GetForward() * 16 );
			self:Steam( 20, self:GetPos() + self:GetUp() * 10 + self:GetRight() * -10 + self:GetForward() * -16 );
			
		end
		
	end
	
	self:DrawModel();
	
end
