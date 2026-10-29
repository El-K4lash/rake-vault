--!strict
-- ServerScriptService/Services/DebugService
-- Outils de test, UNIQUEMENT dans Studio (jamais en jeu publié) :
-- une BindableFunction ServerStorage.SFE_Debug appelable depuis la barre de commande serveur.
--   Debug:Invoke("money", 50000)
--   Debug:Invoke("pet", "Snow Owl", "Frost")   Debug:Invoke("storm", "golden")   Debug:Invoke("tutorial", 0)   Debug:Invoke("reset")
--   Debug:Invoke("rebirths", 3)   Debug:Invoke("shovel", 12)   Debug:Invoke("sled", 5)
--   Debug:Invoke("advent", 12) (jour forcé, nil = vraie date)   Debug:Invoke("xp", 5000)   Debug:Invoke("quests")   Debug:Invoke("starter")   Debug:Invoke("pass", "WinterPass")
--   Debug:Invoke("data") -> copie des données
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local DataService = require(script.Parent.DataService)
local HarvestService = require(script.Parent.HarvestService)
local PlotService = require(script.Parent.PlotService)

local DebugService = {}

function DebugService.Start()
	if not RunService:IsStudio() then return end
	local bf = Instance.new("BindableFunction")
	bf.Name = "SFE_Debug"
	bf.OnInvoke = function(cmd: string, a: any, b: any)
		local p = Players:GetPlayers()[1]
		local d = p and DataService.Get(p)
		if not d then return "pas de joueur" end
		if cmd == "money" then
			d.Money += a
			DataService.Push(p, "Money")
		elseif cmd == "pet" then
			HarvestService.AddPet(p, d, a, b or "Normal")
			DataService.Push(p, "Pets")
			DataService.Push(p, "Index")
		elseif cmd == "rebirths" then
			d.Rebirths = a
			DataService.Push(p)
			PlotService.Refresh(p)
		elseif cmd == "egg" then
			d.Eggs[a] = (d.Eggs[a] or 0) + (b or 1)
			DataService.Push(p, "Eggs")
			local EggService = require(script.Parent.EggService) :: any
			EggService.SyncTools(p, d)
		elseif cmd == "shovel" then
			d.Shovel = a
			DataService.Push(p)
			HarvestService.GiveShovel(p, d)
		elseif cmd == "sled" then
			d.Sled = a
			DataService.Push(p)
		elseif cmd == "advent" then
			workspace:SetAttribute("AdventDayOverride", a) -- nil pour revenir à la vraie date
		elseif cmd == "xp" then
			local RewardsService = require(script.Parent.RewardsService) :: any
			RewardsService.Grant(p, d, { Kind = "XP", Amount = a or 1000 })
		elseif cmd == "quests" then
			d.Quests = { Day = "", List = {}, Bonus = false }
			local RewardsService = require(script.Parent.RewardsService) :: any
			RewardsService.EnsureQuests(p, d)
		elseif cmd == "starter" then
			d.StarterBought = false; d.Stats.Playtime = 9999
		elseif cmd == "pass" then
			d.Passes[a or "WinterPass"] = true
			DataService.Push(p, "Passes")
		elseif cmd == "hatchall" then
			for _, inc in pairs(d.Incubating) do inc.HatchAt = os.time() end
		elseif cmd == "slots" then
			d.Slots = a
			DataService.Push(p, "Slots")
			PlotService.Refresh(p)
		elseif cmd == "fence" then
			d.Fences[a] = true; d.Fence = a
			DataService.Push(p)
			PlotService.Refresh(p)
		elseif cmd == "tutorial" then
			d.Tutorial = a or 0
			DataService.Push(p, "Tutorial")
		elseif cmd == "reset" then
			return tostring(DataService.ResetData(p))
		elseif cmd == "storm" then
			local StormService = require(script.Parent.StormService) :: any
			StormService.Trigger(a == "golden")
		elseif cmd == "data" then
			return game:GetService("HttpService"):JSONEncode(d)
		end
		return "ok"
	end
	bf.Parent = ServerStorage
end

return DebugService
