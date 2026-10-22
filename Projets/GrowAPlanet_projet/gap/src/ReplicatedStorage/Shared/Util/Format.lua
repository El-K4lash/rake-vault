--!strict
-- ReplicatedStorage/Shared/Util/Format
-- Mise en forme des nombres et des durées pour l'affichage (client et serveur).

local Format = {}

local SUFFIXES = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }

-- 1234 -> "1.23K", 1500000 -> "1.5M"
function Format.Number(n: number): string
	if n ~= n then return "0" end
	local negative = n < 0
	n = math.abs(n)
	if n < 1000 then
		local s = tostring(math.floor(n))
		return negative and "-" .. s or s
	end
	local i = 1
	while n >= 1000 and i < #SUFFIXES do
		n /= 1000
		i += 1
	end
	local s
	if n >= 100 then
		s = string.format("%d", math.floor(n))
	elseif n >= 10 then
		s = string.format("%.1f", math.floor(n * 10) / 10)
	else
		s = string.format("%.2f", math.floor(n * 100) / 100)
	end
	if s:find("%.") then s = s:gsub("%.?0+$", "") end
	return (negative and "-" or "") .. s .. SUFFIXES[i]
end

function Format.Money(n: number): string
	return "$" .. Format.Number(n)
end

-- 75 -> "1m 15s", 3700 -> "1h 01m", 9 -> "9s"
function Format.Time(seconds: number): string
	seconds = math.max(0, math.ceil(seconds))
	if seconds < 60 then
		return seconds .. "s"
	elseif seconds < 3600 then
		return string.format("%dm %02ds", seconds // 60, seconds % 60)
	elseif seconds < 86400 then
		return string.format("%dh %02dm", seconds // 3600, (seconds % 3600) // 60)
	end
	return string.format("%dd %02dh", seconds // 86400, (seconds % 86400) // 3600)
end

-- 0.0123 -> "1.23%", 0.00001 -> "0.001%"
function Format.Percent(p: number): string
	local v = p * 100
	if v >= 10 then return (string.format("%.1f", v):gsub("%.0$", "")) .. "%" end
	if v >= 1 then return (string.format("%.2f", v):gsub("%.?0+$", "")) .. "%" end
	if v >= 0.01 then return (string.format("%.3f", v):gsub("%.?0+$", "")) .. "%" end
	return (string.format("%.4f", v):gsub("%.?0+$", "")) .. "%"
end

return Format
