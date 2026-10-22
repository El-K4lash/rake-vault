--!strict
-- Shared/Config/Items
-- Tout ce qu'on peut ramasser au sol. Value = prix de vente de base (multiplié par la zone).
-- Kind : "Junk" (se vend), "Rune" (bonus permanent, gardé), "Boost" (consommable), "Rare" (se vend cher)
-- Visual : forme/couleur du bloc posé au sol (construit en Parts à studs par ItemVisuals)

export type Item = {
	Id: string, Name: string, Kind: string, Value: number,
	Color: Color3, Shape: string, Size: number, Neon: boolean?,
	Rune: { Stat: string, Amount: number }?,   -- bonus permanent
	Boost: { Stat: string, Mult: number, Duration: number }?, -- boost temporaire
}

local function it(id: string, name: string, kind: string, value: number, r: number, g: number, b: number, shape: string, size: number, extra: any?): Item
	local t: any = { Id = id, Name = name, Kind = kind, Value = value, Color = Color3.fromRGB(r, g, b), Shape = shape, Size = size }
	if extra then for k, v in pairs(extra) do t[k] = v end end
	return t
end

local List: { Item } = {
	-- Déchets (Beach)
	it("Can", "Crushed Can", "Junk", 4, 210, 50, 60, "Cylinder", 1.4),
	it("Bottle", "Plastic Bottle", "Junk", 5, 120, 200, 240, "Cylinder", 1.6),
	it("Shell", "Seashell", "Junk", 8, 245, 225, 190, "Ball", 1.3),
	it("Boot", "Old Boot", "Junk", 6, 120, 80, 45, "Block", 1.5),
	it("Coin", "Lost Coin", "Junk", 12, 255, 210, 50, "Cylinder", 1.2, { Neon = true }),
	it("Pearl", "Pearl", "Rare", 30, 250, 245, 255, "Ball", 1.1, { Neon = true }),
	-- Swamp
	it("Mushroom", "Glow Mushroom", "Junk", 7, 160, 90, 220, "Ball", 1.4, { Neon = true }),
	it("Frog", "Rubber Frog", "Junk", 9, 90, 220, 90, "Block", 1.3),
	it("Lilypad", "Lilypad", "Junk", 11, 60, 170, 70, "Cylinder", 1.8),
	-- Volcano
	it("Obsidian", "Obsidian", "Junk", 10, 30, 25, 40, "Block", 1.5),
	it("Ember", "Ember", "Junk", 13, 255, 120, 30, "Ball", 1.1, { Neon = true }),
	it("FireOpal", "Fire Opal", "Rare", 40, 255, 80, 60, "Ball", 1.2, { Neon = true }),
	-- Ice
	it("IceCube", "Ice Cube", "Junk", 9, 190, 235, 255, "Block", 1.5),
	it("Snowball", "Snowball", "Junk", 7, 250, 250, 255, "Ball", 1.4),
	it("Crystal", "Crystal", "Junk", 16, 120, 220, 255, "Block", 1.3, { Neon = true }),
	it("FrozenGem", "Frozen Gem", "Rare", 45, 160, 240, 255, "Ball", 1.2, { Neon = true }),
	-- Void
	it("Stardust", "Stardust", "Junk", 12, 240, 200, 255, "Ball", 1.0, { Neon = true }),
	it("Asteroid", "Asteroid", "Junk", 14, 110, 90, 130, "Block", 1.7),
	it("Nebula", "Nebula Shard", "Rare", 60, 200, 90, 255, "Block", 1.3, { Neon = true }),
	it("BlackHole", "Mini Black Hole", "Rare", 120, 20, 10, 40, "Ball", 1.4, { Neon = true }),
	-- Spécial
	it("Chest", "Treasure Chest", "Rare", 80, 220, 160, 40, "Block", 1.8),
	-- Runes : bonus permanents (gardés au rebirth)
	it("RuneGreen", "Green Rune", "Rune", 0, 90, 255, 120, "Block", 1.3, { Neon = true, Rune = { Stat = "Luck", Amount = 0.02 } }),
	it("RuneRed", "Red Rune", "Rune", 0, 255, 70, 70, "Block", 1.3, { Neon = true, Rune = { Stat = "Speed", Amount = 0.02 } }),
	it("RuneBlue", "Blue Rune", "Rune", 0, 80, 180, 255, "Block", 1.3, { Neon = true, Rune = { Stat = "Bag", Amount = 1 } }),
	it("RunePurple", "Purple Rune", "Rune", 0, 190, 90, 255, "Block", 1.3, { Neon = true, Rune = { Stat = "Income", Amount = 0.02 } }),
}

local ById: { [string]: Item } = {}
for _, i in ipairs(List) do ById[i.Id] = i end

-- plafonds des runes (pour ne pas devenir infini)
local RuneCaps = { Luck = 0.5, Speed = 0.5, Bag = 40, Income = 0.5 }

return { List = List, ById = ById, RuneCaps = RuneCaps }
