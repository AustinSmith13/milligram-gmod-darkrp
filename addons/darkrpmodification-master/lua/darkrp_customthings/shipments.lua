--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]

DarkRP.createShipment("Unarrest Batton", {
    model = "models/weapons/w_stunbaton.mdl",
    entity = "unarrest_stick",
    amount = 10,
    price = 10000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_BLACK}
})

DarkRP.createShipment("Lockpick", {
    model = "models/weapons/w_crowbar.mdl",
    entity = "lockpick",
    amount = 10,
    price = 5000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_BLACK}
})

DarkRP.createShipment("Kaypad Cracker", {
    model = "models/weapons/w_c4_planted.mdl",
    entity = "keypad_cracker",
    amount = 10,
    price = 6000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_BLACK}
})

--[[
DarkRP.createShipment("M29 Beretta", {
    model = "models/weapons/w_beretta_m92.mdl",
    entity = "m9k_m92beretta_drp",
    amount = 10,
    price = 1200,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})

DarkRP.createShipment("HK45C", {
    model = "models/weapons/w_beretta_m92.mdl",
    entity = "m9k_hk45_drp",
    amount = 10,
    price = 1000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})

DarkRP.createShipment("Deagle", {
    model = "models/weapons/w_tcom_deagle.mdl",
    entity = "m9k_deagle_drp",
    amount = 10,
    price = 2998,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})

DarkRP.createShipment("Honey Badger", {
    model = "models/weapons/w_aac_honeybadger.mdl",
    entity = "m9k_honeybadger_drp",
    amount = 10,
    price = 12000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})

DarkRP.createShipment("MP7", {
    model = "models/weapons/w_mp7_silenced.mdl",
    entity = "m9k_mp7_drp",
    amount = 10,
    price = 10250,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})

DarkRP.createShipment("AK-47", {
    model = "models/weapons/w_ak47_m9k.mdl",
    entity = "m9k_ak47_drp",
    amount = 10,
    price = 12000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})




DarkRP.createShipment("AK-74", {
    model = "models/weapons/w_ak47_m9k.mdl",
    entity = "m9k_ak74_drp",
    amount = 10,
    price = 13500,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})

DarkRP.createShipment("HK 416", {
    model = "models/weapons/w_hk_416.mdl",
    entity = "m9k_m416_drp",
    amount = 10,
    price = 11000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})


DarkRP.createShipment("SCAR", {
    model = "models/weapons/w_fn_scar_h.mdl",
    entity = "m9k_scar_drp",
    amount = 10,
    price = 14000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})

DarkRP.createShipment("FG 42", {
    model = "models/weapons/w_fg42.mdl",
    entity = "m9k_fg42_drp",
    amount = 10,
    price = 20000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})


DarkRP.createShipment("M24", {
    model = "models/weapons/w_snip_m24_6.mdl",
    entity = "m9k_m24_drp",
    amount = 10,
    price = 16000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})


DarkRP.createShipment("Benelli M3", {
    model = "models/weapons/w_benelli_m3.mdl",
    entity = "m9k_m3_drp",
    amount = 10,
    price = 9000,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})


DarkRP.createShipment("MP9", {
    model = "models/weapons/w_brugger_thomet_mp9.mdl",
    entity = "m9k_mp9_drp",
    amount = 10,
    price = 10499,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN}
})	

--]]

DarkRP.createShipment("M249", {
    model = "models/weapons/w_mach_m249para.mdl",
    entity = "lite_m249",
    price = 15000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("Galil", {
    model = "models/weapons/w_rif_galil.mdl",
    entity = "lite_galil",
    price = 10000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("AK47", {
    model = "models/weapons/w_rif_ak47.mdl",
    entity = "lite_ak47",
    price = 10000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("M4A1", {
    model = "models/weapons/w_rif_m4a1.mdl",
    entity = "lite_m4a1",
    price = 10000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("Famas", {
    model = "models/weapons/w_rif_famas.mdl",
    entity = "lite_famas",
    price = 10000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("AWP", {
    model = "models/weapons/w_snip_awp.mdl",
    entity = "lite_awp",
    price = 15000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("Scout", {
    model = "models/weapons/w_snip_scout.mdl",
    entity = "lite_scout",
    price = 10000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("SteyrAug", {
    model = "models/weapons/w_rif_aug.mdl",
    entity = "lite_aug",
    price = 10000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("SG552", {
    model = "models/weapons/w_rif_sg552.mdl",
    entity = "lite_sg552",
    price = 15000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("G3SG1", {
    model = "models/weapons/w_snip_g3sg1.mdl",
    entity = "lite_g3sg1",
    price = 15000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("SG550", {
    model = "models/weapons/w_snip_sg550.mdl",
    entity = "lite_sg550",
    price = 15000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles"
 })
  
 DarkRP.createShipment("UMP45", {
    model = "models/weapons/w_smg_ump45.mdl",
    entity = "lite_ump",
    price = 8000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "SMGs"
 })
  
 DarkRP.createShipment("P90", {
    model = "models/weapons/w_smg_p90.mdl",
    entity = "lite_p90",
    price = 10000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "SMGs"
 })
  
 DarkRP.createShipment("TMP", {
    model = "models/weapons/w_smg_tmp.mdl",
    entity = "lite_tmp",
    price = 10000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "SMGs"
 })
  
 DarkRP.createShipment("MP5", {
    model = "models/weapons/w_smg_mp5.mdl",
    entity = "lite_mp5",
    price = 8000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "SMGs"
 })
  
 DarkRP.createShipment("Mac10", {
    model = "models/weapons/w_smg_mac10.mdl",
    entity = "lite_mac10",
    price = 6000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "SMGs"
 })
  
 DarkRP.createShipment("XM 1014", {
    model = "models/weapons/w_shot_xm1014.mdl",
    entity = "lite_xm1014",
    price = 15000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Shotguns"
 })
  
 DarkRP.createShipment("M3 Super90", {
    model = "models/weapons/w_shot_m3super90.mdl",
    entity = "lite_m3",
    price = 8000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Shotguns"
 })
  
 DarkRP.createShipment("Fragmentation Grenade", {
    model = "models/weapons/w_eq_fraggrenade.mdl",
    entity = "lite_hegrenade",
    price = 20000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Other"
 })
  
 DarkRP.createShipment("Flashbang", {
    model = "models/weapons/w_eq_flashbang_thrown.mdl",
    entity = "lite_flashbang",
    price = 5000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Other"
 })
  
 DarkRP.createShipment("Smoke Grenade", {
    model = "models/weapons/w_eq_smokegrenade.mdl",
    entity = "lite_smokegrenade",
    price = 5000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Other"
 })
  
 DarkRP.createShipment("Laser Tripmine", {
    model = "models/weapons/w_slam.mdl",
    entity = "weapon_slam",
    price = 20000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Other"
 })
  
 DarkRP.createShipment("Dual Beretta 96GE", {
    model = "models/weapons/w_pist_elite_dropped.mdl",
    entity = "lite_dualberettas",
    price = 5000,
    amount = 5,
    separate = true,
    pricesep = 1000,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Pistols"
 })
  
 DarkRP.createShipment("Deagle", {
    model = "models/weapons/w_pist_deagle.mdl",
    entity = "lite_deagle",
    price = 5000,
    amount = 5,
    separate = true,
    pricesep = 1000,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Pistols"
 })
  
 DarkRP.createShipment("USP", {
    model = "models/weapons/w_pist_usp.mdl",
    entity = "lite_usp",
    price = 2500,
    amount = 5,
    separate = true,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Pistols"
 })
  
 DarkRP.createShipment("P228", {
    model = "models/weapons/w_pist_p228.mdl",
    entity = "lite_p228",
    price = 2000,
    amount = 5,
    separate = true,
    pricesep = 400,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Pistols"
 })
  
 DarkRP.createShipment("Glock", {
    model = "models/weapons/w_pist_glock18.mdl",
    entity = "lite_glock",
    price = 2500,
    amount = 5,
    separate = true,
    pricesep = 400,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Pistols"
 })
  
 DarkRP.createShipment("FiveSeven", {
    model = "models/weapons/w_pist_fiveseven.mdl",
    entity = "lite_fiveseven",
    price = 5000,
    amount = 5,
    separate = true,
    pricesep = 1000,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Pistols"
 })