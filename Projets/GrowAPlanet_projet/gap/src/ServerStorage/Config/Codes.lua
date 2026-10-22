--!strict
-- ServerStorage/Config/Codes (côté serveur : les joueurs ne peuvent pas lire la liste)
-- Codes promo (majuscules). Un code ne marche qu'une fois par joueur. Expires = os.time() ou nil.

return {
	LAUNCH = { Reward = { Type = "Money", Amount = 1_000 } },
	GALAXY = { Reward = { Type = "Galaxy", Galaxy = "EmeraldSwirl" } },
	LUCKY  = { Reward = { Type = "Boost", Boost = "Luck", Duration = 600 } },
}
