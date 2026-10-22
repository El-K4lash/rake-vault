--!strict
-- ReplicatedStorage/Shared/Config/IndexRewards
-- Compléter toutes les planètes d'une rareté dans l'Index (sans mutation) débloque
-- un bonus d'argent PERMANENT à réclamer. Bonus = +X (0.05 = +5 %).

return {
	Bonus = {
		Common = 0.05,
		Rare = 0.05,
		Epic = 0.10,
		Legendary = 0.10,
		Mythic = 0.15,
		Secret = 0.25,
	},
}
