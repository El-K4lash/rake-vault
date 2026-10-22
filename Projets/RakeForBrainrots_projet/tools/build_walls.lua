-- tools/build_walls.lua : murs invisibles (Edit, une fois).
--   * autour de chaque zone, sur la ligne de clôture : on ne passe que par l'arche (barrière "Gate") ou
--     par la sortie arrière (barrière invisible "GateBack", même rebirth requis : impossible d'entrer par derrière)
--   * au-dessus des ouvertures (on ne saute pas par-dessus l'arche)
--   * tout autour de l'île (on ne tombe pas à la mer)
local Zones = require(game.ReplicatedStorage.Shared.Config.Zones:Clone())
local MAP = workspace.Map
local old = MAP:FindFirstChild("Walls"); if old then old:Destroy() end
local walls = Instance.new("Folder"); walls.Name = "Walls"; walls.Parent = MAP
local TOP = 90
local function wall(name, a, b, y0, y1, parent)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.CanCollide = true; p.CanQuery = false; p.CanTouch = false
	p.Transparency = 1; p.CastShadow = false
	local len = (b - a).Magnitude
	p.Size = Vector3.new(1, y1 - y0, len)
	p.CFrame = CFrame.lookAt((a + b) / 2, b) + Vector3.new(0, (y0 + y1) / 2, 0)
	p.Parent = parent or walls
	return p
end
local V = function(x, z) return Vector3.new(x, 0, z) end
local OPEN = 7.7 -- demi-largeur de l'ouverture entre les piliers
local last = 0
for _, z in ipairs(Zones.List) do if z.Order > last then last = z.Order end end
for _, z in ipairs(Zones.List) do
	local zf = MAP.Zones:FindFirstChild(z.Id)
	local c, H = z.Center.Z, z.Size / 2 + 0.5
	wall(z.Id .. "_L", V(-H, c - H), V(-H, c + H), 0, TOP)
	wall(z.Id .. "_R", V(H, c - H), V(H, c + H), 0, TOP)
	-- avant
	wall(z.Id .. "_F1", V(-H, c - H), V(-OPEN, c - H), 0, TOP)
	wall(z.Id .. "_F2", V(OPEN, c - H), V(H, c - H), 0, TOP)
	wall(z.Id .. "_FTop", V(-OPEN, c - H), V(OPEN, c - H), 11.9, TOP)
	local oldBack = zf:FindFirstChild("GateBack"); if oldBack then oldBack:Destroy() end
	if z.Order < last then
		wall(z.Id .. "_B1", V(-H, c + H), V(-OPEN, c + H), 0, TOP)
		wall(z.Id .. "_B2", V(OPEN, c + H), V(H, c + H), 0, TOP)
		wall(z.Id .. "_BTop", V(-OPEN, c + H), V(OPEN, c + H), 9.5, TOP)
		local gb = wall("GateBack", V(-OPEN, c + H), V(OPEN, c + H), 0, 9.5, zf)
		gb:SetAttribute("Rebirths", z.Rebirths)
	else
		wall(z.Id .. "_B", V(-H, c + H), V(H, c + H), 0, TOP)
	end
end
-- île (bords à x = ±510, z = 315 ± 510)
local cz, h = 315, 510
wall("Island_N", V(-h, cz - h), V(h, cz - h), -10, TOP)
wall("Island_S", V(-h, cz + h), V(h, cz + h), -10, TOP)
wall("Island_W", V(-h, cz - h), V(-h, cz + h), -10, TOP)
wall("Island_E", V(h, cz - h), V(h, cz + h), -10, TOP)
return #walls:GetChildren() .. " murs"
