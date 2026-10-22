-- tools/build_rakes.lua : à lancer UNE fois dans Studio (Edit), ServerStorage.Vault chargé.
-- Crée ReplicatedStorage.Assets.Rakes.Rake1..12 depuis les râteaux du Rake Vault (constellation "Outils") :
-- socle d'exposition retiré, tête tournée de 90° (dents perpendiculaires au manche), échelle 0.8, Handle invisible
-- le long du manche. Attributs lus par Client/RakeController : BottomY, HeadY, TeethLen (espace du Handle).
local U = require(game.ReplicatedStorage.Shared.Config.Upgrades:Clone()) -- clone : pas de cache require en Edit
local src = { "tools_rake_wood", "tools_rake_stone", "tools_rake_iron", "tools_rake_gold", "tools_rake_emerald", "tools_rake_ruby",
	"tools_rake_diamond", "tools_rake_lava", "tools_rake_ice", "tools_rake_void", "tools_rake_galaxy", "tools_rake_rainbow" }
local rakes = game.ReplicatedStorage.Assets.Rakes
local S = 0.8 -- assez long pour que le manche parte en biais de la main jusqu au sol devant
local MID, PIV, CUT, BOT, TOP = 6.05, 11.8, 11.45, 0.8, 11.3 -- repères des râteaux du vault (manche de 0.8 à 11.3)
local grip0 = CFrame.Angles(math.rad(90), 0, 0)
local out = {}
for _, t in ipairs(rakes:GetChildren()) do t:Destroy() end
for i, n in ipairs(src) do
	local m = game.ServerStorage.Vault.tools[n]:Clone()
	for _, p in ipairs(m:GetChildren()) do if p.Position.Y < 0.9 then p:Destroy() end end -- socle
	local maxY = -1e9
	local P = CFrame.new(0, PIV, 0)
	for _, p in ipairs(m:GetChildren()) do
		if p.Position.Y > CUT then
			local ey = math.abs(p.CFrame.RightVector.Y) * p.Size.X + math.abs(p.CFrame.UpVector.Y) * p.Size.Y + math.abs(p.CFrame.LookVector.Y) * p.Size.Z
			maxY = math.max(maxY, p.Position.Y + ey / 2)
			p.CFrame = P * CFrame.Angles(math.rad(-90), 0, 0) * P:ToObjectSpace(p.CFrame)
		end
	end
	m.WorldPivot = CFrame.new(0, MID, 0)
	m:ScaleTo(S)
	m:PivotTo(CFrame.new())
	local tool = Instance.new("Tool"); tool.Name = "Rake" .. i; tool.CanBeDropped = false; tool.RequiresHandle = true
	tool.ToolTip = U.Rakes[i].Name
	local L = (TOP - BOT) * S
	local hc = ((BOT + TOP) / 2 - MID) * S
	local h = Instance.new("Part"); h.Name = "Handle"; h.Size = Vector3.new(0.3, L, 0.3); h.Transparency = 1
	h.CanCollide = false; h.CanQuery = false; h.CanTouch = false; h.Massless = true
	h.CFrame = CFrame.new(0, hc, 0); h.Parent = tool
	local vis = Instance.new("Model"); vis.Name = "Visual"; vis.Parent = tool
	for _, p in ipairs(m:GetChildren()) do
		if p:IsA("BasePart") then
			p.Anchored = false; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.Massless = true; p.Parent = vis
			local w = Instance.new("WeldConstraint"); w.Part0 = h; w.Part1 = p; w.Parent = p
		end
	end
	m:Destroy()
	tool:SetAttribute("BottomY", (BOT - MID) * S - hc)
	tool:SetAttribute("HeadY", (PIV - MID) * S - hc)
	tool:SetAttribute("TeethLen", math.max(0.5, (maxY - PIV) * S))
	tool.Grip = CFrame.new(0, (BOT - MID) * S - hc + 0.8, 0) * grip0
	-- anneaux décoratifs du socle d'exposition restés au bas du manche
	for _, p in ipairs(vis:GetChildren()) do
		local r = h.CFrame:ToObjectSpace(p.CFrame)
		if r.Y < tool:GetAttribute("BottomY") + 1.65 * S and math.sqrt(r.X ^ 2 + r.Z ^ 2) > 0.82 * S then p:Destroy() end
	end
	tool.Parent = rakes
	table.insert(out, tool.Name .. "=" .. #vis:GetChildren())
end
return table.concat(out, " ")
