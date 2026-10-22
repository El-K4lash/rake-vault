--!strict
-- Shared/Config/Eggs
-- Les œufs trouvés en ratissant. Un œuf par zone. On le pose dans son enclos : il éclot après HatchTime
-- secondes en un brainrot tiré selon Rarities (poids). Modèle 3D : ReplicatedStorage/Assets/Eggs/<Model>.

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

local List: { Egg } = {
	{ Id = "BeachEgg", Name = "Beach Egg", Zone = "Beach", Model = "Beach", HatchTime = 15, Order = 1,
		Rarities = { Common = 78, Rare = 20, Epic = 2 }, Color = Color3.fromRGB(255, 214, 90) },
	{ Id = "SwampEgg", Name = "Swamp Egg", Zone = "Swamp", Model = "Swamp", HatchTime = 30, Order = 2,
		Rarities = { Common = 40, Rare = 42, Epic = 16, Legendary = 2 }, Color = Color3.fromRGB(110, 230, 120) },
	{ Id = "VolcanoEgg", Name = "Volcano Egg", Zone = "Volcano", Model = "Volcano", HatchTime = 60, Order = 3,
		Rarities = { Rare = 38, Epic = 42, Legendary = 18, Mythic = 2 }, Color = Color3.fromRGB(255, 110, 50) },
	{ Id = "IceEgg", Name = "Ice Egg", Zone = "Ice", Model = "Ice", HatchTime = 120, Order = 4,
		Rarities = { Epic = 38, Legendary = 44, Mythic = 16, Secret = 2 }, Color = Color3.fromRGB(120, 220, 255) },
	{ Id = "VoidEgg", Name = "Void Egg", Zone = "Void", Model = "Void", HatchTime = 240, Order = 5,
		Rarities = { Legendary = 40, Mythic = 46, Secret = 14 }, Color = Color3.fromRGB(180, 110, 255) },
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
