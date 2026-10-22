--!strict
-- ReplicatedStorage/Shared/Config/Mutations
-- Tirées à l'éclosion, une seule possible. Chance de base, multipliée par la Luck (voir LuckFactor).
-- Ordre de test : la plus rare d'abord.

local Mutations = {
	LuckFactor = 0.5, -- Luck x2 → chances de mutation x1.5 (moins fort que sur la rareté)
	List = {
		{ Id = "Rainbow", Name = "Rainbow", Chance = 0.002, Multiplier = 10, Color = Color3.fromRGB(255, 255, 255), Rainbow = true },
		{ Id = "Fire",    Name = "On Fire", Chance = 0.01,  Multiplier = 5,  Color = Color3.fromRGB(255, 110, 30) },
		{ Id = "Frozen",  Name = "Frozen",  Chance = 0.025, Multiplier = 3,  Color = Color3.fromRGB(140, 220, 255) },
		{ Id = "Golden",  Name = "Golden",  Chance = 0.05,  Multiplier = 2,  Color = Color3.fromRGB(255, 205, 50) },
	},
}

Mutations.ById = {}
for _, m in ipairs(Mutations.List) do
	Mutations.ById[m.Id] = m
end

return Mutations
