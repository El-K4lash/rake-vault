local F = require("Util/Formulas")
local Format = require("Util/Format")
local Galaxies = require("Config/Galaxies")
local fails = 0
local function check(c, msg) if not c then fails += 1; print("ECHEC: " .. msg) end end

-- Format
check(Format.Number(999) == "999", "999")
check(Format.Number(1234) == "1.23K", "1.23K got " .. Format.Number(1234))
check(Format.Number(1500000) == "1.5M", "1.5M got " .. Format.Number(1500000))
check(Format.Number(50000000) == "50M", "50M got " .. Format.Number(50000000))
check(Format.Time(75) == "1m 15s", "time " .. Format.Time(75))
check(Format.Percent(0.0001) == "0.01%", "pct " .. Format.Percent(0.0001))
print("Percent 0.35 ->", Format.Percent(0.35), " 0.0123 ->", Format.Percent(0.0123))

-- les chances de chaque galaxie font bien 100 %
for _, luck in ipairs({1, 2.5, 10}) do
  for _, g in ipairs(Galaxies.List) do
    local s = 0
    for _, o in ipairs(F.PlanetOdds(g.Id, luck)) do s += o.chance end
    check(math.abs(s - 1) < 1e-9, g.Id .. " somme " .. s)
  end
end

-- simulation : 200 000 apparitions de galaxies, luck 1
local rng = Random.new(42)
local counts = {}
local N = 200000
for i = 1, N do local id = F.RollGalaxy(rng, 1); counts[id] = (counts[id] or 0) + 1 end
for _, g in ipairs(Galaxies.List) do print(string.format("spawn %-15s %6.3f%%", g.Id, (counts[g.Id] or 0) / N * 100)) end

-- mutations
local mc = {}
for i = 1, N do local m = F.RollMutation(rng, 1) or "None"; mc[m] = (mc[m] or 0) + 1 end
for k, v in pairs(mc) do print(string.format("mutation %-8s %6.3f%%", k, v / N * 100)) end

-- état joueur type
local state = { Rebirths = 2, Upgrades = { Luck = 4, Spawners = 1, HatchSpeed = 3 }, Passes = { DoubleMoney = true }, Boosts = { Money = 100 }, IndexClaimed = { Common = true }, Now = 50 }
print("luck", F.Luck(state), "money mult", F.MoneyMultiplier(state), "slots", F.EquipSlots(state), "spawners", F.SpawnerCount(state), "hatch legendary", F.HatchDuration("GoldenCrown", state))
check(F.MoneyMultiplier(state) == 2 * 2 * 2 * 1.05, "money mult")
check(F.UpgradeCost("Luck", 10) == nil, "max level")
check(F.RollPlanet(rng, "PrismCore", 5) ~= nil, "secret roll")
print(fails == 0 and "TOUS LES TESTS OK" or (fails .. " echecs"))
print(Format.Money(100000), Format.Money(120000000), Format.Money(1500), Format.Money(10), Format.Money(2000000))
assert(Format.Money(100000) == "$100K" and Format.Money(120000000) == "$120M" and Format.Money(2000000) == "$2M", "format fix")
print("format ok")
