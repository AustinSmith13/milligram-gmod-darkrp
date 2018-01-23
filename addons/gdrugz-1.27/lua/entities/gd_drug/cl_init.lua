include( "shared.lua" );

function ENT:Draw3D2D( p )
	
	local a = 1;
	local d = LocalPlayer():EyePos():Distance( p );
	if( d > GD.DrugFadeStart ) then
		a = 1 - ( ( d - GD.DrugFadeStart ) / ( GD.DrugFadeEnd - GD.DrugFadeStart ) );
	end
	
	if( a <= 0 ) then return end
	
	surface.SetFont( "GD.LabEntitySmall" );
	local w, h = surface.GetTextSize( self.PrintName );
	
	local y = 0;
	
	surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
	surface.SetTextPos( -w / 2, y );
	surface.DrawText( self.PrintName );
	
	y = y + h;
	
	if( self:GetDrugName() != "" ) then
		
		surface.SetFont( "GD.LabEntity30" );
		local w, h = surface.GetTextSize( "\"" .. self:GetDrugName() .. "\"" );
		
		surface.SetTextPos( -w / 2, y );
		surface.DrawText( "\"" .. self:GetDrugName() .. "\"" );
		
	end
	
end

function ENT:Draw()
	
	self:DrawModel();
	
	local a = LocalPlayer():EyeAngles();
	a:RotateAroundAxis( a:Forward(), 90 );
	a:RotateAroundAxis( a:Right(), 90 );
	
	local o = self:OBBMaxs().z + 10;
	local p = self:GetPos() + Vector( 0, 0, o );
	
	cam.Start3D2D( p, a, 0.07 );
		self:Draw3D2D( p );
	cam.End3D2D();
	
end

function ENT:isKeysOwnable()

	return false;
	
end
