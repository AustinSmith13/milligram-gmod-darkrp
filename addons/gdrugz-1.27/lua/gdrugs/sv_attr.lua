function GD.GravGunOnPickedUp( ply, ent )
	
	if( ent.GDrug or ent:GetClass() == "gd_testkit" ) then
		
		ent.Player = ply;
		
	end
	
end
hook.Add( "GravGunOnPickedUp", "GD.GravGunOnPickedUp", GD.GravGunOnPickedUp );

function GD.PhysgunPickup( ply, ent )
	
	if( ent.GDrug or ent:GetClass() == "gd_testkit" ) then
		
		ent.Player = ply;
		
	end
	
end
hook.Add( "PhysgunPickup", "GD.PhysgunPickup", GD.PhysgunPickup );

function GD.PlayerDisconnected( ply )
	
	if( GD.DisconnectRemoveLabs ) then
		
		for _, v in pairs( ents.FindByClass( "gd_lab" ) ) do
			
			if( v.SID == ply.SID ) then
				
				v:Remove();
				
			end
			
		end
		
	end
	
end
hook.Add( "PlayerDisconnected", "GD.PlayerDisconnected", GD.PlayerDisconnected );

function GD.OnPlayerChangedTeam( ply, src, dest )
	
	if( GD.TeamRemoveLabs ) then
		
		for _, v in pairs( ents.FindByClass( "gd_lab" ) ) do
			
			if( v.SID == ply.SID ) then
				
				if( v:GetDrugLabType() == GD_DRUGLAB_LAB ) then
					
					if( GD.DrugLabJobs and !table.HasValue( GD.DrugLabJobs, dest ) ) then
						
						v:Remove();
						
					end
					
				elseif( v:GetDrugLabType() == GD_DRUGLAB_POT ) then
					
					if( GD.DrugPotJobs and !table.HasValue( GD.DrugPotJobs, dest ) ) then
						
						v:Remove();
						
					end
					
				elseif( v:GetDrugLabType() == GD_DRUGLAB_BREWERY ) then
					
					if( GD.BreweryJobs and #GD.BreweryJobs > 0 and !table.HasValue( GD.BreweryJobs, dest ) ) then
						
						v:Remove();
						
					end
					
				end
				
			end
			
		end
		
	end
	
end
hook.Add( "OnPlayerChangedTeam", "GD.OnPlayerChangedTeam", GD.OnPlayerChangedTeam );