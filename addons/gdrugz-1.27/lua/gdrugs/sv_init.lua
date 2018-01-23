GD = GD or { };

AddCSLuaFile( "sh_enum.lua" );
AddCSLuaFile( "gdrugs_config.lua" );
AddCSLuaFile( "sh_init.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_gui.lua" );
AddCSLuaFile( "cl_npc.lua" );
AddCSLuaFile( "cl_skin.lua" );

include( "sh_enum.lua" );
include( "gdrugs_config.lua" );
include( "sh_init.lua" );
include( "sv_attr.lua" );
include( "sv_resource.lua" );

resource.AddFile( "resource/fonts/goodbylullaby.ttf" );

util.AddNetworkString( "GD.OpenDrugLab" );
util.AddNetworkString( "nGDStartDrug" );
util.AddNetworkString( "nGDEndDrug" );
util.AddNetworkString( "nGDEndDrugs" );
util.AddNetworkString( "nGDForceGUIClose" );
util.AddNetworkString( "nGDDisallowedLabUse" );
util.AddNetworkString( "nGDDisallowedLabCooked" );
util.AddNetworkString( "nGDTestKitInstructions" );
util.AddNetworkString( "nGDTestKit" );
util.AddNetworkString( "nGDNPCUsed" );
util.AddNetworkString( "nGDNPCGiven" );
util.AddNetworkString( "nGDDealerNPCUsed" );
util.AddNetworkString( "nGDDealerNPCBuy" );

function GD.AddMoney( ply, amt ) -- Wrapper
	
	ply:addMoney( amt );
	
end

function GD.Think()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( !v.GDrugs ) then v.GDrugs = { } end
		if( !v.GDrugStarts ) then v.GDrugStarts = { } end
		if( !v.GDrugQualities ) then v.GDrugQualities = { } end
		
		local s = v.GDrugs;
		
		if( s and #s > 0 ) then
			
			for m, n in pairs( s ) do
				
				local d = GD.Drugs[n].Duration;
				local start = v.GDrugStarts[m];
				
				local t = CurTime() - start;
				
				if( t > d ) then
					
					local q = v.GDrugQualities[m];
					
					net.Start( "nGDEndDrug" );
						net.WriteString( n );
						net.WriteFloat( q );
					net.Broadcast();
					
					if( GD.Drugs[n].OnEnd ) then
						
						GD.Drugs[n]:OnEnd( v, q );
						
					end
					
					table.remove( v.GDrugs, m );
					table.remove( v.GDrugStarts, m );
					table.remove( v.GDrugQualities, m );
					
				end
				
			end
			
		end
		
	end
	
end
hook.Add( "Think", "GD.Think", GD.Think );

function GD.ScalePlayerDamage( ply, hit, dmg )
	
	if( ply.GDDamageMul ) then
		
		local d = GD.UnderTheInfluence( ply );
		
		for k, v in pairs( d ) do
			
			local mul = GD.DrugMul( ply, k );
			
			dmg:ScaleDamage( ply.GDDamageMul + ( 1 - mul ) * ( 1 - ply.GDDamageMul ) );
			
		end
		
	end
	
end
hook.Add( "ScalePlayerDamage", "GD.ScalePlayerDamage", GD.ScalePlayerDamage );

function GD.PlayerInitialSpawn( ply )
	
	ply:SetNWInt( "GD.XP", tonumber( ply:GetPData( "GD.XP", 0 ) ) );
	
	ply.GDrugs = { };
	ply.GDrugStarts = { };
	ply.GDrugQualities = { };
	
end
hook.Add( "PlayerInitialSpawn", "GD.PlayerInitialSpawn", GD.PlayerInitialSpawn );

function GD.PlayerDeath( ply )
	
	ply.GDrugs = { };
	ply.GDrugStarts = { };
	ply.GDrugQualities = { };
	
	net.Start( "nGDEndDrugs" );
	net.Send( ply );
	
end
hook.Add( "PlayerDeath", "GD.PlayerDeath", GD.PlayerDeath );

function GD.InitPostEntity()
	
	if( GD.NPCsEnabled ) then
		
		for _, v in pairs( GD.NPCSpawns ) do
			
			local e = ents.Create( "gd_buyer" );
			e:SetPos( v[1] );
			e:SetAngles( Angle( 0, v[2].y, 0 ) );
			e.SpawnedPosition = v[1];
			e.SpawnedAngles = Angle( 0, v[2].y, 0 );
			e:Spawn();
			e:Activate();
			
		end
		
		for _, v in pairs( GD.DealerNPCSpawns ) do
			
			local e = ents.Create( "gd_dealer" );
			e:SetPos( v[1] );
			e:SetAngles( Angle( 0, v[2].y, 0 ) );
			e.SpawnedPosition = v[1];
			e.SpawnedAngles = Angle( 0, v[2].y, 0 );
			e:Spawn();
			e:Activate();
			
		end
		
	end
	
end
hook.Add( "InitPostEntity", "GD.InitPostEntity", GD.InitPostEntity );

function GD.CanPocket( ply, item )
	
	if( item:GetClass() == "gd_testkit" or item.GDrug ) then item.Player = ply end
	if( item:GetClass() == "gd_buyer" or item:GetClass() == "gd_dealer" ) then return false, "You can't pocket people!"; end
	
	if( item:GetClass() == "gd_lab" and item:GetDrugLabType() == GD_DRUGLAB_LAB and !GD.CanPocketLabs ) then return false, "You can't pocket pots!" end
	if( item:GetClass() == "gd_lab" and item:GetDrugLabType() == GD_DRUGLAB_POT and !GD.CanPocketPots ) then return false, "You can't pocket labs!" end
	if( item:GetClass() == "gd_lab" and item:GetDrugLabType() == GD_DRUGLAB_BREWERY and !GD.CanPocketBreweries ) then return false, "You can't pocket breweries!" end
	
end
hook.Add( "canPocket", "GD.CanPocket", GD.CanPocket );

function GD.NPCUsed( ent, ply )
	
	net.Start( "nGDNPCUsed" );
	net.Send( ply );
	
end

function GD.DealerNPCUsed( ent, ply )
	
	net.Start( "nGDDealerNPCUsed" );
		net.WriteEntity( ent );
	net.Send( ply );
	
end

local function nGDDealerNPCBuy( len, ply )
	
	local ent = net.ReadEntity();
	local drug = net.ReadString();
	
	if( !ent or !ent:IsValid() ) then return end
	if( ent:GetClass() != "gd_dealer" ) then return end
	if( ply:GetPos():Distance( ent:GetPos() ) > 250 ) then return end
	if( !GD.Drugs[drug] ) then return end
	
	local c = math.floor( GD.Drugs[drug].SellPrice * GD.DealerMultiplier );
	if( GD.GetMoney( ply ) < c ) then return end
	
	GD.AddMoney( ply, -c );
	
	ent:SpawnDrug( drug );
	
end
net.Receive( "nGDDealerNPCBuy", nGDDealerNPCBuy );

function GD.AddXP( ply, addxp )
	
	ply:SetNWInt( "GD.XP", ply:GetNWInt( "GD.XP", 0 ) + addxp );
	ply:SetPData( "GD.XP", ply:GetNWInt( "GD.XP" ) );
	
end

local function nGDCloseMenu( len, ply )
	
	local ent = net.ReadEntity();
	
	if( !ent or !ent:IsValid() ) then return end
	if( ent:GetClass() != "gd_lab" ) then return end
	
	if( ent:GetUser() == ply ) then
		
		ent:SetUser( NULL );
		ent.UserTime = nil;
		
	end
	
end
net.Receive( "nGDCloseMenu", nGDCloseMenu );
util.AddNetworkString( "nGDCloseMenu" );

local function nGDStartCook( len, ply )
	
	local ent = net.ReadEntity();
	local drug = net.ReadString();
	
	if( !ent or !ent:IsValid() ) then return end
	if( ent:GetClass() != "gd_lab" ) then return end
	if( ent:Cooking() ) then return end
	if( ply:GetPos():Distance( ent:GetPos() ) > 128 ) then return end
	if( !GD.Drugs[drug] ) then return end
	if( GD.Drugs[drug].LabType != ent:GetDrugLabType() ) then return end
	if( GD.Levelling and GD.Drugs[drug].MinLevel and GD.GetLevel( LocalPlayer() ) < GD.Drugs[drug].MinLevel ) then return end
	
	local c = GD.GetDrugCost( drug );
	if( GD.GetMoney( ply ) < c ) then return end
	
	GD.AddMoney( ply, -c );
	
	ent:SetUser( NULL );
	ent.UserTime = nil;
	
	ent:SetDrugInProgress( drug );
	ent:SetCook( ply );
	ent:SetDrugStartTime( CurTime() );
	ent:SetDrugCompleteTime( CurTime() + math.ceil( GD.TimeMultiplier * GD.Drugs[drug].LabTime ) );
	
	if( GD.Levelling ) then
		
		local diff = GD.Drugs[drug].Purity[2] - GD.Drugs[drug].Purity[1];
		local qual = GD.Drugs[drug].Purity[1] + math.Rand( diff * ( GD.GetLevel( ply ) - 1 ) / #GD.Levels, diff * ( GD.GetLevel( ply ) ) / #GD.Levels );
		
		ent:SetDrugQuality( qual );
		
	else
		
		ent:SetDrugQuality( math.Rand( GD.Drugs[drug].Purity[1], GD.Drugs[drug].Purity[2] ) );
		
	end
	
end
net.Receive( "nGDStartCook", nGDStartCook );
util.AddNetworkString( "nGDStartCook" );

local function nGDCancelCook( len, ply )
	
	if( !GD.CanCancelCooks ) then return end
	
	local ent = net.ReadEntity();
	
	if( !ent or !ent:IsValid() ) then return end
	if( ent:GetClass() != "gd_lab" ) then return end
	if( !ent:Cooking() ) then return end
	if( GD.RestrictDrugToCook and ent:GetCook() != ply ) then return end
	if( ply:GetPos():Distance( ent:GetPos() ) > 128 ) then return end
	
	ent:SetUser( NULL );
	ent.UserTime = nil;
	
	ent:SetDrugInProgress( "" );
	ent:SetCook( NULL );
	ent:SetDrugStartTime( -1 );
	ent:SetDrugCompleteTime( -1 );
	ent:SetDrugQuality( -1 );
	
end
net.Receive( "nGDCancelCook", nGDCancelCook );
util.AddNetworkString( "nGDCancelCook" );

local function nGDSellCook( len, ply )
	
	if( !GD.CanSellDirectly ) then return end
	
	local ent = net.ReadEntity();
	
	if( !ent or !ent:IsValid() ) then return end
	if( ent:GetClass() != "gd_lab" ) then return end
	if( !ent:Cooked() ) then return end
	if( GD.RestrictDrugToCook and ent:GetCook() != ply ) then return end
	if( ply:GetPos():Distance( ent:GetPos() ) > 128 ) then return end
	
	GD.AddMoney( ply, math.floor( GD.RevenueMultiplier * ent:GetDrugQuality() * GD.Drugs[ent:GetDrugInProgress()].SellPrice ) );
	
	if( GD.Levelling ) then
		GD.AddXP( ply, GD.Drugs[ent:GetDrugInProgress()].LabTime * GD.XPMultiplier );
	end
	
	if( GD.GrantLevelsXP and ply.addXP ) then
		ply:addXP( GD.GrantLevelsXPAmt );
	end
	
	ent:SetUser( NULL );
	ent.UserTime = nil;
	
	ent:SetDrugInProgress( "" );
	ent:SetCook( NULL );
	ent:SetDrugStartTime( -1 );
	ent:SetDrugCompleteTime( -1 );
	ent:SetDrugQuality( -1 );
	
end
net.Receive( "nGDSellCook", nGDSellCook );
util.AddNetworkString( "nGDSellCook" );

local function nGDTakeDrug( len, ply )
	
	local ent = net.ReadEntity();
	local name = net.ReadString();
	
	if( !ent or !ent:IsValid() ) then return end
	if( ent:GetClass() != "gd_lab" ) then return end
	if( !ent:Cooked() ) then return end
	if( GD.RestrictDrugToCook and ent:GetCook() != ply ) then return end
	if( ply:GetPos():Distance( ent:GetPos() ) > 128 ) then return end
	
	ent:SetUser( NULL );
	ent.UserTime = nil;
	
	if( GD.CanNameDrugs ) then
		ent:SpawnDrug( string.sub( name, 0, 32 ) );
	else
		ent:SpawnDrug( "" );
	end
	
	if( GD.Levelling ) then
		GD.AddXP( ply, GD.Drugs[ent:GetDrugInProgress()].LabTime * GD.XPMultiplier );
	end
	
	if( GD.GrantLevelsXP and ply.addXP ) then
		ply:addXP( GD.GrantLevelsXPAmt );
	end
	
	ent:SetDrugInProgress( "" );
	ent:SetCook( NULL );
	ent:SetDrugStartTime( -1 );
	ent:SetDrugCompleteTime( -1 );
	ent:SetDrugQuality( -1 );
	
end
net.Receive( "nGDTakeDrug", nGDTakeDrug );
util.AddNetworkString( "nGDTakeDrug" );
