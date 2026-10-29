--!strict
-- ServerScriptService/Services/CodesService : codes promo (liste dans ServerStorage/Codes).
local ServerStorage = game:GetService("ServerStorage")
local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Eggs = require(Shared.Config.Eggs)

local CodesService = {}

local function redeem(player: Player, code: any)
	local data = DataService.Get(player)
	if not data or not Net.IsString(code, 24) then return { ok = false, msg = "Invalid code" } end
	local codes = require(ServerStorage:WaitForChild("Codes")) :: any
	local cleaned = ((code :: string):gsub("%s", ""))
	local c = string.upper(cleaned)
	local reward = codes[c]
	if not reward then return { ok = false, msg = "This code doesn't exist" } end
	if data.Codes[c] then return { ok = false, msg = "You already used this code!" } end
	if reward.From and os.time() < reward.From then return { ok = false, msg = "This code isn't active yet" } end
	if reward.Until and os.time() > reward.Until then return { ok = false, msg = "This code has expired" } end
	data.Codes[c] = true
	local got = {}
	if reward.Money then
		table.insert(got, Format.Money(reward.Money))
	end
	if reward.Boost then
		local b = reward.Boost
		table.insert(got, string.format("x%s %s %d min", tostring(b.Mult or 2), tostring(b.Stat), math.floor(b.Duration / 60)))
	end
	if reward.Eggs then
		for id, n in pairs(reward.Eggs) do
			local e = Eggs.ById[id]
			table.insert(got, n .. "x " .. (e and e.Name or id))
		end
	end
	if reward.Money then
		data.Money += reward.Money
		data.TotalEarned += reward.Money
		DataService.Push(player, "Money")
	end
	if reward.Boost then
		local b = reward.Boost
		data.Boosts[b.Stat] = math.max(data.Boosts[b.Stat] or 0, os.time()) + b.Duration
		DataService.Push(player, "Boosts")
	end
	if reward.Eggs then
		for id, n in pairs(reward.Eggs) do data.Eggs[id] = (data.Eggs[id] or 0) + n end
		DataService.Push(player, "Eggs")
		local EggService = require(script.Parent.EggService) :: any
		EggService.SyncTools(player, data)
	end
	DataService.Push(player, "Codes")
	return { ok = true, msg = #got > 0 and ("Code redeemed! You got " .. table.concat(got, " + ")) or "Code redeemed!" }
end

function CodesService.Start()
	Net.OnInvoke("Redeem", redeem, 1, 2)
end

return CodesService
