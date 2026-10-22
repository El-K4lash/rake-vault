--!strict
-- ReplicatedStorage/Shared/Config/DailyRewards
-- Cycle de 7 jours. Si le joueur rate plus de 48 h, on revient au jour 1.
-- Money = minutes de gains actuels (avec minimum), pour rester utile à tous les niveaux.

return {
	ResetAfterHours = 48,
	Days = {
		{ Type = "Money",  Minutes = 5,  Min = 500 },
		{ Type = "Galaxy", Galaxy = "EmeraldSwirl" },
		{ Type = "Boost",  Boost = "Luck", Duration = 900 },
		{ Type = "Money",  Minutes = 20, Min = 5_000 },
		{ Type = "Galaxy", Galaxy = "AmethystSpiral" },
		{ Type = "Boost",  Boost = "Money", Duration = 1800 },
		{ Type = "Galaxy", Galaxy = "GoldenCrown" },
	},
}
