--!strict
-- StarterPlayerScripts/Client/PlanetsController
-- Inventaire des planètes : grille (équipées en premier, puis les plus rentables),
-- détail de la planète choisie (Equip / Lock / Sell), EQUIP BEST et SELL ALL.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Formulas = require(Shared.Util.Formulas)
local Planets = require(Shared.Config.Planets)
local Rarities = require(Shared.Config.Rarities)
local Mutations = require(Shared.Config.Mutations)
local Upgrades = require(Shared.Config.Upgrades)
local Models = require(Shared.Visuals.Models)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local panel = UI.Panel("Planets")
local content = panel:WaitForChild("Body"):WaitForChild("Content")
local grid = content:WaitForChild("Grid") :: ScrollingFrame
local template = grid:WaitForChild("Template") :: Frame
local detail = content:WaitForChild("Detail") :: Frame
local slotsLabel = content:WaitForChild("Slots") :: TextLabel
local totalLabel = content:WaitForChild("Total") :: TextLabel
local empty = content:WaitForChild("Empty") :: TextLabel

local cards: { [string]: Frame } = {}
local selected: string? = nil
local sellArmed = false

local function rarityOf(id: string): string
	local p = Planets.ById[id]
	return p and p.Rarity or "Common"
end

local function mutationText(mut: string?): (string, Color3)
	local m = mut and Mutations.ById[mut]
	if not m then return "", Color3.new(1, 1, 1) end
	return string.upper(m.Name), m.Color
end

local function showDetail()
	local data = State.Data.Planets or {}
	local p = selected and data[selected]
	local view = detail:FindFirstChild("View") :: ViewportFrame
	if not p then
		(detail:FindFirstChild("PlanetName") :: TextLabel).Text = "Select a planet";
		(detail:FindFirstChild("Rarity") :: TextLabel).Text = "";
		(detail:FindFirstChild("Mutation") :: TextLabel).Text = "";
		(detail:FindFirstChild("Income") :: TextLabel).Text = ""
		UI.Viewport(view, nil)
		for _, n in ipairs({ "Equip", "Lock", "Sell" }) do (detail:FindFirstChild(n) :: Frame).Visible = false end
		return
	end
	local info = Planets.ById[p.Id]
	local rarity = rarityOf(p.Id);
	(detail:FindFirstChild("PlanetName") :: TextLabel).Text = info and info.Name or p.Id
	local rl = detail:FindFirstChild("Rarity") :: TextLabel
	rl.Text = string.upper(rarity)
	UI.Tint(rl, rarity, "TextColor3")
	local mt, mc = mutationText(p.Mut)
	local ml = detail:FindFirstChild("Mutation") :: TextLabel
	ml.Text = mt ~= "" and (mt .. " x" .. Mutations.ById[p.Mut].Multiplier) or ""
	ml.TextColor3 = mc
	local mult = Formulas.MoneyMultiplier(State.Build());
	(detail:FindFirstChild("Income") :: TextLabel).Text = "+" .. Format.Money(Formulas.PlanetIncome(p.Id, p.Mut) * mult) .. "/s"
	UI.Viewport(view, Models.Planet(p.Id, p.Mut, 3), 0.7, 0.95)
	local eq = detail:FindFirstChild("Equip") :: Frame
	local lock = detail:FindFirstChild("Lock") :: Frame
	local sell = detail:FindFirstChild("Sell") :: Frame
	eq.Visible = true; lock.Visible = true; sell.Visible = true
	UI.SetLabel(eq, p.Eq and "UNEQUIP" or "EQUIP")
	UI.SetLabel(lock, p.Lock and "UNLOCK" or "LOCK")
	sellArmed = false
	UI.SetLabel(sell, "SELL " .. Format.Money(Formulas.SellValue(p.Id, p.Mut)))
end

local function makeCard(uid: string, p: any): Frame
	local c = template:Clone()
	c.Name = uid
	c.Visible = true
	local rarity = rarityOf(p.Id)
	local design = c:FindFirstChild("Design") :: ImageLabel
	UI.Tint(design, rarity, "ImageColor3")
	local info = Planets.ById[p.Id];
	(c:FindFirstChild("PlanetName") :: TextLabel).Text = info and info.Name or p.Id
	local mt, mc = mutationText(p.Mut)
	local ml = c:FindFirstChild("Mutation") :: TextLabel
	ml.Text = mt
	ml.TextColor3 = mc
	UI.Viewport(c:FindFirstChild("View") :: ViewportFrame, Models.Planet(p.Id, p.Mut, 3), 0, 0.95)
	UI.Button(c, function()
		selected = uid
		showDetail()
	end)
	c.Parent = grid
	return c
end

local function refresh()
	local data = State.Data.Planets or {}
	local mult = Formulas.MoneyMultiplier(State.Build())
	local list = {}
	local equipped, total = 0, 0
	for uid, p in pairs(data) do
		local income = Formulas.PlanetIncome(p.Id, p.Mut)
		table.insert(list, { uid = uid, p = p, income = income })
		if p.Eq then
			equipped += 1
			total += income
		end
	end
	table.sort(list, function(a, b)
		if a.p.Eq ~= b.p.Eq then return a.p.Eq end
		if a.income ~= b.income then return a.income > b.income end
		return a.uid < b.uid
	end)
	local seen = {}
	for i, e in ipairs(list) do
		seen[e.uid] = true
		local c = cards[e.uid] or makeCard(e.uid, e.p)
		cards[e.uid] = c
		c.LayoutOrder = i;
		(c:FindFirstChild("Income") :: TextLabel).Text = Format.Money(e.income * mult) .. "/s";
		(c:FindFirstChild("Equipped") :: Frame).Visible = e.p.Eq == true;
		(c:FindFirstChild("Lock") :: TextLabel).Visible = e.p.Lock == true
	end
	for uid, c in pairs(cards) do
		if not seen[uid] then
			c:Destroy()
			cards[uid] = nil
		end
	end
	if selected and not data[selected] then selected = nil end
	local slots = Formulas.EquipSlots(State.Build())
	slotsLabel.Text = "EQUIPPED " .. equipped .. "/" .. slots .. "   (" .. #list .. "/" .. Upgrades.Base.InventoryMax .. ")"
	totalLabel.Text = "+" .. Format.Money(total * mult) .. "/s"
	empty.Visible = #list == 0
	showDetail()
end
State.On("Planets", refresh)
State.On("Rebirths", refresh)
State.On("Passes", refresh)

UI.Button(detail:WaitForChild("Equip"), function()
	local p = selected and (State.Data.Planets or {})[selected]
	if not p then return end
	State.Request(p.Eq and "Unequip" or "Equip", selected)
end)
UI.Button(detail:WaitForChild("Lock"), function()
	if selected then State.Request("Lock", selected) end
end)
UI.Button(detail:WaitForChild("Sell"), function()
	local p = selected and (State.Data.Planets or {})[selected]
	if not p then return end
	-- 2 clics pour vendre une planète rare (anti-erreur)
	local order = Rarities.Info[rarityOf(p.Id)].Order
	if (order >= 3 or p.Mut) and not sellArmed then
		sellArmed = true
		UI.SetLabel(detail.Sell, "SURE?")
		return
	end
	State.Request("Sell", selected)
end)
UI.Button(content:WaitForChild("EquipBest"), function()
	State.Request("EquipBest")
end)

-- SELL ALL : vend les planètes non équipées et non verrouillées jusqu'à "Rare" (2 clics)
local sellAllArmed = false
UI.Button(content:WaitForChild("SellAll"), function()
	if not sellAllArmed then
		sellAllArmed = true
		UI.SetLabel(content.SellAll, "SURE?")
		task.delay(3, function()
			sellAllArmed = false
			UI.SetLabel(content.SellAll, "SELL ALL")
		end)
		return
	end
	sellAllArmed = false
	UI.SetLabel(content.SellAll, "SELL ALL")
	State.Request("SellAll", 2)
end)

UI.OnOpen("Planets", function()
	refresh()
end)

return {}
