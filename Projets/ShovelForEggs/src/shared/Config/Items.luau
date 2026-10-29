--!strict
-- Shared/Config/Items
-- Tout ce qu'on déterre avec la pelle. Value = prix de vente de base (multiplié par la zone).
-- Kind : "Snow" (remplit la luge, se vend un peu), "Junk" (objet perdu sous la neige, se vend),
--        "Rare" (cristal de glace, se vend cher), "Charm" (porte-bonheur = bonus permanent, gardé au rebirth).
-- Visual : forme/couleur du bloc posé au sol (modèle dans ReplicatedStorage/Assets/ItemModels/<Id>, sinon bloc à studs).

export type Item = {
	Id: string, Name: string, Kind: string, Value: number,
	Color: Color3, Shape: string, Size: number, Neon: boolean?,
	Rune: { Stat: string, Amount: number }?,   -- bonus permanent (porte-bonheur)
	Boost: { Stat: string, Mult: number, Duration: number }?, -- boost temporaire
}

local function it(id: string, name: string, kind: string, value: number, r: number, g: number, b: number, shape: string, size: number, extra: any?): Item
	local t: any = { Id = id, Name = name, Kind = kind, Value = value, Color = Color3.fromRGB(r, g, b), Shape = shape, Size = size }
	if extra then for k, v in pairs(extra) do t[k] = v end end
	return t
end

local List: { Item } = {
	-- Neige (partout) : c'est ce qui remplit la luge
	it("Snow", "Snow Pile", "Snow", 3, 250, 252, 255, "Pile", 1.8),
	it("Snowball", "Snowball", "Snow", 5, 240, 246, 255, "Ball", 1.3),
	it("Icicle", "Icicle", "Snow", 7, 190, 232, 255, "Block", 1.5),
	-- Objets perdus sous la neige
	it("Mitten", "Lost Mitten", "Junk", 6, 230, 70, 70, "Block", 1.3),
	it("Pinecone", "Pinecone", "Junk", 6, 120, 85, 50, "Ball", 1.1),
	it("FrozenCoin", "Frozen Coin", "Junk", 12, 255, 210, 50, "Cylinder", 1.2, { Neon = true }),
	it("FrozenFish", "Frozen Fish", "Junk", 14, 120, 200, 230, "Block", 1.5),
	-- Cristaux de glace (rares)
	it("IceShard", "Ice Shard", "Rare", 30, 160, 230, 255, "Block", 1.2, { Neon = true }),
	it("PineCrystal", "Pine Crystal", "Rare", 40, 90, 230, 150, "Block", 1.2, { Neon = true }),
	it("FrozenPearl", "Frozen Pearl", "Rare", 50, 235, 245, 255, "Ball", 1.1, { Neon = true }),
	it("FrostGem", "Frost Gem", "Rare", 55, 120, 220, 255, "Ball", 1.2, { Neon = true }),
	it("CrystalShard", "Crystal Shard", "Rare", 70, 170, 140, 255, "Block", 1.3, { Neon = true }),
	it("Geode", "Geode", "Rare", 110, 110, 90, 200, "Ball", 1.5, { Neon = true }),
	it("GlacierGem", "Glacier Gem", "Rare", 90, 200, 240, 255, "Ball", 1.3, { Neon = true }),
	it("AncientIce", "Ancient Ice", "Rare", 150, 150, 210, 255, "Block", 1.7, { Neon = true }),
	it("StarFragment", "Star Fragment", "Rare", 120, 255, 240, 150, "Ball", 1.1, { Neon = true }),
	it("AuroraShard", "Aurora Shard", "Rare", 180, 120, 255, 200, "Block", 1.3, { Neon = true }),
	it("Moonstone", "Moonstone", "Rare", 260, 220, 220, 255, "Ball", 1.4, { Neon = true }),
	-- North Pole (zone 7)
	it("Ornament", "Christmas Ornament", "Rare", 320, 230, 50, 60, "Ball", 1.3, { Neon = true }),
	it("Present", "Lost Present", "Rare", 400, 60, 170, 90, "Block", 1.5, { Neon = true }),
	it("StarTopper", "Star Topper", "Rare", 520, 255, 215, 70, "Block", 1.4, { Neon = true }),
	-- Coffre gelé : très rare, partout (WorldService), donne argent + œuf + XP (HarvestService)
	it("FrozenChest", "Frozen Chest", "Chest", 0, 150, 210, 255, "Block", 2.2, { Neon = true }),
	-- Porte-bonheurs : bonus permanents (gardés au rebirth)
	it("CharmLuck", "Lucky Snowflake", "Charm", 0, 140, 230, 255, "Block", 1.3, { Neon = true, Rune = { Stat = "Luck", Amount = 0.02 } }),
	it("CharmSpeed", "Hot Cocoa", "Charm", 0, 160, 95, 50, "Cylinder", 1.3, { Neon = true, Rune = { Stat = "Speed", Amount = 0.02 } }),
	it("CharmSled", "Big Mitten", "Charm", 0, 80, 180, 255, "Block", 1.3, { Neon = true, Rune = { Stat = "Sled", Amount = 1 } }),
	it("CharmIncome", "Candy Cane", "Charm", 0, 255, 70, 90, "Block", 1.3, { Neon = true, Rune = { Stat = "Income", Amount = 0.02 } }),
}

local ById: { [string]: Item } = {}
for _, i in ipairs(List) do ById[i.Id] = i end

-- plafonds des porte-bonheurs (pour ne pas devenir infini)
local RuneCaps = { Luck = 0.5, Speed = 0.5, Sled = 40, Income = 0.5 }

return { List = List, ById = ById, RuneCaps = RuneCaps }
