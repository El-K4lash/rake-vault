--!strict
-- Shared/Config/Events : contenu "live" du jeu (lu par le serveur ET le client pour l'affichage).
--   * Advent      : calendrier de l'Avent du 1er au 24 décembre (une case par jour, cases ratées rattrapables)
--   * Quests      : 3 quêtes du jour (tirées chaque jour à 00:00 UTC), bonus si les 3 sont finies
--   * Pass        : Winter Pass (saison de Noël), 30 paliers, piste gratuite + piste premium (Game Pass "WinterPass")
--   * Starter     : offre de départ (Developer Product "Starter"), proposée après 5 min de jeu
--   * Launch      : week-end de lancement (tempêtes dorées garanties + code LAUNCH)
-- Récompense : { Kind = "Money", Mins = n }  -> n minutes du revenu actuel de la base (minimum Min)
--              { Kind = "Egg", Egg = id, Count = n } / { Kind = "BestEgg", Count = n } (œuf de la meilleure zone débloquée)
--              { Kind = "Boost", Stat = "Luck"/"Money", Mult = 2, Mins = n }
--              { Kind = "Charm", Stat = "Luck"/"Speed"/"Income", Amount = x } (bonus permanent, plafonné)
--              { Kind = "Pet", Rarity = "Mythic"/"Secret", Mut = "Rainbow" } (brainrot avec mutation)
--              { Kind = "XP", Amount = n } (Winter Pass)

local M = {}

-- [ CALENDRIER DE L'AVENT ] ----------------------------------------------------------------
M.Advent = {
	Year = 2026, Month = 12, -- décembre 2026 (UTC)
	Days = {
		[1] = { { Kind = "Money", Mins = 10, Min = 2500 }, { Kind = "BestEgg", Count = 1 } },
		[2] = { { Kind = "Boost", Stat = "Luck", Mult = 2, Mins = 15 } },
		[3] = { { Kind = "Egg", Egg = "SnowEgg", Count = 3 } },
		[4] = { { Kind = "Money", Mins = 15, Min = 4000 } },
		[5] = { { Kind = "Charm", Stat = "Luck", Amount = 0.03 } },
		[6] = { { Kind = "Egg", Egg = "GoldenEgg", Count = 1 } },
		[7] = { { Kind = "Boost", Stat = "Money", Mult = 2, Mins = 20 } },
		[8] = { { Kind = "BestEgg", Count = 2 } },
		[9] = { { Kind = "Money", Mins = 20, Min = 6000 }, { Kind = "XP", Amount = 300 } },
		[10] = { { Kind = "Charm", Stat = "Speed", Amount = 0.03 } },
		[11] = { { Kind = "Egg", Egg = "GoldenEgg", Count = 2 } },
		[12] = { { Kind = "Pet", Rarity = "Legendary", Mut = "Rainbow" } },
		[13] = { { Kind = "Boost", Stat = "Luck", Mult = 2, Mins = 30 } },
		[14] = { { Kind = "Money", Mins = 30, Min = 10000 } },
		[15] = { { Kind = "BestEgg", Count = 3 } },
		[16] = { { Kind = "Charm", Stat = "Income", Amount = 0.03 } },
		[17] = { { Kind = "Egg", Egg = "GoldenEgg", Count = 3 } },
		[18] = { { Kind = "Boost", Stat = "Money", Mult = 2, Mins = 45 }, { Kind = "XP", Amount = 500 } },
		[19] = { { Kind = "Money", Mins = 45, Min = 20000 } },
		[20] = { { Kind = "Pet", Rarity = "Mythic", Mut = "Rainbow" } },
		[21] = { { Kind = "BestEgg", Count = 5 } },
		[22] = { { Kind = "Egg", Egg = "GoldenEgg", Count = 5 } },
		[23] = { { Kind = "Boost", Stat = "Luck", Mult = 2, Mins = 60 }, { Kind = "Money", Mins = 60, Min = 50000 } },
		[24] = { { Kind = "Pet", Rarity = "Secret", Mut = "Rainbow" }, { Kind = "Egg", Egg = "GoldenEgg", Count = 5 } },
	},
}

-- [ QUÊTES DU JOUR ] -------------------------------------------------------------------------
-- Goal(rebirths) = objectif ; Stat = ce qui fait avancer (RewardsService.Progress(player, Stat, n))
M.Quests = {
	{ Id = "Dig", Stat = "Dig", Text = "Dig %d snow piles", Goal = function(r) return 150 + r * 25 end },
	{ Id = "Eggs", Stat = "Egg", Text = "Find %d eggs in the snow", Goal = function(r) return 3 + math.floor(r / 3) end },
	{ Id = "Hatch", Stat = "Hatch", Text = "Hatch %d eggs", Goal = function(r) return 3 + math.floor(r / 3) end },
	{ Id = "Sell", Stat = "Sell", Text = "Sell %d items", Goal = function(r) return 120 + r * 20 end },
	{ Id = "Rare", Stat = "Rare", Text = "Find %d ice crystals", Goal = function(r) return 15 + r * 2 end },
	{ Id = "Combo", Stat = "Combo", Text = "Reach a x%d dig combo", Goal = function(r) return 25 + math.min(r, 10) * 3 end, Max = true },
	{ Id = "Chest", Stat = "Chest", Text = "Open %d frozen chest", Goal = function() return 1 end },
	{ Id = "Storm", Stat = "StormDig", Text = "Dig %d piles during a storm", Goal = function(r) return 40 + r * 5 end },
	{ Id = "Upgrade", Stat = "Upgrade", Text = "Upgrade your brainrots %d times", Goal = function(r) return 5 + math.floor(r / 2) end },
}
M.QuestCount = 3
M.QuestReward = { { Kind = "Money", Mins = 8, Min = 1500 }, { Kind = "XP", Amount = 150 } }
M.QuestBonus = { { Kind = "Egg", Egg = "GoldenEgg", Count = 1 }, { Kind = "XP", Amount = 250 } } -- les 3 finies

-- [ WINTER PASS ] -----------------------------------------------------------------------------
M.Pass = {
	Name = "Winter Pass",
	Ends = DateTime.fromUniversalTime(2027, 1, 7, 0, 0, 0).UnixTimestamp, -- fin de saison (UTC)
	XP = { Dig = 1, Hatch = 12, Sell = 0.2, Egg = 8, Chest = 60, Upgrade = 10 },  -- XP par action (Sell = par objet vendu)
	TierXP = function(t: number): number return 300 + t * 60 end,  -- XP pour passer du palier t-1 au palier t
	Tiers = {} :: { { Free: any, Premium: any } },
}
do
	local T = M.Pass.Tiers
	for t = 1, 30 do
		local free, prem
		if t % 10 == 0 then
			free = { Kind = "Pet", Rarity = (t == 30) and "Mythic" or "Legendary", Mut = "Rainbow" }
			prem = { Kind = "Pet", Rarity = (t == 30) and "Secret" or "Mythic", Mut = "Hacker" }
		elseif t % 5 == 0 then
			free = { Kind = "Egg", Egg = "GoldenEgg", Count = 1 }
			prem = { Kind = "Egg", Egg = "GoldenEgg", Count = 4 }
		elseif t % 3 == 0 then
			free = { Kind = "Boost", Stat = (t % 2 == 0) and "Money" or "Luck", Mult = 2, Mins = 10 }
			prem = { Kind = "Boost", Stat = (t % 2 == 0) and "Money" or "Luck", Mult = 2, Mins = 30 }
		elseif t % 2 == 0 then
			free = { Kind = "BestEgg", Count = 1 }
			prem = { Kind = "BestEgg", Count = 3 }
		else
			free = { Kind = "Money", Mins = 5 + t, Min = 1000 * t }
			prem = { Kind = "Money", Mins = 15 + t * 2, Min = 3000 * t }
		end
		T[t] = { Free = free, Premium = prem }
	end
end

-- [ OFFRE DE DÉPART ] -------------------------------------------------------------------------
M.Starter = {
	ShowAfter = 300, -- secondes de jeu
	Rewards = {
		{ Kind = "Egg", Egg = "GoldenEgg", Count = 3 },
		{ Kind = "Boost", Stat = "Money", Mult = 2, Mins = 30 },
		{ Kind = "Boost", Stat = "Luck", Mult = 2, Mins = 30 },
		{ Kind = "Money", Mins = 20, Min = 25000 },
	},
}

-- [ LANCEMENT ] -------------------------------------------------------------------------------
M.Launch = {
	Start = DateTime.fromUniversalTime(2026, 12, 4, 17, 0, 0).UnixTimestamp, -- vendredi 4 décembre 2026, 18 h (heure de Paris)
	Hours = 72,                                                        -- tout le week-end
	StormEvery = 5 * 60,                                               -- tempêtes plus fréquentes, toutes dorées
}
function M.LaunchActive(now: number): boolean
	return now >= M.Launch.Start and now < M.Launch.Start + M.Launch.Hours * 3600
end

-- jour courant (UTC) -> clé "AAAA-MM-JJ"
function M.DayKey(now: number): string
	local t = os.date("!*t", now) :: any
	return string.format("%04d-%02d-%02d", t.year, t.month, t.day)
end
-- jour de décembre ouvert (1..24) ou 0 avant / après
function M.AdventDay(now: number): number
	local t = os.date("!*t", now) :: any
	if t.year == M.Advent.Year and t.month == M.Advent.Month and t.day >= 1 and t.day <= 24 then return t.day end
	if t.year > M.Advent.Year or (t.year == M.Advent.Year and t.month == 12 and t.day > 24) then return 25 end
	return 0
end
-- secondes jusqu'à minuit UTC
function M.ToMidnight(now: number): number
	return 86400 - (now % 86400)
end
-- numéro de semaine (pour les classements hebdomadaires) : semaines qui commencent le lundi 00:00 UTC
function M.WeekId(now: number): number
	return math.floor((now - 345600) / 604800) -- 345600 = décalage pour tomber sur le lundi (1/1/1970 = jeudi)
end

return M
