--!strict
-- Shared/Config/Zones
-- Les 5 zones du jeu. Tout l'équilibrage des zones est ici.
-- Chaque zone est un carré de Size x Size studs centré sur Center, avec un pond au milieu.

export type Zone = {
	Id: string,
	Name: string,
	Order: number,
	Rebirths: number,        -- rebirths requis pour entrer
	Center: Vector3,
	Size: number,
	PondSize: number,
	ItemValueMult: number,   -- multiplie la valeur des objets de la zone
	BrainrotChance: number,  -- (ancien nom) = EggChance
	EggChance: number,       -- chance de trouver un œuf par objet ramassé
	Egg: string,             -- id de l'œuf de la zone (Eggs.lua)
	Rarities: { [string]: number }, -- poids des raretés de brainrot dans cette zone
	Items: { string },       -- ids d'objets (Items.lua) qui apparaissent au sol
	PondItems: { string },   -- objets dans le pond
	MaxItems: number,        -- objets max au sol en même temps
	SpawnEvery: number,      -- secondes entre deux apparitions
	Color: Color3,
	GroundColor: Color3,
	PondColor: Color3,
	Theme: string,
}

local Zones: { Zone } = {
	{
		Id = "Beach", Name = "Beach", Order = 1, Rebirths = 0,
		Center = Vector3.new(0, 0, 230), Size = 84, PondSize = 23.2,
		ItemValueMult = 1, BrainrotChance = 1 / 18, EggChance = 1 / 18, Egg = "BeachEgg",
		Rarities = { Common = 80, Rare = 20 },
		Items = { "Can", "Bottle", "Shell", "Boot", "Coin" },
		PondItems = { "Shell", "Pearl", "Coin" },
		MaxItems = 34, SpawnEvery = 1.2,
		Color = Color3.fromRGB(255, 204, 51), GroundColor = Color3.fromRGB(236, 212, 140), PondColor = Color3.fromRGB(70, 200, 230),
		Theme = "Coastal",
	},
	{
		Id = "Swamp", Name = "Swamp", Order = 2, Rebirths = 1,
		Center = Vector3.new(0, 0, 360), Size = 84, PondSize = 23.2,
		ItemValueMult = 5, BrainrotChance = 1 / 22, EggChance = 1 / 22, Egg = "SwampEgg",
		Rarities = { Common = 45, Rare = 40, Epic = 15 },
		Items = { "Can", "Boot", "Mushroom", "Frog", "RuneGreen" },
		PondItems = { "Frog", "Lilypad", "RuneGreen" },
		MaxItems = 34, SpawnEvery = 1.3,
		Color = Color3.fromRGB(108, 240, 138), GroundColor = Color3.fromRGB(92, 120, 62), PondColor = Color3.fromRGB(70, 130, 70),
		Theme = "Swamp",
	},
	{
		Id = "Volcano", Name = "Volcano", Order = 3, Rebirths = 2,
		Center = Vector3.new(0, 0, 490), Size = 84, PondSize = 23.2,
		ItemValueMult = 24, BrainrotChance = 1 / 26, EggChance = 1 / 26, Egg = "VolcanoEgg",
		Rarities = { Rare = 40, Epic = 42, Legendary = 18 },
		Items = { "Obsidian", "Ember", "Boot", "Chest", "RuneRed" },
		PondItems = { "Ember", "FireOpal", "RuneRed" },
		MaxItems = 32, SpawnEvery = 1.5,
		Color = Color3.fromRGB(255, 106, 61), GroundColor = Color3.fromRGB(58, 50, 54), PondColor = Color3.fromRGB(255, 120, 20),
		Theme = "Volcano",
	},
	{
		Id = "Ice", Name = "Ice", Order = 4, Rebirths = 3,
		Center = Vector3.new(0, 0, 620), Size = 84, PondSize = 23.2,
		ItemValueMult = 120, BrainrotChance = 1 / 30, EggChance = 1 / 30, Egg = "IceEgg",
		Rarities = { Epic = 40, Legendary = 45, Mythic = 15 },
		Items = { "IceCube", "Snowball", "Crystal", "Chest", "RuneBlue" },
		PondItems = { "Crystal", "FrozenGem", "RuneBlue" },
		MaxItems = 32, SpawnEvery = 1.6,
		Color = Color3.fromRGB(79, 216, 255), GroundColor = Color3.fromRGB(226, 240, 250), PondColor = Color3.fromRGB(120, 210, 255),
		Theme = "Snow",
	},
	{
		Id = "Void", Name = "Void", Order = 5, Rebirths = 4,
		Center = Vector3.new(0, 0, 750), Size = 84, PondSize = 23.2,
		ItemValueMult = 600, BrainrotChance = 1 / 34, EggChance = 1 / 34, Egg = "VoidEgg",
		Rarities = { Legendary = 40, Mythic = 48, Secret = 12 },
		Items = { "Stardust", "Asteroid", "Crystal", "Chest", "RunePurple" },
		PondItems = { "Nebula", "BlackHole", "RunePurple" },
		MaxItems = 30, SpawnEvery = 1.8,
		Color = Color3.fromRGB(178, 107, 255), GroundColor = Color3.fromRGB(52, 30, 90), PondColor = Color3.fromRGB(150, 60, 255),
		Theme = "Void",
	},
}

local byId: { [string]: Zone } = {}
for _, z in ipairs(Zones) do byId[z.Id] = z end

local M = {}
M.List = Zones
M.ById = byId

-- la zone qui contient une position (nil si hors zone)
function M.At(pos: Vector3): Zone?
	for _, z in ipairs(Zones) do
		local h = z.Size / 2
		if math.abs(pos.X - z.Center.X) <= h and math.abs(pos.Z - z.Center.Z) <= h then
			return z
		end
	end
	return nil
end

-- le pond est rond (diamètre PondSize) au centre de la zone
function M.InPond(z: Zone, pos: Vector3): boolean
	local h = z.PondSize / 2
	local dx, dz = pos.X - z.Center.X, pos.Z - z.Center.Z
	return dx * dx + dz * dz <= h * h
end

return M
