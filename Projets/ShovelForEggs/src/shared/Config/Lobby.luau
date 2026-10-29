--!strict
-- Shared/Config/Lobby
-- Réglages des machines du lobby : roue de la fortune, incubateur (super éclosion), machine de fusion.

-- [ ROUE ] -------------------------------------------------------------------------
-- 8 parts sur la roue (tools/build_wheel.lua). Angle = centre de la part, en degrés, dans le repère de la roue
-- (0° = droite, 90° = en haut, sens anti-horaire vu de face). Le pointeur est en haut (90°).
-- Le serveur tire le gain (poids), puis une part de ce gain ; le client fait tourner la roue jusqu'à elle.
local Rewards = {
	Coins   = { Name = "Money",        Color = Color3.fromRGB(255, 138, 26),  Weight = 30 }, -- orange
	Money   = { Name = "Big Money",    Color = Color3.fromRGB(255, 200, 40),  Weight = 22 }, -- jaune
	Egg     = { Name = "Free Egg",     Color = Color3.fromRGB(59, 160, 255),  Weight = 18 }, -- bleu
	Luck    = { Name = "Luck x2",      Color = Color3.fromRGB(170, 95, 255),  Weight = 12 }, -- violet
	Boost   = { Name = "Money x2",     Color = Color3.fromRGB(60, 210, 110),  Weight = 12 }, -- vert
	Jackpot = { Name = "JACKPOT",      Color = Color3.fromRGB(240, 60, 90),   Weight = 6 },  -- rouge
}
local Segments = {
	{ Angle = 90, Reward = "Jackpot" }, { Angle = 45, Reward = "Coins" }, { Angle = 0, Reward = "Egg" },
	{ Angle = -45, Reward = "Money" },  { Angle = -90, Reward = "Luck" }, { Angle = -135, Reward = "Coins" },
	{ Angle = -180, Reward = "Boost" }, { Angle = -225, Reward = "Money" },
}

local Wheel = {
	Cooldown = 3600,       -- 1 tour gratuit par heure
	BoostTime = 600,       -- boosts x2 de 10 min
	SpinTime = 5,          -- durée de l'animation (s)
	Rewards = Rewards,
	Segments = Segments,
}
-- argent gagné : au moins X secondes de revenu de la base, avec un minimum qui suit les rebirths
function Wheel.MoneyFor(kind: string, income: number, rebirths: number): number
	local scale = 3 ^ math.min(rebirths, 30)
	if kind == "Coins" then return math.floor(math.max(300 * scale, income * 60)) end
	if kind == "Money" then return math.floor(math.max(1000 * scale, income * 180)) end
	if kind == "Jackpot" then return math.floor(math.max(5000 * scale, income * 900)) end
	return 0
end

-- [ INCUBATEUR ] : super éclosion immédiate de l'œuf en main, avec plus de chance de mutation --------------
local Incubator = {
	MutationLuck = 3,      -- x3 chances de mutation
	RarityLuck = 1.5,      -- x1.5 chance de rareté
}
-- prix selon l'œuf (Order 1..5) et les rebirths
function Incubator.Cost(eggOrder: number, rebirths: number): number
	return math.floor(500 * 8 ^ (eggOrder - 1) * (1 + rebirths))
end

-- [ FUSION ] : on met 3 pets dans la machine --------------------------------------------------------
--   3 identiques (même nom + même mutation) -> le même avec la mutation suivante (100 %)
--   3 différents -> un pet au hasard de la plus haute rareté mise (UpChance : rareté au-dessus),
--                   mutation = la plus basse des 3 (MutUpChance : une mutation au-dessus)
local Fusion = {
	Count = 3,
	UpChance = 0.35,
	MutUpChance = 0.10,
}

return {
	Wheel = Wheel,
	Incubator = Incubator,
	Fusion = Fusion,
}
