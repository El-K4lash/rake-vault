--!strict
-- Client/PlotTagController : repère les bases (StarterGui.PlotTags, construit en instances).
--   * au-dessus du portail de chaque base occupée : tête du propriétaire + pseudo (taille en studs, visible à 120 studs)
--   * sur MA base : "YOUR BASE" en vert, contour vert, flèche qui rebondit
--   * panneaux UPGRADES / MY STATS des autres bases : couverture avec la tête et le pseudo du propriétaire
--     (les vrais panneaux sont des SurfaceGui perso, posés seulement sur sa propre base)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local tpl = pg:WaitForChild("PlotTags"):WaitForChild("Templates")
local TagTpl = tpl:WaitForChild("Tag") :: BillboardGui
local CoverTpl = tpl:WaitForChild("BoardCover") :: SurfaceGui
local plots = workspace:WaitForChild("Map"):WaitForChild("Plots")

-- (les BillboardGui / SurfaceGui ne s'affichent que posés directement dans le PlayerGui, pas dans un Folder)
type Entry = { tag: BillboardGui, covers: { SurfaceGui }, pen: Instance?, owner: number }
local entries: { [Instance]: Entry } = {}

local function headshot(uid: number): string
	return "rbxthumb://type=AvatarHeadShot&id=" .. uid .. "&w=150&h=150"
end

local function clearCovers(e: Entry)
	for _, c in ipairs(e.covers) do c:Destroy() end
	e.covers = {}
end

local function refresh(plot: Instance)
	local e = entries[plot]
	local owner = (plot:GetAttribute("Owner") :: number?) or 0
	local pen = plot:FindFirstChild("Pen")
	local root = plot:FindFirstChild("Root") :: BasePart?
	if owner == 0 or not pen or not root then
		if e then e.tag.Enabled = false; clearCovers(e) end
		return
	end
	if not e then
		local tag = TagTpl:Clone(); tag.Name = "PlotTag_" .. plot.Name; tag.Parent = pg
		e = { tag = tag, covers = {}, pen = nil, owner = 0 }
		entries[plot] = e
	end
	local entry = e :: Entry
	local mine = owner == player.UserId
	local p = Players:GetPlayerByUserId(owner)
	local name = p and p.DisplayName or "Player"
	-- étiquette au-dessus du portail
	local gate = pen:FindFirstChild("Gate")
	local top = 14
	if gate and gate:IsA("Model") then
		local cf, sz = gate:GetBoundingBox()
		top = cf.Position.Y + sz.Y / 2 - root.Position.Y
	end
	local tag = entry.tag
	tag.Adornee = root
	tag.StudsOffsetWorldSpace = Vector3.new(0, top + 6, 0)
	tag.Enabled = true
	local holder = tag:FindFirstChild("Holder") :: Frame
	local av = holder:FindFirstChild("Avatar") :: ImageLabel
	av.Image = headshot(owner)
	local ring = av:FindFirstChild("Ring") :: UIStroke
	ring.Color = mine and Color3.fromRGB(90, 255, 110) or Color3.new(1, 1, 1)
	local title = holder:FindFirstChild("Title") :: TextLabel
	title.Text = mine and "YOUR BASE" or name
	title.TextColor3 = mine and Color3.fromRGB(110, 255, 120) or Color3.new(1, 1, 1)
	local sub = holder:FindFirstChild("Sub") :: TextLabel
	sub.Text = mine and "▼" or ""
	sub.TextColor3 = Color3.fromRGB(110, 255, 120)
	tag:SetAttribute("Mine", mine)
	-- couvertures des panneaux (bases des autres)
	if entry.pen ~= pen or entry.owner ~= owner then
		clearCovers(entry)
		entry.pen = pen; entry.owner = owner
		if not mine then
			for _, pair in ipairs({ { "UpgradeBoard", "UPGRADES" }, { "StatsBoard", "STATS" } }) do
				local b = pen:FindFirstChild(pair[1], true)
				if b and b:IsA("BasePart") then
					local c = CoverTpl:Clone()
					c.Adornee = b; c.Enabled = true
					local bg = c:FindFirstChild("Bg") :: Frame
					(bg:FindFirstChild("Avatar") :: ImageLabel).Image = headshot(owner);
					(bg:FindFirstChild("Title") :: TextLabel).Text = string.upper(name) .. "'S PEN";
					(bg:FindFirstChild("Sub") :: TextLabel).Text = pair[2]
					c.Name = "BoardCover_" .. plot.Name; c.Parent = pg
					table.insert(entry.covers, c)
				end
			end
		end
	end
end

local function watch(plot: Instance)
	plot:GetAttributeChangedSignal("Owner"):Connect(function() refresh(plot) end)
	plot.ChildAdded:Connect(function(c) if c.Name == "Pen" then task.wait(0.3); refresh(plot) end end)
	refresh(plot)
end
for _, p in ipairs(plots:GetChildren()) do watch(p) end
plots.ChildAdded:Connect(watch)
Players.PlayerAdded:Connect(function() task.wait(1); for p in pairs(entries) do refresh(p) end end)
-- filet de sécurité (enclos reconstruits, pseudo chargé en retard)
task.spawn(function()
	while true do
		task.wait(2)
		for _, p in ipairs(plots:GetChildren()) do refresh(p) end
	end
end)

-- MA base : l'étiquette rebondit doucement
local t = 0
RunService.RenderStepped:Connect(function(dt)
	t += dt
	for _, e in pairs(entries) do
		if e.tag:GetAttribute("Mine") then
			local holder = e.tag:FindFirstChild("Holder") :: Frame
			holder.Position = UDim2.fromScale(0, -math.abs(math.sin(t * 3)) * 0.06)
		end
	end
end)

return true
