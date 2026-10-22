--!strict
-- ReplicatedStorage/Shared/Config/Planets
-- 5 planètes par rareté. Income = argent par seconde quand elle est équipée.
-- Weight = chance relative DANS sa rareté (35/28/20/12/5 → la 5e est la plus rare et rapporte le plus).
-- Look = indications pour le modèle 3D (couleur principale, anneau, etc.)

local Planets = {
	List = {
		-- COMMON
		{ Id = "RockyPebble",  Name = "Rocky Pebble",   Rarity = "Common", Income = 1,  Weight = 35, Look = { Color = Color3.fromRGB(150, 140, 130) } },
		{ Id = "DustBall",     Name = "Dust Ball",      Rarity = "Common", Income = 2,  Weight = 28, Look = { Color = Color3.fromRGB(200, 170, 120) } },
		{ Id = "MossyMoon",    Name = "Mossy Moon",     Rarity = "Common", Income = 3,  Weight = 20, Look = { Color = Color3.fromRGB(120, 160, 100) } },
		{ Id = "ClayOrb",      Name = "Clay Orb",       Rarity = "Common", Income = 4,  Weight = 12, Look = { Color = Color3.fromRGB(190, 110, 80) } },
		{ Id = "FoggyRock",    Name = "Foggy Rock",     Rarity = "Common", Income = 6,  Weight = 5,  Look = { Color = Color3.fromRGB(170, 180, 200), Ring = true } },
		-- RARE
		{ Id = "OceanBubble",  Name = "Ocean Bubble",   Rarity = "Rare", Income = 8,  Weight = 35, Look = { Color = Color3.fromRGB(40, 140, 255) } },
		{ Id = "JungleSphere", Name = "Jungle Sphere",  Rarity = "Rare", Income = 11, Weight = 28, Look = { Color = Color3.fromRGB(40, 190, 70) } },
		{ Id = "MintRing",     Name = "Mint Ring",      Rarity = "Rare", Income = 14, Weight = 20, Look = { Color = Color3.fromRGB(120, 255, 200), Ring = true } },
		{ Id = "CoralReef",    Name = "Coral Reef",     Rarity = "Rare", Income = 18, Weight = 12, Look = { Color = Color3.fromRGB(255, 130, 120) } },
		{ Id = "LimeComet",    Name = "Lime Comet",     Rarity = "Rare", Income = 25, Weight = 5,  Look = { Color = Color3.fromRGB(190, 255, 60), Tail = true } },
		-- EPIC
		{ Id = "CrystalCore",  Name = "Crystal Core",   Rarity = "Epic", Income = 60,  Weight = 35, Look = { Color = Color3.fromRGB(150, 220, 255), Crystals = true } },
		{ Id = "NeonStorm",    Name = "Neon Storm",     Rarity = "Epic", Income = 80,  Weight = 28, Look = { Color = Color3.fromRGB(0, 255, 230) } },
		{ Id = "AmethystGiant",Name = "Amethyst Giant", Rarity = "Epic", Income = 105, Weight = 20, Look = { Color = Color3.fromRGB(160, 70, 255), Ring = true } },
		{ Id = "VoidJelly",    Name = "Void Jelly",     Rarity = "Epic", Income = 135, Weight = 12, Look = { Color = Color3.fromRGB(90, 30, 160) } },
		{ Id = "PlasmaPearl",  Name = "Plasma Pearl",   Rarity = "Epic", Income = 180, Weight = 5,  Look = { Color = Color3.fromRGB(255, 120, 255), Glow = true } },
		-- LEGENDARY
		{ Id = "GoldenSaturn", Name = "Golden Saturn",  Rarity = "Legendary", Income = 500,  Weight = 35, Look = { Color = Color3.fromRGB(255, 200, 60), Ring = true } },
		{ Id = "SunForge",     Name = "Sun Forge",      Rarity = "Legendary", Income = 650,  Weight = 28, Look = { Color = Color3.fromRGB(255, 140, 30), Glow = true } },
		{ Id = "HoneyNova",    Name = "Honey Nova",     Rarity = "Legendary", Income = 850,  Weight = 20, Look = { Color = Color3.fromRGB(255, 220, 110) } },
		{ Id = "CrownWorld",   Name = "Crown World",    Rarity = "Legendary", Income = 1100, Weight = 12, Look = { Color = Color3.fromRGB(255, 230, 150), Crystals = true } },
		{ Id = "AmberTitan",   Name = "Amber Titan",    Rarity = "Legendary", Income = 1500, Weight = 5,  Look = { Color = Color3.fromRGB(230, 130, 20), Ring = true, Glow = true } },
		-- MYTHIC
		{ Id = "CrimsonEye",   Name = "Crimson Eye",    Rarity = "Mythic", Income = 5_000,  Weight = 35, Look = { Color = Color3.fromRGB(220, 30, 60) } },
		{ Id = "BloodMoon",    Name = "Blood Moon",     Rarity = "Mythic", Income = 6_500,  Weight = 28, Look = { Color = Color3.fromRGB(160, 0, 30), Glow = true } },
		{ Id = "HeartNebula",  Name = "Heart Nebula",   Rarity = "Mythic", Income = 8_500,  Weight = 20, Look = { Color = Color3.fromRGB(255, 90, 160) } },
		{ Id = "InfernoPrime", Name = "Inferno Prime",  Rarity = "Mythic", Income = 11_000, Weight = 12, Look = { Color = Color3.fromRGB(255, 70, 0), Glow = true } },
		{ Id = "RoseQuasar",   Name = "Rose Quasar",    Rarity = "Mythic", Income = 15_000, Weight = 5,  Look = { Color = Color3.fromRGB(255, 40, 120), Ring = true, Glow = true } },
		-- SECRET
		{ Id = "PrismSingularity", Name = "Prism Singularity", Rarity = "Secret", Income = 80_000,  Weight = 35, Look = { Rainbow = true } },
		{ Id = "RainbowAbyss",     Name = "Rainbow Abyss",     Rarity = "Secret", Income = 100_000, Weight = 28, Look = { Rainbow = true, Ring = true } },
		{ Id = "CosmicEgg",        Name = "Cosmic Egg",        Rarity = "Secret", Income = 130_000, Weight = 20, Look = { Rainbow = true, Glow = true } },
		{ Id = "OmegaStar",        Name = "Omega Star",        Rarity = "Secret", Income = 170_000, Weight = 12, Look = { Rainbow = true, Glow = true } },
		{ Id = "TheGlitch",        Name = "The Glitch",        Rarity = "Secret", Income = 250_000, Weight = 5,  Look = { Rainbow = true, Glitch = true } },
	},
}

Planets.ById = {}
Planets.ByRarity = {}
for _, p in ipairs(Planets.List) do
	Planets.ById[p.Id] = p
	Planets.ByRarity[p.Rarity] = Planets.ByRarity[p.Rarity] or {}
	table.insert(Planets.ByRarity[p.Rarity], p)
end

return Planets
