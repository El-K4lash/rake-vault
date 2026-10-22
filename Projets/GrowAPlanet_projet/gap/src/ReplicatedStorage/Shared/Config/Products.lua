--!strict
-- ReplicatedStorage/Shared/Config/Products
-- Developer products (achats répétables). Id = 0 tant que non créés.
-- Les packs d'argent donnent X minutes de gains actuels (minimum garanti) pour rester utiles toute la partie.

return {
	BoostMoney15 = { Id = 0, Name = "x2 Money (15 min)", Price = 49, Boost = "Money", Duration = 900 },
	BoostLuck15  = { Id = 0, Name = "x2 Luck (15 min)",  Price = 49, Boost = "Luck",  Duration = 900 },
	SkipOne      = { Id = 0, Name = "Skip 1 Galaxy",     Price = 25 },
	SkipAll      = { Id = 0, Name = "Skip All",          Price = 99 },
	CashSmall    = { Id = 0, Name = "Cash Pack S", Price = 25,  Minutes = 10,  Min = 1_000 },
	CashMedium   = { Id = 0, Name = "Cash Pack M", Price = 99,  Minutes = 60,  Min = 10_000 },
	CashLarge    = { Id = 0, Name = "Cash Pack L", Price = 399, Minutes = 360, Min = 100_000 },
	StarterPack  = { Id = 0, Name = "Starter Pack", Price = 99, OncePerPlayer = true,
		Gives = { Money = 25_000, Galaxy = "GoldenCrown", Boost = "Money", BoostDuration = 1800 } },
	MythicGalaxy = { Id = 0, Name = "Crimson Eye Galaxy",     Price = 199, Galaxy = "CrimsonEye", ShowOdds = true },
	SecretGalaxy = { Id = 0, Name = "Prism Singularity",      Price = 799, Galaxy = "PrismCore",  ShowOdds = true },
}
