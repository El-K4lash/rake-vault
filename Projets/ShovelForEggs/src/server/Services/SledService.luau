--!strict
-- ServerScriptService/Services/SledService
-- Le traîneau visible : le joueur le traîne derrière lui SEULEMENT dans les zones de neige (Zones.At).
-- Modèle Assets.Sleds.Sled<niveau> (tools/build_sleds.lua) : meilleur traîneau acheté = plus grand, plus détaillé.
--   * soudé au joueur par une Weld "SledWeld" (root -> Base) : le client (SledAnimController) anime son C0
--     (suit le sol et les pentes, balance, traîne en virage) ; tout le reste est soudé à Base.
--   * chargement : les morceaux de Cargo (attribut Order) apparaissent un par un selon SledItems / capacité,
--     et prennent la couleur des objets vraiment ramassés (neige blanche, cristaux, charmes...).
-- Tout est côté serveur (tout le monde voit le même traîneau et le même chargement).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Zones = require(Shared.Config.Zones)
local Items = require(Shared.Config.Items)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)

local SledService = {}
local SCALE = 0.85
type Cur = { Model: Model, Level: number, Shown: number, Sig: string, Cargo: { BasePart } }
local current: { [Player]: Cur } = {}

local function clear(player: Player)
	local c = current[player]
	if c and c.Model.Parent then c.Model:Destroy() end
	current[player] = nil
end

local function attach(player: Player, data: any)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end
	local folder = ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("Sleds")
	local lvl = math.max(1, data.Sled or 1)
	local tpl = folder and (folder:FindFirstChild("Sled" .. lvl) or folder:FindFirstChild("Sled1")) :: Model?
	if not tpl then return end
	clear(player)
	local m = tpl:Clone()
	m.Name = "Sled"
	m:ScaleTo(SCALE)
	local base = m:FindFirstChild("Base") :: BasePart?
	if not base then m:Destroy(); return end
	local len = ((m:GetAttribute("Length") :: number?) or 5) * SCALE
	-- position de départ : au sol derrière le joueur, l'avant (-Z) tourné vers lui (le client l'anime ensuite)
	local hip = hum.HipHeight + root.Size.Y / 2
	local off = CFrame.new(0, -hip + 0.05, len / 2 + 1.8)
	m:PivotTo(root.CFrame * off)
	local cargo: { BasePart } = {}
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then
			d.Anchored = false; d.CanCollide = false; d.CanQuery = false; d.CanTouch = false; d.Massless = true
			if d ~= base then
				local w = Instance.new("WeldConstraint"); w.Part0 = base; w.Part1 = d; w.Parent = d
			end
			if d:GetAttribute("Order") then d.Transparency = 1; table.insert(cargo, d) end
		end
	end
	table.sort(cargo, function(a, b) return (a:GetAttribute("Order") :: number) < (b:GetAttribute("Order") :: number) end)
	local weld = Instance.new("Weld")
	weld.Name = "SledWeld"; weld.Part0 = root; weld.Part1 = base; weld.C0 = off
	weld.Parent = base
	m:SetAttribute("Hip", hip)
	m:SetAttribute("Back", len / 2 + 1.8)
	m:SetAttribute("Owner", player.UserId)
	m.Parent = char
	current[player] = { Model = m, Level = lvl, Shown = 0, Sig = "", Cargo = cargo }
end

-- couleurs du chargement : une couleur par objet ramassé (proportionnel), la neige reste blanche
local function cargoColors(data: any, n: number): { Color3 }
	local list: { { c: Color3, k: number } } = {}
	local total = 0
	for key, count in pairs(data.SledItems) do
		local id = string.match(key, "^(.-)@") or key
		local def = Items.ById[id]
		if def and count > 0 then
			table.insert(list, { c = def.Color, k = count })
			total += count
		end
	end
	table.sort(list, function(a, b) return a.k > b.k end)
	local out: { Color3 } = {}
	if total == 0 then return out end
	for _, e in ipairs(list) do
		local share = math.max(1, math.floor(e.k / total * n + 0.5))
		for _ = 1, share do table.insert(out, e.c) end
	end
	return out
end

local function setFill(player: Player, data: any)
	local c = current[player]
	if not c or not c.Model.Parent then return end
	local cap = Stats.SledCapacity(data)
	local count = Stats.SledCount(data)
	local n = #c.Cargo
	local shown = cap > 0 and math.clamp(math.ceil(count / cap * n), 0, n) or 0
	if count > 0 and shown == 0 then shown = 1 end
	local colors = cargoColors(data, shown)
	local sig = shown .. ":" .. #colors
	if shown == c.Shown and sig == c.Sig then return end
	c.Shown = shown; c.Sig = sig
	-- mélange stable des couleurs : les objets rares ressortent un peu partout dans le tas
	for i, p in ipairs(c.Cargo) do
		if i <= shown then
			p.Transparency = 0
			local col = colors[((i * 7) % math.max(1, #colors)) + 1]
			if col then
				p.Color = col
				local rare = col.R + col.G + col.B < 2.6
				p.Material = rare and Enum.Material.Neon or Enum.Material.Plastic
			end
		else
			p.Transparency = 1
		end
	end
end

local function inZone(player: Player): boolean
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	return root ~= nil and Zones.At(root.Position) ~= nil
end

function SledService.Refresh(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local c = current[player]
	if not inZone(player) then
		if c then clear(player) end
		return
	end
	if not c or not c.Model.Parent or c.Level ~= (data.Sled or 1) then attach(player, data) end
	setFill(player, data)
end

function SledService.Start()
	DataService.OnLoaded(function(player, _data)
		player.CharacterAdded:Connect(function() clear(player) end)
	end)
	Players.PlayerRemoving:Connect(clear)
	-- zone / remplissage / changement de traîneau : vérifié 4 fois par seconde (calcul très léger)
	task.spawn(function()
		while true do
			task.wait(0.25)
			for _, p in ipairs(Players:GetPlayers()) do
				local ok, err = pcall(SledService.Refresh, p)
				if not ok then warn("[SledService] " .. tostring(err)) end
			end
		end
	end)
end

return SledService
