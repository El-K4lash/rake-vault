local f = workspace:FindFirstChild("GrowAPlanet_Install") or game:GetService("Selection"):Get()[1]
for _, s in ipairs(f:GetChildren()) do
	if s.Name ~= "Tools" then
		local svc = s.Name == "StarterPlayerScripts" and game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterPlayerScripts") or game:GetService(s.Name)
		for _, c in ipairs(s:GetChildren()) do
			local old = svc:FindFirstChild(c.Name)
			if old then old:Destroy() end
			c.Parent = svc
		end
	end
end
print(require(f.Tools.MapBuilder))
print(require(f.Tools.GuiBuilder))
f:Destroy()
print("Grow a Planet installé ! Appuie sur Play.")
