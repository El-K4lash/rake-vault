--!strict
-- ReplicatedStorage/Shared/Config/Rarities
-- Les 6 raretés du jeu, de la plus commune à la plus rare.
-- Order : sert à trier et à savoir quelle rareté est « au-dessus ».
-- Color : utilisée partout (bordures, textes, effets). Secret = arc-en-ciel (Rainbow = true).

local Rarities = {
	List = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret" },
	Info = {
		Common    = { Order = 1, Name = "Common",    Color = Color3.fromRGB(190, 195, 205), Dark = Color3.fromRGB(70, 75, 85) },
		Rare      = { Order = 2, Name = "Rare",      Color = Color3.fromRGB(85, 225, 95),   Dark = Color3.fromRGB(20, 95, 35) },
		Epic      = { Order = 3, Name = "Epic",      Color = Color3.fromRGB(170, 85, 255),  Dark = Color3.fromRGB(70, 20, 130) },
		Legendary = { Order = 4, Name = "Legendary", Color = Color3.fromRGB(255, 200, 40),  Dark = Color3.fromRGB(130, 80, 0) },
		Mythic    = { Order = 5, Name = "Mythic",    Color = Color3.fromRGB(255, 70, 120),  Dark = Color3.fromRGB(120, 10, 45) },
		Secret    = { Order = 6, Name = "Secret",    Color = Color3.fromRGB(255, 255, 255), Dark = Color3.fromRGB(40, 20, 70), Rainbow = true },
	},
}

-- rareté juste au-dessus (nil pour Secret)
function Rarities.Next(rarity: string): string?
	local info = Rarities.Info[rarity]
	return info and Rarities.List[info.Order + 1] or nil
end

return Rarities
