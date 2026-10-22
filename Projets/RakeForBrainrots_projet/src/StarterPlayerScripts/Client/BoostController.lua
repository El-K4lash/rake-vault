--!strict
-- Client/BoostController : icônes des boosts actifs en bas à droite (HUD.Boosts), avec le temps restant et un badge xN.
-- Survol = infobulle (HUD.BoostTip). Sources : events serveur (attributs workspace Event<Stat> / Event<Stat>End,
-- lancés depuis le panel admin) et boosts perso du joueur (data.Boosts, codes...). Les deux se cumulent.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local Row = UI.HUD:WaitForChild("Boosts") :: Frame
local Tip = UI.HUD:WaitForChild("BoostTip") :: Frame
local Tpl = UI.Templates:WaitForChild("BoostTemplate") :: ImageLabel

local INFO = {
	Luck = { Name = "LUCK", Icon = "rbxassetid://81193001619814", Color = Color3.fromRGB(120, 255, 140), Desc = "chance to find brainrots & eggs" },
	Money = { Name = "MONEY", Icon = "rbxassetid://103944045008759", Color = Color3.fromRGB(255, 220, 90), Desc = "money from selling & your base" },
}

type Boost = { Key: string, Stat: string, Mult: number, Ends: number, Server: boolean }

local function now(): number return workspace:GetServerTimeNow() end

local function active(): { Boost }
	local list: { Boost } = {}
	for stat in pairs(INFO) do
		local m = workspace:GetAttribute("Event" .. stat)
		local e = workspace:GetAttribute("Event" .. stat .. "End")
		if type(m) == "number" and type(e) == "number" and e > now() and m > 1 then
			table.insert(list, { Key = "S_" .. stat, Stat = stat, Mult = m, Ends = e, Server = true })
		end
		local d = State.Data
		local pe = d and d.Boosts and d.Boosts[stat]
		if type(pe) == "number" and pe > now() then
			table.insert(list, { Key = "P_" .. stat, Stat = stat, Mult = 2, Ends = pe, Server = false })
		end
	end
	table.sort(list, function(a, b) return a.Ends < b.Ends end)
	return list
end

local function fmt(sec: number): string
	sec = math.max(0, math.floor(sec))
	if sec >= 3600 then return string.format("%d:%02d:%02d", sec // 3600, (sec % 3600) // 60, sec % 60) end
	return string.format("%d:%02d", sec // 60, sec % 60)
end
local function long(sec: number): string
	sec = math.max(0, math.floor(sec))
	if sec >= 3600 then return string.format("%dh %dm", sec // 3600, (sec % 3600) // 60) end
	if sec >= 60 then return string.format("%dm %ds", sec // 60, sec % 60) end
	return sec .. "s"
end

local icons: { [string]: ImageLabel } = {}
local hovered: Boost? = nil
local current: { [string]: Boost } = {}

local function showTip(bo: Boost?)
	hovered = bo
	if not bo then Tip.Visible = false; return end
	local info = INFO[bo.Stat]
	;(Tip:FindFirstChild("Icon") :: ImageLabel).Image = info.Icon
	local title = Tip:FindFirstChild("Title") :: TextLabel
	title.Text = info.Name .. " x" .. bo.Mult
	title.TextColor3 = info.Color
	UI.SetText(Tip, "Source", bo.Server and "Server event (everyone)" or "Your personal boost")
	UI.SetText(Tip, "Desc", "x" .. bo.Mult .. " " .. info.Desc)
	UI.SetText(Tip, "Left", "Ends in " .. long(bo.Ends - now()))
	Tip.Visible = true
end

local function make(bo: Boost): ImageLabel
	local b = Tpl:Clone()
	b.Name = bo.Key
	b.Visible = true
	;(b:FindFirstChild("Icon") :: ImageLabel).Image = INFO[bo.Stat].Icon
	;(b:FindFirstChild("Server") :: GuiObject).Visible = bo.Server
	b.MouseEnter:Connect(function() showTip(current[bo.Key]) end)
	b.MouseLeave:Connect(function() if hovered and hovered.Key == bo.Key then showTip(nil) end end)
	-- mobile : un appui affiche l'infobulle 2 s
	b.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			showTip(current[bo.Key])
			task.delay(2, function() if hovered and hovered.Key == bo.Key then showTip(nil) end end)
		end
	end)
	local pop = b:FindFirstChild("Pop") :: UIScale
	pop.Scale = 0
	b.Parent = Row
	TweenService:Create(pop, TweenInfo.new(0.35, Enum.EasingStyle.Back), { Scale = 1 }):Play()
	return b
end

local acc = 0
RunService.Heartbeat:Connect(function(dt)
	acc += dt
	-- l'infobulle suit la souris
	if Tip.Visible then
		local m = UserInputService:GetMouseLocation()
		Tip.Position = UDim2.fromOffset(m.X - 10, m.Y - 46)
	end
	if acc < 0.25 then return end
	acc = 0
	local list = active()
	local seen: { [string]: boolean } = {}
	current = {}
	for i, bo in ipairs(list) do
		seen[bo.Key] = true
		current[bo.Key] = bo
		local b = icons[bo.Key] or make(bo)
		icons[bo.Key] = b
		b.LayoutOrder = -i
		UI.SetText(b:FindFirstChild("Badge") :: Instance, "Text", "x" .. bo.Mult)
		local left = bo.Ends - now()
		local t = b:FindFirstChild("Timer") :: TextLabel
		t.Text = fmt(left)
		t.TextColor3 = left < 30 and Color3.fromRGB(255, 110, 110) or Color3.new(1, 1, 1)
		if hovered and hovered.Key == bo.Key then showTip(bo) end
	end
	for key, b in pairs(icons) do
		if not seen[key] then
			icons[key] = nil
			if hovered and hovered.Key == key then showTip(nil) end
			local pop = b:FindFirstChild("Pop") :: UIScale
			local tw = TweenService:Create(pop, TweenInfo.new(0.2), { Scale = 0 })
			tw:Play()
			tw.Completed:Once(function() b:Destroy() end)
		end
	end
end)

return true
