--!strict
-- ServerScriptService/Services/TutorialService
-- Progression du tutoriel des nouveaux joueurs (data.Tutorial = nombre d'étapes validées, 99 = fini ou passé).
-- Le client (Client/TutorialController) envoie "Tutorial" avec :
--   * n (nombre)  : étape n validée — accepté seulement si n = étape actuelle + 1 (pas de saut)
--   * "skip"      : tutoriel passé (pas de récompense)
--   * "done"      : fin — récompense donnée une seule fois, si toutes les étapes ont été validées
-- Les anciens joueurs (déjà avancés) ne le voient pas : marqué fini au chargement.
local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)
local Format = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared").Util.Format)

local TutorialService = {}
local STEPS = 7
local REWARD = 500
local DONE = 99

function TutorialService.Start()
	DataService.OnLoaded(function(player, data)
		data.Tutorial = data.Tutorial or 0
		if data.Tutorial < DONE and ((data.Rebirths or 0) > 0 or (data.Stats and data.Stats.Harvested or 0) > 60) then
			data.Tutorial = DONE
			DataService.Push(player, "Tutorial")
		end
	end)

	Net.On("Tutorial", function(player: Player, v: any)
		local data = DataService.Get(player)
		if not data or (data.Tutorial or 0) >= DONE then return end
		if v == "skip" then
			data.Tutorial = DONE
		elseif v == "done" then
			if data.Tutorial < STEPS then return end
			data.Tutorial = DONE
			data.Money += REWARD
			data.TotalEarned += REWARD
			DataService.Push(player, "Money")
			Net.Fire(player, "TutorialReward", REWARD)
			Net.Notify(player, "Tutorial complete! +" .. Format.Money(REWARD), "success")
		elseif type(v) == "number" and v == data.Tutorial + 1 and v <= STEPS then
			data.Tutorial = v
		else
			return
		end
		DataService.Push(player, "Tutorial")
	end, 2, 4)
end

return TutorialService
