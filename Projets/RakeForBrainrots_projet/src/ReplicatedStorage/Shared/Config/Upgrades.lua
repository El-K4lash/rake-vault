--!strict
-- Shared/Config/Upgrades
-- Râteaux (vitesse + rayon + chance), sacs (capacité), slots de base.
-- Les niveaux repartent à 1 au rebirth (sauf les slots).

export type Level = { Name: string, Price: number, Value: number, Value2: number?, Color: Color3 }

local Rakes: { Level } = {
	-- Value = objets ramassés par coup, Value2 = rayon (studs). Cooldown = Rake.Cooldown / (1 + Speed runes)
	-- Modèles : ReplicatedStorage.Assets.Rakes.Rake<N> (râteaux du Rake Vault, constellation "Outils")
	{ Name = "Wooden Rake",  Price = 0,          Value = 1, Value2 = 7,  Color = Color3.fromRGB(201, 139, 79) },
	{ Name = "Stone Rake",   Price = 150,        Value = 1, Value2 = 8,  Color = Color3.fromRGB(150, 150, 160) },
	{ Name = "Iron Rake",    Price = 600,        Value = 2, Value2 = 8,  Color = Color3.fromRGB(207, 227, 242) },
	{ Name = "Golden Rake",  Price = 2500,       Value = 2, Value2 = 9,  Color = Color3.fromRGB(255, 197, 49) },
	{ Name = "Emerald Rake", Price = 9000,       Value = 3, Value2 = 9,  Color = Color3.fromRGB(60, 220, 110) },
	{ Name = "Ruby Rake",    Price = 30000,      Value = 3, Value2 = 10, Color = Color3.fromRGB(235, 50, 80) },
	{ Name = "Diamond Rake", Price = 100000,     Value = 4, Value2 = 10, Color = Color3.fromRGB(189, 246, 255) },
	{ Name = "Lava Rake",    Price = 350000,     Value = 4, Value2 = 11, Color = Color3.fromRGB(255, 110, 30) },
	{ Name = "Ice Rake",     Price = 1200000,    Value = 5, Value2 = 11, Color = Color3.fromRGB(140, 220, 255) },
	{ Name = "Void Rake",    Price = 4000000,    Value = 5, Value2 = 12, Color = Color3.fromRGB(150, 70, 255) },
	{ Name = "Galaxy Rake",  Price = 15000000,   Value = 6, Value2 = 12, Color = Color3.fromRGB(90, 60, 200) },
	{ Name = "Rainbow Rake", Price = 60000000,   Value = 7, Value2 = 13, Color = Color3.fromRGB(255, 120, 200) },
}

local Bags: { Level } = {
	-- Value = capacité
	{ Name = "Small Bag",   Price = 0,      Value = 20,  Color = Color3.fromRGB(190, 140, 90) },
	{ Name = "Medium Bag",  Price = 150,    Value = 40,  Color = Color3.fromRGB(160, 110, 70) },
	{ Name = "Big Bag",     Price = 1500,   Value = 80,  Color = Color3.fromRGB(90, 150, 90) },
	{ Name = "Huge Bag",    Price = 12000,  Value = 160, Color = Color3.fromRGB(80, 120, 220) },
	{ Name = "Cosmic Bag",  Price = 90000,  Value = 320, Color = Color3.fromRGB(178, 107, 255) },
}

-- prix du slot N de la base (4 slots offerts, jusqu'à 20). Les rebirths en offrent aussi.
local SlotPrices: { number } = { 0, 0, 0, 0, 500, 2000, 6000, 15000, 40000, 100000, 250000, 600000, 1500000, 4000000, 10000000, 25000000, 60000000, 150000000, 400000000, 1000000000 }

-- clôtures de l'enclos (cosmétique, achat au shop). Post = poteaux, Rail = rails, Accent = arche de l'entrée
local FenceStyles = {
	{ Id = "Wood",    Name = "Wood Fence",    Price = 0,         Rail = Color3.fromRGB(160, 95, 53),   Accent = Color3.fromRGB(255, 200, 40) },
	{ Id = "White",   Name = "White Fence",   Price = 1500,      Rail = Color3.fromRGB(248, 248, 248), Accent = Color3.fromRGB(80, 200, 255) },
	{ Id = "Red",     Name = "Cherry Fence",  Price = 8000,      Rail = Color3.fromRGB(235, 60, 70),   Accent = Color3.fromRGB(255, 255, 255) },
	{ Id = "Blue",    Name = "Ocean Fence",   Price = 30000,     Rail = Color3.fromRGB(40, 150, 255),  Accent = Color3.fromRGB(255, 255, 255) },
	{ Id = "Pink",    Name = "Candy Fence",   Price = 120000,    Rail = Color3.fromRGB(255, 120, 200), Accent = Color3.fromRGB(255, 240, 120), Cap = Color3.fromRGB(255, 240, 120) },
	{ Id = "Gold",    Name = "Golden Fence",  Price = 750000,    Rail = Color3.fromRGB(255, 200, 30),  Accent = Color3.fromRGB(255, 230, 120), Cap = Color3.fromRGB(255, 240, 160), Post = Color3.fromRGB(120, 80, 10) },
	{ Id = "Void",    Name = "Void Fence",    Price = 6000000,   Rail = Color3.fromRGB(170, 80, 255),  Accent = Color3.fromRGB(170, 80, 255), Cap = Color3.fromRGB(220, 160, 255), Post = Color3.fromRGB(20, 10, 35), Neon = true },
	{ Id = "Rainbow", Name = "Rainbow Fence", Price = 50000000,  Rail = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(255, 255, 255), Cap = Color3.fromRGB(255, 255, 255), Rainbow = true, Neon = true },
}
local FenceById = {}
for i, f in ipairs(FenceStyles) do (f :: any).Order = i; FenceById[f.Id] = f end

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
	{ Id = "EggSlots", Name = "Egg Slots", Desc = "Eggs hatching at once", Icon = "rbxassetid://140583595805309",
		Max = 6, Base = 25000, Growth = 3.5, Value = function(l) return 2 + l end,
		Show = function(l) return (2 + l) .. " eggs" end },
	{ Id = "HatchSpeed", Name = "Hatch Speed", Desc = "Eggs hatch faster", Icon = "rbxassetid://125369529148044",
		Max = 8, Base = 3000, Growth = 1.9, Value = function(l) return 1 - 0.07 * l end,
		Show = function(l) return "-" .. (7 * l) .. "% time" end },
	{ Id = "AutoRake", Name = "Auto Rake", Desc = "Unlocks the AUTO button", Icon = "rbxassetid://118147684330981",
		Max = 1, Base = 5000, Growth = 1, Value = function(l) return l end,
		Show = function(l) return l > 0 and "Unlocked" or "Locked" end },
	{ Id = "AutoSpeed", Name = "Auto Speed", Desc = "Auto rake clicks / sec", Icon = "rbxassetid://85473564227225",
		Max = 5, Base = 8000, Growth = 2.2, Requires = "AutoRake", Value = function(l) return 0.8 + 0.2 * l end,
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
	Pen = Pen,
	Rakes = Rakes,
	Bags = Bags,
	SlotPrices = SlotPrices,
	MaxSlots = 20,
	FreeSlots = 4,
	RakeCooldown = 0.55,      -- secondes entre deux coups de râteau
	PondCooldownMult = 2,     -- 2x plus lent dans le pond
	PondLuckMult = 2,         -- 2x plus de chance de brainrot dans le pond
	SellPadRadius = 9,
}
