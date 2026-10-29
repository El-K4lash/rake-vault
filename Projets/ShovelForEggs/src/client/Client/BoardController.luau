--!strict
-- Client/BoardController : les deux panneaux du fond de MON enclos.
--   UPGRADES : StarterGui.UpgradeBoardGui posée (Adornee) sur Pen.UpgradeBoard -> achat via "BuyUpgrade".
--   STATS    : StarterGui.StatsBoardGui posée sur Pen.StatsBoard -> argent, revenus, sac, râteau, œufs, pets...
-- + le bouton AUTO du HUD (amélioration Auto Shovel) : ratisse tout seul avec le râteau en main.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Upgrades = require(Shared.Config.Upgrades)
local Rebirth = require(Shared.Config.Rebirth)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local UpGui = pg:WaitForChild("UpgradeBoardGui") :: SurfaceGui
local StGui = pg:WaitForChild("StatsBoardGui") :: SurfaceGui
local UpList = UpGui:WaitForChild("Bg"):WaitForChild("List")
local StGrid = StGui:WaitForChild("Bg"):WaitForChild("Grid")
local AutoBtn = pg:WaitForChild("Hotbar"):WaitForChild("AutoHolder"):WaitForChild("AutoShovel") :: ImageButton

-- [ pose sur MON enclos ] ----------------------------------------------------------
local function attach()
	local plotName = player:GetAttribute("Plot")
	local map = workspace:FindFirstChild("Map")
	local plot = map and plotName and map:FindFirstChild("Plots") and map.Plots:FindFirstChild(plotName)
	local pen = plot and plot:FindFirstChild("Pen")
	UpGui.Adornee = pen and pen:FindFirstChild("UpgradeBoard", true) :: BasePart?
	StGui.Adornee = pen and pen:FindFirstChild("StatsBoard", true) :: BasePart?
end
task.spawn(function()
	while true do
		-- l'enclos est reconstruit (nouveau slot, clôture...) : on reprend les nouvelles parts
		-- (l'ancien enclos est gardé quelques secondes sous le nom "OldPen" pendant l'animation : on ne reste pas dessus)
		local function ok(a: Instance?): boolean return a ~= nil and a.Parent ~= nil and a:FindFirstAncestor("Pen") ~= nil end
		if not (ok(UpGui.Adornee) and ok(StGui.Adornee)) then attach() end
		task.wait(0.2)
	end
end)
player:GetAttributeChangedSignal("Plot"):Connect(attach)

-- [ UPGRADES ] ----------------------------------------------------------------------
local function lvl(id: string): number
	local d = State.Data
	return d and d.Up and d.Up[id] or 0
end

local function refreshUpgrades()
	local d = State.Data
	if not d then return end
	for _, u in ipairs(Upgrades.BaseUpgrades) do
		local r = UpList:FindFirstChild(u.Id)
		if not r then continue end
		local l = lvl(u.Id)
		local maxed = l >= u.Max
		local locked = u.Requires ~= nil and lvl(u.Requires :: string) <= 0
		UI.SetText(r, "Level", "Lv " .. l .. "/" .. u.Max)
		UI.SetText(r, "Value", u.Show(l))
		local b = r:FindFirstChild("Buy") :: TextButton
		local cost = Upgrades.UpgradeCost(u, l, d.Rebirths)
		local label = maxed and "MAX" or (locked and "LOCKED" or Format.Money(cost))
		UI.SetText(b, "Text", label)
		local can = not maxed and not locked and d.Money >= cost
		b.BackgroundColor3 = maxed and Color3.fromRGB(90, 150, 90) or (can and Color3.fromRGB(201, 139, 79) or Color3.fromRGB(120, 100, 85))
	end
end
for _, u in ipairs(Upgrades.BaseUpgrades) do
	local r = UpList:WaitForChild(u.Id)
	UI.Button(r:WaitForChild("Buy") :: GuiButton, function() State.Send("BuyUpgrade", u.Id) end)
end
State.On({ "Up", "Money", "Rebirths" }, refreshUpgrades)

-- [ STATS ] -------------------------------------------------------------------------
local function set(name: string, value: string)
	local c = StGrid:FindFirstChild(name)
	if c then UI.SetText(c, "Value", value) end
end

local function count(t: any): number
	local n = 0
	if type(t) == "table" then for _, v in pairs(t) do n += (type(v) == "number" and v or 1) end end
	return n
end

local function refreshStats()
	local d = State.Data
	if not d then return end
	UI.SetText(StGui:FindFirstChild("Bg") :: Instance, "Sub", player.DisplayName)
	local income = (player:GetAttribute("Income") :: number?) or 0
	set("Money", Format.Money(d.Money))
	set("Rebirths", tostring(d.Rebirths))
	set("IncomeSec", Format.Money(income) .. "/s")
	set("MoneyMult", string.format("x%.2f", (player:GetAttribute("MoneyMult") :: number?) or Rebirth.Mult(d.Rebirths)))
	local luck = (player:GetAttribute("Luck") :: number?) or 1
	set("Luck", string.format("x%.2f", luck))
	-- effets des upgrades du panneau
	local U = Upgrades.BaseUpgradeById
	set("EggLuck", string.format("x%.2f", luck * U.EggLuck.Value(lvl("EggLuck"))))
	local ht = lvl("HatchSpeed")
	set("HatchTime", ht > 0 and ("-" .. math.floor((1 - U.HatchSpeed.Value(ht)) * 100 + 0.5) .. "%") or "normal")
	set("WalkSpeed", tostring(U.WalkSpeed.Value(lvl("WalkSpeed"))))
	set("AutoShovel", lvl("AutoShovel") > 0 and string.format("%.1f clicks/s", U.AutoSpeed.Value(lvl("AutoSpeed"))) or "locked")
	local inPen, total = 0, 0
	for _, e in pairs(d.Pets) do total += 1; if e.Slot and e.Slot > 0 then inPen += 1 end end
	set("Pets", inPen .. " / " .. total)
	set("PenSlots", tostring(d.Slots) .. " / " .. Upgrades.MaxSlots)
	local cap = (player:GetAttribute("SledCap") :: number?) or Upgrades.Sleds[math.clamp(d.Sled, 1, #Upgrades.Sleds)].Value
	set("Sled", count(d.SledItems) .. " / " .. cap)
	local shovel = Upgrades.Shovels[math.clamp(d.Shovel, 1, #Upgrades.Shovels)]
	set("Shovel", shovel.Name)
	set("ShovelPower", shovel.Value .. (shovel.Value == 1 and " item" or " items"))
	set("Eggs", tostring(count(d.Eggs)))
	local maxEggs = Upgrades.BaseUpgradeById.EggSlots.Value(lvl("EggSlots"))
	set("Hatching", count(d.Incubating) .. " / " .. maxEggs)
	set("Earned", Format.Money(d.TotalEarned or 0))
	set("Found", Format.Num(d.Stats and d.Stats.Harvested or 0) .. " / " .. Format.Num(d.Stats and d.Stats.Found or 0))
end
State.On({ "Money", "Rebirths", "Pets", "Slots", "Sled", "SledItems", "Shovel", "Eggs", "Incubating", "Up", "Stats" }, refreshStats)
task.spawn(function() while true do task.wait(2); refreshStats() end end)

-- [ AUTO RAKE ] ---------------------------------------------------------------------
local auto = false
-- râteau en main ?
local function shovelInHand(): Tool?
	local char = player.Character
	local tool = char and char:FindFirstChildOfClass("Tool")
	return (tool and tool:GetAttribute("Shovel")) and tool or nil
end
local function drawAuto()
	local unlocked = lvl("AutoShovel") > 0
	if not unlocked then auto = false end
	-- toujours visible avec la pelle en main : verrouillé = affiche le prix (un clic l'achète)
	local show = shovelInHand() ~= nil
	if show and not AutoBtn.Visible then
		local pop = AutoBtn:FindFirstChild("Pop") :: UIScale?
		if pop then pop.Scale = 0.6; TweenService:Create(pop, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Scale = 1 }):Play() end
	end
	AutoBtn.Visible = show
	AutoBtn.Image = (AutoBtn:GetAttribute(auto and "On" or "Off") :: string?) or AutoBtn.Image
	if unlocked then
		AutoBtn.ImageColor3 = Color3.new(1, 1, 1)
		UI.SetText(AutoBtn, "Text", auto and "AUTO: ON" or "AUTO: OFF")
	else
		local u = Upgrades.BaseUpgradeById.AutoShovel
		local data = State.Data
		local cost = Upgrades.UpgradeCost(u, 0, data and data.Rebirths or 0)
		local afford = data and data.Money >= cost
		AutoBtn.ImageColor3 = afford and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 160)
		UI.SetText(AutoBtn, "Text", "🔒 AUTO " .. Format.Money(cost))
	end
end
local function clickAuto()
	if lvl("AutoShovel") > 0 then auto = not auto; drawAuto(); return end
	State.Send("BuyUpgrade", "AutoShovel")
end
UI.Button(AutoBtn, clickAuto)
State.On({ "Up", "Money", "Rebirths" }, drawAuto)
local function watchChar(char: Model)
	char.ChildAdded:Connect(function(c) if c:IsA("Tool") then drawAuto() end end)
	char.ChildRemoved:Connect(function(c) if c:IsA("Tool") then task.defer(drawAuto) end end)
	drawAuto()
end
if player.Character then watchChar(player.Character) end
player.CharacterAdded:Connect(watchChar)
drawAuto()

local acc = 0
RunService.Heartbeat:Connect(function(dt)
	if not auto then acc = 0; return end
	acc += dt
	local cps = Upgrades.BaseUpgradeById.AutoSpeed.Value(lvl("AutoSpeed"))
	if acc < 1 / cps then return end
	acc = 0
	local char = player.Character
	local tool = char and char:FindFirstChildOfClass("Tool")
	if tool and tool:GetAttribute("Shovel") then
		tool:Activate()
		task.defer(function() tool:Deactivate() end)
	end
end)

return true
