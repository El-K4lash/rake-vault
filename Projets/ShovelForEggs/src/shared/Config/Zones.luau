--!strict
-- Shared/Config/Zones
-- Les 6 zones de la montagne (de bas en haut). Tout l'équilibrage des zones est ici.
-- Chaque zone est un carré de Size x Size studs centré sur Center (Y = niveau du sol de la terrasse : la montagne monte zone après zone),
-- avec une plaque de glace ronde au milieu (le "pond" : on creuse 2x plus lentement, 2x plus de chance d'œuf).

export type Zone = {
	Id: string,
	Name: string,
	Order: number,
	Rebirths: number,        -- rebirths requis pour entrer
	Center: Vector3,
	Size: number,
	PondSize: number,
	ItemValueMult: number,   -- multiplie la valeur des objets de la zone
	PetChance: number,       -- (ancien nom) = EggChance
	EggChance: number,       -- chance de trouver un œuf par tas de neige creusé
	Egg: string,             -- id de l'œuf de la zone (Eggs.lua)
	Rarities: { [string]: number }, -- poids des raretés de pet dans cette zone
	Items: { string },       -- ids d'objets (Items.lua) qui apparaissent sous la neige
	PondItems: { string },   -- objets sur la plaque de glace
	MaxItems: number,        -- objets max au sol en même temps
	SpawnEvery: number,      -- secondes entre deux apparitions
	Color: Color3,
	GroundColor: Color3,
	PondColor: Color3,
	Theme: string,
}

local Zones: { Zone } = {
	{
		Id = "Village", Name = "Snowy Village", Order = 1, Rebirths = 0,
		Center = Vector3.new(0, 0, 230), Size = 84, PondSize = 23.2,
		ItemValueMult = 1, PetChance = 1 / 16, EggChance = 1 / 16, Egg = "SnowEgg",
		Rarities = { Common = 80, Rare = 20 },
		Items = { "Snow", "Snow", "Snowball", "Mitten", "FrozenCoin", "IceShard" },
		PondItems = { "IceShard", "Snowball", "FrozenCoin" },
		MaxItems = 34, SpawnEvery = 1.2,
		Color = Color3.fromRGB(255, 190, 90), GroundColor = Color3.fromRGB(244, 248, 255), PondColor = Color3.fromRGB(170, 225, 255),
		Theme = "Village",
	},
	{
		Id = "Forest", Name = "Pine Forest", Order = 2, Rebirths = 1,
		Center = Vector3.new(0, 12, 360), Size = 84, PondSize = 23.2,
		ItemValueMult = 5, PetChance = 1 / 20, EggChance = 1 / 20, Egg = "PineEgg",
		Rarities = { Common = 45, Rare = 40, Epic = 15 },
		Items = { "Snow", "Snow", "Pinecone", "Snowball", "PineCrystal", "CharmLuck" },
		PondItems = { "PineCrystal", "Pinecone", "CharmLuck" },
		MaxItems = 34, SpawnEvery = 1.3,
		Color = Color3.fromRGB(90, 200, 120), GroundColor = Color3.fromRGB(236, 244, 250), PondColor = Color3.fromRGB(150, 215, 255),
		Theme = "Forest",
	},
	{
		Id = "FrozenLake", Name = "Frozen Lake", Order = 3, Rebirths = 2,
		Center = Vector3.new(0, 26, 490), Size = 84, PondSize = 30,
		ItemValueMult = 24, PetChance = 1 / 24, EggChance = 1 / 24, Egg = "FrozenEgg",
		Rarities = { Rare = 40, Epic = 42, Legendary = 18 },
		Items = { "Snow", "Snow", "Icicle", "FrozenFish", "FrostGem", "CharmSpeed" },
		PondItems = { "FrozenPearl", "FrozenFish", "CharmSpeed" },
		MaxItems = 32, SpawnEvery = 1.5,
		Color = Color3.fromRGB(80, 200, 255), GroundColor = Color3.fromRGB(230, 242, 252), PondColor = Color3.fromRGB(120, 200, 255),
		Theme = "Lake",
	},
	{
		Id = "IceCave", Name = "Ice Cave", Order = 4, Rebirths = 3,
		Center = Vector3.new(0, 42, 620), Size = 84, PondSize = 23.2,
		ItemValueMult = 120, PetChance = 1 / 28, EggChance = 1 / 28, Egg = "CrystalEgg",
		Rarities = { Epic = 40, Legendary = 45, Mythic = 15 },
		Items = { "Snow", "Snow", "Icicle", "CrystalShard", "Geode", "CharmSled" },
		PondItems = { "CrystalShard", "Geode", "CharmSled" },
		MaxItems = 32, SpawnEvery = 1.6,
		Color = Color3.fromRGB(150, 120, 255), GroundColor = Color3.fromRGB(205, 220, 245), PondColor = Color3.fromRGB(150, 160, 255),
		Theme = "Cave",
	},
	{
		Id = "Glacier", Name = "Glacier Summit", Order = 5, Rebirths = 5,
		Center = Vector3.new(0, 60, 750), Size = 84, PondSize = 23.2,
		ItemValueMult = 600, PetChance = 1 / 32, EggChance = 1 / 32, Egg = "GlacierEgg",
		Rarities = { Legendary = 40, Mythic = 48, Secret = 12 },
		Items = { "Snow", "Snow", "Icicle", "GlacierGem", "AncientIce", "CharmIncome" },
		PondItems = { "GlacierGem", "AncientIce", "CharmIncome" },
		MaxItems = 30, SpawnEvery = 1.8,
		Color = Color3.fromRGB(255, 255, 255), GroundColor = Color3.fromRGB(240, 248, 255), PondColor = Color3.fromRGB(200, 235, 255),
		Theme = "Glacier",
	},
	{
		Id = "Aurora", Name = "Aurora Peak", Order = 6, Rebirths = 8,
		Center = Vector3.new(0, 82, 880), Size = 84, PondSize = 23.2,
		ItemValueMult = 3000, PetChance = 1 / 36, EggChance = 1 / 36, Egg = "AuroraEgg",
		Rarities = { Mythic = 55, Secret = 45 },
		Items = { "Snow", "Snow", "StarFragment", "AuroraShard", "Moonstone", "CharmLuck" },
		PondItems = { "AuroraShard", "Moonstone", "StarFragment" },
		MaxItems = 30, SpawnEvery = 2,
		Color = Color3.fromRGB(120, 255, 200), GroundColor = Color3.fromRGB(225, 235, 255), PondColor = Color3.fromRGB(140, 255, 220),
		Theme = "Aurora",
	},
	{
		-- zone 7 (fin de la montagne) : l'atelier du Père Noël. Œuf exclusif.
		Id = "NorthPole", Name = "North Pole", Order = 7, Rebirths = 12,
		Center = Vector3.new(0, 108, 1010), Size = 84, PondSize = 23.2,
		ItemValueMult = 15000, PetChance = 1 / 40, EggChance = 1 / 40, Egg = "NorthPoleEgg",
		Rarities = { Mythic = 45, Secret = 55 },
		Items = { "Snow", "Snow", "Present", "Ornament", "StarTopper", "CharmIncome" },
		PondItems = { "Ornament", "StarTopper", "Present" },
		MaxItems = 30, SpawnEvery = 2,
		Color = Color3.fromRGB(255, 80, 80), GroundColor = Color3.fromRGB(246, 250, 255), PondColor = Color3.fromRGB(190, 230, 255),
		Theme = "NorthPole",
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

-- la plaque de glace est ronde (diamètre PondSize) au centre de la zone
function M.InPond(z: Zone, pos: Vector3): boolean
	local h = z.PondSize / 2
	local dx, dz = pos.X - z.Center.X, pos.Z - z.Center.Z
	return dx * dx + dz * dz <= h * h
end

return M
