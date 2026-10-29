--!strict
-- Client/HotbarController : barre d'inventaire du jeu (remplace celle de Roblox).
-- Inspirée de lib/systems/CustomHotbar : touches 1..9 ou clic = équiper / ranger. Les cases sont de vraies
-- instances (StarterGui.Hotbar.Bar.Slot1..9) ; ici on ne fait que les remplir (modèle 3D, nom, quantité).
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local UI = require(script.Parent.UI)
local Eggs = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("Eggs"))
local eggFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):FindFirstChild("Eggs")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("Hotbar") :: ScreenGui
local bar = gui:WaitForChild("Bar") :: Frame

pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false) end)

local KEYS = {
	[Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3, [Enum.KeyCode.Four] = 4, [Enum.KeyCode.Five] = 5,
	[Enum.KeyCode.Six] = 6, [Enum.KeyCode.Seven] = 7, [Enum.KeyCode.Eight] = 8, [Enum.KeyCode.Nine] = 9,
}
local slots: { Tool? } = {}   -- index de case -> outil
local slotOf: { [Tool]: number } = {}
local shownModel: { [number]: Tool? } = {}

local function character(): Model? return player.Character end
local function humanoid(): Humanoid?
	local c = character()
	return c and c:FindFirstChildOfClass("Humanoid") or nil
end

-- nom affiché : "Beach Egg x3" -> "Beach Egg" + quantité à part
local function label(tool: Tool): (string, string)
	local n = tool:GetAttribute("Count") :: number?
	local name = tool.Name:gsub(" x%d+$", "")
	return name, (n and n > 1) and ("x" .. n) or ""
end

-- modèle 3D de l'outil dans la case (copie visuelle : uniquement les pièces)
local function showTool(i: number, vp: ViewportFrame, tool: Tool?)
	if shownModel[i] == tool then return end
	shownModel[i] = tool
	if not tool then UI.ShowModel(vp, nil); return end
	-- œuf : on montre le modèle de l'œuf debout (pas la copie tenue en main, qui est penchée)
	local eggId = tool:GetAttribute("EggId")
	if eggId then
		local def = Eggs.ById[eggId :: string]
		local tpl = def and eggFolder and eggFolder:FindFirstChild(def.Model) :: Model?
		if tpl then UI.ShowModel(vp, tpl, false, 0.9); return end
	end
	local m = Instance.new("Model")
	for _, d in ipairs(tool:GetDescendants()) do
		if d:IsA("BasePart") and d.Transparency < 1 then
			local p = d:Clone()
			for _, k in ipairs(p:GetChildren()) do if not (k:IsA("SpecialMesh") or k:IsA("Decal") or k:IsA("Texture") or k:IsA("SurfaceAppearance")) then k:Destroy() end end
			p.Anchored = true
			p.Parent = m
		end
	end
	if #m:GetChildren() == 0 then UI.ShowModel(vp, nil); return end
	UI.ShowModel(vp, m, false, 0.88)
	m:Destroy()
end

local function refresh()
	local char = character()
	for i = 1, 9 do
		local b = bar:FindFirstChild("Slot" .. i) :: ImageButton?
		if not b then continue end
		local tool = slots[i]
		if tool and not tool.Parent then slots[i] = nil; slotOf[tool] = nil; tool = nil end
		b.Visible = tool ~= nil
		if tool then
			local name, count = label(tool)
			local nameL = b:FindFirstChild("ToolName") :: TextLabel
			local countL = b:FindFirstChild("Count") :: TextLabel
			local sel = b:FindFirstChild("Sel") :: UIStroke
			nameL.Text = name
			countL.Text = count
			local equipped = char ~= nil and tool.Parent == char
			sel.Enabled = equipped
			b.ImageColor3 = equipped and Color3.fromRGB(64, 120, 78) or Color3.fromRGB(70, 74, 92)
			local pop = b:FindFirstChild("Pop") :: UIScale
			TweenService:Create(pop, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Scale = equipped and 1.1 or 1 }):Play()
		end
		showTool(i, b:FindFirstChild("View") :: ViewportFrame, tool)
	end
end

local function add(tool: Instance)
	if not tool:IsA("Tool") or slotOf[tool] then return end
	-- le râteau est toujours en case 1 (quand on l'améliore, le nouveau arrive avant que l'ancien soit retiré)
	if tool:GetAttribute("Shovel") then
		local cur = slots[1]
		if cur and cur ~= tool then
			slotOf[cur] = nil
			slots[1] = nil
			if cur.Parent and not cur:GetAttribute("Shovel") then
				for j = 2, 9 do if not slots[j] then slots[j] = cur; slotOf[cur] = j; break end end
			end
		end
		for j = 2, 9 do if slots[j] and slots[j]:GetAttribute("Shovel") then slotOf[slots[j] :: Tool] = nil; slots[j] = nil end end
		slots[1] = tool; slotOf[tool] = 1
		tool:GetAttributeChangedSignal("Count"):Connect(refresh)
		tool:GetPropertyChangedSignal("Name"):Connect(refresh)
		refresh()
		return
	end
	for i = 2, 9 do
		if not slots[i] then
			slots[i] = tool; slotOf[tool] = i
			tool:GetAttributeChangedSignal("Count"):Connect(refresh)
			tool:GetPropertyChangedSignal("Name"):Connect(refresh)
			break
		end
	end
	refresh()
end

local function removed(tool: Instance)
	if not tool:IsA("Tool") then return end
	task.defer(function()
		local char = character()
		local bp = player:FindFirstChildOfClass("Backpack")
		if tool.Parent ~= char and tool.Parent ~= bp then
			local i = slotOf[tool :: Tool]
			if i then slots[i] = nil; slotOf[tool :: Tool] = nil end
		end
		refresh()
	end)
end

local function toggle(i: number)
	local tool = slots[i]
	local hum = humanoid()
	if not tool or not hum then return end
	if tool.Parent == character() then hum:UnequipTools() else hum:EquipTool(tool) end
	UI.Play("Click", 0.4)
end

local function watch(container: Instance)
	for _, t in ipairs(container:GetChildren()) do add(t) end
	container.ChildAdded:Connect(add)
	container.ChildRemoved:Connect(removed)
end

for i = 1, 9 do
	local b = bar:FindFirstChild("Slot" .. i) :: ImageButton?
	if b then b.Activated:Connect(function() toggle(i) end) end
end
UserInputService.InputBegan:Connect(function(input, processed)
	if processed or UserInputService:GetFocusedTextBox() then return end
	local i = KEYS[input.KeyCode]
	if i then toggle(i) end
end)

local function onCharacter(char: Model)
	watch(char)
	refresh()
end
local bp = player:WaitForChild("Backpack")
watch(bp)
player.ChildAdded:Connect(function(c) if c:IsA("Backpack") then watch(c) end end)
if player.Character then onCharacter(player.Character) end
player.CharacterAdded:Connect(onCharacter)

-- cachée quand un menu est ouvert (sinon elle passe sous le bas des fenêtres)
UI.Opened.Event:Connect(function(n) gui.Enabled = n == nil end)

-- petits écrans : barre un peu plus petite
local cam = workspace.CurrentCamera
local function fit()
	local fitScale = bar:FindFirstChild("Fit") :: UIScale
	fitScale.Scale = math.clamp(cam.ViewportSize.X / 1100, 0.7, 1.15)
	-- bouton AUTO au-dessus de la barre : même échelle
	local holder = gui:FindFirstChild("AutoHolder")
	local hs = holder and holder:FindFirstChild("Fit") :: UIScale?
	if hs then hs.Scale = fitScale.Scale end
end
cam:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
fit()

return true
