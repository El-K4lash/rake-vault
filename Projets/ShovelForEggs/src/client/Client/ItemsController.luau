--!strict
-- Client/ItemsController : dessine les objets à ratisser PERSONNELS du joueur (envoyés par WorldService).
-- Ils n'existent que sur ce client : les autres joueurs ne les voient pas. Chaque objet = hitbox invisible
-- (tag "Item", attributs ItemId / ZoneId / Pond / Kind) + modèle 3D soudé (Assets.ItemModels.<ItemId>).
-- Le ramassage reste décidé par le serveur (WorldService.Near / Take).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Items = require(Shared.Config.Items)
local State = require(script.Parent.State)

local folder = Instance.new("Folder")
folder.Name = "MyItems"
folder.Parent = workspace

local SHAPES = { Block = Enum.PartType.Block, Ball = Enum.PartType.Ball, Cylinder = Enum.PartType.Cylinder }
local itemModels = ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("ItemModels")
local parts: { [number]: BasePart } = {}

local function make(r: any)
	if parts[r.U] then return end
	local def = Items.ById[r.I]
	if not def then return end
	local tpl = itemModels and itemModels:FindFirstChild(r.I) :: Model?
	local p = Instance.new("Part")
	p.Name = def.Name
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	if tpl then
		p.Size = Vector3.new(def.Size, def.Size, def.Size) * 1.4
		p.Transparency = 1
	else
		p.Shape = SHAPES[def.Shape] or Enum.PartType.Block
		p.Size = Vector3.new(def.Size, def.Size, def.Size)
		p.Color = def.Color
		p.Material = def.Neon and Enum.Material.Neon or Enum.Material.Plastic
	end
	p:SetAttribute("ItemId", r.I)
	p:SetAttribute("ZoneId", r.Z)
	p:SetAttribute("Pond", r.P)
	p:SetAttribute("Kind", def.Kind)
	p:SetAttribute("Uid", r.U)
	local base = CFrame.new(r.X, r.Y, r.W) * CFrame.Angles(0, r.R, 0)
	p.CFrame = base * CFrame.new(0, p.Size.Y / 2, 0)
	if tpl then
		local m = tpl:Clone()
		m.Name = "Visual"
		m:PivotTo(base)
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") then
				d.Anchored = false; d.Massless = true; d.CanCollide = false; d.CanQuery = false; d.CanTouch = false
				local w = Instance.new("WeldConstraint"); w.Part0 = p; w.Part1 = d; w.Parent = d
			end
		end
		m.Parent = p
		-- les objets rares brillent
		if def.Kind ~= "Junk" and def.Kind ~= "Snow" then
			local att = Instance.new("Attachment"); att.Parent = p
			local sp = Instance.new("ParticleEmitter")
			sp.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			sp.Color = ColorSequence.new(def.Color)
			sp.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 0) })
			sp.Lifetime = NumberRange.new(0.6, 1)
			sp.Rate = 4; sp.Speed = NumberRange.new(0.5, 1.5); sp.SpreadAngle = Vector2.new(180, 180)
			sp.LightEmission = 1
			sp.Parent = att
		end
	end
	CollectionService:AddTag(p, "Item")
	p.Parent = folder
	parts[r.U] = p
end

local function remove(u: number)
	local p = parts[u]
	if p then p:Destroy(); parts[u] = nil end
end

State.Event.Event:Connect(function(name: string, payload: any)
	if name == "ItemAdd" then
		for _, r in ipairs(payload) do make(r) end
	elseif name == "ItemDel" then
		for _, u in ipairs(payload) do remove(u) end
	elseif name == "ItemSync" then
		local keep: { [number]: boolean } = {}
		for _, r in ipairs(payload) do keep[r.U] = true; make(r) end
		for u in pairs(parts) do if not keep[u] then remove(u) end end
	end
end)

-- on demande la liste complète (ce qui a été envoyé avant que ce contrôleur écoute)
State.Send("ItemsSync")

return true
