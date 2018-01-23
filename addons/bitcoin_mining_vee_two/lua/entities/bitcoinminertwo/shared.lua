ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "BitCoin Miner"
ENT.Author = "Paperlacks"
ENT.Category = "Paperlacks' Stuff"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()

	self:NetworkVar("Entity", 1, "owning_ent")
	self:NetworkVar("String", 1, "BitcoinAddress")
	self:NetworkVar("Int", 1, "BatteryPercent")
	self:NetworkVar("String", 2, "MinedBTC")
	self:NetworkVar("Bool", 1, "MinerStatus")
	self:NetworkVar("String", 3, "TotalMinedBTC")
	self:NetworkVar("Int", 2, "BatteryTickTime")
	self:NetworkVar("Int", 4, "RamLevel")
	self:NetworkVar("Int", 5, "ChipLevel")
	self:NetworkVar("Int", 6, "BatLevel")

end
