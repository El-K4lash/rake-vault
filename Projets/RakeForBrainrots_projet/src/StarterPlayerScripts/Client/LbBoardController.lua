--!strict
-- Client/LbBoardController : classements du lobby (TOP EARNERS / TOP REBIRTHS), top 100 défilable.
-- Les listes sont des SurfaceGui de StarterGui (LbBoard_Money / LbBoard_Rebirths, construits par tools/build_leaderboards.lua),
-- posés sur les écrans Hub.<Clé>Leaderboard.Leaderboard : dans le PlayerGui ils reçoivent la molette et le doigt.
-- Données : événement "Leaderboards" (LeaderboardService, toutes les 60 s) + demande au démarrage.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Format = require(ReplicatedStorage:WaitForChild("Shared").Util.Format)
local State = require(script.Parent.State)

local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
local hub = workspace:WaitForChild("Map"):WaitForChild("Hub")
local BOARDS = {
	{ Key = "Money", Model = "MoneyLeaderboard", Fmt = function(n: number): string return Format.Money(n) end },
	{ Key = "Rebirths", Model = "RebirthsLeaderboard", Fmt = function(n: number): string return Format.Num(n) end },
}

local function attach()
	for _, b in ipairs(BOARDS) do
		local sg = pg:FindFirstChild("LbBoard_" .. b.Key) :: SurfaceGui?
		local m = hub:FindFirstChild(b.Model)
		local scr = m and m:FindFirstChild("Leaderboard")
		if sg and scr and scr:IsA("BasePart") and sg.Adornee ~= scr then sg.Adornee = scr end
	end
end

local function fill(data: any)
	if type(data) ~= "table" then return end
	for _, b in ipairs(BOARDS) do
		local sg = pg:FindFirstChild("LbBoard_" .. b.Key)
		local list = sg and sg:FindFirstChild("List")
		local rows = data[b.Key]
		if not list or type(rows) ~= "table" then continue end
		for i = 1, 100 do
			local row = list:FindFirstChild("Row" .. i)
			if not row then continue end
			local r = rows[i]
			local n = row:FindFirstChild("PName") :: TextLabel?
			local v = row:FindFirstChild("Value") :: TextLabel?
			local av = row:FindFirstChild("Avatar") :: ImageLabel?
			if n then n.Text = r and tostring(r.Name) or (i == 1 and "No data yet" or "-") end
			if v then v.Text = r and b.Fmt(tonumber(r.Value) or 0) or "" end
			if av then
				local uid = r and tonumber(r.UserId) or 0
				av.Image = uid > 0 and ("rbxthumb://type=AvatarHeadShot&id=" .. uid .. "&w=150&h=150") or ""
			end
		end
	end
end

State.Event.Event:Connect(function(name: string, payload: any)
	if name == "Leaderboards" then attach(); fill(payload) end
end)
hub.ChildAdded:Connect(function() task.wait(0.2); attach() end)
attach()
task.delay(3, function() State.Send("GetLeaderboards") end)

return true
