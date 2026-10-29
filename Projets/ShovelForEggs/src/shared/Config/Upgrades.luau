--!strict
-- Shared/Config/Upgrades
-- Râteaux (vitesse + rayon + chance), sacs (capacité), slots de base.
-- Les niveaux repartent à 1 au rebirth (sauf les slots).

export type Level = { Name: string, Price: number, Value: number, Value2: number?, Color: Color3 }

local Shovels: { Level } = {
	-- Value = tas de neige creusés par coup, Value2 = rayon (studs). Cooldown = ShovelCooldown / (1 + Speed charms)
	-- Modèles : ReplicatedStorage.Assets.Shovels.Shovel<N> (pelles du Rake Vault, constellation "Outils", recolorées)
	{ Name = "Wooden Shovel",   Price = 0,          Value = 1, Value2 = 7,  Color = Color3.fromRGB(201, 139, 79) },
	{ Name = "Stone Shovel",    Price = 150,        Value = 1, Value2 = 8,  Color = Color3.fromRGB(150, 150, 160) },
	{ Name = "Iron Shovel",     Price = 600,        Value = 2, Value2 = 8,  Color = Color3.fromRGB(207, 227, 242) },
	{ Name = "Golden Shovel",   Price = 2500,       Value = 2, Value2 = 9,  Color = Color3.fromRGB(255, 197, 49) },
	{ Name = "Candy Shovel",    Price = 9000,       Value = 3, Value2 = 9,  Color = Color3.fromRGB(255, 80, 110) },
	{ Name = "Emerald Shovel",  Price = 30000,      Value = 3, Value2 = 10, Color = Color3.fromRGB(60, 220, 110) },
	{ Name = "Frost Shovel",    Price = 100000,     Value = 4, Value2 = 10, Color = Color3.fromRGB(150, 225, 255) },
	{ Name = "Ruby Shovel",     Price = 350000,     Value = 4, Value2 = 11, Color = Color3.fromRGB(235, 50, 80) },
	{ Name = "Crystal Shovel",  Price = 1200000,    Value = 5, Value2 = 11, Color = Color3.fromRGB(180, 150, 255) },
	{ Name = "Glacier Shovel",  Price = 4000000,    Value = 5, Value2 = 12, Color = Color3.fromRGB(230, 245, 255) },
	{ Name = "Aurora Shovel",   Price = 15000000,   Value = 6, Value2 = 12, Color = Color3.fromRGB(120, 255, 200) },
	{ Name = "Santa Shovel",    Price = 60000000,   Value = 7, Value2 = 13, Color = Color3.fromRGB(255, 60, 60) },
}

local Sleds: { Level } = {
	-- Value = capacité (tas de neige)
	{ Name = "Wooden Sled",  Price = 0,      Value = 20,  Color = Color3.fromRGB(190, 140, 90) },
	{ Name = "Red Sled",     Price = 150,    Value = 40,  Color = Color3.fromRGB(220, 60, 60) },
	{ Name = "Blue Sled",    Price = 1500,   Value = 80,  Color = Color3.fromRGB(60, 140, 230) },
	{ Name = "Golden Sled",  Price = 12000,  Value = 160, Color = Color3.fromRGB(255, 200, 50) },
	{ Name = "Santa Sleigh", Price = 90000,  Value = 320, Color = Color3.fromRGB(255, 70, 70) },
}

local SlotPrices: { number } = { 0, 0, 0, 0, 500, 2000, 6000, 15000, 40000, 100000, 250000, 600000, 1500000, 4000000, 10000000, 25000000, 60000000, 150000000, 400000000, 1000000000 }

-- clôtures de l'enclos (cosmétique, achat au shop). Post = poteaux, Rail = rails, Accent = arche de l'entrée
local FenceStyles = {
	{ Id = "Wood",    Name = "Wood Fence",    Price = 0,         Rail = Color3.fromRGB(160, 95, 53),   Accent = Color3.fromRGB(255, 200, 40) },
	{ Id = "White",   Name = "Snowy Fence",   Price = 1500,      Rail = Color3.fromRGB(248, 248, 248), Accent = Color3.fromRGB(80, 200, 255) },
	{ Id = "Red",     Name = "Candy Fence",   Price = 8000,      Rail = Color3.fromRGB(235, 60, 70),   Accent = Color3.fromRGB(255, 255, 255), Cap = Color3.fromRGB(255, 255, 255) },
	{ Id = "Blue",    Name = "Frost Fence",   Price = 30000,     Rail = Color3.fromRGB(90, 190, 255),  Accent = Color3.fromRGB(255, 255, 255) },
	{ Id = "Green",   Name = "Pine Fence",    Price = 120000,    Rail = Color3.fromRGB(40, 150, 90),   Accent = Color3.fromRGB(255, 220, 80), Cap = Color3.fromRGB(240, 248, 255) },
	{ Id = "Gold",    Name = "Golden Fence",  Price = 750000,    Rail = Color3.fromRGB(255, 200, 30),  Accent = Color3.fromRGB(255, 230, 120), Cap = Color3.fromRGB(255, 240, 160), Post = Color3.fromRGB(120, 80, 10) },
	{ Id = "Crystal", Name = "Crystal Fence", Price = 6000000,   Rail = Color3.fromRGB(170, 140, 255), Accent = Color3.fromRGB(200, 180, 255), Cap = Color3.fromRGB(230, 220, 255), Post = Color3.fromRGB(60, 40, 110), Neon = true },
	{ Id = "Aurora",  Name = "Aurora Fence",  Price = 50000000,  Rail = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(255, 255, 255), Cap = Color3.fromRGB(255, 255, 255), Rainbow = true, Neon = true },
}
local FenceById = {}
for i, f in ipairs(FenceStyles) do (f :: any).Order = i; FenceById[f.Id] = f end

-- clôture offerte par les rebirths : la couleur de l'enclos monte avec le niveau du joueur.
-- On affiche la meilleure entre celle des rebirths et celle achetée au shop.
local RebirthFences = {
	{ 0, "Wood" }, { 1, "White" }, { 2, "Red" }, { 3, "Blue" },
	{ 5, "Green" }, { 8, "Gold" }, { 10, "Crystal" }, { 12, "Aurora" },
}
local function FenceFor(data: any?): string
	local bought = (data and data.Fence) or "Wood"
	local reb = (data and data.Rebirths) or 0
	local best = "Wood"
	for _, r in ipairs(RebirthFences) do
		if reb >= (r[1] :: number) then best = r[2] :: string end
	end
	local b, f = FenceById[bought], FenceById[best]
	if b and f and (b :: any).Order > (f :: any).Order then return bought end
	return best
end

-- taille de l'enclos selon le nombre de slots (plus de slots = plus grand)
local Pen = { Width = 44, MinLength = 40, MaxLength = 92, PerSlot = 3.2, BaseLength = 28 }
function Pen.Size(slots: number): (number, number)
	local l = math.clamp(Pen.BaseLength + slots * Pen.PerSlot, Pen.MinLength, Pen.MaxLength)
	local w = Pen.Width + math.clamp(slots - 4, 0, 16) * 0.6
	return w, l
end

-- améliorations de la base (panneau UPGRADES de l'enclos). Remises à zéro au rebirth.
-- Cost(niveau actuel, rebirths) ; Value(niveau) = effet ; Requires = autre amélioration nécessaire.
export type BaseUpgrade = { Id: string, Name: string, Desc: string, Icon: string, Max: number, Base: number, Growth: number,
	Requires: string?, Value: (number) -> number, Show: (number) -> string }
local BaseUpgrades: { BaseUpgrade } = {
	{ Id = "EggLuck", Name = "Egg Luck", Desc = "Better egg rarities", Icon = "rbxassetid://81193001619814",
		Max = 10, Base = 2000, Growth = 1.8, Value = function(l) return 1 + 0.1 * l end,
		Show = function(l) return string.format("x%.1f luck", 1 + 0.1 * l) end },
	-- (vendu dans le Shop, carte "Hatch slot", plus sur le panneau de l'enclos : un seul endroit pour les slots)
	{ Id = "EggSlots", Name = "Hatch Slots", Desc = "Eggs hatching at the same time", Icon = "rbxassetid://140583595805309",
		Max = 6, Base = 25000, Growth = 3.5, Value = function(l) return 2 + l end,
		Show = function(l) return (2 + l) .. " eggs" end },
	{ Id = "HatchSpeed", Name = "Hatch Speed", Desc = "Eggs hatch faster", Icon = "rbxassetid://125369529148044",
		Max = 8, Base = 3000, Growth = 1.9, Value = function(l) return 1 - 0.07 * l end,
		Show = function(l) return "-" .. (7 * l) .. "% time" end },
	{ Id = "AutoShovel", Name = "Auto Shovel", Desc = "Unlocks the AUTO button", Icon = "rbxassetid://103738908144358",
		Max = 1, Base = 5000, Growth = 1, Value = function(l) return l end,
		Show = function(l) return l > 0 and "Unlocked" or "Locked" end },
	{ Id = "AutoSpeed", Name = "Auto Speed", Desc = "Auto digs / sec", Icon = "rbxassetid://85473564227225",
		Max = 5, Base = 8000, Growth = 2.2, Requires = "AutoShovel", Value = function(l) return 0.8 + 0.2 * l end,
		Show = function(l) return string.format("%.1f clicks/s", 0.8 + 0.2 * l) end },
	{ Id = "WalkSpeed", Name = "Walk Speed", Desc = "Run faster", Icon = "rbxassetid://85473564227225",
		Max = 8, Base = 1500, Growth = 1.7, Value = function(l) return 16 + 2 * l end,
		Show = function(l) return (16 + 2 * l) .. " speed" end },
}
local BaseUpgradeById: { [string]: BaseUpgrade } = {}
for i, u in ipairs(BaseUpgrades) do (u :: any).Order = i; BaseUpgradeById[u.Id] = u end
local function UpgradeCost(u: BaseUpgrade, level: number, rebirths: number): number
	return math.floor(u.Base * (u.Growth ^ level) * (2 ^ rebirths))
end

return {
	FenceStyles = FenceStyles,
	BaseUpgrades = BaseUpgrades,
	BaseUpgradeById = BaseUpgradeById,
	UpgradeCost = UpgradeCost,
	FenceById = FenceById,
	RebirthFences = RebirthFences,
	FenceFor = FenceFor,
	Pen = Pen,
	Shovels = Shovels,
	Sleds = Sleds,
	SlotPrices = SlotPrices,
	MaxSlots = 20,
	FreeSlots = 4,
	ShovelCooldown = 0.55,      -- secondes entre deux coups de pelle
	PondCooldownMult = 2,     -- 2x plus lent sur la plaque de glace
	PondLuckMult = 2,         -- 2x plus de chance d'oeuf sur la plaque de glace
	SellPadRadius = 9,
}
