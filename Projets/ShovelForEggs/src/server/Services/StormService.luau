--!strict
-- ServerScriptService/Services/StormService
-- Les tempêtes, raison de rester et de revenir :
--   * Tempête de neige (toutes les Storm.Every secondes, dure Storm.Duration) : la neige retombe = toutes les zones
--     de tous les joueurs se remplissent à 100 % (WorldService.RefillAll). Annoncée 20 s avant.
--   * Tempête dorée (1 chance sur Storm.GoldenOneIn à chaque tempête, ou commande admin) : pendant Storm.GoldenDuration,
--     luck x3 (attribut workspace EventLuck, déjà lu par Stats.ServerEvent) ; un œuf trouvé a 40 % de chance d'être
--     celui de la zone du dessus, et les ŒUFS DORÉS ne sortent QUE dans la dernière zone (StormService.EggFor).
-- Le client (StormController) lit les attributs de workspace : StormKind ("" / "Snow" / "Golden"), StormEnd, NextStorm (os.time()).

local Players = game:GetService("Players")

local Net = require(script.Parent.Parent.Lib.Net)
local Events = require(game:GetService("ReplicatedStorage").Shared.Config.Events)

local StormService = {}

local Storm = {
	Every = 8 * 60,       -- secondes entre deux tempêtes
	Duration = 45,        -- durée d'une tempête de neige
	Warning = 20,         -- annonce avant la tempête
	GoldenOneIn = 6,      -- 1 tempête sur 6 est dorée
	GoldenDuration = 120, -- durée de la tempête dorée
	GoldenLuck = 3,       -- multiplicateur de chance pendant la dorée
}
StormService.Config = Storm

local kind: string = ""
local rng = Random.new()

local function broadcast(name: string, payload: any)
	for _, p in ipairs(Players:GetPlayers()) do Net.Fire(p, name, payload) end
end

function StormService.IsGolden(): boolean
	return kind == "Golden"
end

-- œuf trouvé pendant une tempête dorée (sinon l'œuf de la zone) :
--   * dernière zone (Pôle Nord) : œuf DORÉ — c'est la seule zone où on en trouve en creusant ;
--   * autres zones : GoldenUpChance de chance d'avoir l'œuf de la zone du DESSUS, sinon l'œuf normal
--     (la luck x3 de la tempête s'applique en plus).
Storm.GoldenUpChance = 0.4
function StormService.EggFor(zoneId: string, baseEgg: string): string
	if kind ~= "Golden" then return baseEgg end
	local Zones = require(game:GetService("ReplicatedStorage").Shared.Config.Zones) :: any
	local list = Zones.List
	local idx = 0
	for i, z in ipairs(list) do if z.Id == zoneId then idx = i break end end
	if idx == 0 then return baseEgg end
	if idx == #list then return "GoldenEgg" end
	if rng:NextNumber() < Storm.GoldenUpChance then
		return list[idx + 1].Egg or baseEgg
	end
	return baseEgg
end

function StormService.Kind(): string
	return kind
end

local function setKind(k: string, endsAt: number)
	kind = k
	workspace:SetAttribute("StormKind", k)
	workspace:SetAttribute("StormEnd", endsAt)
end

-- lance une tempête maintenant (golden = true pour forcer une dorée, panel admin / commande Debug)
function StormService.Trigger(golden: boolean?)
	local WorldService = require(script.Parent.WorldService) :: any
	-- week-end de lancement : toutes les tempêtes automatiques sont dorées
	local isGolden = golden == true or (golden == nil and (Events.LaunchActive(os.time()) or rng:NextInteger(1, Storm.GoldenOneIn) == 1))
	local dur = isGolden and Storm.GoldenDuration or Storm.Duration
	local endsAt = os.time() + dur
	setKind(isGolden and "Golden" or "Snow", endsAt)
	if isGolden then
		workspace:SetAttribute("EventLuck", Storm.GoldenLuck)
		workspace:SetAttribute("EventLuckEnd", endsAt)
	end
	-- la neige retombe : toutes les zones se remplissent
	local n = WorldService.RefillAll()
	broadcast("StormStart", { Kind = kind, Duration = dur, Refilled = n })
	for _, p in ipairs(Players:GetPlayers()) do
		Net.Notify(p, isGolden and "GOLDEN STORM! Golden eggs are falling!" or "Snow storm! All zones are full of snow again!", isGolden and "rune" or "info")
	end
	task.delay(dur, function()
		if workspace:GetAttribute("StormEnd") == endsAt then
			setKind("", 0)
			broadcast("StormEnd", nil)
		end
	end)
end

-- arrête la tempête en cours (panel admin)
function StormService.Stop(): boolean
	if kind == "" then return false end
	if kind == "Golden" then
		workspace:SetAttribute("EventLuck", nil)
		workspace:SetAttribute("EventLuckEnd", nil)
	end
	setKind("", 0)
	broadcast("StormEnd", nil)
	return true
end

function StormService.Start()
	setKind("", 0)
	task.spawn(function()
		while true do
			local every = Events.LaunchActive(os.time()) and Events.Launch.StormEvery or Storm.Every
			workspace:SetAttribute("LaunchEvent", Events.LaunchActive(os.time()))
			local nextAt = os.time() + every
			workspace:SetAttribute("NextStorm", nextAt)
			task.wait(math.max(1, every - Storm.Warning))
			broadcast("StormWarning", { In = Storm.Warning })
			task.wait(Storm.Warning)
			local ok, err = pcall(StormService.Trigger)
			if not ok then warn("[StormService] " .. tostring(err)) end
			-- on attend la fin avant de relancer le compte à rebours
			task.wait((kind == "Golden" and Storm.GoldenDuration or Storm.Duration) + 1)
		end
	end)
end

return StormService
