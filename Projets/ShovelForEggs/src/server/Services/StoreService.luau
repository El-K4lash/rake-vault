--!strict
-- ServerScriptService/Services/StoreService
-- Achats Robux : passes (permanents) et produits (argent, œufs). Le serveur seul donne les récompenses
-- (ProcessReceipt) ; un reçu déjà traité n'est jamais redonné (data.Receipts).

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Store = require(Shared.Config.Store)

local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)

local StoreService = {}

local function syncEggs(player: Player, data: any)
	local EggService = require(script.Parent.EggService) :: any
	EggService.SyncTools(player, data)
end

-- donne la récompense d'un produit ; renvoie true si c'est fait
local function grant(player: Player, data: any, p: any, silent: boolean?): boolean
	-- produits spéciaux (Config/Store.Special)
	if p.Key == "Starter" then
		local RewardsService = require(script.Parent.RewardsService) :: any
		return RewardsService.GrantStarter(player, data)
	elseif p.Key == "OfflineX2" then
		local RewardsService = require(script.Parent.RewardsService) :: any
		return RewardsService.GrantOfflineX2(player, data)
	elseif p.Key == "SkipEgg" then
		local EggService = require(script.Parent.EggService) :: any
		return EggService.GrantSkip(player, data)
	elseif p.Key == "GiftSkip" then
		local EggService = require(script.Parent.EggService) :: any
		return EggService.GrantGiftSkip(player, data)
	end
	if p.Amount then
		data.Money += p.Amount
		data.TotalEarned = (data.TotalEarned or 0) + p.Amount
		DataService.Push(player, "Money")
	elseif p.Egg then
		data.Eggs[p.Egg] = (data.Eggs[p.Egg] or 0) + p.Count
		DataService.Push(player, "Eggs")
		syncEggs(player, data)
	else
		return false
	end
	if not silent then Net.Notify(player, "Thanks for your purchase!", "success") end
	return true
end

local function setPass(player: Player, data: any, key: string)
	if data.Passes[key] then return end
	if data.PassRevoked then data.PassRevoked[key] = nil end
	data.Passes[key] = true
	DataService.Push(player, "Passes")
	local PlotService = require(script.Parent.PlotService) :: any
	PlotService.Refresh(player)
end

-- [ PANEL ADMIN ] ------------------------------------------------------------------
-- donne un produit (comme un achat, sans reçu) ; chaque appel redonne
function StoreService.AdminGrant(player: Player, data: any, key: string): boolean
	local p = Store.ByKey[key]
	if not p or Store.IsPass(key) then return false end
	if key == "Starter" then data.StarterBought = false end -- pour pouvoir le redonner
	return grant(player, data, p, true)
end

-- coche / décoche un pass. Décoché = retiré même s'il a été acheté : PassRevoked empêche
-- la vérification au chargement (UserOwnsGamePassAsync) de le redonner.
function StoreService.AdminSetPass(player: Player, data: any, key: string, on: boolean): boolean
	if not Store.IsPass(key) then return false end
	data.PassRevoked = data.PassRevoked or {}
	if on then
		setPass(player, data, key)
	else
		data.Passes[key] = nil
		data.PassRevoked[key] = true
		DataService.Push(player, "Passes")
		local PlotService = require(script.Parent.PlotService) :: any
		PlotService.Refresh(player)
	end
	return true
end

function StoreService.Start()
	MarketplaceService.ProcessReceipt = function(info)
		local player = Players:GetPlayerByUserId(info.PlayerId)
		local data = player and DataService.Get(player)
		local GRANTED, LATER = Enum.ProductPurchaseDecision.PurchaseGranted, Enum.ProductPurchaseDecision.NotProcessedYet
		if not player or not data then return LATER end
		local id = tostring(info.PurchaseId)
		-- on ne confirme l'achat à Roblox que si la sauvegarde a réussi (sinon Roblox redemandera plus tard)
		if DataService.HasReceipt(data, id) then return DataService.SaveNow(player) and GRANTED or LATER end
		local p = Store.ProductById[info.ProductId]
		if not p or not grant(player, data, p) then return LATER end
		DataService.AddReceipt(data, id)
		return DataService.SaveNow(player) and GRANTED or LATER
	end

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, bought)
		local p = Store.PassById[passId]
		local data = DataService.Get(player)
		if bought and p and data then
			-- on ne fait pas confiance au signal : on vérifie que le joueur possède vraiment le pass
			local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, passId)
			if ok and owns then
				setPass(player, data, p.Key)
				Net.Notify(player, p.Name .. " unlocked!", "success")
			end
		end
	end)

	-- au chargement : vérifie les passes possédés (achetés sur le site, sur un autre serveur...)
	DataService.OnLoaded(function(player, data)
		for _, p in ipairs(Store.Passes) do
			if p.Id > 0 and not data.Passes[p.Key] and not (data.PassRevoked and data.PassRevoked[p.Key]) then
				local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, p.Id)
				if ok and owns then setPass(player, data, p.Key) end
			end
		end
	end)
end

return StoreService
