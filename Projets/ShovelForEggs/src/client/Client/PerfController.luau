--!strict
-- Client/PerfController : téléphones / tablettes -> moins de particules (le jeu en met beaucoup : neige, tempête,
-- étincelles des œufs...). Divise le débit de chaque ParticleEmitter par 2 (et coupe les très gros
-- débits), et réduit le niveau de qualité des ombres. Rien ne change sur ordinateur.
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
if not mobile then return true end

local FACTOR, CAP = 0.5, 40
local function tame(d: Instance)
	if d:IsA("ParticleEmitter") and d:GetAttribute("PerfRate") == nil then
		d:SetAttribute("PerfRate", d.Rate)
		d.Rate = math.min(d.Rate * FACTOR, CAP)
		-- si un script change le débit plus tard, on le ré-applique
		d:GetPropertyChangedSignal("Rate"):Connect(function()
			local want = math.min(d.Rate, CAP)
			if d.Rate > CAP then d.Rate = want end
		end)
	end
end
for _, d in ipairs(workspace:GetDescendants()) do tame(d) end
workspace.DescendantAdded:Connect(tame)
Lighting.GlobalShadows = true
local sh = Lighting:FindFirstChildOfClass("BloomEffect")
if sh then sh.Size = math.min(sh.Size, 16) end
return true
