function GD:LoadDrugs()
	
	if( !self.Drugs ) then
		self.Drugs = { };
	end
	
	local tab = file.Find( "gdrugs/drugs/*.lua", "LUA" );
	
	for _, v in pairs( tab ) do
		
		if( SERVER ) then
			
			AddCSLuaFile( "gdrugs/drugs/" .. v );
			
		end
		
		DRUG = { };
		
		include( "gdrugs/drugs/" .. v );
		
		self.Drugs[DRUG.ID] = DRUG;
		
		local ENT = { };
		
		ENT.Type 			= "anim";
		ENT.Base 			= "gd_drug";
		ENT.PrintName 		= DRUG.Name;
		ENT.DrugModel 		= DRUG.Model;
		ENT.DrugID 			= DRUG.ID;
		ENT.DrugQualityMin 	= DRUG.Purity[1];
		ENT.DrugQualityMax 	= DRUG.Purity[2];
		
		ENT.GDrug			= true;
		
		ENT.Category		= "GDrugs";
		ENT.Spawnable		= GD.AdminsCanSpawn;
		ENT.AdminSpawnable	= GD.AdminsCanSpawn;
		
		scripted_ents.Register( ENT, "gd_" .. DRUG.ID );
		
		DRUG = nil;
		
	end
	
end

GD:LoadDrugs();

function GD.GetMoney( ply )
	
	return ( ply:getDarkRPVar( "money" ) or 0 )
	
end

function GD.DrugMul( ply, id )
	
	if( !ply.GDrugs ) then ply.GDrugs = { } end
	local s = ply.GDrugs;
	
	if( #s != 0 and s[id] ) then
		
		local d = GD.Drugs[s[id]].Duration;
		local start = ply.GDrugStarts[id];
		
		local m = CurTime() - start;
		
		local mul;
		
		if( m < GD.ComeUpTime ) then
			
			if( GD.Drugs[s[id]].DurationCurve == GD_CURVE_LINEAR ) then
				
				mul = m / GD.ComeUpTime;
				
			else
				
				mul = math.EaseInOut( m / GD.ComeUpTime, 1, 1 );
				
			end
			
		elseif( m / d < GD.ComeDownTime ) then
			
			mul = 1;
			
		else
			
			if( GD.Drugs[s[id]].DurationCurve == GD_CURVE_LINEAR ) then
				
				mul = 1 - ( ( m - d * GD.ComeDownTime ) / ( d * ( 1 - GD.ComeDownTime ) ) );
				
			elseif( GD.Drugs[s[id]].DurationCurve == GD_CURVE_POLY ) then
				
				mul = 1 - math.EaseInOut( ( ( m - d * GD.ComeDownTime ) / ( d * ( 1 - GD.ComeDownTime ) ) ), 1, 1 );
				
			end
			
		end
		
		local q = ply.GDrugQualities[id];
		mul = mul * q;
		
		if( m < d ) then
			
			return mul;
			
		end
		
	end
	
	return 0;
	
end

function GD.UnderTheInfluence( ply )
	
	if( !ply.GDrugs ) then ply.GDrugs = { } end
	return ply.GDrugs;
	
end

function GD.GetDrugCost( d )
	
	local n = 0;
	
	for _, v in pairs( GD.Drugs[d].Ingredients ) do
		n = n + v[1];
	end
	
	return n;
	
end

function GD.XP( ply )
	
	return ply:GetNWInt( "GD.XP", 0 );
	
end

function GD.GetLevel( ply )
	
	local x = GD.XP( ply );
	
	for i = #GD.Levels, 1, -1 do
		
		if( x >= GD.Levels[i][1] ) then
			
			return i;
			
		end
		
	end
	
	return 1;
	
end

function GD.ShouldCollide( e1, e2 )
	
	if( e1.GDrug and e2.GDrug ) then return false end
	
end
hook.Add( "ShouldCollide", "GD.ShouldCollide", GD.ShouldCollide );