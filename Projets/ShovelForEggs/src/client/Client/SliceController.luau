--!strict
-- Client/SliceController : garde les contours du kit UI fins et réguliers
-- sur toutes les tailles d'écran (PC, mobile, tablette) et sur les GUI clonées.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local Slice9 = require(RS:WaitForChild("Shared"):WaitForChild("Util"):WaitForChild("Slice9"))

local tracked: { [Instance]: boolean } = setmetatable({}, { __mode = "k" }) :: any

local function track(g: Instance)
	if tracked[g] then return end
	if not (g:IsA("ImageLabel") or g:IsA("ImageButton")) then return end
	local img = g :: ImageLabel
	if not Slice9.IsKit(img.Image) then
		-- l'image peut changer plus tard (ex : bouton vert -> gris)
		local c
		c = img:GetPropertyChangedSignal("Image"):Connect(function()
			if Slice9.IsKit(img.Image) then
				c:Disconnect()
				track(img)
			end
		end)
		return
	end
	tracked[g] = true
	Slice9.Apply(img)
	img:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		Slice9.Apply(img)
	end)
	img:GetPropertyChangedSignal("Image"):Connect(function()
		Slice9.Apply(img)
	end)
end

local function watch(root: Instance)
	for _, d in ipairs(root:GetDescendants()) do track(d) end
	root.DescendantAdded:Connect(track)
end

local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
watch(pg)
watch(workspace)

return {}
