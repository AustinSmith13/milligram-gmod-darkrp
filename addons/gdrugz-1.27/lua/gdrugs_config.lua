-- General settings

GD.CanCancelCooks		= true;		-- Can people cancel cooking midway through? (true/false)
GD.CanSellDirectly		= true;		-- Can people sell drugs directly via the script? (true/false)
GD.CanNameDrugs			= true;		-- Can people name their drugs? (true/false)

GD.ThirdPersonCook		= true;		-- Should the camera rotate around while in the GD Menu? (true/false)

GD.RevenueMultiplier	= 1.5;		-- Are drug labs not earning enough profit? Increase this to multiply revenue across all drugs. (default 1.0)
GD.TimeMultiplier		= 1.0;		-- Decrease this multiplier to make drugs take longer to cook. (default 1.0)

GD.CookTimeout			= 300;		-- If a user is in the drug menu for this many seconds without doing anything, they're kicked out (ie. someone goes AFK using a drug lab, preventing other people from using it) (default 300)

GD.RestrictUseToCook	= false;	-- If this is true, only the person who bought the druglab can use it.
GD.RestrictDrugToCook	= false;	-- If this is true, only the person who started a cook can cancel the cook or retrieve the drug.

GD.LabFadeStart			= 500;		-- How far away should the "Drug Lab" and "Drug Pot" text be visible (default 500/700)
GD.LabFadeEnd			= 700;
GD.DrugFadeStart		= 200;		-- How far away should drugs and their names be visible (default 200/400)
GD.DrugFadeEnd			= 400;
GD.NPCFadeStart			= 500;		-- How far away should NPC types be visible (default 500/700)
GD.NPCFadeEnd			= 700;

GD.LabSounds			= true;		-- Should drug labs play a sound while cooking? (true/false)

GD.AdminsCanSpawn		= true;		-- Can admins spawn drugs from spawnmenu? (true/false)
GD.AdminsCanSpawnNPCs	= true;		-- Can admins spawn NPCs from spawnmenu? Note that they don't stay over server restarts! (true/false)

GD.CanOverdose			= true;		-- Can people overdose from drugs? (true/false)
GD.OverdoseCount		= 4;		-- How many drugs can one person take before dying? (default 4)

GD.DisconnectRemoveLabs	= true;		-- Should drug labs be removed on player disconnect? (true/false)
GD.TeamRemoveLabs		= true;		-- Should changing team to a team that doesn't have access to drug labs, remove a player's drug labs? (true/false)

GD.DrugDespawnTime		= 12;		-- Number of hours drugs should exist before automatically de-spawning (default 12)

GD.Itemstore			= true;		-- Should itemstore be enabled?

-- Effect settings
-- Some people hate motion blur with a passion - this is for them

GD.DrawMotionBlur 	= true;		-- Draw motion blur (true/false)
GD.DrawOverlays		= true;		-- Draw overlays (true/false)
GD.DrawBloom		= true;		-- Draw bloom (true/false)
GD.DrawColormod		= true;		-- Draw colormod (true/false)
GD.DrawSharpen		= true;		-- Draw sharpen (true/false)
GD.DrawHalos		= true;		-- Draw halos (true/false)

GD.ComeUpTime		= 5;		-- How many seconds does it take for the drug to "fade in"? (default 5)
GD.ComeDownTime		= 4/5;		-- At fraction of the total duration of the drug should the drug start "fading out"? eg. if a drug lasts 60 seconds, and this is set to 4/5, the drug will start to fade out at 48 seconds. (default 4/5)

GD.LabParticles		= true;		-- Should the drug lab have refract particles when its on? (true/false)


-- Levelling settings

GD.Levelling		= true;		-- Should the levelling system exist? (true/false) If disabled, drug quality will be random.
GD.Levels = {	-- Levels: { xp required, rank name }
	{ 0, "Newbie" },
	{ 2000, "Junkie" },
	{ 5000, "Cook" },
	{ 20000, "Lab Assistant" },
	{ 50000, "Chemist" },
	{ 100000, "Drug Kingpin" }
};
GD.XPMultiplier		= 1;	-- Bigger number, more XP. For example, 0.01 = 1% XP, 10 = 1000% XP

-- Damage Settings

GD.DrugLabsDamageable	= true;	-- Should drug labs take damage and be destroyed after too much? (true/false)
GD.DrugLabHealth		= 500;		-- Drug Lab health
GD.DrugPotHealth		= 50;		-- Drug Pot health
GD.BreweryHealth		= 500;		-- Brewery Health

-- NPC settings

GD.NPCsEnabled		= true;		-- Should the NPC system spawn NPCs? (true/false)
GD.NPCMultiplierMin	= 1.0;		-- How much more (or less) should NPCs pay, compared to normal prices, as a multiple? (default 1.0/1.2)
GD.NPCMultiplierMax	= 1.2;
GD.ShowNPCTitles	= true;		-- Should we show "Drug Dealer" etc above NPCs? (true/false)

-- Spawnpoints for NPC buyers.
-- To get these, run gd_npc in your console while on the server's map.
-- It'll output the position where you're standing.
GD.NPCSpawns = {
	{ Vector( 26, 951,-195 ), Angle( 0, -93, 0 ) },

}

-- These are for NPC dealers. Same process as above.
GD.DealerNPCSpawns = {
	--{ Vector( 26, 951,-195 ), Angle( 0, -93, 0 ) },
	{ Vector( 26, 951,-195 ), Angle( 0, -93, 0 ) },
	{ Vector( 17, 4201,-195 ), Angle( 0, -47, 0 ) },
	{ Vector( -970, 1561,-447 ), Angle( 0, 91, 0 ) }

}
GD.DealerMultiplier = 1.2;		-- What cost multiple do dealers charge, compared to how much it'd sell for if you made it yourself?
GD.FreezeNPCs = true;			-- Should NPCs teleport back to their original position if moved?

GD.DealersTakeDrugs = true;		-- Drug dealers function as drug buyers, you can bring them drugs (true/false).

GD.NPCModels = { -- Models for the NPCs to pick at random
	"models/humans/group01/male_01.mdl",
	"models/humans/group01/male_02.mdl",
	"models/humans/group01/male_03.mdl",
	"models/humans/group01/male_04.mdl",
	"models/humans/group01/male_05.mdl",
	"models/humans/group01/male_06.mdl",
	"models/humans/group01/male_07.mdl",
	"models/humans/group01/male_08.mdl",
	"models/humans/group01/male_09.mdl",
	"models/humans/group01/female_01.mdl",
	"models/humans/group01/female_02.mdl",
	"models/humans/group01/female_03.mdl",
	"models/humans/group01/female_04.mdl",
	"models/humans/group01/female_06.mdl",
	"models/humans/group01/female_07.mdl"
}

GD.NPCLines = { -- Lines for the NPCs to say when you sell them drugs
	"Thanks, buddy! Here's $money.",
	"Just what I needed. $money enough?",
	"That'll hit the spot! $money's yours!",
	"Only $money? Great!",
	"Oh yeah, that's it. $money comin' right up."
}


-- DarkRP settings

GD.DrugLabCommand	= "gdbuydruglab";	-- Command to buy drug lab
GD.DrugLabMax		= 3;				-- Max number of entities
GD.DrugLabPrice		= 1000;				-- Cost of drug lab
GD.DrugLabJobs		= { TEAM_DRUG };	-- Jobs allowed to buy drug lab
GD.DrugLabModel		= "models/props_wasteland/laundry_washer003.mdl"	-- Model of the drug lab

GD.DrugPotCommand	= "gdbuydrugpot";	-- Command to buy drug pot
GD.DrugPotMax		= 5;				-- Max number of entities
GD.DrugPotPrice		= 100;				-- Cost of drug pot
GD.DrugPotJobs		= { TEAM_CITIZEN, TEAM_HOBO, TEAM_GANG, TEAM_MOB, TEAM_HITMAN, TEAM_THIEF, TEAM_GUARD, TEAM_HOTEL, TEAM_KINGHOBO, TEAM_ETOO, TEAM_BLACK, TEAM_DRUG };	-- Jobs allowed to buy drug pot
GD.DrugPotModel		= "models/gdrugs/drugpot.mdl"	-- Model of the drug pot

GD.BreweryCommand	= "gdbuybrewery";	-- Command to buy brewery
GD.BreweryMax		= 3;				-- Max number of entities
GD.BreweryPrice		= 500;				-- Cost of brewery
GD.BreweryJobs		= { TEAM_CITIZEN, TEAM_HOBO, TEAM_GANG, TEAM_MOB, TEAM_HITMAN, TEAM_THIEF, TEAM_GUARD, TEAM_HOTEL, TEAM_KINGHOBO, TEAM_ETOO, TEAM_BLACK, TEAM_DRUG };	-- Jobs allows to buy brewery
GD.BreweryModel		= "models/props_wasteland/laundry_washer001a.mdl"; -- Model of brewery

GD.TestKitEnabled	= true;				-- Can players buy test kits? (true/false)
GD.TestKitCommand	= "gdbuytestkit";	-- Command to buy test kit
GD.TestKitMax		= 10;				-- Max number of test kits
GD.TestKitPrice		= 10;				-- Cost of test kit

GD.DrugLabLevel		= 0;	-- If you have a levelling/XP system, you must be this level to purchase a drug lab
GD.DrugPotLevel		= 0;	-- Same as above, for pots
GD.BreweryLevel		= 0;	-- Same as above, for breweries
GD.DrugKitLevel		= 0;	-- Same as above, for test kits

GD.DrugLabWeight	= 0;	-- If you use an inventory system with weight, how much should drug labs weigh?
GD.DrugPotWeight	= 0;	-- Above, but for pots?
GD.BreweryWeight	= 0;	-- Above, but for breweries?
GD.DrugKitWeight	= 0;	-- Above, but for kits?

GD.GrantLevelsXP	= false;	-- Grant DarkRP levels module XP to users for cooking drugs? (true/false)
GD.GrantLevelsXPAmt	= 150;		-- Amount DarkRP levels module XP to give users for cooking drugs

GD.CanPocketPots	= true;	-- Can players pocket drug labs/pots?
GD.CanPocketLabs	= true;

GD.F4Drugs			= true;		-- Can players buy drugs direct from the F4 menu?
GD.F4Allowed		= { TEAM_DRUG };	-- Jobs allowed to buy F4 drugs
GD.F4PriceMul		= 1.3;		-- How much more expensive than normal should F4 drugs be? (similar to GD.DealerMultiplier)
GD.F4Max			= 1;		-- What is the max number of F4 drugs you can buy?
GD.F4Command		= "gdbuy";	-- What should commands start with? (ie. gdbuycoke, gdbuyweed etc)
GD.F4DrugLevel		= 0;		-- If you use a levelling system, you must be this level to buy drugs
GD.F4Weight			= 0.25;		-- If you use an inventory with a weight system, drugs weigh this much


-- Itemstore settings
GD.ItemStoreStackable	= true;	-- Can the drugs stack in itemstore?


-- Misc settings

GD.DisplayAtStart	= false;		-- Display the intro message ("This server is running...") (true/false)
GD.AccentColor 		= Color( 0, 150, 255, 255 );		-- Color of button highlights, progress bars, etc (default blue)
GD.Font				= "Good bye lullaby";	-- Font for GDrugs. If you have non-English translations, you may want to change this into "Arial" or similar.

GD.UseWorkshop		= false;	-- Use the Gmod Workshop for downloads? If false, uses regular FastDL (true/false)


-- For tweaking the drugs themselves, look in: 	lua/gdrugs/drugs/*.lua
	-- Be aware that all drugs are balanced to have ~equal profit (taking cook time and average drug quality into account).
	-- If you want to make drugs earn more profit try increasing GD.RevenueMultiplier or decreasing GD.TimeMultiplier.
	-- The base income is ~$1 per second, given half-yield (ie. LSD has a 50-100% quality, so for 75% quality, it earns $1/second).
	-- So, GD.RevenueMultiplier = 2 will make drug labs earn $2/second on average.