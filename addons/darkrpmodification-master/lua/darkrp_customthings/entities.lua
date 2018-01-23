--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

DarkRP.createEntity("Card Machine", {
	ent = "sent_arc_pinmachine",
	model = "models/arc/atm_cardmachine.mdl",
	price = 150,
	max = 10,
	cmd = "buycardmachine",
	allowTools = true,
})


DarkRP.createEntity("T0 Printer", {
    ent = "t0printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 500,
    max = 2,
    cmd = "bymoneyprinter0",
    category = "Money Printers"
})

DarkRP.createEntity("T1 Printer", {
    ent = "t1printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 1500,
    max = 2,
    cmd = "buymoeyprinter1",
    category = "Money Printers"
})

DarkRP.createEntity("T2 Printer", {
    ent = "t2printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 3000,
    max = 2,
    cmd = "buymoneprinter2",
    category = "Money Printers"
})

DarkRP.createEntity("T3 Printer", {
    ent = "t3printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 5000,
    max = 2,
    cmd = "buymoneyprnter3",
    category = "Money Printers"
})

DarkRP.createEntity("T4 Printer", {
    ent = "t4printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 10000,
    max = 2,
    cmd = "buymoneypinter4",
    category = "Money Printers"
})

DarkRP.createEntity("T5 Printer", {
    ent = "t5printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 25000,
    max = 2,
    cmd = "buymoeyprinter5",
    category = "Money Printers"
})

DarkRP.createEntity("T6 Printer", {
    ent = "t6printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 45000,
    max = 2,
    cmd = "buymoeypnter6",
    category = "Money Printers"
})


DarkRP.createEntity("Bitcoin Mining Server", {
    ent = "bitcoinminertwo",
    model = "models/props_c17/consolebox01a.mdl",
    price = 25000,
    max = 4,
    cmd = "buyserverprinter",
    category = "Bitcoin Mining",
    allowed = {TEAM_BITCOIN}
})