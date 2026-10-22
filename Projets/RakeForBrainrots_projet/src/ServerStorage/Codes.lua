--!strict
-- ServerStorage/Codes (côté serveur uniquement, invisible pour les joueurs)
-- Reward : Money (montant), ou Boost { Stat = "Luck"/"Money", Mult, Duration }
return {
	RAKE = { Money = 500 },
	BRAINROT = { Money = 2500 },
	LUCKY = { Boost = { Stat = "Luck", Mult = 2, Duration = 15 * 60 } },
	RELEASE = { Money = 10000 },
}
