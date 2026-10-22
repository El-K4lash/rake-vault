--!strict
-- Client/NextWorldController : le portail au fond de la zone Void. ProximityPrompt (attribut ClientAction = "NextWorld")
-- -> ouvre le menu NextWorld : "prochain monde bientôt disponible" + conditions (rebirths, argent, brainrots trouvés).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local NextWorld = require(Shared.Config.NextWorld)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local Frame = UI.Frames:WaitForChild("NextWorld") :: Frame
local Req = Frame:WaitForChild("Requirements") :: Frame
local Preview = Frame:WaitForChild("Preview") :: Frame
UI.HookClose(Frame)
UI.Button(Frame:WaitForChild("OkButton") :: GuiButton, UI.Close)

local function setRow(name: string, have: number, need: number, fmt: (number) -> string)
	local r = Req:FindFirstChild(name)
	if not r then return end
	local pct = math.clamp(have / math.max(need, 1), 0, 1)
	local bar = r:FindFirstChild("Bar") :: Frame
	local fill = bar:FindFirstChild("Fill") :: GuiObject
	fill.Size = UDim2.fromScale(0.976 * pct, 0.8)
	fill.Visible = pct > 0.01
	UI.SetText(bar, "Text", fmt(math.min(have, need)) .. " / " .. fmt(need))
	local done = pct >= 1
	(r:FindFirstChild("Check") :: GuiObject).Visible = done;
	(r:FindFirstChild("Percent") :: GuiObject).Visible = not done
	UI.SetText(r, "Percent", math.floor(pct * 100) .. "%")
end

local function refresh()
	local d = State.Data
	if not d then return end
	local found = 0
	for k in pairs(d.Index or {}) do
		if not string.find(k, ":", 1, true) then found += 1 end
	end
	setRow("Rebirths", d.Rebirths or 0, NextWorld.Rebirths, tostring)
	setRow("Money", d.Money or 0, NextWorld.Money, Format.Money)
	setRow("Brainrots", found, NextWorld.Brainrots, tostring)
	local ready = (d.Rebirths or 0) >= NextWorld.Rebirths and (d.Money or 0) >= NextWorld.Money and found >= NextWorld.Brainrots
	UI.SetText(Frame, "Status", ready and "You're ready! The new world opens in the next update."
		or "Unlocks in a future update — stay tuned!")
end
State.On({ "Rebirths", "Money", "Index" }, function() if Frame.Visible then refresh() end end)
UI.Opened.Event:Connect(function(n) if n == "NextWorld" then refresh() end end)

-- "???" qui pulse + étoiles qui tournent doucement quand le menu est ouvert
local mystery = Preview:FindFirstChild("Mystery") :: TextLabel?
local t = 0
RunService.Heartbeat:Connect(function(dt)
	if not Frame.Visible then return end
	t += dt
	if mystery then mystery.Rotation = math.sin(t * 2) * 4 end
	for _, c in ipairs(Preview:GetChildren()) do
		if c:IsA("ImageLabel") and string.sub(c.Name, 1, 4) == "Star" then
			c.Rotation += dt * 40
			c.ImageTransparency = 0.3 + 0.3 * math.sin(t * 3 + c.Rotation * 0.05)
		end
	end
end)

-- le prompt du portail (instance posée dans la map)
local function hook(d: Instance)
	if d:IsA("ProximityPrompt") and d:GetAttribute("ClientAction") == "NextWorld" then
		d.Triggered:Connect(function() if UI.Open ~= Frame then UI.Show("NextWorld") end end)
	end
end
local map = workspace:WaitForChild("Map")
for _, d in ipairs(map:GetDescendants()) do hook(d) end
map.DescendantAdded:Connect(hook)

return true
