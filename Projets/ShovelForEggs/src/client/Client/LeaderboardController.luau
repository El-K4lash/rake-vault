--!strict
-- Client/LeaderboardController : menu Leaderboard (Money / Rebirths).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local Frame = UI.Frames:WaitForChild("Leaderboard") :: Frame
local Tabs = Frame:WaitForChild("Tabs") :: Frame
local Rows = Frame:WaitForChild("Rows") :: ScrollingFrame
local Template = Rows:WaitForChild("RowTemplate") :: Frame
local Empty = Frame:WaitForChild("Empty") :: TextLabel
local Mine = Frame:WaitForChild("Mine") :: Frame
UI.HookClose(Frame)

local data: any = {}
local tab = "Money"

local function refresh()
	for _, c in ipairs(Rows:GetChildren()) do
		if c:IsA("GuiObject") and c ~= Template then c:Destroy() end
	end
	local rows = data[tab] or {}
	Empty.Visible = #rows == 0
	Empty.Text = "No players yet"
	for i, r in ipairs(rows) do
		local row = Template:Clone()
		row.Name = "Row" .. i
		row.Visible = true
		row.LayoutOrder = i
		UI.SetText(row, "Rank", "#" .. i)
		UI.SetText(row, "PlayerName", r.Name)
		UI.SetText(row, "Score", tab == "Money" and Format.Money(r.Value) or tostring(r.Value))
		local av = row:FindFirstChild("Avatar") :: ImageLabel?
		if av and r.UserId and r.UserId > 0 then
			av.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48", r.UserId)
		end
		row.Parent = Rows
	end
	local me = State.Data
	if me then
		local earned = me.TotalEarned or 0
		for _, r in ipairs(data.Money or {}) do
			if r.UserId == Players.LocalPlayer.UserId then earned = math.max(earned, r.Value) end
		end
		UI.SetText(Mine, "Text", "You: " .. (tab == "Money" and (Format.Money(earned) .. " earned") or (tostring(me.Rebirths) .. " rebirths")))
	end
end

for _, b in ipairs(Tabs:GetChildren()) do
	if b:IsA("GuiButton") then
		UI.Button(b, function()
			tab = b.Name:gsub("Tab_", "")
			refresh()
		end)
	end
end
State.Event.Event:Connect(function(name, payload)
	if name == "Leaderboards" then data = payload; refresh() end
end)
UI.Opened.Event:Connect(function(n) if n == "Leaderboard" then State.Send("GetLeaderboards"); refresh() end end)

return true
