util.AddNetworkString("bitcoins_request_refill_battery")
util.AddNetworkString("bitcoins_request_withdraw")
util.AddNetworkString("bitcoins_request_withdraw_to")
util.AddNetworkString("bitcoins_received_bitcoins")
util.AddNetworkString("bitcoins_received_bitcoins_from")
util.AddNetworkString("bitcoins_request_turn_on")
util.AddNetworkString("bitcoins_request_turn_off")
util.AddNetworkString("bitcoins_upgrade_ram")
util.AddNetworkString("bitcoins_upgrade_chip")
util.AddNetworkString("bitcoins_upgrade_bat")
util.AddNetworkString("bitcoins_downgrade_ram")
util.AddNetworkString("bitcoins_downgrade_chip")
util.AddNetworkString("bitcoins_downgrade_bat")
util.AddNetworkString("bitcoins_upgrademax_ram")
util.AddNetworkString("bitcoins_upgrademax_chip")
util.AddNetworkString("bitcoins_upgrademax_bat")
util.AddNetworkString("bitcoins_changeaddress")
util.AddNetworkString("bitcoins_to_cash")
util.AddNetworkString("bitcoins_from_cash")
util.AddNetworkString("bitcoins_sendbtc")
util.AddNetworkString("giveaddr")
util.AddNetworkString("givepayments")

net.Receive("bitcoins_sendbtc", function(len, ply)
	local address = net.ReadString()
	local Amount = net.ReadString()
	local players = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))
	local newTable = players
	local FoundAddress = false
	
	Amount = math.abs(tonumber(Amount))

	if tonumber(Amount) > ply:GetBTCWallet()[2] then return end

	for k, v in pairs(newTable) do
		if v[1] == address then
			v[2] = v[2] + tonumber(Amount)
			FoundAddress = true
			break
		end
		FoundAddress = false
	end

	if FoundAddress == false then return end

	file.Write("bitcoin_mining_two/wallets.txt", util.TableToJSON(newTable, true))
	ply:TakeBitcoins(Amount)

	AddPaymentRecord(ply:GetBTCWallet()[1], address, Amount)
end)

net.Receive("bitcoins_to_cash", function(len, ply)
	local Amount = net.ReadString()
	
	Amount = math.abs(tonumber(Amount))

	if tonumber(Amount) > ply:GetBTCWallet()[2] then return end

	ply:TakeBitcoins(tonumber(Amount))
	ply:addMoney(tonumber(Amount) * BitCoins_CFG.Worth)
end)

net.Receive("bitcoins_from_cash", function(len, ply)
	local Amount = net.ReadInt(32)
	local Wallet = ply:getDarkRPVar("money")
	
	Amount = math.abs(Amount)

	if Amount % 2 != 0 then return end

	if Amount > Wallet then return end

	ply:GiveBitcoins(Amount / BitCoins_CFG.Worth)
	local removeAm = Amount / BitCoins_CFG.Worth
	ply:addMoney(-Amount)
end)


net.Receive("giveaddr", function(len, ply)

	local addresses = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))
	local theirAddr

	for k, v in pairs(addresses) do
		if v[3] == ply:SteamID() then theirAddr = v break end
	end

	if theirAddr == nil then return end

	net.Start("giveaddr")
	net.WriteString(theirAddr[1])
	net.WriteString(tostring(theirAddr[2]))
	net.Send(ply)

end)


local function GiveBTCByAddress(addr, amount)

	local currentAccounts = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))
	local newAccounts = currentAccounts
	local newAmount
	
	Amount = math.abs(tonumber(Amount))

	for k, v in pairs(newAccounts) do
		if v[1] == addr then
			newAmount = v[2] + tonumber(amount)
			v[2] = newAmount
		end
	end

	file.Write("bitcoin_mining_two/wallets.txt", util.TableToJSON(newAccounts, true))

end

local function FindPlyBySteamID(id)
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == id then
			return v
		end
	end
end

local function FindPlyByBTCAddr(addr)

	local Accounts = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))

	for k, v in pairs(Accounts) do
		if v[1] == addr then
			return {FindPlyBySteamID(v[3]), v[1]}
		end
	end

end

net.Receive("bitcoins_request_refill_battery", function(len, ply)
	local RefillThis = net.ReadEntity()
	local PlyMoney = ply:getDarkRPVar("money")

	if RefillThis:GetClass() == "bitcoinminertwo" then

		if PlyMoney < BitCoins_CFG.RefillBatteryPrice then
			ply:ChatPrint("You don't have enough money to refill your battery.")
			return
		end

		if RefillThis:GetBatteryPercent() == 100 then
			ply:ChatPrint("The battery is already full!")
			return
		end

		RefillThis:SetBatteryPercent(100)
		ply:addMoney(-BitCoins_CFG.RefillBatteryPrice)
		ply:ChatPrint("You have refilled your battery for " .. DarkRP.formatMoney(BitCoins_CFG.RefillBatteryPrice) .."!")

	end

end)

net.Receive("bitcoins_request_withdraw", function(len, ply)
	local Ent = net.ReadEntity()
	local Address = net.ReadString()
	local addressNow = file.Read("bitcoin_mining_two/wallets.txt")
	local addressNowTable = util.JSONToTable(addressNow)
	local newTable = addressNowTable

	if Ent:GetClass() == "bitcoinminertwo" then

		if ply:GetPos():Distance(Ent:GetPos()) > 100 then
			ply:ChatPrint("You're not close enough!")
			return
		end

		for k, v in pairs(newTable) do
			if v[1] == Address then  v[2] = v[2] + tonumber(Ent:GetMinedBTC()) break end
		end

		file.Write("bitcoin_mining_two/wallets.txt", util.TableToJSON(newTable, true))

		Ent:SetMinedBTC(tostring(0))

	end

end)


net.Receive("bitcoins_request_turn_on", function(len, ply)
	local Miner = net.ReadEntity()

	if Miner:GetClass() == "bitcoinminertwo" then
		Miner:SetMinerStatus(true)
	end
end)

net.Receive("bitcoins_request_turn_off", function(len, ply)
	local Miner = net.ReadEntity()

	if Miner:GetClass() == "bitcoinminertwo" then
		Miner:SetMinerStatus(false)
	end
end)













net.Receive("bitcoins_upgrade_ram", function(len, ply)
	local miner = net.ReadEntity()
	local upgradeLvl = net.ReadInt(32)

	if miner:GetClass() == "bitcoinminertwo" then
		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end
		if upgradeLvl > 3 then return end

		if ply:getDarkRPVar("money") < BitCoins_CFG.RamUpgradePrice then return end

		miner:SetRamLevel(upgradeLvl)
		ply:addMoney(-BitCoins_CFG.RamUpgradePrice)
	end
end)

net.Receive("bitcoins_upgrade_chip", function(len, ply)
	local miner = net.ReadEntity()
	local upgradeLvl = net.ReadInt(32)

	if miner:GetClass() == "bitcoinminertwo" then
		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end
		if upgradeLvl > 6 then return end
		if upgradeLvl < 4 then return end

		if ply:getDarkRPVar("money") < BitCoins_CFG.ChipUpgradePrice then return end

		miner:SetChipLevel(upgradeLvl)
		ply:addMoney(-BitCoins_CFG.ChipUpgradePrice)
	end
end)

net.Receive("bitcoins_upgrade_bat", function(len, ply)
	local miner = net.ReadEntity()
	local upgradeLvl = net.ReadInt(32)

	if miner:GetClass() == "bitcoinminertwo" then

		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end
		if upgradeLvl > 9 then return end
		if upgradeLvl < 7 then return end

		if ply:getDarkRPVar("money") < BitCoins_CFG.BatUpgradePrice then return end

		miner:SetBatLevel(upgradeLvl)
		ply:addMoney(-BitCoins_CFG.BatUpgradePrice)
	end
end)











net.Receive("bitcoins_downgrade_ram", function(len, ply)
	local miner = net.ReadEntity()
	local downgradeLvl = net.ReadInt(32)

	if miner:GetClass() == "bitcoinminertwo" then

		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end
		if downgradeLvl < 1 then return end
		if downgradeLvl > 3 then return end

		miner:SetRamLevel(downgradeLvl)
	end
end)

net.Receive("bitcoins_downgrade_chip", function(len, ply)
	local miner = net.ReadEntity()
	local downgradeLvl = net.ReadInt(32)

	if miner:GetClass() == "bitcoinminertwo" then
		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end
		if downgradeLvl < 4 then return end
		if downgradeLvl > 6 then return end

		miner:SetChipLevel(downgradeLvl)
	end
end)

net.Receive("bitcoins_downgrade_bat", function(len, ply)
	local miner = net.ReadEntity()
	local downgradeLvl = net.ReadInt(32)

	if miner:GetClass() == "bitcoinminertwo" then
		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end
		if downgradeLvl < 7 then return end
		if downgradeLvl > 9 then return end

		miner:SetBatLevel(downgradeLvl)
	end
end)

net.Receive("bitcoins_upgrademax_ram", function(len, ply)
	local miner = net.ReadEntity()

		if miner:GetClass() == "bitcoinminertwo" then
		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end

		if miner:GetRamLevel() == 3 then return end
		if ply:getDarkRPVar("money") < BitCoins_CFG.RamUpgradePrice * 3 then return end

		miner:SetRamLevel(3)
		ply:addMoney(-BitCoins_CFG.RamUpgradePrice)
	end
end)

net.Receive("bitcoins_upgrademax_chip", function(len, ply)
	local miner = net.ReadEntity()

	if miner:GetClass() == "bitcoinminertwo" then
		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end

		if miner:GetChipLevel() == 6 then return end
		if ply:getDarkRPVar("money") < BitCoins_CFG.ChipUpgradePrice * 3 then return end

		miner:SetChipLevel(6)
		ply:addMoney(-BitCoins_CFG.ChipUpgradePrice)
	end
end)

net.Receive("bitcoins_upgrademax_bat", function(len, ply)
	local miner = net.ReadEntity()
	if miner:GetClass() == "bitcoinminertwo" then
		if miner:IsValid() == false then return end
		if ply:GetPos():Distance(miner:GetPos()) > 200 then return end

		if miner:GetBatLevel() == 9 then return end
		if ply:getDarkRPVar("money") < BitCoins_CFG.BatUpgradePrice then return end

		miner:SetBatLevel(9)
		ply:addMoney(-BitCoins_CFG.BatUpgradePrice)
	end
end)





net.Receive("bitcoins_changeaddress", function(len, ply)
	local miner = net.ReadEntity()
	local newaddress = net.ReadString()
	if string.len(newaddress) > 35 then return end
	if miner:IsValid() == false then return end
	if ply:GetPos():Distance(miner:GetPos()) > 200 then return end
	if miner:GetClass() == "bitcoinminertwo" then

		local addressData = file.Read("bitcoin_mining_two/wallets.txt", "DATA")
		local addressTable = util.JSONToTable(addressData)

		for k, v in pairs(addressTable) do
			if v[1] == newaddress then miner:SetBitcoinAddress(newaddress) break end
		end

	end
end)
