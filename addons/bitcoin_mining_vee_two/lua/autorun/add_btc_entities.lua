timer.Simple(4, function()
	DarkRP.createEntity("BitCoin Miner", {
		ent = "bitcoinminertwo",
		model = "models/props_c17/consolebox01a.mdl",
		price = BitCoins_CFG.MinerCost,
		max = BitCoins_CFG.Max,
		cmd = "buybtcminer",
		category = "Bitcoin Mining"
	})
end)
