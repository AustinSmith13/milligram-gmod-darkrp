--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]



--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]


TEAM_HITMAN = DarkRP.createJob("Hitman", {
    color = Color(173, 8, 8, 255),
    model = {"models/player/Group01/male_04.mdl"},
    description = [[Take hits, carry them out. Don't RDM.]],
    weapons = {"lite_usp"},
    command = "hitman",
    max = 3,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Crime"
})
DarkRP.addHitmanTeam(TEAM_HITMAN)

TEAM_THIEF = DarkRP.createJob("Thief", {
    color = Color(148, 148, 148, 255),
    model = {"models/player/arctic.mdl"},
    description = [[Steal everything, raid, mug.]],
    weapons = {"lockpick", "keypad_cracker"},
    command = "thief",
    max = 6,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Crime"
})

TEAM_GUARD = DarkRP.createJob("Guard", {
    color = Color(0, 223, 255, 255),
    model = {"models/player/odessa.mdl"},
    description = [[Be hired to guard other players, illegally or legally.]],
    weapons = {"weaponchecker", "lite_usp"},
    command = "guard",
    max = 2,
    salary = 110,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Citizens"
})

TEAM_HOTEL = DarkRP.createJob("Hotel Manager", {
    color = Color(48, 235, 121, 255),
    model = {"models/player/hostage/hostage_04.mdl"},
    description = [[Run the Hotel or A Hotel]],
    weapons = {},
    command = "hotel",
    max = 1,
    salary = 120,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Citizens"
})

TEAM_KINGHOBO = DarkRP.createJob("King Hobo", {
    color = Color(133, 0, 32, 255),
    model = {"models/player/charple.mdl"},
    description = [[Lead the hobo army]],
    weapons = {"lite_xm1014"},
    command = "hoboleader",
    max = 1,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    NeedToChangeFrom = TEAM_HOBO,
    category = "Citizens"
})

TEAM_ETOO = DarkRP.createJob("E2 Contractor", {
    color = Color(255, 214, 0, 255),
    model = {"models/player/hostage/hostage_02.mdl"},
    description = [[E2 Contractor]],
    weapons = {},
    command = "etoo",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
})

TEAM_BLACK = DarkRP.createJob("Black Market Dealer", {
    color = Color(133, 19, 32, 255),
    model = {"models/player/leet.mdl"},
    description = [[Sell Illegal Items]],
    weapons = {},
    command = "black",
    max = 2,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Citizens"
})

TEAM_POLICE = DarkRP.createJob("Civil Protection", {
    color = Color(25, 25, 170, 255),
    model = {"models/player/police.mdl", "models/player/police_fem.mdl"},
    description = [[The protector of every citizen that lives in the city.
        You have the power to arrest criminals and protect innocents.
        Hit a player with your arrest baton to put them in jail.
        Bash a player with a stunstick and they may learn to obey the law.
        The Battering Ram can break down the door of a criminal, with a warrant for their arrest.
        The Battering Ram can also unfreeze frozen props (if enabled).
        Type /wanted <name> to alert the public to the presence of a criminal.]],
    weapons = {"arrest_stick", "unarrest_stick", "lite_fiveseven", "stunstick", "door_ram", "weaponchecker"},
    command = "cp",
    max = 4,
    salary = GAMEMODE.Config.normalsalary * 1.45,
    admin = 0,
    vote = true,
    hasLicense = true,
    ammo = {
        ["pistol"] = 60,
    },
    category = "Civil Protection",
})

TEAM_CHIEF = DarkRP.createJob("Civil Protection Chief", {
    color = Color(20, 20, 255, 255),
    model = "models/player/combine_soldier_prisonguard.mdl",
    description = [[The Chief is the leader of the Civil Protection unit.
        Coordinate the police force to enforce law in the city.
        Hit a player with arrest baton to put them in jail.
        Bash a player with a stunstick and they may learn to obey the law.
        The Battering Ram can break down the door of a criminal, with a warrant for his/her arrest.
        Type /wanted <name> to alert the public to the presence of a criminal.
        Type /jailpos to set the Jail Position]],
    weapons = {"arrest_stick", "unarrest_stick", "lite_aug", "stunstick", "door_ram", "weaponchecker", "weapon_breachingram"},
    command = "chief",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 1.67,
    admin = 0,
    vote = false,
    hasLicense = true,
    chief = true,
    NeedToChangeFrom = TEAM_POLICE,
    ammo = {
        ["pistol"] = 60,
    },
    category = "Civil Protection",
})

TEAM_DRUG = DarkRP.createJob("Drug Lord", {
    color = Color(125, 86, 86, 255),
    model = {"models/player/soldier_stripped.mdl"},
    description = [[Cook and make hard drugs.]],
    weapons = {"lite_fiveseven"},
    command = "drugdealer",
    max = 4,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Crime"
})

TEAM_BITCOIN = DarkRP.createJob("Bitcoin Miner", {
    color = Color(0, 255, 239, 255),
    model = {"models/player/magnusson.mdl"},
    description = [[You invest large amounts of fiat currency to mine bitcoin.]],
    weapons = {},
    command = "bitcoimmin",
    max = 3,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Citizens"
})