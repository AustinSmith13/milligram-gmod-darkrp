function GD.DarkRPInit()
	
	include( "gdrugs_config.lua" );

	DarkRP.createCategory( {
		name = "GDrugs",
		categorises = "entities",
		startExpanded = true,
		color = GD.AccentColor,
		canSee = fp{fn.Id, true},
		sortOrder = 255,
	} );
	
	DarkRP.createEntity( "Drug Lab", {
		ent = "gd_lab",
		model = GD.DrugLabModel,
		price = GD.DrugLabPrice,
		max = GD.DrugLabMax,
		cmd = GD.DrugLabCommand,
		category = "GDrugs",
		allowed = GD.DrugLabJobs,
		spawn = function( ply, tr, enttab )
			
			local ent = ents.Create( enttab.ent );
			ent:SetPos( tr.HitPos );
			ent:SetDrugLabType( GD_DRUGLAB_LAB );
			ent.SID = ply.SID;
			ent.allowed = enttab.allowed;
			ent.DarkRPItem = enttab;
			ent:Spawn();
			ent:Activate();
			return ent;
			
		end,
		level = ( GD.DrugLabLevel > 0 and GD.DrugLabLevel or nil ),
		weight = GD.DrugLabWeight
	} );

	DarkRP.createEntity( "Drug Pot", {
		ent = "gd_lab",
		model = GD.DrugPotModel,
		price = GD.DrugPotPrice,
		max = GD.DrugPotMax,
		cmd = GD.DrugPotCommand,
		category = "GDrugs",
		allowed = GD.DrugPotJobs,
		spawn = function( ply, tr, enttab )
			
			local ent = ents.Create( enttab.ent );
			ent:SetPos( tr.HitPos );
			ent:SetDrugLabType( GD_DRUGLAB_POT );
			ent.SID = ply.SID;
			ent.allowed = enttab.allowed;
			ent.DarkRPItem = enttab;
			ent:Spawn();
			ent:Activate();
			return ent;
			
		end,
		level = ( GD.DrugPotLevel > 0 and GD.DrugPotLevel or nil ),
		weight = GD.DrugPotWeight
	} );

	DarkRP.createEntity( "Brewery", {
		ent = "gd_lab",
		model = GD.BreweryModel,
		price = GD.BreweryPrice,
		max = GD.BreweryMax,
		cmd = GD.BreweryCommand,
		category = "GDrugs",
		allowed = GD.BreweryJobs,
		spawn = function( ply, tr, enttab )
			
			local ent = ents.Create( enttab.ent );
			ent:SetPos( tr.HitPos );
			ent:SetDrugLabType( GD_DRUGLAB_BREWERY );
			ent.SID = ply.SID;
			ent.allowed = enttab.allowed;
			ent.DarkRPItem = enttab;
			ent:Spawn();
			ent:Activate();
			return ent;
			
		end,
		level = ( GD.BreweryLevel > 0 and GD.BreweryLevel or nil ),
		weight = GD.BreweryWeight
	} );

	if( GD.TestKitEnabled ) then
		
		DarkRP.createEntity( "Drug Test Kit", {
			ent = "gd_testkit",
			model = "models/props_lab/jar01b.mdl",
			price = GD.TestKitPrice,
			max = GD.TestKitMax,
			cmd = GD.TestKitCommand,
			category = "GDrugs",
			spawn = function( ply, tr, enttab )
				
				local ent = ents.Create( enttab.ent );
				ent:SetPos( tr.HitPos );
				ent.SID = ply.SID;
				ent.allowed = enttab.allowed;
				ent.DarkRPItem = enttab;
				ent.Player = ply;
				ent:Spawn();
				ent:Activate();
				return ent;
				
			end,
			level = ( GD.DrugKitLevel > 0 and GD.DrugKitLevel or nil ),
			weight = GD.DrugKitWeight
		} );

	end
	
	if( GD.F4Drugs ) then
		
		for k, v in pairs( GD.Drugs ) do
			
			DarkRP.createEntity( v.Name, {
				ent = "gd_" .. k,
				allowed = GD.F4Allowed,
				model = v.Model,
				price = math.floor( v.SellPrice * GD.F4PriceMul ),
				max = GD.F4Max,
				cmd = GD.F4Command .. k,
				category = "GDrugs",
				level = ( GD.F4DrugLevel > 0 and GD.F4DrugLevel or nil ),
				weight = GD.F4Weight,
				spawn = function( ply, tr, enttab )
					
					local ent = ents.Create( enttab.ent );
					ent:SetPos( tr.HitPos );
					ent.SID = ply.SID;
					ent.allowed = enttab.allowed;
					ent.DarkRPItem = enttab;
					ent.Player = ply;
					ent:SetDrugQuality( math.Rand( v.Purity[1], v.Purity[2] ) );
					ent:Spawn();
					ent:Activate();
					return ent;
					
				end,
			} );
			
		end
		
	end
	
end
hook.Add( "loadCustomDarkRPItems", "GD.DarkRPInit", GD.DarkRPInit );
