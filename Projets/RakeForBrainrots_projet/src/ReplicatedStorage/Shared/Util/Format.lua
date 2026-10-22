--!strict
-- Shared/Util/Format : 1234 -> "1.23K", 2500000 -> "2.5M"
local Format = {}
local SUFFIX = { "", "K", "M", "B", "T", "Qa", "Qi" }

function Format.Num(n: number): string
	n = math.floor(n)
	if n < 1000 then return tostring(n) end
	local i = 1
	local v = n
	while v >= 1000 and i < #SUFFIX do
		v /= 1000
		i += 1
	end
	local s = string.format(v >= 100 and "%.0f" or (v >= 10 and "%.1f" or "%.2f"), v)
	if string.find(s, ".", 1, true) then
		s = s:gsub("0+$", ""):gsub("%.$", "")
	end
	return s .. SUFFIX[i]
end

function Format.Money(n: number): string
	return "$" .. Format.Num(n)
end

function Format.Time(sec: number): string
	sec = math.max(0, math.floor(sec))
	if sec >= 3600 then return string.format("%dh %02dm", sec // 3600, (sec % 3600) // 60) end
	if sec >= 60 then return string.format("%dm %02ds", sec // 60, sec % 60) end
	return sec .. "s"
end

return Format
