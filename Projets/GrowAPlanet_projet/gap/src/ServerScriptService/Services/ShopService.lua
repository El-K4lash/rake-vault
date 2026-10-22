--!strict
-- ServerScriptService/Services/ShopService
-- Achats Robux.
--   * Gamepasses : vérifiés à l'arrivée + après achat → attribut Pass_<Nom> sur le joueur
--   * Developer products : ProcessReceipt IDEMPOTENT. Chaque reçu (PurchaseId) est noté dans
--     la sauvegarde : un achat n'est jamais donné 2 fois, et jamais perdu (si la sauvegarde
--     échoue, Roblox redemandera plus tard).

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Gamepasses = require(Shared.Config.Gamepasses)
local Products = require(Shared.Config.Products)
local Upgrades = require(Shared.Config.Upgrades)
local Gamepass = Gamepasses

local Net = require(script.Parent.Parent.Lib.Net)
local Rewards = require(script.Parent.Parent.Lib.Rewards)
local DataService = require(script.Parent.DataService)
local IncubatorService = require(script.Parent.IncubatorService)
local PlanetService = require(script.Parent.PlanetService)

local ShopService = {}

local skipTarget: { [Player]: string } = {}

-- justBought = true seulement juste après un achat (pas à chaque connexion :
-- les timers sauvegardés tiennent déjà compte du pass)
local function setPass(player: Player, name: string, owned: boolean, justBought: boolean?)
	local before = player:GetAttribute("Pass_" .. name) == true
	player:SetAttribute("Pass_" .. name, owned)
	if owned and not before and justBought then
		if name == "FastHatch" then
			IncubatorService.Rescale(player, 1, Gamepass.FastHatch.Value)
		elseif name == "ExtraSlots" then
			PlanetService.EquipBest(player)
		end
	end
end

local function checkPasses(player: Player)
	for name, info in pairs(Gamepasses) do
		if info.Id and info.Id ~= 0 then
			local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, info.Id)
			if ok and owns then setPass(player, name, true) end
		end
	end
end

-- produit -> ce qu'il donne
local function grant(player: Player, key: string, info: any, data: any): boolean
	if info.Boost and info.Duration then
		Rewards.AddBoost(player, info.Boost, info.Duration)
	elseif key == "SkipOne" then
		if not IncubatorService.Skip(player, skipTarget[player]) then
			-- rien à accélérer : on rend la valeur en argent pour ne pas perdre l'achat
			Rewards.Give(player, { Type = "Money", Minutes = 10, Min = 1000 })
		end
		skipTarget[player] = nil
	elseif key == "SkipAll" then
		if not IncubatorService.SkipAll(player) then
			Rewards.Give(player, { Type = "Money", Minutes = 30, Min = 5000 })
		end
	elseif info.Minutes then
		Rewards.Give(player, { Type = "Money", Minutes = info.Minutes, Min = info.Min })
	elseif key == "StarterPack" then
		local g = info.Gives
		Rewards.Give(player, { Type = "Money", Amount = g.Money })
		if not data.StarterPack then
			IncubatorService.Give(player, g.Galaxy)
			Rewards.AddBoost(player, g.Boost, g.BoostDuration)
		end
		data.StarterPack = true
		DataService.Push(player, "StarterPack")
	elseif info.Galaxy then
		IncubatorService.Give(player, info.Galaxy)
	else
		return false
	end
	return true
end

local productById: { [number]: string } = {}
for key, info in pairs(Products) do
	if info.Id and info.Id ~= 0 then productById[info.Id] = key end
end

MarketplaceService.ProcessReceipt = function(receipt)
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local data = DataService.Get(player)
	if not data then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local purchaseId = tostring(receipt.PurchaseId)
	if DataService.HasReceipt(data, purchaseId) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	local key = productById[receipt.ProductId]
	if not key then
		warn("[ShopService] produit inconnu " .. receipt.ProductId)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local ok, granted = pcall(grant, player, key, Products[key], data)
	if not ok or not granted then
		warn("[ShopService] échec " .. key .. " : " .. tostring(granted))
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	DataService.AddReceipt(data, purchaseId)
	-- la sauvegarde DOIT réussir avant de dire "accordé" ; sinon Roblox redemandera
	-- (le reçu est déjà noté en mémoire : pas de double don dans cette session)
	if not DataService.SaveNow(player) then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	Net.Fire(player, "Purchased", { Key = key })
	Net.Notify(player, "Thanks for your purchase! (" .. Products[key].Name .. ")", "success")
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

function ShopService.Start()
	DataService.OnLoaded(function(player)
		checkPasses(player)
	end)
	Players.PlayerRemoving:Connect(function(p) skipTarget[p] = nil end)

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
		if not purchased then return end
		for name, info in pairs(Gamepasses) do
			if info.Id == passId then
				setPass(player, name, true, true)
				Net.Notify(player, "You now own " .. info.Name .. "!", "success")
			end
		end
	end)

	-- le client dit quelle galaxie il veut accélérer juste avant d'acheter "Skip"
	Net.On("SkipTarget", function(player, uid)
		if Net.IsString(uid, 16) then skipTarget[player] = uid end
	end, 4, 6)

	-- TESTS dans Studio uniquement : argent / pass gratuits pour essayer le jeu
	if RunService:IsStudio() then
		Net.On("Debug", function(player, what, value)
			local data = DataService.Get(player)
			if not data then return end
			if what == "Money" and Net.IsInt(value, 0, 1e15) then
				data.Money += value
				DataService.Push(player, "Money")
			elseif what == "Pass" and type(value) == "string" and Gamepasses[value] then
				setPass(player, value, not player:GetAttribute("Pass_" .. value), true)
			elseif what == "Product" and type(value) == "string" and Products[value] then
				grant(player, value, Products[value], data)
			elseif what == "SkipAll" then
				IncubatorService.SkipAll(player)
			end
		end, 10, 20)
	end
	local _ = Upgrades
end

return ShopService
