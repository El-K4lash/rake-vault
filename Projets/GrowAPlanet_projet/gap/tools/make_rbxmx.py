# Fabrique GrowAPlanet.rbxmx : un modèle à glisser dans Studio qui contient tout le code + les outils.
import os, glob, html
ROOTS = ['ReplicatedStorage','ServerScriptService','ServerStorage','StarterPlayerScripts']
ref=[0]
def nref():
    ref[0]+=1; return 'RBX%d'%ref[0]
def item(cls,name,children='',src=None):
    p='<string name="Name">%s</string>'%html.escape(name)
    if src is not None:
        assert ']]>' not in src
        p+='<ProtectedString name="Source"><![CDATA[%s]]></ProtectedString>'%src
    return '<Item class="%s" referent="%s"><Properties>%s</Properties>%s</Item>'%(cls,nref(),p,children)
def build_dir(path):
    out=''
    for e in sorted(os.listdir(path)):
        full=os.path.join(path,e)
        if os.path.isdir(full):
            out+=item('Folder',e,build_dir(full))
        elif e.endswith('.lua'):
            n=e[:-4]; cls='ModuleScript'
            if n.endswith('.server'): n=n[:-7]; cls='Script'
            elif n.endswith('.client'): n=n[:-7]; cls='LocalScript'
            out+=item(cls,n,'',open(full).read())
    return out
kids=''
for r in ROOTS:
    kids+=item('Folder',r,build_dir('src/'+r))
tools=item('ModuleScript','MapBuilder','',open('tools/MapBuilder.lua').read())+item('ModuleScript','GuiBuilder','',open('tools/GuiBuilder.lua').read())
kids+=item('Folder','Tools',tools)
xml='<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" version="4">'+item('Folder','GrowAPlanet_Install',kids)+'</roblox>'
open('deliver/GrowAPlanet.rbxmx','w').write(xml)
print('ok', len(xml))
