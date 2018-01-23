AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local function GetType(number)
	if isnumber(string.find(number, ".")) then return "float" else return "int" end
end



function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:SetColor(Color(72, 72, 72, 255))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.health = 100
	self.InUse = false

	self.CurNow = CurTime()
	self.CurNowBat = CurTime()
	self.MiningRate = 0

	local owner = self:Getowning_ent()

	self:SetBatteryPercent(20)
	self:SetMinedBTC("0")
	self:SetRamLevel(1)
	self:SetChipLevel(4)
	self:SetBatLevel(7)
	self:SetBatteryTickTime(5)
	self:SetTotalMinedBTC("0")
	self:SetMinerStatus(false)
	self:SetBitcoinAddress(owner:GetBTCWallet()[1])

	self:SetUseType(SIMPLE_USE)

end


function ENT:Think()

	self.MiningRate = 0

	if self:GetBatLevel() == 7 then
		self:SetBatteryTickTime(5)
	elseif self:GetBatLevel() == 8 then
		self:SetBatteryTickTime(10)
	elseif self:GetBatLevel() == 9 then
		self:SetBatteryTickTime(15)
	end


	if self:GetRamLevel() == 1 then
		self.MiningRate = self.MiningRate + 0.003
	elseif self:GetRamLevel() == 2 then
		self.MiningRate = self.MiningRate + 0.006
	elseif self:GetRamLevel() == 3 then
		self.MiningRate = self.MiningRate + 0.009
	end

	if self:GetChipLevel() == 4 then
		self.MiningRate = self.MiningRate + 0.006
	elseif self:GetChipLevel() == 5 then
		self.MiningRate = self.MiningRate + 0.008
	elseif self:GetChipLevel() == 6 then
		self.MiningRate = self.MiningRate + 0.01
	end


	if CurTime() > self.CurNow + 1 then
		self.CurNow = CurTime()
		if self:GetBatteryPercent() == 0 then return end
		if self:GetMinerStatus() == false then return end
		local newAmount = tonumber(self:GetMinedBTC()) + self.MiningRate
		self:SetMinedBTC(tostring(newAmount))
		self:SetTotalMinedBTC(tostring(tonumber(self:GetTotalMinedBTC())) + self.MiningRate)
	end

	if CurTime() > self.CurNowBat + self:GetBatteryTickTime() then
		self.CurNowBat = CurTime()
		if self:GetBatteryPercent() == 0 then return end
		if self:GetMinerStatus() == false then return end
		self:SetBatteryPercent(self:GetBatteryPercent() - 1)
	end
end

function ENT:Use( activator, caller )

end

function ENT:OnTakeDamage(dmg)
	local dmgAmount = dmg:GetDamage()

	self.health = self.health - dmgAmount

	if self.health <= 0 then
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("Explosion", effectdata)
		self:Remove()
	end
end
