--!strict
-- Shared/Config/Eggs
-- Les œufs trouvés sous la neige. Un œuf par zone + l'œuf doré (tempête dorée). On le pose dans son chalet :
-- il éclot après HatchTime secondes en un pet tiré selon Rarities (poids). Modèle 3D : ReplicatedStorage/Assets/Eggs/<Model>.

export type Egg = {
	Id: string,
	Name: string,
	Zone: string,
	Model: string,
	HatchTime: number,
	Rarities: { [string]: number },
	Color: Color3,
	Order: number,
}

-- équilibrage du 23/10 : chaque rareté = les pets d'UNE zone (Common = Village, Rare = Forêt, Epic = Lac gelé,
-- Legendary = Grotte, Mythic = Glacier, Secret = Aurore). Chaque œuf donne surtout les pets de SA zone, un peu de la
-- zone du dessus, et plus jamais ceux des zones d'en dessous : un œuf de zone N bat toujours un œuf de zone N-1
-- (sauf grosse mutation, c'est le jackpot).
local List: { Egg } = {
	{ Id = "SnowEgg", Name = "Snow Egg", Zone = "Village", Model = "Snow", HatchTime = 15, Order = 1,
		Rarities = { Common = 82, Rare = 16, Epic = 2 }, Color = Color3.fromRGB(240, 248, 255) },
	{ Id = "PineEgg", Name = "Pine Egg", Zone = "Forest", Model = "Pine", HatchTime = 30, Order = 2,
		Rarities = { Rare = 74, Epic = 22, Legendary = 4 }, Color = Color3.fromRGB(90, 200, 120) },
	{ Id = "FrozenEgg", Name = "Frozen Egg", Zone = "FrozenLake", Model = "Frozen", HatchTime = 60, Order = 3,
		Rarities = { Epic = 74, Legendary = 22, Mythic = 4 }, Color = Color3.fromRGB(100, 200, 255) },
	{ Id = "CrystalEgg", Name = "Crystal Egg", Zone = "IceCave", Model = "Crystal", HatchTime = 120, Order = 4,
		Rarities = { Legendary = 74, Mythic = 22, Secret = 4 }, Color = Color3.fromRGB(160, 130, 255) },
	{ Id = "GlacierEgg", Name = "Glacier Egg", Zone = "Glacier", Model = "Glacier", HatchTime = 240, Order = 5,
		Rarities = { Mythic = 86, Secret = 14 }, Color = Color3.fromRGB(220, 240, 255) },
	{ Id = "AuroraEgg", Name = "Aurora Egg", Zone = "Aurora", Model = "Aurora", HatchTime = 420, Order = 6,
		Rarities = { Mythic = 60, Secret = 40 }, Color = Color3.fromRGB(120, 255, 210) },
	-- œuf du Pôle Nord (zone 7)
	{ Id = "NorthPoleEgg", Name = "North Pole Egg", Zone = "NorthPole", Model = "NorthPole", HatchTime = 600, Order = 7,
		Rarities = { Mythic = 30, Secret = 70 }, Color = Color3.fromRGB(255, 80, 80) },
	-- œuf de la tempête dorée : rareté selon la meilleure zone du joueur, mais tiré vers le haut (voir StormService)
	{ Id = "GoldenEgg", Name = "Golden Egg", Zone = "Storm", Model = "Golden", HatchTime = 90, Order = 8,
		Rarities = { Epic = 30, Legendary = 40, Mythic = 24, Secret = 6 }, Color = Color3.fromRGB(255, 210, 60) },
}

local ById: { [string]: Egg } = {}
for _, e in ipairs(List) do ById[e.Id] = e end

local M = { List = List, ById = ById }

-- tire une rareté selon les poids de l'œuf (la chance pousse un peu vers les raretés hautes)
local ORDER = { Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythic = 5, Secret = 6 }
function M.RollRarity(rng: Random, egg: Egg, luck: number): string
	local weights = {}
	local total = 0
	for r, w in pairs(egg.Rarities) do
		local ww = w * (1 + (luck - 1) * (ORDER[r] or 1) * 0.35)
		weights[r] = ww
		total += ww
	end
	local x = rng:NextNumber() * total
	local last = "Common"
	for r, w in pairs(weights) do
		x -= w
		last = r
		if x <= 0 then return r end
	end
	return last
end

return M
