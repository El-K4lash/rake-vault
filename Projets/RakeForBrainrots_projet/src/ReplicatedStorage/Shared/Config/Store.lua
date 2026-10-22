--!strict
-- Shared/Config/Store
-- Boutique Robux (menu "Store" du HUD). Remplis les Id avec tes vrais GamePass / Developer Products
-- (Creator Hub > ton jeu > Monetization). Tant qu'un Id vaut 0, le bouton affiche "SOON".

local M = {}

-- Passes (achat unique, permanents)
M.Passes = {
	{ Key = "Money", Name = "x2 Money", Desc = "Earn <font color=\"#00FF00\">x2</font> money forever!", Price = 199, Id = 0 },
	{ Key = "Hatch", Name = "x2 Hatch", Desc = "Eggs hatch <font color=\"#00FF00\">x2</font> faster!", Price = 149, Id = 0 },
	{ Key = "Luck", Name = "x2 Luck", Desc = "<font color=\"#00FF00\">x2</font> luck on rarity & mutations!", Price = 249, Id = 0 },
	{ Key = "VIP", Name = "VIP", Desc = "<font color=\"#FFD200\">+50%</font> money & bigger bag!", Price = 349, Id = 0 },
}

-- Packs d'argent (Developer Products)
M.Cash = {
	{ Key = "Cash1", Amount = 5_000, Price = 25, Id = 0 },
	{ Key = "Cash2", Amount = 50_000, Price = 99, Id = 0 },
	{ Key = "Cash3", Amount = 250_000, Price = 199, Id = 0 },
	{ Key = "Cash4", Amount = 1_000_000, Price = 399, Id = 0 },
	{ Key = "Cash5", Amount = 5_000_000, Price = 799, Id = 0 },
}

-- Packs d'œufs (Developer Products)
M.Eggs = {
	{ Key = "EggBeach", Egg = "BeachEgg", Count = 3, Price = 25, Id = 0 },
	{ Key = "EggSwamp", Egg = "SwampEgg", Count = 3, Price = 49, Id = 0 },
	{ Key = "EggVolcano", Egg = "VolcanoEgg", Count = 3, Price = 99, Id = 0 },
	{ Key = "EggIce", Egg = "IceEgg", Count = 3, Price = 199, Id = 0 },
	{ Key = "EggVoid", Egg = "VoidEgg", Count = 3, Price = 399, Id = 0 },
	{ Key = "EggVoid10", Egg = "VoidEgg", Count = 10, Price = 999, Id = 0 },
}

-- Offre limitée en haut du menu (œufs Void)
M.Limited = {
	{ Key = "Limited1", Egg = "VoidEgg", Count = 1, Price = 79, Id = 0 },
	{ Key = "Limited2", Egg = "VoidEgg", Count = 5, Price = 349, Id = 0 },
	{ Key = "Limited3", Egg = "VoidEgg", Count = 15, Price = 899, Id = 0 },
	{ Key = "Limited4", Egg = "VoidEgg", Count = 40, Price = 1999, Id = 0 },
}

-- index par clé et par Id
M.ByKey = {} :: { [string]: any }
M.ProductById = {} :: { [number]: any }
M.PassById = {} :: { [number]: any }
for _, p in ipairs(M.Passes) do M.ByKey[p.Key] = p; if p.Id > 0 then M.PassById[p.Id] = p end end
for _, list in ipairs({ M.Cash, M.Eggs, M.Limited }) do
	for _, p in ipairs(list) do M.ByKey[p.Key] = p; if p.Id > 0 then M.ProductById[p.Id] = p end end
end

return M
