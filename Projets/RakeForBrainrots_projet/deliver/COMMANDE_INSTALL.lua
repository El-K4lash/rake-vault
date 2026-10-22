-- RAKE FOR BRAINROTS — installation (à coller dans la barre de commande de Studio, mode Édition)
-- 1) Glisse deliver/RakeForBrainrots.rbxmx dans Studio (il apparaît dans Workspace sous le nom RakeForBrainrots_Install)
-- 2) Colle cette commande et Entrée. 3) Play.
local f = workspace:FindFirstChild("RakeForBrainrots_Install") or game:GetService("Selection"):Get()[1]
assert(f, "Glisse d'abord RakeForBrainrots.rbxmx dans Workspace")
local function svcOf(name)
	if name == "StarterPlayerScripts" then return game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterPlayerScripts") end
	if name == "Workspace" then return workspace end
	return game:GetService(name)
end
for _, folder in ipairs(f:GetChildren()) do
	local svc = svcOf(folder.Name)
	for _, c in ipairs(folder:GetChildren()) do
		local old = svc:FindFirstChild(c.Name)
		if old then old:Destroy() end
		c.Parent = svc
	end
end
for _, n in ipairs({ "Baseplate", "SpawnLocation" }) do
	local o = workspace:FindFirstChild(n)
	if o and o.Parent == workspace then o:Destroy() end
end
local L = game:GetService("Lighting")
L.ClockTime = 14.5; L.Brightness = 2.5; L.EnvironmentDiffuseScale = 0.6; L.EnvironmentSpecularScale = 0.6
L.OutdoorAmbient = Color3.fromRGB(140, 140, 160); L.Ambient = Color3.fromRGB(90, 90, 110)
if not L:FindFirstChildOfClass("Atmosphere") then local a = Instance.new("Atmosphere"); a.Density = 0.25; a.Haze = 1; a.Parent = L end
if not L:FindFirstChildOfClass("BloomEffect") then local b = Instance.new("BloomEffect"); b.Intensity = 0.4; b.Size = 24; b.Threshold = 1.2; b.Parent = L end
workspace.StreamingEnabled = false
f:Destroy()
print("Rake for Brainrots installé ! Appuie sur Play. (Game Settings > Security > Enable Studio Access to API Services pour la sauvegarde)")
