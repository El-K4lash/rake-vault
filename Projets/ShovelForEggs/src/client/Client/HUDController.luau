--!strict
-- Client/HUDController : argent, sac, rebirths, boutons de gauche, bouton "Collect" de la base.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Upgrades = require(Shared.Config.Upgrades)
local Items = require(Shared.Config.Items)
local Zones = require(Shared.Config.Zones)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local HUD = UI.HUD
local Left = HUD:WaitForChild("Left") :: Frame
local Labels = HUD:WaitForChild("Labels") :: Frame
local Money = Labels:WaitForChild("Money") :: TextLabel
local Sled = Labels:WaitForChild("Sled") :: TextLabel
local Rebirths = Labels:WaitForChild("Rebirths") :: TextLabel
local Collect = HUD:WaitForChild("Collect") :: TextButton
local SledBar = Labels:FindFirstChild("SledBar")
local SledFill = SledBar and SledBar:FindFirstChild("Fill") :: ImageLabel?
local Quick = HUD:FindFirstChild("Quick")
local Eggs = require(Shared.Config.Eggs)

local function sledCapacity(data: any): number
	local lvl = Upgrades.Sleds[math.clamp(data.Sled, 1, #Upgrades.Sleds)]
	local cap = lvl.Value + math.min(data.Runes.Sled or 0, Items.RuneCaps.Sled)
	if data.Passes and data.Passes.VIP then cap = math.floor(cap * 1.5) end
	return cap
end
local function sledCount(data: any): number
	local n = 0
	for _, c in pairs(data.SledItems) do n += c end
	return n
end

-- animation du compteur d'argent
local shownMoney = 0
local function setMoney(target: number)
	local from = shownMoney
	local t0 = os.clock()
	task.spawn(function()
		while os.clock() - t0 < 0.4 do
			local a = (os.clock() - t0) / 0.4
			shownMoney = from + (target - from) * a
			Money.Text = Format.Money(shownMoney)
			task.wait()
		end
		shownMoney = target
		Money.Text = Format.Money(target)
	end)
end

State.On({ "Money" }, function()
	setMoney(State.Data.Money)
end)

State.On({ "SledItems", "Sled", "Runes", "Passes" }, function()
	local d = State.Data
	local n, cap = sledCount(d), sledCapacity(d)
	Sled.Text = string.format("Sled %d / %d", n, cap)
	Sled.TextColor3 = n >= cap and Color3.fromRGB(255, 90, 90) or (n >= cap * 0.8 and Color3.fromRGB(255, 190, 60) or Color3.new(1, 1, 1))
	if SledFill then
		local a = cap > 0 and math.clamp(n / cap, 0, 1) or 0
		SledFill.Visible = a > 0.01
		TweenService:Create(SledFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Size = UDim2.fromScale(0.976 * a, 0.76) }):Play()
		SledFill.ImageColor3 = a >= 1 and Color3.fromRGB(255, 110, 110) or Color3.new(1, 1, 1)
	end
end)

State.On({ "Rebirths" }, function()
	Rebirths.Text = "Rebirths: " .. tostring(State.Data.Rebirths)
end)

local LocalPlayer = game:GetService("Players").LocalPlayer
-- pelle en main ? (le bouton AUTO de la pelle prend alors la même place que Collect)
local function shovelEquipped(): boolean
	local char = LocalPlayer.Character
	local tool = char and char:FindFirstChildOfClass("Tool")
	return tool ~= nil and tool:GetAttribute("Shovel") ~= nil
end
local function updateCollect()
	local p = State.Data and State.Data.Pending or 0
	-- caché quand un menu est ouvert (il passait par-dessus les fenêtres) et quand la pelle est équipée
	Collect.Visible = p >= 1 and UI.Open == nil and not shovelEquipped()
	UI.SetText(Collect, "Text", "Collect " .. Format.Money(p))
end
State.On({ "Pending" }, updateCollect)
UI.Opened.Event:Connect(updateCollect)
local function watchTools(char: Model)
	char.ChildAdded:Connect(function(c) if c:IsA("Tool") then updateCollect() end end)
	char.ChildRemoved:Connect(function(c) if c:IsA("Tool") then task.defer(updateCollect) end end)
	updateCollect()
end
if LocalPlayer.Character then watchTools(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(watchTools)

-- boutons de gauche : chaque bouton ouvre le menu du même nom
for _, b in ipairs(Left:GetChildren()) do
	if b:IsA("GuiButton") and b.Name ~= "Music" then -- (Music : bouton on/off, géré par MusicController)
		UI.Button(b, function() UI.Toggle(b.Name) end)
	end
end
UI.Button(Collect, function() State.Send("Collect") end)

-- raccourcis du haut : téléportation (le serveur choisit la destination)
if Quick then
	local map = { TpBase = "Base", TpSell = "Sell", TpZone = "Zone" }
	for name, where in pairs(map) do
		local b = Quick:FindFirstChild(name) :: GuiButton?
		if b then UI.Button(b, function() State.Send("Teleport", where) end) end
	end
end

-- petit "+$" quand on vend / ramasse
local function floatText(text: string, color: Color3)
	local tpl = UI.Templates:FindFirstChild("NotificationTemplate") :: TextLabel?
	if not tpl then return end
	local l = tpl:Clone()
	l.Text = text
	l.TextColor3 = color
	l.Visible = true
	l.Position = UDim2.new(0.5, 0, 0.6, 0)
	l.AnchorPoint = Vector2.new(0.5, 0.5)
	l.Size = UDim2.new(0.3, 0, 0.06, 0)
	l.Parent = UI.Gui
	TweenService:Create(l, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.45, 0), TextTransparency = 1 }):Play()
	task.delay(1.2, function() l:Destroy() end)
end
local uiAny: any = UI
uiAny.FloatText = floatText

local lastMiss = 0
State.Event.Event:Connect(function(name, payload)
	if name == "Sold" then
		if payload.Money > 0 then
			floatText("+" .. Format.Money(payload.Money), Color3.fromRGB(120, 255, 140))
			UI.Play("Money", 0.6)
		end
	elseif name == "Collected" then
		floatText("+" .. Format.Money(payload), Color3.fromRGB(120, 255, 140))
		UI.Play("Money", 0.6)
	elseif name == "Harvested" then
		UI.Play("Normal", 0.25)
	elseif name == "SwingMiss" then
		-- retour visuel discret quand le coup ne touche rien (limité à 1 toutes les 2 s)
		local now = os.clock()
		if now - lastMiss > 2 then
			lastMiss = now
			floatText("Nothing here... find items!", Color3.fromRGB(230, 230, 240))
		end
	elseif name == "EggFound" then
		local def = Eggs.ById[payload.Egg]
		local label = def and def.Name or "Egg"
		floatText((payload.Chest and "FREE " or "+1 ") .. label .. "!", def and def.Color or Color3.fromRGB(255, 230, 120))
		UI.Play("Success", 0.5)
	elseif name == "OpenMenu" and type(payload) == "string" then
		if UI.Open ~= UI.Frames:FindFirstChild(payload) then UI.Show(payload) end
	end
end)

-- cercles du hub (ShopPad, IndexPad) : on entre dans le cercle = le menu s'ouvre, on sort = il se ferme.
-- Plus besoin d'appuyer sur E : le ProximityPrompt de ces deux pads est coupé (côté client seulement).
task.spawn(function()
	local hub = workspace:WaitForChild("Map"):WaitForChild("Hub", 30)
	if not hub then return end
	local pads: { { Part: BasePart, Menu: string, Inside: boolean } } = {}
	for _, n in ipairs({ "ShopPad", "IndexPad" }) do
		local pad = hub:WaitForChild(n, 10) :: BasePart?
		if pad then
			local pp = pad:FindFirstChildOfClass("ProximityPrompt")
			local menu = pp and pp:GetAttribute("Action") or string.gsub(n, "Pad$", "")
			if pp then pp.Enabled = false end
			table.insert(pads, { Part = pad, Menu = menu :: string, Inside = false })
		end
	end
	while true do
		task.wait(0.15)
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
		for _, p in ipairs(pads) do
			local inside = false
			if root then
				local d = root.Position - p.Part.Position
				local r = math.max(p.Part.Size.X, p.Part.Size.Z) / 2
				inside = Vector2.new(d.X, d.Z).Magnitude <= r and d.Y > -2 and d.Y < 10
			end
			if inside ~= p.Inside then
				p.Inside = inside
				local frame = UI.Frames:FindFirstChild(p.Menu)
				if inside then
					if frame and UI.Open ~= frame then UI.Show(p.Menu) end
				elseif frame and UI.Open == frame then
					UI.Close()
				end
			end
		end
	end
end)

return true
