include("shared.lua")

surface.CreateFont( "OwnerFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 41,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "BitCoinTitlefont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 605,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "WalletTitleFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "BatPercentTextNoNumber", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 80,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "BatPercent", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 200,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "PaymentsFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "PaymentsFontTwo", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local UploadMaterial = Material("btc_miner/upgrades.png", "smooth noclamp")
local MainPageMaterial = Material("btc_miner/details.png", "smooth noclamp")
local UpgradeMaterial = Material("btc_miner/upgrade.png", "smooth noclamp")
local DowngradeMaterial = Material("btc_miner/downgrade.png", "smooth noclamp")
local MaxUpgradesMaterial = Material("btc_miner/maxupgrades.png", "smooth noclamp")
local InfoMaterial = Material("btc_miner/info.png", "smooth noclamp")
local ExtrasMaterial = Material("btc_miner/extras.png", "smooth noclamp")
local BTCWalletMaterial = Material("btc_miner/btcwallet.png", "smooth noclamp")
local UserMaterial = Material("btc_miner/user.png", "smooth noclamp")
local CopyClipboardMaterial = Material("icon16/page_paste.png", "smooth noclamp")

local function GetMyBTCAddress()
	net.Start("giveaddr")
	net.SendToServer()
end

local function GetPayments()
	net.Start("givepayments")
	net.SendToServer()
end

GetMyBTCAddress()
GetPayments()

timer.Create("updatelol", 1, 0, function()
	GetMyBTCAddress()
end)

timer.Create("updatepaymentslol", 1, 0, function()
	GetPayments()
end)


local MyAddressTable = {}

MyAddressTable[4] = CopyClipboardMaterial

net.Receive("giveaddr", function()
	local addr = net.ReadString()
	local btcs = net.ReadString()
	MyAddressTable[1] = addr
	MyAddressTable[3] = btcs
end)

net.Receive("givepayments", function()
	local payments = net.ReadTable()
	local totalPayments = net.ReadString()
	MyAddressTable[5] = payments
	MyAddressTable[6] = totalPayments
end)

local function ChangeMinerAddress(entity, newaddress)
	if IsValid(entity) == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are too far away!", NOTIFY_ERROR, 5) return end
	if string.len(newaddress) > 35 then notification.AddLegacy("This is not a valid BitCoin adress!", NOTIFY_ERROR, 5) return end
	if string.len(newaddress) < 35 then notification.AddLegacy("This is not a valid BitCoin adress!", NOTIFY_ERROR, 5) return end

	net.Start("bitcoins_changeaddress")
	net.WriteEntity(entity)
	net.WriteString(newaddress)
	net.SendToServer()
end

local function RequestRefillBattery(ent)

	net.Start("bitcoins_request_refill_battery")
	net.WriteEntity(ent)
	net.SendToServer()

end

local function RequestWithdrawBTC(ent, address)

	net.Start("bitcoins_request_withdraw")
	net.WriteEntity(ent)
	net.WriteString(address)
	net.SendToServer()

end

local function RequestOn(ent)

	net.Start("bitcoins_request_turn_on")
	net.WriteEntity(ent)
	net.SendToServer()

end

local function RequestOff(ent)

	net.Start("bitcoins_request_turn_off")
	net.WriteEntity(ent)
	net.SendToServer()

end

local function GetNameByBool(bool)

	if bool == true then return "On" end
	if bool == false then return "Off" end

	return "Unknown Data Type"

end

local function GetNameByNumber(number)
		local string
		for k, v in pairs(BitCoins_CFG) do
			if v == number then string = k break end
		end
		return string
end

local function UpgradeRam(entity, number)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end
	if number > 3 then notification.AddLegacy("This is already max upgraded!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_upgrade_ram")
	net.WriteEntity(entity)
	net.WriteInt(number, 32)
	net.SendToServer()

end

local function UpgradeChip(entity, number)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end
	if number > 6 then notification.AddLegacy("This is already max upgraded!", NOTIFY_ERROR, 3) return end
	if number < 4 then notification.AddLegacy("Invalid upgrade interger!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_upgrade_chip")
	net.WriteEntity(entity)
	net.WriteInt(number, 32)
	net.SendToServer()

end

local function UpgradeBat(entity, number)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end
	if number > 9 then notification.AddLegacy("This is already max upgraded!", NOTIFY_ERROR, 3) return end
	if number < 7 then notification.AddLegacy("Invalid upgrade interger!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_upgrade_bat")
	net.WriteEntity(entity)
	net.WriteInt(number, 32)
	net.SendToServer()

end

local function DowngradeRam(entity, number)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end
	if number < 1 then notification.AddLegacy("This is already max downgraded!", NOTIFY_ERROR, 3) return end
	if number > 3 then notification.AddLegacy("Invalid downgrade interger!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_downgrade_ram")
	net.WriteEntity(entity)
	net.WriteInt(number, 32)
	net.SendToServer()

end

local function DowngradeChip(entity, number)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end
	if number < 4 then notification.AddLegacy("This is already max downgraded!", NOTIFY_ERROR, 3) return end
	if number > 6 then notification.AddLegacy("Invalid downgrade interger!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_downgrade_chip")
	net.WriteEntity(entity)
	net.WriteInt(number, 32)
	net.SendToServer()

end

local function DowngradeBat(entity, number)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end
	if number < 7 then notification.AddLegacy("This is already max downgraded!", NOTIFY_ERROR, 3) return end
	if number > 9 then notification.AddLegacy("Invalid downgrade interger!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_downgrade_bat")
	net.WriteEntity(entity)
	net.WriteInt(number, 32)
	net.SendToServer()

end

local function UpgradeRamMax(entity)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_upgrademax_ram")
	net.WriteEntity(entity)
	net.SendToServer()

end

local function UpgradeChipMax(entity)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_upgrademax_chip")
	net.WriteEntity(entity)
	net.SendToServer()

end

local function UpgradeBatMax(entity)
	if entity:IsValid() == false then return end
	if LocalPlayer():GetPos():Distance(entity:GetPos()) > 200 then notification.AddLegacy("You are not close enough!", NOTIFY_ERROR, 3) return end

	net.Start("bitcoins_upgrademax_bat")
	net.WriteEntity(entity)
	net.SendToServer()

end

MyAddressTable[2] = 10.31
local RefillY = -4.47
local RefillW = 12.64
local RefillH = 2.96
local RefillAlpha = 0
local HaveMousedBat = false
local HaveReqRefill = false

local CurrAddX = -7.43
local CurrAddY = -13.51
local CurrAddW = -4.01
local CurrAddH = 3.25
local CurrAddAlpha = 0
local HaveMousedCurrAdd = false
local HaveReqCurrAdd = false

local SettingsX = -1.90
local SettingsY = -13.07
local SettingsW = 4.22
local SettingsH = 3.04
local SettingsAlpha = 0
local HaveMousedSettings = false
local HaveReqSettings = false

local ButtonOnX = 6.32
local ButtonOnY = -13.21
local ButtonOnW = 7.48
local ButtonOnH = -5.306
local ButtonOnAlpha = 0
local HaveMousedButtonOn = false
local HaveReqButtonOn = false

local ButtonOffX = 6.32
local ButtonOffY = -4.5
local ButtonOffW = 7.48
local ButtonOffH = 3.2
local ButtonOffAlpha = 0
local HaveMousedButtonOff = false
local HaveReqButtonOff = false



function ENT:Draw()

	self:DrawModel()

	if LocalPlayer():GetPos():Distance(self:GetPos()) > 400 then return end 
	
	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local MINER = self

	-- top bit

	Ang:RotateAroundAxis(Ang:Up(), 90)

	cam.Start3D2D(Pos + Ang:Up()*10.6, Ang, 0.025)

		draw.RoundedBox(0,-600,-650,1230,1300,Color(22,22,22,255)) -- Dark background
		draw.RoundedBox(64,-580,-630,1190,1190,Color(255,191,22,255)) -- Cornered orange background

		surface.SetDrawColor(0,0,0,255)
		surface.DrawLine(-581, -525, 610, -525)

		draw.RoundedBox(16,-240,-625,500,45,Color(33,33,33,255)) -- Address rounded box
		draw.RoundedBox(16,-570,-580,1170,50,Color(66,66,66,255)) -- Address box

		draw.RoundedBox(0,-550,-510,220,50,Color(33,33,33,255)) -- Miner Status Box
		draw.SimpleText("Miner Status: " .. GetNameByBool(self:GetMinerStatus()), "DermaLarge", -540, -500, Color(255,255,255,255), TEXT_ALIGN_LEFT) -- On Text

		draw.RoundedBox(0,-550,-450,700,300,Color(33,33,33,255)) -- Current stored BTC Box
		draw.SimpleTextOutlined("Current BitCoins", "BatPercentTextNoNumber", -210, -410, Color(255,255,255,255), TEXT_ALIGN_CENTER, 1, 1, Color(0,0,0,255))
		draw.SimpleTextOutlined(self:GetMinedBTC(), "BatPercentTextNoNumber", -210, -340, Color(255,255,255,255), TEXT_ALIGN_CENTER, 1, 1, Color(0,0,0,255))
		surface.SetDrawColor(Color(255,255,255))
		surface.DrawLine(-550, -370, 150, -370)
		surface.DrawLine(-550, -310, 150, -310)
		draw.RoundedBox(0,-545,-304,690,150,Color(0,161,255,160)) -- Withdraw to current address
		draw.RoundedBox(0,-545,-304,690,150,Color(0,161,255,CurrAddAlpha)) -- Withdraw to current address alpha

		draw.SimpleTextOutlined("Withdraw BitCoins", "BatPercentTextNoNumber", -190, -225, Color(255,255,255,255), TEXT_ALIGN_CENTER, 1, 1, Color(0,0,0,255))

		draw.RoundedBox(0,-550,-100,700,300,Color(33,33,33,255)) -- Settings button container
		draw.RoundedBox(0,-530,-80,660,260,Color(145,145,145,255)) -- Settings button
		draw.RoundedBox(0,-530,-80,660,260,Color(255,255,255,SettingsAlpha)) -- Settings button
		draw.SimpleTextOutlined("Edit Settings", "BatPercent", -520, 50, Color(255,255,255,255), TEXT_ALIGN_LEFT, 1, 1, Color(0,0,0,255))

		draw.RoundedBox(0,179,-500,400,1020,Color(33,33,33,255)) -- Battery percentage
		draw.RoundedBox(0,209,-480,340,980,Color(255,0,0,170)) -- Battery percentage
		draw.RoundedBox(0,209,500,340,-(self:GetBatteryPercent() / 100 * 980),Color(33,255,33,185)) -- Battery percentage filler upper, batPercentTest
		draw.RoundedBox(0,300,400,150,90,Color(44,44,44,255)) -- Battery Icon Non Tip
		draw.RoundedBox(0,450,420,12,50,Color(88,88,88,255)) -- Battery Icon Tip

		draw.RoundedBox(0,-550,320,700,200,Color(33,33,33,255)) -- Battery percent text box
		surface.SetDrawColor(Color(255,255,255,255)) -- Set the following lines to white
		surface.DrawLine(-550, 400, 150, 400)
		draw.SimpleTextOutlined("Battery Percentage", "BatPercentTextNoNumber", -500, 357, Color(255,255,255,255), TEXT_ALIGN_LEFT, 1, 1, Color(0,0,0,255))
		draw.SimpleTextOutlined(self:GetBatteryPercent() .. "%", "BatPercent", -530, 460, Color(255,255,255,255), TEXT_ALIGN_LEFT, 1, 1, Color(0,0,0,255))
		surface.DrawLine(-200, 400, -200, 520)

		draw.RoundedBox(0, -180, 410, 310, 100, Color(0,0,255,100))
		draw.RoundedBox(0, -180, 410, 310, 100, Color(255,255,255,RefillAlpha))
		draw.SimpleTextOutlined("Refill Battery", "WalletTitleFont", -150, 457, Color(255,255,255,255), TEXT_ALIGN_LEFT, 1, 1, Color(0,0,0,255))

		draw.RoundedBox(0, -550, 210, 700, 100, Color(33,33,33,255)) -- On / Off Box
		draw.RoundedBox(16, -330, 210, 270, 30, Color(77,77,77,255)) -- Cornered Header
		draw.SimpleTextOutlined("Turn Miner Off / On", "DermaLarge", -200, 225, Color(255,255,255,255), TEXT_ALIGN_CENTER, 1, 1, Color(0,0,0,255))
		surface.SetDrawColor(255,255,255,255)
		surface.DrawLine(-550, 245, 150, 245)
		surface.DrawLine(-200, 245, -200, 310)
		draw.RoundedBox(0, -540, 250, 330, 55, Color(66,255,100,200)) -- On Button
		draw.RoundedBox(0, -540, 250, 330, 55, Color(66,255,100,ButtonOnAlpha)) -- On Button Alpha
		draw.RoundedBox(0, -190, 250, 330, 55, Color(255,66,100,200)) -- Off Button
		draw.RoundedBox(0, -190, 250, 330, 55, Color(255,66,100,ButtonOffAlpha)) -- Off Button Alpha
		draw.SimpleText("Turn Miner On", "WalletTitleFont", -380, 252, Color(255,255,255,255), TEXT_ALIGN_CENTER) -- On Text
		draw.SimpleText("Turn Miner Off", "WalletTitleFont", -30, 252, Color(255,255,255,255), TEXT_ALIGN_CENTER) -- Off Text


		draw.SimpleTextOutlined("BitCoin Wallet", "WalletTitleFont", 0, -602, Color(255,255,255,255), TEXT_ALIGN_CENTER, 1, 1, Color(0,0,0,255))
		draw.SimpleTextOutlined(self:GetBitcoinAddress(), "WalletTitleFont", 30, -558, Color(255,255,255,255), TEXT_ALIGN_CENTER, 1, 1, Color(0,0,0,255))

	cam.End3D2D()

	if LocalPlayer():GetEyeTrace().Entity  then
        if LocalPlayer():GetEyeTrace().Entity == self then
            localTrace = self:WorldToLocal( LocalPlayer():GetEyeTrace().HitPos )
			--LocalPlayer():ChatPrint("x = " .. tostring(localTrace.x) .. ", y = " .. tostring(localTrace.y))
        end
    end

	if localTrace == nil then return end

	if ( localTrace.x > MyAddressTable[2] and localTrace.x < RefillW ) and ( localTrace.y > RefillY and localTrace.y < RefillH ) and LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTrace().Entity:GetPos()) <= 100 then
		RefillAlpha = 100
		if HaveMousedBat == false then
			HaveMousedBat = true
		end
		if LocalPlayer():KeyDown(32) then
			if HaveReqRefill == false then
				RequestRefillBattery(self)
				LocalPlayer():EmitSound("/buttons/blip1.wav")
			end
			HaveReqRefill = true
		end
	else
		RefillAlpha = 0
		HaveMousedBat = false
		HaveReqRefill = false
	end

	if ( localTrace.x > CurrAddX and localTrace.x < CurrAddW ) and ( localTrace.y > CurrAddY and localTrace.y < CurrAddH ) and LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTrace().Entity:GetPos()) <= 100 then
		CurrAddAlpha = 100
		if HaveMousedCurrAdd == false then
			HaveMousedCurrAdd = true
		end
		if LocalPlayer():KeyDown(32) then
			if HaveReqCurrAdd == false then
				RequestWithdrawBTC(self, self:GetBitcoinAddress())
				LocalPlayer():EmitSound("/buttons/blip1.wav")
			end
			HaveReqCurrAdd = true
		end
	else
		CurrAddAlpha = 0
		HaveMousedCurrAdd = false
		HaveReqCurrAdd = false
	end

	if ( localTrace.x > SettingsX and localTrace.x < SettingsW ) and ( localTrace.y > SettingsY and localTrace.y < SettingsH ) and LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTrace().Entity:GetPos()) <= 100 then
		SettingsAlpha = 100
		if HaveMousedSettings == false then
			HaveMousedSettings = true
		end
		if LocalPlayer():KeyDown(32) then
			if HaveReqSettings == false then
				LocalPlayer():EmitSound("/buttons/blip1.wav")
				local Frame = vgui.Create("DFrame")
				Frame:SetSize(800, 595)
				Frame:Center()
				Frame:SetTitle("")
				Frame:MakePopup()
				Frame:SetDraggable(false)
				Frame:ShowCloseButton(false)
				Frame.Paint = function(selff, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255)) -- Paint it grey
					draw.RoundedBox(0, 0, 0, w, 64, Color(88,88,88,255)) -- Header
					draw.RoundedBox(0, 0, 64, 80, Frame:GetTall() - 64, Color(32,32,32,255)) -- Tabs Bar
					draw.SimpleText("Tabs", "DermaLarge", 40, 65, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.RoundedBox(0, 0, 95, 80, 5, Color(255,255,255,155)) -- Tabs Bar Seperator

					draw.RoundedBox(0, 10, 2, 70, 60, Color(255,255,255,255))

					draw.RoundedBox(0, 100, 84, 680, 200, Color(120,120,120,255)) -- MinerSpecifications Box
					draw.RoundedBox(0, 110, 128, 660, 150, Color(33,33,33,255)) -- MinerSpecifications Box INSIDE
					draw.RoundedBox(0, 100, 117, 680, 5, Color(33,33,33,255)) -- MinerSpecifications Seperator

					draw.RoundedBox(0, 100, 294, 680, 273, Color(120,120,120,255)) -- MinerStatistics Box
					draw.RoundedBox(0, 110, 337, 660, 223, Color(33,33,33,255)) -- MinerSpecifications Box INSIDE
					draw.RoundedBox(0, 100, 325, 680, 5, Color(33,33,33,255)) -- MinerStatistics Seperator

					draw.RoundedBox(0, 110, 347, 660, 30, Color(44,44,44,255)) -- TotalMinedBTCBox
					draw.RoundedBox(0, 110, 378, 660, 30, Color(66,66,66,255)) -- TotalMinedBTCBox that actually has the numbers in it

					draw.RoundedBox(0, 110, 418, 660, 30, Color(44,44,44,255)) -- CurrentMinedBTCBox
					draw.RoundedBox(0, 110, 449, 660, 30, Color(66,66,66,255)) -- CurrentMinedBTCBox that actually has the numbers in it

					draw.RoundedBox(0, 110, 489, 660, 30, Color(44,44,44,255)) -- BatteryDepletionBox
					draw.RoundedBox(0, 110, 520, 660, 30, Color(66,66,66,255)) -- BatteryDepletionBox that actually has the numbers in it

					draw.SimpleText("Battery Depletion Rate", "DermaLarge", 428, 489, Color(220,0,255,255), TEXT_ALIGN_CENTER)
					draw.SimpleText("1% Battery Removed Per " .. self:GetBatteryTickTime() .. " Seconds", "DermaLarge", 432, 518, Color(127,255,255,255), TEXT_ALIGN_CENTER)

					draw.SimpleText("BitCoins Mined", "DermaLarge", 428, 346, Color(255,191,0,255), TEXT_ALIGN_CENTER)
					draw.SimpleText("Total BitCoins Mined", "DermaLarge", 428, 418, Color(255,191,0,255), TEXT_ALIGN_CENTER)
					draw.SimpleText(self:GetTotalMinedBTC() .. " BTC", "DermaLarge", 428, 449, Color(255,191,0,255), TEXT_ALIGN_CENTER)

					surface.SetDrawColor(255,255,255,255)
					surface.DrawLine(110, 377, 110 + 659, 377)
					surface.DrawLine(110, 448, 110 + 659, 448)
					surface.DrawLine(110, 519, 110 + 659, 519)

					draw.SimpleText(self:GetMinedBTC() .. " BTC", "DermaLarge", 428, 377, Color(255,191,0,255), TEXT_ALIGN_CENTER)

					draw.SimpleText("Miner Specifications", "DermaLarge", 110, 85, Color(44,44,44,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("Miner Information And Statistics", "DermaLarge", 110, 295, Color(44,44,44,255), TEXT_ALIGN_LEFT)

					draw.SimpleText("RAM:", "DermaLarge", 120, 145, Color(0,255,63,255), TEXT_ALIGN_LEFT)
					draw.SimpleText(GetNameByNumber(self:GetRamLevel()), "DermaLarge", 190, 145, Color(120,120,120,255), TEXT_ALIGN_LEFT)

					draw.SimpleText("Chipset:", "DermaLarge", 120, 185, Color(0,255,255,255), TEXT_ALIGN_LEFT)
					draw.SimpleText(GetNameByNumber(self:GetChipLevel()), "DermaLarge", 222, 185, Color(120,120,120,255), TEXT_ALIGN_LEFT)

					draw.SimpleText("Battery:", "DermaLarge", 120, 225, Color(220,0,255,255), TEXT_ALIGN_LEFT)
					draw.SimpleText(GetNameByNumber(self:GetBatLevel()) .. " " .. tostring(self:GetBatteryPercent()) .. "%", "DermaLarge", 217, 225, Color(120,120,120,255), TEXT_ALIGN_LEFT)


					draw.RoundedBox(0, Frame:GetWide() - 20, 0, 20, 20, Color(255,0,0,122))
					draw.SimpleText("X", "Trebuchet24", Frame:GetWide() - 10, -2, Color(255,255,255,255), TEXT_ALIGN_CENTER)

					draw.RoundedBox(0, 90, 0, 5, 64, Color(33,33,33,255)) -- Avatar seperator
					draw.RoundedBox(0, 90, 32, Frame:GetWide() - 90, 5, Color(33,33,33,255)) -- Long text seperator

					draw.SimpleText("Logged in " .. LocalPlayer():Nick() .. " to the BitCoin Network (BlockChain).", "Trebuchet24", 100, 4, Color(36,36,36,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("All activity performed will be encrypted with a 256-bit connection protocol.", "Trebuchet24", 100, 37, Color(36,36,36,255), TEXT_ALIGN_LEFT)

				end

				local CloseButton = vgui.Create("DButton", Frame)
				CloseButton:SetSize(20, 20)
				CloseButton:SetPos(Frame:GetWide() - CloseButton:GetWide(), 0)
				CloseButton:SetText(" ")
				CloseButton.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
				end
				CloseButton.DoClick = function(self)
					Frame:Close()
				end

				local AvatarPic = vgui.Create("AvatarImage", Frame)
				AvatarPic:SetSize(64,54)
				AvatarPic:SetPos(13, 5)
				AvatarPic:SetPlayer(LocalPlayer(), 64)

				local OptionsPanel= vgui.Create("DPanel", Frame)
				OptionsPanel:SetPos(80, 64)
				OptionsPanel:SetSize(Frame:GetWide() - 80, Frame:GetTall() - 64)
				OptionsPanel:Hide()
				OptionsPanel.Paint = function(selfp, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255)) -- Grey background

					draw.RoundedBox(0, 20, 20, w - 40, 210, Color(120,120,120,255)) -- Grey background
					draw.RoundedBox(0, 20, 53, w - 40, 5, Color(33,33,33,255)) -- Seperator
					draw.RoundedBox(0, 30, 64, w - 60, 160, Color(33,33,33,255)) -- Inside

					draw.RoundedBox(0, 20, 250, w - 40, 171, Color(120,120,120,255))
					draw.RoundedBox(0, 30, 293, w - 60, 121, Color(33,33,33,255))
					draw.RoundedBox(0, 20, 280, w - 40, 5, Color(33,33,33,255))

					draw.RoundedBox(0, 20, 441, w - 40, 72, Color(120,120,120,255))


					draw.SimpleText("Information On How To Upgrade Your Miner", "DermaLarge", 30, 249, Color(44,44,44,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("BitCoin Miner Upgrades", "DermaLarge", 30, 21, Color(44,44,44,255), TEXT_ALIGN_LEFT)
					draw.SimpleText(self:GetBitcoinAddress(), "DermaLarge", 130, 480, Color(44,44,44,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("Current Encoded Wallet Address", "DermaLarge", 130, 443, Color(255,191,20,255), TEXT_ALIGN_LEFT)
					draw.RoundedBox(0, 120, 441, 5, OptionsPanel:GetTall() - 460, Color(23,23,23,255))
					draw.RoundedBox(0, 125, 475, OptionsPanel:GetWide() - 145, 5, Color(23,23,23,255))
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(BTCWalletMaterial)
					surface.DrawTexturedRect(40, 445, 64, 64)

					draw.SimpleText("Buttons from left to right are as follows", "DermaLarge", 355, 299, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.SimpleText("Left icon: upgrade corresponding hardware by one level", "Trebuchet24", 357, 334, Color(109,109,109,255), TEXT_ALIGN_CENTER)
					draw.SimpleText("Middle icon: downgrade corresponding hardware by one level", "Trebuchet24", 357, 362, Color(109,109,109,255), TEXT_ALIGN_CENTER)
					draw.SimpleText("Right icon: upgrade corresponding hardware to the max level", "Trebuchet24", 358, 388, Color(109,109,109,255), TEXT_ALIGN_CENTER)

					surface.SetDrawColor(Color(255,255,255,255))
					surface.DrawLine(30, 333, OptionsPanel:GetWide() - 30, 333)
					surface.DrawLine(30, 360, OptionsPanel:GetWide() - 30, 360)
					surface.DrawLine(30, 387, OptionsPanel:GetWide() - 30, 387)

					draw.SimpleText("RAM: ", "DermaLarge", 35, 74, Color(0,255,63,255), TEXT_ALIGN_LEFT)
					draw.SimpleText(GetNameByNumber(self:GetRamLevel()), "DermaLarge", 100, 74, Color(120,120,120,255), TEXT_ALIGN_LEFT)

					draw.SimpleText("Chipset: ", "DermaLarge", 35, 127, Color(0,255,255,255), TEXT_ALIGN_LEFT)
					draw.SimpleText(GetNameByNumber(self:GetChipLevel()), "DermaLarge", 132, 127, Color(120,120,120,255), TEXT_ALIGN_LEFT)

					draw.SimpleText("Battery: ", "DermaLarge", 35, 182, Color(220,0,255,255), TEXT_ALIGN_LEFT)
					draw.SimpleText(GetNameByNumber(self:GetBatLevel()), "DermaLarge", 130, 182, Color(120,120,120,255), TEXT_ALIGN_LEFT)

					surface.SetDrawColor(Color(255,255,255,255))

					surface.DrawLine(30, 113, w - 30, 113)
					surface.DrawLine(30, 170, w - 30, 170)

					surface.DrawLine(490, 64, 490, 150 + 74)
					surface.DrawLine(561, 64, 561, 150 + 74)
					surface.DrawLine(623, 64, 623, 150 + 74)

				end

				local ChangeAddress = vgui.Create("DButton", OptionsPanel)
				ChangeAddress:SetSize(150, 25)
				ChangeAddress:SetPos(530, 445)
				ChangeAddress:SetText("")
				ChangeAddress.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(255,191,0,255))

					draw.SimpleText("Change Address", "Trebuchet24", 7.5, 0, Color(112,112,112,255), TEXT_ALIGN_LEFT)
				end
				ChangeAddress.DoClick = function(self)

					local ChangeFrame = vgui.Create("DFrame")
					ChangeFrame:SetSize(500, 50)
					ChangeFrame:Center()
					ChangeFrame:SetTitle("Change BitCoin Address ::: Make sure the address is valid!")
					ChangeFrame:SetBackgroundBlur(true)
					ChangeFrame:MakePopup()
					ChangeFrame.Paint = function(selfn, w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255))
					end

					local AddressBox = vgui.Create("DTextEntry", ChangeFrame)
					AddressBox:SetSize(ChangeFrame:GetWide() - 20, 20)
					AddressBox:SetPos(10, 25)
					AddressBox:SetText("BitCoin Address Goes Here")
					AddressBox.OnEnter = function(selfa)
						ChangeMinerAddress(MINER, selfa:GetValue())
						ChangeFrame:Close()
					end
				end

				local InfoPanel = vgui.Create("DPanel", Frame)
				InfoPanel:SetPos(80, 64)
				InfoPanel:SetSize(Frame:GetWide() - 80, Frame:GetTall() - 64)
				InfoPanel:Hide()
				InfoPanel.Paint = function(selfp, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255)) -- Grey background

					draw.RoundedBox(0, 20, 20, w - 40, 150, Color(120,120,120,255)) -- Grey background
					draw.RoundedBox(0, 20, 53, w - 40, 5, Color(33,33,33,255)) -- Seperator
					draw.RoundedBox(0, 30, 64, w - 60, 100, Color(33,33,33,255)) -- Inside

					draw.RoundedBox(0, 20, 180, w - 40, 340, Color(120,120,120,255)) -- Grey background
					draw.RoundedBox(0, 20, 213, w - 40, 5, Color(33,33,33,255)) -- Seperator
					draw.RoundedBox(0, 30, 224, w - 60, 290, Color(33,33,33,255)) -- Inside

					draw.SimpleText("The BlockChain Encryption Key (used for transactions)", "DermaLarge", 30, 180, Color(44,44,44,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("xsRNPhz5YPdL8I9002I20D3Negm2gXf0ns8937MrG07", "DermaLarge", 33, 230, Color(63,127,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("ns8937MrG07x717zd1678hk9X4AlBN5WE68nL78L53A", "DermaLarge", 30, 260, Color(63,127,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("8kAuBZLgv0C2SSUoL1B0h6186JNBd91M6KZJ6Vi9sS", "DermaLarge", 30, 290, Color(63,127,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("KF6x0cql8U11tpGbSooFNrlwrB5zhUU2r2F0Qi37Rx888", "DermaLarge", 30, 320, Color(63,127,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("l6PL38w781bZt0NO4m579Y5NkICu3447856293lcZ418", "DermaLarge", 30, 350, Color(63,127,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("G9mj2yo99K8upeqY12AJoldwqzo7v5DK4E6xSW5697L", "DermaLarge", 30, 380, Color(63,127,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("7AqR51s16zx32fY7KWdUI8s8z45PQ3S3ud8xEY7cmg7", "DermaLarge", 30, 410, Color(63,127,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("yI6tF5V9plyI0d7bSKns9e1w2urvL4bT9bG2zWi8BN7Ii3", "DermaLarge", 30, 440, Color(63,127,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("0VLtJfQWyvK5V6KjKu2FRZx62ME08Ln50uvtL8oE8G5x", "DermaLarge", 30, 470, Color(63,127,0,255), TEXT_ALIGN_LEFT)


					draw.SimpleText("Generic BitCoin Info", "DermaLarge", 30, 21, Color(44,44,44,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("The current worth of a BitCoin is approximately: " .. DarkRP.formatMoney(BitCoins_CFG.Worth), "Trebuchet24", 32, 70, Color(0,155,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("The current amount of payments on the BlockChain is: " .. MyAddressTable[6], "Trebuchet24", 32, 100, Color(0,161,255,255), TEXT_ALIGN_LEFT)
					local AmountOfMiners = 0
					for k, v in pairs(ents.FindByClass("bitcoinminertwo")) do
						AmountOfMiners = AmountOfMiners + 1
					end
					draw.SimpleText("There are currently " .. tostring(AmountOfMiners) .. " BitCoin Miners logged in to the BlockChain.", "Trebuchet24", 32, 130, Color(150,66,255,255), TEXT_ALIGN_LEFT)


				end

				local ExtrasPanel = vgui.Create("DPanel", Frame)
				ExtrasPanel:SetPos(80, 64)
				ExtrasPanel:SetSize(Frame:GetWide() - 80, Frame:GetTall() - 64)
				ExtrasPanel:Hide()
				ExtrasPanel.Paint = function(selfp, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255)) -- Grey background

					draw.RoundedBox(0, 20, 20, w - 40, 490, Color(120,120,120,255)) -- Grey background
					draw.RoundedBox(0, 20, 53, w - 40, 5, Color(33,33,33,255)) -- Seperator
					draw.RoundedBox(0, 30, 64, w - 60, 440, Color(33,33,33,255)) -- Inside
					draw.SimpleText("Most Recent Transactions", "DermaLarge", 30, 21, Color(44,44,44,255), TEXT_ALIGN_LEFT)
					if istable(MyAddressTable[5][1]) then
						local iterator = 80
						for k, v in pairs(MyAddressTable[5]) do
							draw.SimpleText(v[1] .. " --> " .. v[2] .. ", " .. v[3] .. " BitCoins", "PaymentsFontTwo", 37, iterator, Color(44,255,44,255), TEXT_ALIGN_LEFT)
							iterator = iterator + 30
						end
					else
						draw.SimpleText("No transactions, not be the first?", "DermaLarge", 45, 80, Color(255,44,44,255), TEXT_ALIGN_LEFT)
					end

				end

				local UserPanel = vgui.Create("DPanel", Frame)
				UserPanel:SetPos(80, 64)
				UserPanel:SetSize(Frame:GetWide() - 80, Frame:GetTall() - 64)
				UserPanel:Hide()
				UserPanel.Paint = function(selfp, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255)) -- Grey background

					draw.RoundedBox(0, 20, 20, w - 40, 300, Color(120,120,120,255)) -- Grey background
					draw.RoundedBox(0, 20, 53, w - 40, 5, Color(33,33,33,255)) -- Seperator
					draw.RoundedBox(0, 30, 64, w - 60, 250, Color(33,33,33,255)) -- Inside

					draw.SimpleText("Your Profile ::: " .. LocalPlayer():Nick(), "DermaLarge", 30, 21, Color(44,44,44,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("Your BitCoin Address", "DermaLarge", 360, 65, Color(255,0,255,255), TEXT_ALIGN_CENTER)
					draw.SimpleText(MyAddressTable[1], "DermaLarge", 360, 97, Color(255,191,40,255), TEXT_ALIGN_CENTER)
					draw.SimpleText("Account Holder: BlockChain EU", "DermaLarge", 360, 132, Color(0,255,255,255), TEXT_ALIGN_CENTER)
					draw.SimpleText(MyAddressTable[3] .. " BitCoins", "DermaLarge", 360, 168, Color(155,130,40,255), TEXT_ALIGN_CENTER)
					draw.SimpleText("You have " .. DarkRP.formatMoney(math.Round(tonumber(MyAddressTable[3]) * BitCoins_CFG.Worth)) .. " worth of BitCoins!", "DermaLarge", 360, 203, Color(0,255,0,255), TEXT_ALIGN_CENTER)

					-- honestly.. space holders but it looks cool
					draw.SimpleText("BlockChain BitCoin Wallet Service, All Rights Reserved.", "DermaLarge", 30, 330, Color(0,161,255,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("This BitCoin Miner has been approved by the National", "DermaLarge", 30, 360, Color(0,127,31,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("BitCoin Mining Association (NBMA)", "DermaLarge", 30, 390, Color(0,127,31,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("Please keep this miner in a private area to avoid theft", "DermaLarge", 30, 420, Color(127,0,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("of your BitCoins.", "DermaLarge", 30, 450, Color(127,0,0,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("Please keep your miner cooled at around 24 degrees (C)", "DermaLarge", 30, 480, Color(191,127,255,255), TEXT_ALIGN_LEFT)


				surface.SetDrawColor(Color(255,255,255,255))
				surface.DrawLine(30, 95, UserPanel:GetWide() - 30, 95)
				surface.DrawLine(30, 130, UserPanel:GetWide() - 30, 130)
				surface.DrawLine(30, 165, UserPanel:GetWide() - 30, 165)
				surface.DrawLine(30, 200, UserPanel:GetWide() - 30, 200)
				surface.DrawLine(30, 235, UserPanel:GetWide() - 30, 235)



				end

				local CopyMyAddress = vgui.Create("DButton", UserPanel)
				CopyMyAddress:SetSize(16, 16)
				CopyMyAddress:SetPos(670, 105)
				CopyMyAddress:SetText("")
				CopyMyAddress.Paint = function(selfadd, w, h)
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(MyAddressTable[4])
					surface.DrawTexturedRect(0, 0, 16, 16)
				end
				CopyMyAddress.DoClick = function(self)
					SetClipboardText(MyAddressTable[1])
					notification.AddLegacy("Copied address to clipboard!", NOTIFY_GENERIC, 5)
				end


				local function ToMoneyFromBTC(amountOfBTC)

					if tonumber(amountOfBTC) == nil then notification.AddLegacy("Please enter a number.", NOTIFY_ERROR, 5) return end
					if tonumber(amountOfBTC) > tonumber(MyAddressTable[3]) then notification.AddLegacy("You don't even have that many BitCoins!", NOTIFY_ERROR, 5) return end
					net.Start("bitcoins_to_cash")
					net.WriteString(amountOfBTC)
					net.SendToServer()
				end

				local function ToBTCFromMoney(amountOfMoney)
					local wallet = LocalPlayer():getDarkRPVar("money")

					if tonumber(amountOfMoney) == nil then notification.AddLegacy("Please enter a number.", NOTIFY_ERROR, 5) return end
					if tonumber(amountOfMoney) > wallet then notification.AddLegacy("You don't even have that much money!", NOTIFY_ERROR, 5) return end
					if tonumber(amountOfMoney) % 2 != 0 then notification.AddLegacy("Please enter an even number.", NOTIFY_ERROR, 5) return end

					net.Start("bitcoins_from_cash")
					net.WriteInt(tonumber(amountOfMoney), 32)
					net.SendToServer()
				end

				local function SendBTC(address, amountOfBTC)

				 	if string.len(address) < 35 then notification.AddLegacy("Please enter a valid BitCoin address.", NOTIFY_ERROR, 5) return end
					if string.len(address) > 35 then notification.AddLegacy("Please enter a valid BitCoin address.", NOTIFY_ERROR, 5) return end
					if tonumber(amountOfBTC) == nil then notification.AddLegacy("Please enter a number.", NOTIFY_ERROR, 5) return end
					if tonumber(amountOfBTC) > tonumber(MyAddressTable[3]) then notification.AddLegacy("You don't even have that many BitCoins!", NOTIFY_ERROR, 5) return end

					net.Start("bitcoins_sendbtc")
					net.WriteString(address)
					net.WriteString(amountOfBTC)
					net.SendToServer()
				end

				local ToMoney = vgui.Create("DButton", UserPanel)
				ToMoney:SetSize(200, 50)
				ToMoney:SetPos(40, 255)
				ToMoney:SetText("Convert BTC To Money")
				ToMoney:SetTextColor(Color(255,255,255,255))
				ToMoney.Paint = function(selfto, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(25,190,20,255))
				end
				ToMoney.DoClick = function(selftod)
					local HowFrame = vgui.Create("DFrame")
					HowFrame:SetSize(500, 50)
					HowFrame:Center()
					HowFrame:SetTitle("Convert BitCoins To Money")
					HowFrame:SetBackgroundBlur(true)
					HowFrame:MakePopup()
					HowFrame.Paint = function(selfn, w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255))
					end

					local AmountBox = vgui.Create("DTextEntry", HowFrame)
					AmountBox:SetSize(HowFrame:GetWide() - 20, 20)
					AmountBox:SetPos(10, 25)
					AmountBox:SetText("Amount To Change To Cash Goes Here")
					AmountBox.OnEnter = function(selfdob)
						ToMoneyFromBTC(selfdob:GetValue())
						HowFrame:Close()
					end
				end


				local ToBTC = vgui.Create("DButton", UserPanel)
				ToBTC:SetSize(230, 50)
				ToBTC:SetPos(200 + 40 + 10, 255)
				ToBTC:SetText("Convert Money To BTC")
				ToBTC:SetTextColor(Color(255,255,255,255))
				ToBTC.Paint = function(selfto, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(190,160,20,255))
				end
				ToBTC.DoClick = function(selftod)
					local HowFrame = vgui.Create("DFrame")
					HowFrame:SetSize(500, 50)
					HowFrame:Center()
					HowFrame:SetTitle("Convert Money To BitCoins")
					HowFrame:SetBackgroundBlur(true)
					HowFrame:MakePopup()
					HowFrame.Paint = function(selfn, w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255))
					end

					local AmountBox = vgui.Create("DTextEntry", HowFrame)
					AmountBox:SetSize(HowFrame:GetWide() - 20, 20)
					AmountBox:SetPos(10, 25)
					AmountBox:SetText("Amount To Change To BitCoins Goes Here")
					AmountBox.OnEnter = function(selfdob)
						ToBTCFromMoney(selfdob:GetValue())
						HowFrame:Close()
					end
				end

				local SendBTCButton = vgui.Create("DButton", UserPanel)
				SendBTCButton:SetSize(190, 50)
				SendBTCButton:SetPos(200 + 40 + 10 + 230 + 10, 255)
				SendBTCButton:SetText("Send BitCoins")
				SendBTCButton:SetTextColor(Color(255,255,255,255))
				SendBTCButton.Paint = function(selfbtc, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(255,93,0,255))
				end
				SendBTCButton.DoClick = function(selfbtcc)
					local HowFrame = vgui.Create("DFrame")
					HowFrame:SetSize(500, 50)
					HowFrame:Center()
					HowFrame:SetTitle("Send BitCoins to an address ::: Make sure the address is valid or you may lose your BitCoins!")
					HowFrame:SetBackgroundBlur(true)
					HowFrame:MakePopup()
					HowFrame.Paint = function(selfn, w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55,255))
					end

					local AmountBox = vgui.Create("DTextEntry", HowFrame)
					AmountBox:SetSize(HowFrame:GetWide() - 20, 20)
					AmountBox:SetPos(10, 25)
					AmountBox:SetText("Format: Address,Amount (No Spaces)")
					AmountBox.OnEnter = function(selfdob)
						local Table = string.Explode(",", selfdob:GetValue())
						SendBTC(Table[1], Table[2])
						HowFrame:Close()
					end
				end

				local MainTab = vgui.Create("DButton", Frame)
				MainTab:SetSize(70, 84)
				MainTab:SetPos(5, 110)
				MainTab:SetText(" ")
				MainTab.DoClick = function(self)
					OptionsPanel:Hide()
					InfoPanel:Hide()
					ExtrasPanel:Hide()
					UserPanel:Hide()
				end
				MainTab.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(109,109,109,255))
					surface.SetMaterial(MainPageMaterial)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(3, 0, 64, 64)
					draw.SimpleText("Details", "Trebuchet24", 6, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

				local UploadTab = vgui.Create("DButton", Frame)
				UploadTab:SetSize(70, 84)
				UploadTab:SetPos(5, 110 + 84 + 10)
				UploadTab:SetText(" ")
				UploadTab.DoClick = function(self)
					OptionsPanel:Show()
					InfoPanel:Hide()
					ExtrasPanel:Hide()
					UserPanel:Hide()
				end
				UploadTab.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(109,109,109,255))
					surface.SetMaterial(UploadMaterial)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(3, 1, 64, 64)
					draw.SimpleText("Options", "Trebuchet24", 2, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

				local InfoTab = vgui.Create("DButton", Frame)
				InfoTab:SetSize(70, 84)
				InfoTab:SetPos(5, 110 + 84 + 20 + 84)
				InfoTab:SetText(" ")
				InfoTab.DoClick = function(self)
					OptionsPanel:Hide()
					InfoPanel:Show()
					ExtrasPanel:Hide()
					UserPanel:Hide()
				end
				InfoTab.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(109,109,109,255))
					surface.SetMaterial(InfoMaterial)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(3, 1, 64, 62)
					draw.SimpleText("Info", "Trebuchet24", 18.5, 61, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

				local ExtrasTab = vgui.Create("DButton", Frame)
				ExtrasTab:SetSize(70, 95)
				ExtrasTab:SetPos(5, 110 + 84 + 30 + 84 + 84)
				ExtrasTab:SetText(" ")
				ExtrasTab.DoClick = function(self)
					OptionsPanel:Hide()
					InfoPanel:Hide()
					ExtrasPanel:Show()
					UserPanel:Hide()
				end
				ExtrasTab.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(109,109,109,255))
					surface.SetMaterial(ExtrasMaterial)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(3, 1, 64, 60)
					draw.SimpleText("Latest", "PaymentsFont", 13, 61, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.SimpleText("Payments", "PaymentsFont", 0, 74, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

				local UserTab = vgui.Create("DButton", Frame)
				UserTab:SetSize(70, 84)
				UserTab:SetPos(5, 110 + 84 + 40 + 84 + 84 + 95)
				UserTab:SetText(" ")
				UserTab.DoClick = function(self)
					OptionsPanel:Hide()
					InfoPanel:Hide()
					ExtrasPanel:Hide()
					UserPanel:Show()
				end
				UserTab.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(109,109,109,255))
					surface.SetMaterial(UserMaterial)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(3, 1, 64, 60)
					draw.SimpleText("Profile", "Trebuchet24", 6, 61, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end


				local UpgradeRamButton = vgui.Create("DButton", OptionsPanel)
				UpgradeRamButton:SetSize(50, 48)
				UpgradeRamButton:SetPos(506, 69)
				UpgradeRamButton:SetText("")
				UpgradeRamButton.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(UpgradeMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				UpgradeRamButton.DoClick = function(self)
					UpgradeRam(MINER, MINER:GetRamLevel() + 1)
				end

				local DowngradeRamButton = vgui.Create("DButton", OptionsPanel)
				DowngradeRamButton:SetSize(50, 48)
				DowngradeRamButton:SetPos(509 + 64, 69)
				DowngradeRamButton:SetText("")
				DowngradeRamButton.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(DowngradeMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				DowngradeRamButton.DoClick = function(self)
					DowngradeRam(MINER, MINER:GetRamLevel() - 1)
				end

				local MaxUpgradesRamButton = vgui.Create("DButton", OptionsPanel)
				MaxUpgradesRamButton:SetSize(50, 48)
				MaxUpgradesRamButton:SetPos(509 + 64 + 64, 69)
				MaxUpgradesRamButton:SetText("")
				MaxUpgradesRamButton.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(MaxUpgradesMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				MaxUpgradesRamButton.DoClick = function(self)
					UpgradeRamMax(MINER)
				end

				local UpgradeChipButton = vgui.Create("DButton", OptionsPanel)
				UpgradeChipButton:SetSize(50, 48)
				UpgradeChipButton:SetPos(506, 69 + 52)
				UpgradeChipButton:SetText("")
				UpgradeChipButton.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(UpgradeMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				UpgradeChipButton.DoClick = function(self)
					UpgradeChip(MINER, MINER:GetChipLevel() + 1)
				end

				local DowngradeChipButon = vgui.Create("DButton", OptionsPanel)
				DowngradeChipButon:SetSize(50, 48)
				DowngradeChipButon:SetPos(509 + 64, 52 + 70)
				DowngradeChipButon:SetText("")
				DowngradeChipButon.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(DowngradeMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				DowngradeChipButon.DoClick = function(self)
					DowngradeChip(MINER, MINER:GetChipLevel() - 1)
				end

				local MaxUpgradesChipButton = vgui.Create("DButton", OptionsPanel)
				MaxUpgradesChipButton:SetSize(50, 48)
				MaxUpgradesChipButton:SetPos(509 + 64 + 64, 52 + 70)
				MaxUpgradesChipButton:SetText("")
				MaxUpgradesChipButton.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(MaxUpgradesMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				MaxUpgradesChipButton.DoClick = function(self)
					UpgradeChipMax(MINER)
				end

				local UpgradeBatteryButton = vgui.Create("DButton", OptionsPanel)
				UpgradeBatteryButton:SetSize(50, 48)
				UpgradeBatteryButton:SetPos(506, 69 + 52 + 56)
				UpgradeBatteryButton:SetText("")
				UpgradeBatteryButton.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(UpgradeMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				UpgradeBatteryButton.DoClick = function(self)
					UpgradeBat(MINER, MINER:GetBatLevel() + 1)
				end

				local DowngradeBatteryButton = vgui.Create("DButton", OptionsPanel)
				DowngradeBatteryButton:SetSize(50, 48)
				DowngradeBatteryButton:SetPos(509 + 64, 52 + 70 + 56)
				DowngradeBatteryButton:SetText("")
				DowngradeBatteryButton.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(DowngradeMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				DowngradeBatteryButton.DoClick = function(self)
					DowngradeBat(MINER, MINER:GetBatLevel() - 1)
				end

				local MaxUpgradesBatteryButton = vgui.Create("DButton", OptionsPanel)
				MaxUpgradesBatteryButton:SetSize(50, 48)
				MaxUpgradesBatteryButton:SetPos(509 + 64 + 64, 52 + 70 + 56)
				MaxUpgradesBatteryButton:SetText("")
				MaxUpgradesBatteryButton.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(MaxUpgradesMaterial)
					surface.DrawTexturedRect(0, 0, 40, 40)
				end
				MaxUpgradesBatteryButton.DoClick = function(self)
					UpgradeBatMax(MINER)
				end

			end
			HaveReqSettings = true
		end
	else
		SettingsAlpha = 0
		HaveMousedSettings = false
		HaveReqSettings = false
	end

	if ( localTrace.x > ButtonOnX and localTrace.x < ButtonOnW ) and ( localTrace.y > ButtonOnY and localTrace.y < ButtonOnH ) and LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTrace().Entity:GetPos()) <= 100 then
		ButtonOnAlpha = 100
		if HaveMousedButtonOn == false then
			HaveMousedButtonOn = true
		end
		if LocalPlayer():KeyDown(32) then
			if HaveReqButtonOn == false then
				RequestOn(self)
				LocalPlayer():EmitSound("/buttons/blip1.wav")
			end
			HaveReqButtonOn = true
		end
	else
		ButtonOnAlpha = 0
		HaveMousedButtonOn = false
		HaveReqButtonOn = false
	end

	if ( localTrace.x > ButtonOffX and localTrace.x < ButtonOffW ) and ( localTrace.y > ButtonOffY and localTrace.y < ButtonOffH ) and LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTrace().Entity:GetPos()) <= 100 then
		ButtonOffAlpha = 100
		if HaveMousedButtonOff == false then
			HaveMousedButtonOff = true
		end
		if LocalPlayer():KeyDown(32) then
			if HaveReqButtonOff == false then
				RequestOff(self)
				LocalPlayer():EmitSound("/buttons/blip1.wav")
			end
			HaveReqButtonOff = true
		end
	else
		ButtonOffAlpha = 0
		HaveMousedButtonOff = false
		HaveReqButtonOff = false
	end




	-- front bit

	Ang:RotateAroundAxis(Ang:Forward(), 90)

	cam.Start3D2D(Pos + Ang:Up()*17, Ang, 0.04)

		draw.RoundedBox(0,-388,-275,782,274,Color(22,22,22,255)) -- Dark background

		draw.RoundedBox(0,-350,-250,712,50,Color(127,127,127,255)) -- Light grey background
		draw.RoundedBox(0,-350,-190,712,150,Color(127,127,127,255)) -- BitCoin Background

		draw.SimpleTextOutlined("Owner: " .. owner, "OwnerFont", -340, -225, Color(0,0,0,255), TEXT_ALIGN_LEFT, 1, 1, Color(255,255,255,255))
		draw.SimpleTextOutlined("BitCoin Miner", "BitCoinTitlefont", -340, -115, Color(0,0,0,255), TEXT_ALIGN_LEFT, 1, 1, Color(255,255,255,255))

	cam.End3D2D()

end
