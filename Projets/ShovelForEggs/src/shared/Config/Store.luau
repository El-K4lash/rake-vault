--!strict
-- Shared/Config/Store
-- Boutique Robux (menu "Store" du HUD). Remplis les Id avec tes vrais GamePass / Developer Products
-- (Creator Hub > ton jeu > Monetization). Tant qu'un Id vaut 0, le bouton affiche "SOON".

local M = {}

-- Passes (achat unique, permanents)
M.Passes = {
	{ Key = "Money", Name = "x2 Money", Desc = "Earn <font color=\"#00FF00\">x2</font> money forever!", Price = 199, Id = 2053380750 },
	{ Key = "Hatch", Name = "x2 Hatch", Desc = "Eggs hatch <font color=\"#00FF00\">x2</font> faster!", Price = 149, Id = 2053032762 },
	{ Key = "Luck", Name = "Lucky Egg", Desc = "<font color=\"#00FF00\">x2</font> luck on rarity & mutations!", Price = 249, Id = 2053542792 },
	{ Key = "VIP", Name = "VIP Sled", Desc = "<font color=\"#FFD200\">+50%</font> money & bigger sled!", Price = 349, Id = 2053932808 },
	{ Key = "TripleEgg", Name = "Triple Hatch", Desc = "Hatch <font color=\"#00FF00\">+3</font> eggs at the same time!", Price = 199, Id = 2052162850 },
	{ Key = "WinterPass", Name = "Winter Pass", Desc = "Unlock the <font color=\"#FFD200\">premium</font> Winter Pass rewards!", Price = 399, Id = 2053446763 },
}

-- Produits spéciaux (Developer Products) : offre de départ, x2 gains hors ligne, éclosion immédiate d'un œuf
M.Special = {
	{ Key = "Starter", Name = "Starter Pack", Price = 49, Id = 3722625401 },
	{ Key = "OfflineX2", Name = "x2 Offline Earnings", Price = 19, Id = 3722625420 },
	{ Key = "SkipEgg", Name = "Hatch Now", Price = 15, Id = 3722625440 },
	-- faire éclore tout de suite l'œuf d'un AUTRE joueur (cadeau, Robux uniquement)
	{ Key = "GiftSkip", Name = "[GIFT] Skip Timer", Price = 15, Id = 3722625473 },
}

-- Packs d'argent (Developer Products)
M.Cash = {
	{ Key = "Cash1", Amount = 5_000, Price = 25, Id = 3722625499 },
	{ Key = "Cash2", Amount = 50_000, Price = 99, Id = 3722625534 },
	{ Key = "Cash3", Amount = 250_000, Price = 199, Id = 3722625554 },
	{ Key = "Cash4", Amount = 1_000_000, Price = 399, Id = 3722625591 },
	{ Key = "Cash5", Amount = 5_000_000, Price = 799, Id = 3722625618 },
}

-- Packs d'œufs (Developer Products)
M.Eggs = {
	{ Key = "EggSnow", Egg = "SnowEgg", Count = 3, Price = 25, Id = 3722625639 },
	{ Key = "EggPine", Egg = "PineEgg", Count = 3, Price = 49, Id = 3722625661 },
	{ Key = "EggFrozen", Egg = "FrozenEgg", Count = 3, Price = 99, Id = 3722625676 },
	{ Key = "EggCrystal", Egg = "CrystalEgg", Count = 3, Price = 199, Id = 3722625706 },
	{ Key = "EggGlacier", Egg = "GlacierEgg", Count = 3, Price = 399, Id = 3722625724 },
	{ Key = "EggAurora", Egg = "AuroraEgg", Count = 3, Price = 799, Id = 3722625747 },
}

-- Offre limitée en haut du menu (œufs dorés)
M.Limited = {
	{ Key = "Limited1", Egg = "GoldenEgg", Count = 1, Price = 79, Id = 3722625769 },
	{ Key = "Limited2", Egg = "GoldenEgg", Count = 5, Price = 349, Id = 3722625791 },
	{ Key = "Limited3", Egg = "GoldenEgg", Count = 15, Price = 899, Id = 3722625809 },
	{ Key = "Limited4", Egg = "GoldenEgg", Count = 40, Price = 1999, Id = 3722625829 },
}

-- index par clé et par Id
M.ByKey = {} :: { [string]: any }
M.ProductById = {} :: { [number]: any }
M.PassById = {} :: { [number]: any }
for _, p in ipairs(M.Passes) do M.ByKey[p.Key] = p; if p.Id > 0 then M.PassById[p.Id] = p end end
for _, list in ipairs({ M.Cash, M.Eggs, M.Limited, M.Special }) do
	for _, p in ipairs(list) do M.ByKey[p.Key] = p; if p.Id > 0 then M.ProductById[p.Id] = p end end
end

local passKeys: { [string]: boolean } = {}
for _, p in ipairs(M.Passes) do passKeys[p.Key] = true end
function M.IsPass(key: string): boolean return passKeys[key] == true end

return M
