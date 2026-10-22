--!strict
-- StarterPlayerScripts/Client/GalaxiesController
-- Panneau "Incubator" : les galaxies de l'enclos avec leur timer,
-- bouton HATCH quand c'est prêt, sinon SKIP (Robux). HATCH ALL / SKIP ALL en bas.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Galaxies = require(Shared.Config.Galaxies)
local Rarities = require(Shared.Config.Rarities)
local Products = require(Shared.Config.Products)
local Upgrades = require(Shared.Config.Upgrades)
local Formulas = require(Shared.Util.Formulas)
local Models = require(Shared.Visuals.Models)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local panel = UI.Panel("Galaxies")
local content = panel:WaitForChild("Body"):WaitForChild("Content")
local list = content:WaitForChild("List") :: ScrollingFrame
local template = list:WaitForChild("Template") :: Frame
local slotsLabel = content:WaitForChild("Slots") :: TextLabel
local queueLabel = content:WaitForChild("Queue") :: TextLabel
local empty = content:WaitForChild("Empty") :: TextLabel

local cards: { [string]: Frame } = {}

local function promptProduct(key: string)
	local id = Products[key].Id
	if id == 0 then
		UI.Notify("Coming soon!", "warn")
		return
	end
	MarketplaceService:PromptProductPurchase(player, id)
end

local function makeCard(entry: any): Frame
	local g = Galaxies.ById[entry.Galaxy]
	local rarity = g and g.Rarity or "Common"
	local c = template:Clone()
	c.Name = entry.Uid
	c.Visible = true
	local design = c:FindFirstChild("Design") :: ImageLabel
	design.ImageColor3 = UI.RarityColor(rarity):Lerp(Color3.new(1, 1, 1), 0.15)
	UI.Tint(design, rarity, "ImageColor3");
	(c:FindFirstChild("GalaxyName") :: TextLabel).Text = g and g.Name or entry.Galaxy;
	(c:FindFirstChild("Rarity") :: TextLabel).Text = string.upper(rarity)
	UI.Viewport(c:FindFirstChild("View") :: ViewportFrame, Models.Galaxy(entry.Galaxy, 1), 1, 0.85)
	local uid = entry.Uid
	UI.Button(c:FindFirstChild("Hatch") :: Frame, function()
		State.Request("Hatch", uid)
	end)
	UI.Button(c:FindFirstChild("Skip") :: Frame, function()
		State.Request("SkipTarget", uid)
		promptProduct("SkipOne")
	end)
	c.Parent = list
	return c
end

local function refresh()
	local incubator = State.Data.Incubator or {}
	local seen = {}
	for i, entry in ipairs(incubator) do
		seen[entry.Uid] = true
		local c = cards[entry.Uid] or makeCard(entry)
		cards[entry.Uid] = c
		c.LayoutOrder = i
		c:SetAttribute("EndsAt", entry.EndsAt)
		c:SetAttribute("Galaxy", entry.Galaxy)
	end
	for uid, c in pairs(cards) do
		if not seen[uid] then
			c:Destroy()
			cards[uid] = nil
		end
	end
	slotsLabel.Text = #incubator .. "/" .. Upgrades.Base.IncubatorSlots .. " GALAXIES"
	local q = State.Data.GivenGalaxies or {}
	queueLabel.Text = #q > 0 and (#q .. " waiting for a slot") or ""
	empty.Visible = #incubator == 0
end
State.On("Incubator", refresh)
State.On("GivenGalaxies", refresh)

-- timers : barre + texte, bouton Hatch / Skip
task.spawn(function()
	while true do
		if panel.Visible then
			local now = State.Now()
			local s = State.Build()
			for _, c in pairs(cards) do
				local ends = c:GetAttribute("EndsAt") or 0
				local total = Formulas.HatchDuration(c:GetAttribute("Galaxy") or "", s)
				local left = ends - now
				local bar = c:FindFirstChild("Bar") :: Frame
				local fill = bar:FindFirstChild("Fill") :: Frame
				local t = bar:FindFirstChild("Time") :: TextLabel
				local ready = left <= 0
				fill.Size = UDim2.fromScale(math.clamp(1 - left / math.max(total, 1), 0, 1), 1)
				t.Text = ready and "READY!" or Format.Time(left)
				local hatch = c:FindFirstChild("Hatch") :: Frame
				local skip = c:FindFirstChild("Skip") :: Frame
				hatch.Visible = ready
				skip.Visible = not ready
			end
		end
		task.wait(0.25)
	end
end)

UI.Button(content:WaitForChild("HatchAll"), function()
	State.Request("HatchAll")
end)
UI.Button(content:WaitForChild("SkipAll"), function()
	promptProduct("SkipAll")
end)
UI.SetLabel(content.SkipAll, "SKIP ALL " .. Products.SkipAll.Price)
UI.SetLabel(template:WaitForChild("Skip"), tostring(Products.SkipOne.Price))

local _ = Rarities
return {}
