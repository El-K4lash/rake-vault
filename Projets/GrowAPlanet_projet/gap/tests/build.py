# Assemble les modules Shared en un seul fichier Luau testable hors Roblox.
import os, sys, re
root='src/ReplicatedStorage/Shared'
mods={}
for d,_,fs in os.walk(root):
    for f in fs:
        if f.endswith('.lua'):
            rel=os.path.relpath(os.path.join(d,f),root)[:-4]
            mods[rel]=open(os.path.join(d,f)).read()
out=['''
-- mocks Roblox
Color3 = { fromRGB = function(r,g,b) return {r=r,g=g,b=b} end, new = function(r,g,b) return {r=r,g=g,b=b} end }
local seed = 12345
Random = { new = function(s)
  local st = s or 1
  return { NextNumber = function(self, a, b) st = (st * 1103515245 + 12345) % 2147483648; local x = st / 2147483648; if a then return a + x*(b-a) end return x end,
           NextInteger = function(self, a, b) st = (st * 1103515245 + 12345) % 2147483648; return a + st % (b-a+1) end }
end }
local MODS = {}
local CACHE = {}
local function mkpath(p)
  local node = {__path = p}
  return setmetatable(node, {__index = function(t, k)
    if k == "Parent" then local q = p:match("^(.*)/[^/]+$") or ""; return mkpath(q) end
    if k == "WaitForChild" or k == "FindFirstChild" then return function(self, name) return mkpath((p == "" and "" or p .. "/") .. name) end end
    return mkpath((p == "" and "" or p .. "/") .. k)
  end})
end
local realrequire = require
require = function(m)
  local p = type(m) == "table" and rawget(m, "__path") or m
  if CACHE[p] then return CACHE[p] end
  local f = MODS[p]; assert(f, "module introuvable " .. tostring(p))
  CACHE[p] = f(); return CACHE[p]
end
''']
for k,v in mods.items():
    out.append(f'MODS["{k}"] = function()\nlocal script = mkpath("{k}")\n{v}\nend\n')
out.append(open(sys.argv[1]).read())
open('tests/_run.luau','w').write('\n'.join(out))
