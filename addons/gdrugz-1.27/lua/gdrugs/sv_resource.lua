resource.AddSingleFile( "resource/fonts/goodbylullaby.ttf" );

if( GD.UseWorkshop ) then
	
	resource.AddWorkshop( "571156806" );
	
else

	resource.AddFile( "models/gdrugs/drugpot.mdl" );
	resource.AddFile( "models/gdrugs/cocaine/cocaine.mdl" );
	resource.AddFile( "models/gdrugs/weed/weed.mdl" );
	resource.AddFile( "models/gdrugs/mdma/mdma.mdl" );
	resource.AddFile( "models/gdrugs/meth/meth.mdl" );
	resource.AddFile( "models/gdrugs/shrooms/shrooms.mdl" );

	resource.AddFile( "materials/gdrugs/drugpot/weedplant_bud.vmt" );
	resource.AddFile( "materials/gdrugs/drugpot/weedplant_dirt.vmt" );
	resource.AddFile( "materials/gdrugs/drugpot/weedplant_leaf_new.vmt" );
	resource.AddFile( "materials/gdrugs/drugpot/weedplant_leaf_texture.vmt" );
	resource.AddFile( "materials/gdrugs/drugpot/weedplant_texture.vmt" );
	resource.AddSingleFile( "materials/gdrugs/drugpot/weedplant_bud_bump.vtf" );
	resource.AddSingleFile( "materials/gdrugs/drugpot/weedplant_leaf_new_bump.vtf" );
	
	resource.AddFile( "materials/gdrugs/cocaine/drug.vmt" );
	resource.AddFile( "materials/gdrugs/weed/contraband_one.vmt" );
	resource.AddSingleFile( "materials/gdrugs/weed/contraband_two.vmt" );
	resource.AddFile( "materials/gdrugs/mdma/contraband_one.vmt" );
	resource.AddSingleFile( "materials/gdrugs/mdma/contraband_two.vmt" );
	resource.AddFile( "materials/gdrugs/meth/contraband_one.vmt" );
	resource.AddSingleFile( "materials/gdrugs/meth/contraband_two.vmt" );
	resource.AddFile( "materials/gdrugs/shrooms/contraband_one.vmt" );
	resource.AddSingleFile( "materials/gdrugs/shrooms/contraband_two.vmt" );
	
	resource.AddFile( "materials/gdrugs/mdma.vmt" );
	resource.AddFile( "materials/gdrugs/lsd.vmt" );
	
end