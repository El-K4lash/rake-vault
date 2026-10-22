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
local function grant(player: Player, data: any, p: any): boolean
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
	Net.Notify(player, "Thanks for your purchase!", "success")
	return true
end

local function setPass(player: Player, data: any, key: string)
	if data.Passes[key] then return end
	data.Passes[key] = true
	DataService.Push(player, "Passes")
	local PlotService = require(script.Parent.PlotService) :: any
	PlotService.Refresh(player)
end

function StoreService.Start()
	MarketplaceService.ProcessReceipt = function(info)
		local player = Players:GetPlayerByUserId(info.PlayerId)
		local data = player and DataService.Get(player)
		if not player or not data then return Enum.ProductPurchaseDecision.NotProcessedYet end
		local id = tostring(info.PurchaseId)
		if DataService.HasReceipt(data, id) then return Enum.ProductPurchaseDecision.PurchaseGranted end
		local p = Store.ProductById[info.ProductId]
		if not p or not grant(player, data, p) then return Enum.ProductPurchaseDecision.NotProcessedYet end
		DataService.AddReceipt(data, id)
		DataService.SaveNow(player)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, bought)
		local p = Store.PassById[passId]
		local data = DataService.Get(player)
		if bought and p and data then
			setPass(player, data, p.Key)
			Net.Notify(player, p.Name .. " unlocked!", "success")
		end
	end)

	-- au chargement : vérifie les passes possédés (achetés sur le site, sur un autre serveur...)
	DataService.OnLoaded(function(player, data)
		for _, p in ipairs(Store.Passes) do
			if p.Id > 0 and not data.Passes[p.Key] then
				local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, p.Id)
				if ok and owns then setPass(player, data, p.Key) end
			end
		end
	end)
end

return StoreService
