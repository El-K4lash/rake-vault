--!strict
-- StarterPlayerScripts/Client/ShopController
-- Shop Robux : onglets Featured / Passes / Boosts / Cash / Galaxies.
-- Les galaxies vendues contre des Robux ont un bouton ODDS qui affiche les chances
-- exactes de chaque planète AVANT l'achat (règle Roblox sur les objets aléatoires payants).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Formulas = require(Shared.Util.Formulas)
local Gamepasses = require(Shared.Config.Gamepasses)
local Products = require(Shared.Config.Products)
local Galaxies = require(Shared.Config.Galaxies)
local Planets = require(Shared.Config.Planets)
local Rarities = require(Shared.Config.Rarities)
local Models = require(Shared.Visuals.Models)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local panel = UI.Panel("Shop")
local content = panel:WaitForChild("Body"):WaitForChild("Content")
local list = content:WaitForChild("List") :: ScrollingFrame
local template = list:WaitForChild("Template") :: Frame
local tabs = content:WaitForChild("Tabs")

local ICON = {
	Robux = "rbxassetid://97272186997275",
	Crown = "rbxassetid://94666332436790",
	Gift = "rbxassetid://112101874744840",
	Rebirth = "rbxassetid://102040339566414",
	Book = "rbxassetid://102082573689395",
	Shop = "rbxassetid://110119422421461",
}

-- description de chaque article
type Item = { Kind: string, Key: string, Desc: string, Icon: string?, Galaxy: string?, Planet: string?, Color: Color3 }
local GOLD = Color3.fromRGB(255, 200, 60)
local BLUE = Color3.fromRGB(80, 180, 255)
local GREEN = Color3.fromRGB(90, 220, 90)
local PURPLE = Color3.fromRGB(170, 90, 255)
local PINK = Color3.fromRGB(255, 80, 140)

local ITEMS: { [string]: { Item } } = {
	Featured = {
		{ Kind = "Product", Key = "StarterPack", Desc = "$25K + Legendary galaxy + x2 money 30 min", Galaxy = "GoldenCrown", Color = GOLD },
		{ Kind = "Pass", Key = "DoubleMoney", Desc = "x2 money forever", Planet = "GoldenSaturn", Color = GREEN },
		{ Kind = "Pass", Key = "VIP", Desc = "+25% money, VIP tag", Icon = ICON.Crown, Color = GOLD },
		{ Kind = "Product", Key = "SecretGalaxy", Desc = "Hatches a SECRET planet!", Galaxy = "PrismCore", Color = PINK },
	},
	Passes = {
		{ Kind = "Pass", Key = "DoubleMoney", Desc = "x2 money forever", Planet = "GoldenSaturn", Color = GREEN },
		{ Kind = "Pass", Key = "DoubleLuck", Desc = "x2 luck forever", Planet = "LimeComet", Color = BLUE },
		{ Kind = "Pass", Key = "FastHatch", Desc = "Galaxies hatch 2x faster", Galaxy = "EmeraldSwirl", Color = BLUE },
		{ Kind = "Pass", Key = "ExtraSlots", Desc = "+2 equipped planets", Planet = "AmethystGiant", Color = PURPLE },
		{ Kind = "Pass", Key = "FourthSpawner", Desc = "A 4th galaxy spawner", Galaxy = "AmethystSpiral", Color = PURPLE },
		{ Kind = "Pass", Key = "AutoHatch", Desc = "Hatches ready galaxies for you", Icon = ICON.Book, Color = GREEN },
		{ Kind = "Pass", Key = "VIP", Desc = "+25% money, VIP tag", Icon = ICON.Crown, Color = GOLD },
	},
	Boosts = {
		{ Kind = "Product", Key = "BoostMoney15", Desc = "x2 money for 15 min", Planet = "SunForge", Color = GREEN },
		{ Kind = "Product", Key = "BoostLuck15", Desc = "x2 luck for 15 min", Planet = "MintRing", Color = BLUE },
		{ Kind = "Product", Key = "SkipAll", Desc = "Finish every timer now", Icon = ICON.Rebirth, Color = GOLD },
	},
	Cash = {
		{ Kind = "Product", Key = "CashSmall", Desc = "", Icon = ICON.Gift, Color = GREEN },
		{ Kind = "Product", Key = "CashMedium", Desc = "", Icon = ICON.Gift, Color = GREEN },
		{ Kind = "Product", Key = "CashLarge", Desc = "", Icon = ICON.Gift, Color = GOLD },
	},
	Galaxies = {
		{ Kind = "Product", Key = "MythicGalaxy", Desc = "Mythic planet (or better!)", Galaxy = "CrimsonEye", Color = PINK },
		{ Kind = "Product", Key = "SecretGalaxy", Desc = "Guaranteed SECRET planet", Galaxy = "PrismCore", Color = PINK },
	},
}

local current = "Featured"
local cardsByItem: { { frame: Frame, item: Item } } = {}

local function info(item: Item): any
	return if item.Kind == "Pass" then Gamepasses[item.Key] else Products[item.Key]
end

local function owned(item: Item): boolean
	if item.Kind == "Pass" then return player:GetAttribute("Pass_" .. item.Key) == true end
	if item.Key == "StarterPack" then return State.Data.StarterPack == true end
	return false
end

-- chances des planètes d'une galaxie, avec la Luck actuelle du joueur
local function showOdds(galaxyId: string)
	local odds = UI.Panel("Odds")
	local c = odds:WaitForChild("Body"):WaitForChild("Content")
	local oList = c:WaitForChild("List")
	local oTemplate = oList:WaitForChild("Template") :: Frame
	for _, ch in ipairs(oList:GetChildren()) do
		if ch:IsA("Frame") and ch ~= oTemplate then ch:Destroy() end
	end
	local g = Galaxies.ById[galaxyId];
	(c:WaitForChild("GalaxyName") :: TextLabel).Text = (g and g.Name or galaxyId) .. " (your luck)"
	local luck = Formulas.Luck(State.Build())
	for i, o in ipairs(Formulas.PlanetOdds(galaxyId, luck)) do
		local row = oTemplate:Clone()
		row.Name = o.id
		row.Visible = true
		row.LayoutOrder = i
		local p = Planets.ById[o.id]
		local name = row:FindFirstChild("PlanetName") :: TextLabel
		name.Text = p and p.Name or o.id
		UI.Tint(name, p and p.Rarity or "Common", "TextColor3");
		(row:FindFirstChild("Chance") :: TextLabel).Text = Format.Percent(o.chance)
		row.Parent = oList
	end
	odds.Visible = true
end

local function buy(item: Item)
	if owned(item) and item.Kind == "Pass" then
		UI.Notify("You already own this!", "success")
		return
	end
	local i = info(item)
	if not i or i.Id == 0 then
		UI.Notify("Coming soon!", "warn")
		return
	end
	if item.Kind == "Pass" then
		MarketplaceService:PromptGamePassPurchase(player, i.Id)
	else
		MarketplaceService:PromptProductPurchase(player, i.Id)
	end
end

local function describe(item: Item): string
	local i = info(item)
	if i and i.Minutes then
		local amount = math.max(i.Min or 0, (player:GetAttribute("Income") or 0) * i.Minutes * 60)
		return "+" .. Format.Money(amount) .. " (" .. (i.Minutes >= 60 and (i.Minutes // 60 .. "h") or (i.Minutes .. " min")) .. " of income)"
	end
	return item.Desc
end

local function refreshCards()
	for _, e in ipairs(cardsByItem) do
		local buyBtn = e.frame:FindFirstChild("Buy") :: Frame
		local i = info(e.item)
		if owned(e.item) and e.item.Kind == "Pass" then
			UI.SetLabel(buyBtn, "OWNED");
			(buyBtn:FindFirstChild("Robux") :: ImageLabel).Visible = false
		else
			UI.SetLabel(buyBtn, "   " .. tostring(i and i.Price or "?"));
			(buyBtn:FindFirstChild("Robux") :: ImageLabel).Visible = true
		end;
		(e.frame:FindFirstChild("Desc") :: TextLabel).Text = describe(e.item)
	end
end

local function show(tab: string)
	current = tab
	for _, e in ipairs(cardsByItem) do e.frame:Destroy() end
	table.clear(cardsByItem)
	for i, item in ipairs(ITEMS[tab] or {}) do
		local c = template:Clone()
		c.Name = item.Key
		c.Visible = true
		c.LayoutOrder = i
		local design = c:FindFirstChild("Design") :: ImageLabel
		design.ImageColor3 = item.Color
		local inf = info(item);
		(c:FindFirstChild("ItemName") :: TextLabel).Text = inf and inf.Name or item.Key
		local icon = c:FindFirstChild("Icon") :: ImageLabel
		local view = c:FindFirstChild("View") :: ViewportFrame
		if item.Galaxy then
			UI.Viewport(view, Models.Galaxy(item.Galaxy, 1), 0.9, 0.8)
			icon.Visible = false
		elseif item.Planet and Planets.ById[item.Planet] then
			UI.Viewport(view, Models.Planet(item.Planet, nil, 3), 0.7, 0.9)
			icon.Visible = false
		else
			icon.Image = item.Icon or ""
			view.Visible = false
		end
		UI.Button(c:FindFirstChild("Buy") :: Frame, function() buy(item) end)
		local oddsBtn = c:FindFirstChild("Odds") :: Frame
		if inf and inf.ShowOdds and item.Galaxy then
			oddsBtn.Visible = true
			local gid = item.Galaxy
			UI.Button(oddsBtn, function() showOdds(gid) end)
		end
		c.Parent = list
		table.insert(cardsByItem, { frame = c, item = item })
	end
	refreshCards()
	for _, t in ipairs(tabs:GetChildren()) do
		if t:IsA("Frame") then
			local pop = t:FindFirstChild("Pop") :: UIScale?
			if pop then pop.Scale = t.Name == tab and 1.06 or 1 end
			local d = t:FindFirstChild("Design") :: ImageLabel?
			if d then d.ImageTransparency = t.Name == tab and 0 or 0.25 end
		end
	end
end

for _, t in ipairs(tabs:GetChildren()) do
	if t:IsA("Frame") then
		UI.Button(t, function() show(t.Name) end)
	end
end

UI.OnOpen("Shop", function() show(current) end)
State.On("StarterPack", refreshCards)
State.On("Passes", refreshCards)

local _ = Rarities
return {}
