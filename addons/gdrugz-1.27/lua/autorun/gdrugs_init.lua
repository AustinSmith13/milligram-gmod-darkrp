if( CLIENT ) then
	
	include( "gdrugs/cl_init.lua" );
	
else
	
	AddCSLuaFile();
	include( "gdrugs/sv_init.lua" );
	
end
