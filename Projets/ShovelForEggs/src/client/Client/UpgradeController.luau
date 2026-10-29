--!strict
-- Client/UpgradeController : fenêtre Upgrade (améliorer un brainrot avec de l'argent).
-- Ouverte depuis une carte du menu Base (bouton UPGRADE) ou avec l'invite "Upgrade" (touche F) sur un pet de son enclos.
-- Le serveur (PlotService, "UpgradePet") vérifie l'argent et fait le calcul ; ici on n'affiche que l'aperçu.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Pets = require(Shared.Config.Pets)
local Mutations = require(Shared.Config.Mutations)
local Rebirth = require(Shared.Config.Rebirth)
local Items = require(Shared.Config.Items)
local Levels = require(Shared.Config.Levels)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local Frame = UI.Frames:WaitForChild("Upgrade") :: Frame
local PetBox = Frame:WaitForChild("PetBox") :: ImageLabel
local View = PetBox:WaitForChild("View") :: ViewportFrame
local LvTag = PetBox:WaitForChild("LvTag") :: TextLabel
local PetName = Frame:WaitForChild("PetName") :: TextLabel
local RarityL = Frame:WaitForChild("Rarity") :: TextLabel
local LevelBar = Frame:WaitForChild("LevelBar") :: ImageLabel
local BarFill = LevelBar:WaitForChild("Fill") :: ImageLabel
local BarText = LevelBar:WaitForChild("Text") :: TextLabel
local Level = Frame:WaitForChild("Level") :: TextLabel
local Income = Frame:WaitForChild("Income") :: TextLabel
local One = Frame:WaitForChild("One") :: ImageButton
local Max = Frame:WaitForChild("Max") :: ImageButton
local assets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Pets")

local current: string? = nil   -- uid du pet affiché
local shown: string? = nil     -- uid dont le modèle 3D est dans la vue
local fromBase = false         -- ouvert depuis le menu Base : on y revient en fermant
local busy = false

-- même calcul que le menu Base (rebirths + runes), pour que les chiffres collent
local function moneyMult(d: any): number
	return Rebirth.Mult(d.Rebirths) * (1 + math.min(d.Runes.Income or 0, Items.RuneCaps.Income))
end

-- revenu lisible même pour les petits pets (1.25 au lieu de 1)
local function num(n: number): string
	if n >= 1000 then return Format.Num(n) end
	local s = string.format(n < 100 and "%.2f" or "%.1f", n)
	s = string.gsub(s, "0+$", "")
	return (string.gsub(s, "%.$", ""))
end

local function setEnabled(b: ImageButton, on: boolean)
	b.ImageColor3 = on and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 130)
end

local function refresh()
	if not current or not Frame.Visible then return end
	local d = State.Data
	local e = d and d.Pets[current]
	local br = e and Pets.ById[e.Id]
	if not (d and e and br) then
		current = nil
		if UI.Open == Frame then UI.Close() end
		return
	end
	local mut = Mutations.ById[e.Mut] or Mutations.ById.Normal
	local r = Pets.RarityById[br.Rarity]
	if shown ~= current then
		shown = current
		local folder = assets:FindFirstChild(mut.Folder) or assets:FindFirstChild("Normal")
		local model = folder and folder:FindFirstChild(br.Id) :: Model?
		if not model then model = (assets:FindFirstChild("Normal") :: Folder):FindFirstChild(br.Id) :: Model? end
		task.defer(UI.ShowModel, View, model, false, 0.9)
	end
	PetName.Text = br.Name
	PetName.TextColor3 = Color3.new(1, 1, 1)
	RarityL.Text = string.upper((mut.Id ~= "Normal" and (mut.Name .. " ") or "") .. br.Rarity)
	RarityL.TextColor3 = mut.Id ~= "Normal" and mut.Color or r.Color
	local glow = PetBox:FindFirstChild("Glow") :: ImageLabel?
	if glow then glow.ImageColor3 = mut.Id ~= "Normal" and mut.Color or r.Color end
	local lv = Levels.Of(e)
	local base = br.Income * mut.Mult * moneyMult(d)
	local now = base * Levels.IncomeMult(lv)
	LvTag.Text = lv >= Levels.Max and "MAX" or ("LV " .. lv)
	BarText.Text = "LEVEL " .. lv .. " / " .. Levels.Max
	local a = (lv - 1) / (Levels.Max - 1)
	BarFill.Visible = a > 0.001
	TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { Size = UDim2.fromScale(math.max(0.02, 0.98 * a), BarFill.Size.Y.Scale) }):Play()
	if lv >= Levels.Max then
		Level.Text = "Max level reached!"
		Income.Text = "$" .. num(now) .. "/s"
		UI.SetText(One, "Text", "MAX LEVEL"); setEnabled(One, false)
		Max.Visible = false
		One.Position = UDim2.fromScale(0.285, 0.775) -- seul bouton : centré
		return
	end
	Max.Visible = true
	One.Position = UDim2.fromScale(0.05, 0.775)
	Level.Text = "+" .. math.floor(Levels.PerLevel * 100) .. "% income per level"
	Income.Text = "$" .. num(now) .. "/s  <font color=\"#7CFF8C\">→ $" .. num(base * Levels.IncomeMult(lv + 1)) .. "/s</font>"
	local cost = Levels.Cost(e, d.Rebirths) :: number
	UI.SetText(One, "Text", "UPGRADE " .. Format.Money(cost))
	setEnabled(One, d.Money >= cost)
	local n, total = Levels.Affordable(e, d.Rebirths, d.Money)
	UI.SetText(Max, "Text", n > 1 and ("MAX +" .. n .. "  " .. Format.Money(total)) or "MAX")
	setEnabled(Max, n > 1)
end

local function open(uid: string)
	if not (State.Data and State.Data.Pets[uid]) then return end
	fromBase = UI.Open == UI.Frames:FindFirstChild("Base")
	current = uid
	if UI.Open ~= Frame then UI.Show("Upgrade") end
	refresh()
end
local uiAny: any = UI
uiAny.OpenUpgrade = open

local function pop(label: TextLabel)
	local s = label:FindFirstChild("UpPop") :: UIScale?
	if not s then
		local n = Instance.new("UIScale")
		n.Name = "UpPop"
		n.Parent = label
		s = n
	end
	local sc = s :: UIScale
	sc.Scale = 1.35
	TweenService:Create(sc, TweenInfo.new(0.35, Enum.EasingStyle.Back), { Scale = 1 }):Play()
end

local function buy(n: any)
	if busy or not current then return end
	busy = true
	local ok, res = pcall(State.Ask, "UpgradePet", current, n)
	busy = false
	if ok and type(res) == "table" and res.ok then
		UI.Play("LevelUp", 0.6)
		pop(Level); pop(Income)
		State.Notify:Fire("Level " .. tostring(res.Lv) .. "!" .. (res.Count > 1 and (" (+" .. res.Count .. " levels)") or ""), "success")
	elseif ok and type(res) == "table" and res.msg then
		State.Notify:Fire(res.msg, "error")
	end
	refresh()
end
UI.Button(One, function() buy(1) end)
UI.Button(Max, function() buy("max") end)

-- fermeture : retour au menu Base si on venait de là
local close = Frame:FindFirstChild("Close") :: GuiButton?
if close then
	UI.Button(close, function()
		local back = fromBase
		fromBase = false
		if UI.Open == Frame then UI.Close() end
		if back then task.delay(0.15, function() if UI.Open == nil then UI.Show("Base") end end) end
	end)
end
UI.Opened.Event:Connect(function(n) if n ~= "Upgrade" and n ~= nil then fromBase = false end end)

State.On({ "Money", "Pets", "Rebirths", "Runes" }, refresh)

-- pets de l'enclos : invite "Upgrade" (touche F) + clic souris sur le brainrot, seulement pour le propriétaire
local function ownerOf(inst: Instance): number?
	local m: Instance? = inst.Parent
	while m and m ~= workspace and m:GetAttribute("Owner") == nil do m = m.Parent end
	return m and m:GetAttribute("Owner") :: number? or nil
end
local function hook(d: Instance)
	if d:IsA("ProximityPrompt") and d:GetAttribute("ClientAction") == "Upgrade" then
		if ownerOf(d) ~= player.UserId then d.Enabled = false; return end
		d.Triggered:Connect(function()
			local uid = d:GetAttribute("Uid")
			if type(uid) == "string" then open(uid) end
		end)
	elseif d:IsA("ClickDetector") and d.Name == "UpgradeClick" then
		-- pets des autres : pas de curseur "main" (réglage local)
		if ownerOf(d) ~= player.UserId then d.MaxActivationDistance = 0; return end
		d.MouseClick:Connect(function()
			local uid = d:GetAttribute("Uid")
			if type(uid) == "string" then open(uid) end
		end)
	end
end
for _, d in ipairs(workspace:GetDescendants()) do hook(d) end
workspace.DescendantAdded:Connect(function(d)
	if d:IsA("ProximityPrompt") or d:IsA("ClickDetector") then task.defer(hook, d) end
end)

return true
