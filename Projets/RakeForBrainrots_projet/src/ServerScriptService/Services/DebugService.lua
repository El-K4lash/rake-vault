--!strict
-- ServerScriptService/Services/DebugService
-- Outils de test, UNIQUEMENT dans Studio (jamais en jeu publié) :
-- une BindableFunction ServerStorage.RFB_Debug appelable depuis la barre de commande serveur.
--   Debug:Invoke("money", 50000)
--   Debug:Invoke("brainrot", "Six Seven", "Rainbow")
--   Debug:Invoke("rebirths", 3)
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
	bf.Name = "RFB_Debug"
	bf.OnInvoke = function(cmd: string, a: any, b: any)
		local p = Players:GetPlayers()[1]
		local d = p and DataService.Get(p)
		if not d then return "pas de joueur" end
		if cmd == "money" then
			d.Money += a
			DataService.Push(p, "Money")
		elseif cmd == "brainrot" then
			HarvestService.AddBrainrot(p, d, a, b or "Normal")
			DataService.Push(p, "Brainrots")
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
		elseif cmd == "data" then
			return game:GetService("HttpService"):JSONEncode(d)
		end
		return "ok"
	end
	bf.Parent = ServerStorage
end

return DebugService
