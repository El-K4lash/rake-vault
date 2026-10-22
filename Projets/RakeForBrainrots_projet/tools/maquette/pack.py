import html, sys
D = '/tmp/claude-0/-home-claude/9dbbe67a-9d1b-5c2e-a9db-532cbeb69f8b/scratchpad/conv/'
lines = open(D + 'data.txt').read().split('\n')
chunks, cur, size, lastG = [], [], 0, None
LIM = 110000
for ln in lines:
    if ln.startswith('G '):
        lastG = ln
    if size + len(ln) > LIM and cur:
        chunks.append(cur); cur = [lastG] if (lastG and not ln.startswith('G ')) else []; size = sum(len(x) + 1 for x in cur)
    cur.append(ln); size += len(ln) + 1
if cur: chunks.append(cur)
items = []
for i, c in enumerate(chunks):
    items.append('<Item class="StringValue" referent="S%d"><Properties><string name="Name">C%03d</string><string name="Value">%s</string></Properties></Item>' % (i, i + 1, html.escape('\n'.join(c), quote=False)))
xml = '<roblox version="4"><Item class="Folder" referent="R"><Properties><string name="Name">MaqData</string></Properties>' + ''.join(items) + '</Item></roblox>'
out = '/mnt/user-data/outputs/rfb/maqdata.rbxmx'
open(out, 'w').write(xml)
print(len(chunks), 'chunks', len(xml), 'bytes')
