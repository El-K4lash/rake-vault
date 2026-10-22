--!strict
-- Client/BoardController : les deux panneaux du fond de MON enclos.
--   UPGRADES : StarterGui.UpgradeBoardGui posée (Adornee) sur Pen.UpgradeBoard -> achat via "BuyUpgrade".
--   STATS    : StarterGui.StatsBoardGui posée sur Pen.StatsBoard -> argent, revenus, sac, râteau, œufs, brainrots...
-- + le bouton AUTO du HUD (amélioration Auto Rake) : ratisse tout seul avec le râteau en main.
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
local AutoBtn = pg:WaitForChild("Hotbar"):WaitForChild("AutoHolder"):WaitForChild("AutoRake") :: ImageButton

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
	set("AutoRake", lvl("AutoRake") > 0 and string.format("%.1f clicks/s", U.AutoSpeed.Value(lvl("AutoSpeed"))) or "locked")
	local inPen, total = 0, 0
	for _, e in pairs(d.Brainrots) do total += 1; if e.Slot and e.Slot > 0 then inPen += 1 end end
	set("Brainrots", inPen .. " / " .. total)
	set("PenSlots", tostring(d.Slots) .. " / " .. Upgrades.MaxSlots)
	local cap = (player:GetAttribute("BagCap") :: number?) or Upgrades.Bags[math.clamp(d.Bag, 1, #Upgrades.Bags)].Value
	set("Bag", count(d.BagItems) .. " / " .. cap)
	local rake = Upgrades.Rakes[math.clamp(d.Rake, 1, #Upgrades.Rakes)]
	set("Rake", rake.Name)
	set("RakePower", rake.Value .. (rake.Value == 1 and " item" or " items"))
	set("Eggs", tostring(count(d.Eggs)))
	local maxEggs = Upgrades.BaseUpgradeById.EggSlots.Value(lvl("EggSlots"))
	set("Hatching", count(d.Incubating) .. " / " .. maxEggs)
	set("Earned", Format.Money(d.TotalEarned or 0))
	set("Found", Format.Num(d.Stats and d.Stats.Harvested or 0) .. " / " .. Format.Num(d.Stats and d.Stats.Found or 0))
end
State.On({ "Money", "Rebirths", "Brainrots", "Slots", "Bag", "BagItems", "Rake", "Eggs", "Incubating", "Up", "Stats" }, refreshStats)
task.spawn(function() while true do task.wait(2); refreshStats() end end)

-- [ AUTO RAKE ] ---------------------------------------------------------------------
local auto = false
-- râteau en main ?
local function rakeInHand(): Tool?
	local char = player.Character
	local tool = char and char:FindFirstChildOfClass("Tool")
	return (tool and tool:GetAttribute("Rake")) and tool or nil
end
local function drawAuto()
	local unlocked = lvl("AutoRake") > 0
	if not unlocked then auto = false end
	-- le bouton n'apparaît que si l'upgrade est débloquée ET que le râteau est équipé
	local show = unlocked and rakeInHand() ~= nil
	if show and not AutoBtn.Visible then
		local pop = AutoBtn:FindFirstChild("Pop") :: UIScale?
		if pop then pop.Scale = 0.6; TweenService:Create(pop, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Scale = 1 }):Play() end
	end
	AutoBtn.Visible = show
	AutoBtn.Image = (AutoBtn:GetAttribute(auto and "On" or "Off") :: string?) or AutoBtn.Image
	UI.SetText(AutoBtn, "Text", auto and "AUTO: ON" or "AUTO: OFF")
end
UI.Button(AutoBtn, function() auto = not auto; drawAuto() end)
State.On({ "Up" }, drawAuto)
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
	if tool and tool:GetAttribute("Rake") then
		tool:Activate()
		task.defer(function() tool:Deactivate() end)
	end
end)

return true
