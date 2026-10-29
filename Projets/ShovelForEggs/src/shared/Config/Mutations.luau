--!strict
-- Shared/Config/Mutations
-- Les mutations = les variantes du pack Brainrots_Animated (les mêmes que Rake for Brainrots). "Normal" = pas de mutation.
-- Folder = nom du dossier dans ReplicatedStorage/Assets/Pets.
-- Chance = probabilité à l'éclosion (une seule mutation tirée, de la plus rare à la plus commune).

export type Mutation = { Id: string, Name: string, Folder: string, Mult: number, Chance: number, Color: Color3, Order: number }

local List: { Mutation } = {
	{ Id = "Normal",  Name = "Normal",  Folder = "Normal",   Mult = 1,  Chance = 1,      Color = Color3.fromRGB(230, 230, 240), Order = 1 },
	{ Id = "Gold",    Name = "Gold",    Folder = "Oro",      Mult = 2,  Chance = 0.08,   Color = Color3.fromRGB(255, 204, 51),  Order = 2 },
	{ Id = "Diamond", Name = "Diamond", Folder = "Diamante", Mult = 3,  Chance = 0.03,   Color = Color3.fromRGB(120, 230, 255), Order = 3 },
	{ Id = "Lava",    Name = "Lava",    Folder = "Lava",     Mult = 5,  Chance = 0.012,  Color = Color3.fromRGB(255, 110, 40),  Order = 4 },
	{ Id = "Galaxy",  Name = "Galaxy",  Folder = "Galaxia",  Mult = 7,  Chance = 0.006,  Color = Color3.fromRGB(150, 110, 255), Order = 5 },
	{ Id = "Rainbow", Name = "Rainbow", Folder = "Arcoiris", Mult = 10, Chance = 0.003,  Color = Color3.fromRGB(255, 95, 168),  Order = 6 },
	{ Id = "Hacker",  Name = "Hacker",  Folder = "Hacker",   Mult = 15, Chance = 0.0015, Color = Color3.fromRGB(60, 255, 120),  Order = 7 },
}

local ById: { [string]: Mutation } = {}
for _, m in ipairs(List) do ById[m.Id] = m end

-- tire une mutation (luck multiplie les chances des mutations)
local M = { List = List, ById = ById }
function M.Roll(rng: Random, luck: number): string
	for i = #List, 2, -1 do
		local m = List[i]
		if rng:NextNumber() < m.Chance * luck then return m.Id end
	end
	return "Normal"
end
return M
