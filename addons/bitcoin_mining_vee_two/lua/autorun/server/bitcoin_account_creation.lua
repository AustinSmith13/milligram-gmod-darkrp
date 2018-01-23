local function walletString()
	local numbers = {"1","2","3","4","5","6","7","8","9"}
	local alpbet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z","A","B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "V", "X", "Y", "Z"}
	local wallet = "3"
	local walletTable = {}

	for i=1, 25, 1 do
		local insertVal = table.Random(alpbet)
		table.insert(walletTable, insertVal)
	end

	table.insert(walletTable, table.Random(numbers))

	for i=1, 8, 1 do
		local insertVal = table.Random(alpbet)
		table.insert(walletTable, insertVal)
	end

	for i=1, #walletTable, 1 do
		wallet = wallet .. walletTable[i]
	end

	return wallet

end

if !file.Exists("bitcoin_mining_two", "DATA") then

	file.CreateDir("bitcoin_mining_two")

end

if !file.Exists("bitcoin_mining_two/wallets.txt", "DATA") then

	local TableToWrite = {}
	TableToWrite["STEAM_ID_GOES_HERE"] = {walletString(), 0, "STEAMID_HERE_USED_FOR_INDEXING"}
	file.Write("bitcoin_mining_two/wallets.txt", util.TableToJSON(TableToWrite, true))

end

if !file.Exists("bitcoin_mining_two/amountofpayments.txt", "DATA") then

	local NumberToWrite = 0
	file.Write("bitcoin_mining_two/amountofpayments.txt", NumberToWrite)

end

if !file.Exists("bitcoin_mining_two/payments.txt", "DATA") then

	local TableToWrite = {}
	file.Write("bitcoin_mining_two/payments.txt", util.TableToJSON(TableToWrite, true))

end

net.Receive("givepayments", function(len, ply)
	local payments = util.JSONToTable(file.Read("bitcoin_mining_two/payments.txt"))
	local amountOfPayments = file.Read("bitcoin_mining_two/amountofpayments.txt")
	net.Start("givepayments")
	net.WriteTable(payments)
	net.WriteString(amountOfPayments)
	net.Send(ply)
end)

function AddPaymentRecord(from, to, btc)
	local currentRecords = util.JSONToTable(file.Read("bitcoin_mining_two/payments.txt"))
	local newTable = currentRecords

	if #newTable + 1 >= 15 then
		newTable[1] = {from, to, btc}
		file.Write("bitcoin_mining_two/payments.txt", util.TableToJSON(newTable, true))
	else
		table.insert(newTable, 1, {from, to, btc})
		file.Write("bitcoin_mining_two/payments.txt", util.TableToJSON(newTable, true))
	end

	local curTrans = file.Read("bitcoin_mining_two/amountofpayments.txt")
	local newTrans = curTrans + 1
	file.Write("bitcoin_mining_two/amountofpayments.txt", newTrans)
end

local meta = FindMetaTable("Player")

function meta:CreateBTCWallet()
	if IsValid(self) == false then return end

	local currentAccounts = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))
	local newAccounts = currentAccounts

	if currentAccounts[self:SteamID()] then return end -- if they already have an account

	newAccounts[self:SteamID()] = {walletString(), 0, self:SteamID()}

	file.Write("bitcoin_mining_two/wallets.txt", util.TableToJSON(newAccounts, true))

end

function meta:RenewWalletString()
	if IsValid(self) == false then return end

	local currentAccounts = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))
	local newAccounts = currentAccounts

	if currentAccounts[self:SteamID()] then
		newAccounts[self:SteamID()][1] = walletString()
	end

	file.Write("bitcoin_mining_two/wallets.txt", util.TableToJSON(newAccounts, true))

end

function meta:GiveBitcoins(num)
	if IsValid(self) == false then return end

	local currentAccounts = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))
	local newAccounts = currentAccounts
	local currentBitcoins = currentAccounts[self:SteamID()][2]
	local newBitcoins = math.Round(num + currentBitcoins, 6)

	newAccounts[self:SteamID()][2] = newBitcoins

	file.Write("bitcoin_mining_two/wallets.txt", util.TableToJSON(newAccounts, true))

end

function meta:TakeBitcoins(num)
	if IsValid(self) == false then return end

	local currentAccounts = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))
	local newAccounts = currentAccounts
	local currentBitcoins = currentAccounts[self:SteamID()][2]
	local newBitcoins = math.Round(currentBitcoins - num, 6)

	newAccounts[self:SteamID()][2] = newBitcoins

	file.Write("bitcoin_mining_two/wallets.txt", util.TableToJSON(newAccounts, true))

end

function meta:GetBTCWallet()
	if IsValid(self) == false then return end

	local currentAccounts = util.JSONToTable(file.Read("bitcoin_mining_two/wallets.txt"))

	if currentAccounts[self:SteamID()] == nil then return end -- if they dont have an account

	return currentAccounts[self:SteamID()]

end

hook.Add("PlayerSpawn", "GiveWallet", function(ply)
	ply:CreateBTCWallet()
end)
