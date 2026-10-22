#!/usr/bin/env python3
"""push.py : emballe des fichiers src/*.lua dans un .rbxmx (une entrée StringValue par fichier :
Name = chemin Studio, Value = source, attribut Class) pour les appliquer dans Studio via GetObjects.
Usage : python3 push.py src/ReplicatedStorage/Shared/Config/Zones.lua ...   (ou --all)
"""
import sys, os, html, glob

SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'src')
import time
OUT = '/mnt/user-data/outputs/rfb/push_%d.rbxmx' % int(time.time())

def studio_path(rel):
    rel = rel.replace('\\', '/')
    parts = rel.split('/')
    name = parts[-1]
    cls = 'ModuleScript'
    for suf, c in (('.server.lua', 'Script'), ('.client.lua', 'LocalScript'), ('.lua', 'ModuleScript')):
        if name.endswith(suf):
            name = name[: -len(suf)]
            cls = c
            break
    top = parts[0]
    if top == 'StarterPlayerScripts':
        base = ['StarterPlayer', 'StarterPlayerScripts']
    else:
        base = [top]
    return '.'.join(base + parts[1:-1] + [name]), cls

def main(args):
    files = []
    if args == ['--all'] or not args:
        files = [f for f in glob.glob(SRC + '/**/*.lua', recursive=True)]
    else:
        files = [os.path.abspath(a) for a in args]
    items = []
    for i, f in enumerate(files):
        rel = os.path.relpath(f, SRC)
        path, cls = studio_path(rel)
        src = open(f, encoding='utf-8').read()
        items.append('<Item class="StringValue" referent="P%d"><Properties><string name="Name">%s</string>'
                     '<string name="Value">%s</string><BinaryString name="AttributesSerialize"></BinaryString></Properties></Item>'
                     % (i, html.escape(path + '|' + cls), html.escape(src)))
        print(path, cls, len(src))
    xml = '<roblox version="4"><Item class="Folder" referent="ROOT"><Properties><string name="Name">Push</string></Properties>%s</Item></roblox>' % ''.join(items)
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, 'w', encoding='utf-8').write(xml)
    print('->', OUT, len(xml))

if __name__ == '__main__':
    main(sys.argv[1:])
