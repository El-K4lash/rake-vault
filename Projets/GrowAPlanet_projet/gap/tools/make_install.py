# Génère des scripts Luau d'installation (à exécuter dans Studio, mode Edit) qui créent
# tous les scripts du jeu depuis src/. Découpés en lots de ~45 Ko.
import os, glob
ROOTS = {
  'src/ReplicatedStorage': 'ReplicatedStorage',
  'src/ServerScriptService': 'ServerScriptService',
  'src/ServerStorage': 'ServerStorage',
  'src/StarterPlayerScripts': 'StarterPlayer.StarterPlayerScripts',
}
entries=[]
for base, svc in ROOTS.items():
    for f in sorted(glob.glob(base+'/**/*.lua', recursive=True)):
        rel=os.path.relpath(f, base)[:-4]
        parts=rel.split('/')
        name=parts[-1]; cls='ModuleScript'
        if name.endswith('.server'): name=name[:-7]; cls='Script'
        elif name.endswith('.client'): name=name[:-7]; cls='LocalScript'
        entries.append((svc, parts[:-1], name, cls, open(f).read()))
head='''local function svc(path)
	local o = game
	for part in string.gmatch(path, "[^%.]+") do o = o:FindFirstChild(part) or game:GetService(part) end
	return o
end
local function folder(parent, name)
	local f = parent:FindFirstChild(name)
	if not f then f = Instance.new("Folder"); f.Name = name; f.Parent = parent end
	return f
end
local function put(service, path, name, class, source)
	local parent = svc(service)
	for _, p in ipairs(path) do parent = folder(parent, p) end
	local old = parent:FindFirstChild(name)
	if old and old.ClassName ~= class then old:Destroy(); old = nil end
	local s = old or Instance.new(class)
	s.Name = name
	s.Source = source
	s.Parent = parent
end
local n = 0
'''
batches=[]; cur=head; size=0
for svc,path,name,cls,src in entries:
    eq='='*6
    while ('['+eq+'[') in src or (']'+eq+']') in src: eq+='='
    block='put("%s", {%s}, "%s", "%s", [%s[\n%s]%s])\nn += 1\n'%(svc, ', '.join('"%s"'%p for p in path), name, cls, eq, src, eq)
    if size+len(block)>45000 and size>0:
        batches.append(cur+'return "installé : " .. n\n'); cur=head; size=0
    cur+=block; size+=len(block)
batches.append(cur+'return "installé : " .. n\n')
os.makedirs('install',exist_ok=True)
for i,b in enumerate(batches):
    open('install/install_%d.lua'%(i+1),'w').write(b)
print(len(entries),'fichiers,',len(batches),'lots', [len(b) for b in batches])
