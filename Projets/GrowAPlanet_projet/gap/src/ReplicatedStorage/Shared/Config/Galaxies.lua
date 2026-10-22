--!strict
-- ReplicatedStorage/Shared/Config/Galaxies
-- Une galaxie par rareté. Elles apparaissent sur les spawners de la base.
--   Price      : prix en argent du jeu
--   HatchTime  : durée dans l'enclos avant de pouvoir éclore (secondes)
--   SpawnWeight: poids de tirage sur un spawner (plus c'est grand, plus c'est fréquent)
--   UpgradeChance : chance que la planète soit de la rareté AU-DESSUS (multipliée par la Luck)
--   RobuxOnly  : ne sort pas des spawners, seulement achetable dans le Shop Robux

local Galaxies = {
	Spawn = {
		Interval = 8,      -- une nouvelle galaxie sur chaque spawner libre toutes les 8 s
		Lifetime = 30,     -- si personne ne l'achète, elle disparaît après 30 s
		LuckAffects = true, -- la Luck multiplie le poids des galaxies Rare et au-dessus
	},
	List = {
		{ Id = "DustNebula",    Name = "Dust Nebula",       Rarity = "Common",    Price = 50,         HatchTime = 10,   SpawnWeight = 70,   UpgradeChance = 0.12 },
		{ Id = "EmeraldSwirl",  Name = "Emerald Swirl",     Rarity = "Rare",      Price = 500,        HatchTime = 45,   SpawnWeight = 22,   UpgradeChance = 0.10 },
		{ Id = "AmethystSpiral",Name = "Amethyst Spiral",   Rarity = "Epic",      Price = 5_000,      HatchTime = 180,  SpawnWeight = 6.5,  UpgradeChance = 0.08 },
		{ Id = "GoldenCrown",   Name = "Golden Crown",      Rarity = "Legendary", Price = 75_000,     HatchTime = 600,  SpawnWeight = 1.3,  UpgradeChance = 0.06 },
		{ Id = "CrimsonEye",    Name = "Crimson Eye",       Rarity = "Mythic",    Price = 1_500_000,  HatchTime = 1800, SpawnWeight = 0.19, UpgradeChance = 0.03 },
		{ Id = "PrismCore",     Name = "Prism Singularity", Rarity = "Secret",    Price = 50_000_000, HatchTime = 7200, SpawnWeight = 0.01, UpgradeChance = 0 },
	},
}

-- accès rapide par Id
Galaxies.ById = {}
for _, g in ipairs(Galaxies.List) do
	Galaxies.ById[g.Id] = g
end

return Galaxies
