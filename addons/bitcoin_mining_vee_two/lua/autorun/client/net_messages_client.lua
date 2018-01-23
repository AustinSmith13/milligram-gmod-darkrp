net.Receive("bitcoins_received_bitcoins", function()
	local BitCoins = net.ReadString()
	notification.AddLegacy("You have received " .. BitCoins .. " BitCoins from a BitCoin Miner!", NOTIFY_GENERIC, 5)
end)

net.Receive("bitcoins_received_bitcoins_from", function()
	local BitCoins = net.ReadString()
	local FromWho = net.ReadEntity()

	notification.AddLegacy("You have received " .. BitCoins .. " BitCoins from " .. FromWho:Nick(), NOTIFY_GENERIC, 5)
end)

// old shit, dw
