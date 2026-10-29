--!strict
-- Client/RebirthController : menu Rebirth (avant / après, barre de coût, bouton).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Rebirth = require(Shared.Config.Rebirth)
local Zones = require(Shared.Config.Zones)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local Frame = UI.Frames:WaitForChild("Rebirth") :: Frame
local Stats = Frame:WaitForChild("Stats") :: Frame
local Bar = Frame:WaitForChild("Bar") :: Frame
local Boost = Frame:WaitForChild("RebirthBoost") :: TextLabel
local Btn = Frame:WaitForChild("RebirthButton") :: TextButton
local Skip = Frame:WaitForChild("SkipButton") :: TextButton

UI.HookClose(Frame)

local function nextZone(rebirths: number): string
	for _, z in ipairs(Zones.List) do
		if z.Rebirths > rebirths then return z.Name .. " (" .. z.Rebirths .. (z.Rebirths == 1 and " rebirth)" or " rebirths)") end
	end
	return "all zones unlocked"
end

local function refresh()
	local d = State.Data
	if not d then return end
	local cost = Rebirth.Cost(d.Rebirths)
	UI.SetText((Stats :: any).Before.Money, "Text", string.format("x%.2f money", Rebirth.Mult(d.Rebirths)))
	UI.SetText((Stats :: any).After.Money, "Text", string.format("x%.2f money", Rebirth.Mult(d.Rebirths + 1)))
	local pct = math.clamp(d.Money / cost, 0, 1)
	local prog = Bar:FindFirstChild("Progress") :: Frame
	prog.Size = UDim2.fromScale(0.976 * pct, 0.8); prog.Visible = pct > 0.01
	UI.SetText(Bar, "Text", Format.Money(d.Money) .. " / " .. Format.Money(cost))
	Boost.Text = "Unlocks: " .. nextZone(d.Rebirths) .. "  ·  +1 chalet slot\nResets money, shovel & sled — keeps pets, charms & index"
	UI.SetText(Btn, "Text", pct >= 1 and "REBIRTH!" or "Rebirth")
end

UI.Button(Btn, function() State.Send("Rebirth") end)
UI.Button(Skip, UI.Close)
State.On({ "Money", "Rebirths" }, refresh)
UI.Opened.Event:Connect(function(n) if n == "Rebirth" then refresh() end end)

return true
