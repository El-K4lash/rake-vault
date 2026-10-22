# Convertit le dump three.js de la maquette (scene.json) en liste de pièces Roblox (texte compact).
# Sortie : data.txt, une ligne par instruction :
#   G <name>|<parent>|<attrs>      -> nouveau groupe (Folder ou Model), les pièces suivantes vont dedans
#   K,MAT,COL,TR,sx,sy,sz,px,py,pz,qx,qy,qz,qw,FL[,extra]
# K : B bloc, C cylindre (axe X Roblox), W CornerWedge, M cône (MeshPart), L sphère (Ball)
# MAT : P Plastic, S SmoothPlastic, N Neon, G Glass, F Foil?   FL : 1 collide, 2 ombre, 4 studs
import json, math, sys
import numpy as np

D = '/tmp/claude-0/-home-claude/9dbbe67a-9d1b-5c2e-a9db-532cbeb69f8b/scratchpad/conv/'
d = json.load(open(D + 'scene.json'))

SKIP_SEC = {'LOBBY', 'PENS', 'pre', 'PROPS', 'CAMERA', 'LOOP'}
SKIP_FLAG = {'CHAR', 'PORTAL', 'CHEST'}
import random
random.seed(7)

out = []
stats = {}

def mat4(e):
    return np.array(e, dtype=float).reshape(4, 4).T  # column-major -> row-major

def Ry(a):
    c, s = math.cos(a), math.sin(a)
    return np.array([[c, 0, s], [0, 1, 0], [-s, 0, c]])

def Rx(a):
    c, s = math.cos(a), math.sin(a)
    return np.array([[1, 0, 0], [0, c, -s], [0, s, c]])

def Rz(a):
    c, s = math.cos(a), math.sin(a)
    return np.array([[c, -s, 0], [s, c, 0], [0, 0, 1]])

def quat(R):
    # R : rotation 3x3 -> (x, y, z, w)
    m = R
    tr = m[0, 0] + m[1, 1] + m[2, 2]
    if tr > 0:
        S = math.sqrt(tr + 1.0) * 2
        w = 0.25 * S; x = (m[2, 1] - m[1, 2]) / S; y = (m[0, 2] - m[2, 0]) / S; z = (m[1, 0] - m[0, 1]) / S
    elif m[0, 0] > m[1, 1] and m[0, 0] > m[2, 2]:
        S = math.sqrt(1.0 + m[0, 0] - m[1, 1] - m[2, 2]) * 2
        w = (m[2, 1] - m[1, 2]) / S; x = 0.25 * S; y = (m[0, 1] + m[1, 0]) / S; z = (m[0, 2] + m[2, 0]) / S
    elif m[1, 1] > m[2, 2]:
        S = math.sqrt(1.0 + m[1, 1] - m[0, 0] - m[2, 2]) * 2
        w = (m[0, 2] - m[2, 0]) / S; x = (m[0, 1] + m[1, 0]) / S; y = 0.25 * S; z = (m[1, 2] + m[2, 1]) / S
    else:
        S = math.sqrt(1.0 + m[2, 2] - m[0, 0] - m[1, 1]) * 2
        w = (m[1, 0] - m[0, 1]) / S; x = (m[0, 2] + m[2, 0]) / S; y = (m[1, 2] + m[2, 1]) / S; z = 0.25 * S
    n = math.sqrt(x * x + y * y + z * z + w * w)
    return x / n, y / n, z / n, w / n

def f3(v):
    return '%g' % round(v, 3)

CUR = {'sec': '', 'mat': 'P', 'tr': 0.0, 'collide_rule': None}

def emit(kind, size, pos, R, col, mat=None, tr=None, flags=None):
    mat = mat or CUR['mat']
    tr = CUR['tr'] if tr is None else tr
    sx, sy, sz = [max(0.05, float(v)) for v in size]
    if flags is None:
        flags = 0
        mx, mn = max(sx, sy, sz), min(sx, sy, sz)
        if mx >= 1.2:
            flags |= 2
        if mat == 'P':
            flags |= 4
        if CUR['collide_rule'] and CUR['collide_rule'](kind, (sx, sy, sz), pos):
            flags |= 1
    q = quat(R)
    out.append(','.join([kind, mat, '%06X' % col, '%g' % round(tr, 3), f3(sx), f3(sy), f3(sz), f3(pos[0]), f3(pos[1]), f3(pos[2]),
                         '%g' % round(q[0], 5), '%g' % round(q[1], 5), '%g' % round(q[2], 5), '%g' % round(q[3], 5), str(flags)]))
    stats[kind] = stats.get(kind, 0) + 1

C225, S225 = math.cos(math.pi / 8), math.sin(math.pi / 8)

def prim(g, M, col):
    t = M[:3, 3]
    cols = [M[:3, 0], M[:3, 1], M[:3, 2]]
    s = np.array([np.linalg.norm(c) for c in cols])
    s = np.where(s < 1e-6, 1e-6, s)
    R = np.stack([cols[0] / s[0], cols[1] / s[1], cols[2] / s[2]], axis=1)
    if np.linalg.det(R) < 0:
        R[:, 0] = -R[:, 0]
    sx, sy, sz = s

    def at(off_local_scaled, Rl):
        return t + R @ off_local_scaled, R @ Rl

    if g in ('box', 'rbox'):
        up = abs(R[1, 1]) > 0.999
        if up and sy < 0.15:
            # plaque posée sur un sol : on la décolle un peu (sinon elle clignote avec le sol)
            CUR['thin'] = CUR.get('thin', 0) + 1
            lift = 0.04 + (CUR['thin'] % 8) * 0.014
            bottom = t[1] - sy / 2
            sy2 = max(sy, 0.08)
            t = t.copy(); t[1] = bottom + lift + sy2 / 2; sy = sy2
        elif up and sx * sz > 500 and sy < 3:
            top = t[1] + sy / 2
            if 0.43 < top <= 0.5 or -0.06 < top <= 0:
                newtop = 0.42 if top > 0.3 else -0.1
                bottom = t[1] - sy / 2
                t = t.copy(); sy = newtop - bottom; t[1] = bottom + sy / 2
        emit('B', (sx, sy, sz), t, R, col)
    elif g in ('cyl', 'cyl64', 'cup', 'hcyl'):
        r = (sx + sz) / 2
        if g == 'cup':
            r *= 0.9
        emit('C', (sy, 2 * r, 2 * r), t, R @ Rz(math.pi / 2), col)
    elif g == 'cyl8':
        r = (sx + sz) / 2
        A, e = r * C225, 2 * r * S225
        if r < 0.6:
            emit('B', (2 * A, sy, 2 * A), t, R @ Ry(math.pi / 8), col)
        else:
            for k in range(4):
                th = math.pi / 8 + k * math.pi / 4
                emit('B', (e, sy, 2 * A), t, R @ Ry(th), col)
    elif g in ('cone4', 'octa'):
        r = (sx + sz) / 2
        W = math.sqrt(2) * r
        Rb = R @ Ry(math.pi / 4)
        parts = []
        if g == 'cone4':
            parts.append((np.zeros(3), np.eye(3), sy))
        else:
            parts.append((np.array([0, sy / 2, 0]), np.eye(3), sy))
            parts.append((np.array([0, -sy / 2, 0]), Rx(math.pi), sy))
        if r < 0.3:
            if g == 'cone4':
                emit('B', (0.6 * W, 0.7 * sy, 0.6 * W), t + R @ np.array([0, -0.15 * sy, 0]), Rb, col)
            else:
                emit('B', (0.72 * W, 1.3 * sy, 0.72 * W), t, Rb, col)
            return
        for off, Rp, H in parts:
            base_t = t + Rb @ off
            Rf = Rb @ Rp
            for (ox, oz, rot) in ((1, -1, math.pi), (-1, -1, -math.pi / 2), (1, 1, math.pi / 2), (-1, 1, 0.0)):
                o = np.array([ox * W / 4, 0, oz * W / 4])
                emit('W', (W / 2, H, W / 2), base_t + Rf @ o, Rf @ Ry(rot), col)
    elif g == 'cone8':
        r = (sx + sz) / 2
        emit('M', (2 * r, sy, 2 * r), t, R, col)
    elif g == 'frust':
        r = (sx + sz) / 2
        R1, R2, h = r, 0.36 * r, sy
        n = 10
        c18 = math.cos(math.pi / n)
        b, tw = 2 * R1 * math.sin(math.pi / n), 2 * R2 * math.sin(math.pi / n)
        dth = min(0.6, max(0.15, 0.12 * r))
        for i in range(n):
            phi = (i + 0.5) * 2 * math.pi / n
            nh = np.array([math.sin(phi), 0, math.cos(phi)])
            u = np.array([math.cos(phi), 0, -math.sin(phi)])
            a1, a2 = R1 * c18, R2 * c18
            p0 = nh * a1 + np.array([0, -h / 2, 0])
            p1 = nh * a2 + np.array([0, h / 2, 0])
            vv = p1 - p0; L = np.linalg.norm(vv); v = vv / L
            nn = np.cross(u, v)
            mid = (p0 + p1) / 2 - nn * dth / 2
            # rectangle central (largeur du haut)
            Rm = np.stack([u, v, nn], axis=1)
            emit('B', (tw + 0.02, L, dth), t + R @ mid, R @ Rm, col)
            # deux triangles (coins) : WedgePart, angle droit en bas côté intérieur
            wz = (b - tw) / 2
            if wz > 0.02:
                for side in (-1, 1):
                    cpos = mid + u * side * (tw / 2 + wz / 2)
                    Z = -u * side
                    X = np.cross(v, Z)
                    Rw = np.stack([X, v, Z], axis=1)
                    emit('V', (dth, L, wz), t + R @ cpos, R @ Rw, col)
        emit('C', (0.2, 2 * R2 * 1.02, 2 * R2 * 1.02), t + R @ np.array([0, h / 2 - 0.1, 0]), R @ Rz(math.pi / 2), col)
    elif g == 'torus':
        n = 12
        th = 0.44 * (sx + sy) / 2
        for i in range(n):
            a = (i + 0.5) * 2 * math.pi / n
            p = np.array([math.cos(a) * sx, math.sin(a) * sy, 0])
            phi = math.atan2(math.cos(a) * sy, -math.sin(a) * sx)
            L = 2 * math.pi * (sx + sy) / 2 / n * 1.1
            emit('B', (L, th, 0.44 * sz), t + R @ p, R @ Rz(phi), col)
    elif g in ('ico', 'ico1', 'ico2'):
        if max(sx, sy, sz) < 0.5:
            emit('B', (1.55 * sx, 1.55 * sy, 1.55 * sz), t, R, col)
        elif g == 'ico':
            emit('B', (1.45 * sx, 1.35 * sy, 1.45 * sz), t, R, col)
            a = (sx + sz) / 2
            emit('B', (1.45 * a, 1.1 * sy, 1.45 * a), t + R @ np.array([0, 0.08 * sy, 0]), R @ Ry(math.pi / 4) @ Rx(0.35), col)
        else:
            # sphère / dôme lisse (comme l'icosaèdre subdivisé de la maquette)
            emit('E', (2 * sx, 2 * sy, 2 * sz), t, R, col)
    else:
        print('unknown geom', g, file=sys.stderr)

# ---------------------------------------------------------------- groupes
def group(name, parent='Maquette', attrs=''):
    out.append('G ' + name + '|' + parent + '|' + attrs)

def in_zone_edge(pos, zc):
    x, y, z = pos
    dz = z - zc
    if y > 17:
        return False
    return (abs(abs(x) - 42) < 1.9 and abs(dz) < 44) or (abs(abs(dz) - 42) < 1.9 and abs(x) < 44)

ZC = {'B_beach': 230, 'B_swamp': 360, 'B_volcano': 490, 'B_ice': 620, 'B_void': 750}

def collide_rule_for(sec):
    if sec in ZC:
        zc = ZC[sec]
        return lambda k, s, p: in_zone_edge(p, zc) and max(s) > 0.9
    if sec in ('ISLAND',):
        return lambda k, s, p: True
    if sec == 'PATHS':
        return lambda k, s, p: max(s) > 4 and p[1] < 0.6
    if sec == 'SCATTER':
        return lambda k, s, p: min(s) >= 2.0 and max(s) >= 3
    return None

prims = [p for p in d['prims'] if p[0] not in SKIP_SEC and p[1] not in SKIP_FLAG and p[4] == 0]
order = ['ISLAND', 'PATHS', 'SCATTER'] + list(ZC.keys())
for sec in order:
    sp = [p for p in prims if p[0] == sec]
    group(sec, 'Maquette')
    CUR['collide_rule'] = collide_rule_for(sec)
    for p in sp:
        _, flag, g, kind, mm, e, col = p
        CUR['mat'] = {'T': 'P', 'GL': 'N', 'TR': 'G'}[kind]
        CUR['tr'] = 0.4 if kind == 'TR' else 0.0
        if kind == 'GL' and col == 0xFFE27A:
            col = 0xC8B46E  # têtes de lampadaires adoucies (trop lumineuses en néon)
        prim(g, mat4(e), col)
CUR['collide_rule'] = None

# makeMesh : moulin (pales) + nuages
mmprims = {}
for p in d['prims']:
    if p[4]:
        mmprims.setdefault(p[4], []).append(p)
ci = 0
for m in d['mm']:
    if m['sec'] in SKIP_SEC or m['flag'] in SKIP_FLAG:
        continue
    W = mat4(m['w'])
    if m['anim'] == 'spin3d':
        group('Windmill%d' % m['id'], 'Maquette/SCATTER', 'Anim=Spin3d;Model=1;Pivot=%s' % ','.join('%g' % round(v, 4) for v in m['w']))
        CUR['mat'] = 'P'; CUR['tr'] = 0
    elif m['anim'] == 'cloud':
        ci += 1
        group('Cloud%d' % ci, 'Maquette/Clouds', 'Anim=Cloud;Model=1;Index=%d' % (ci - 1))
        CUR['mat'] = 'S'; CUR['tr'] = round(1 - m['mat']['opacity'], 3)
    else:
        group('MM%d' % m['id'], 'Maquette/SCATTER', '')
        CUR['mat'] = 'P'; CUR['tr'] = 0
    for p in mmprims.get(m['id'], []):
        prim(p[2], W @ mat4(p[5]), p[6])

# ---------------------------------------------------------------- objets three.js « à part »
group('Special', 'Maquette')
names = []
for x in d['meshes']:
    if x['sec'] in SKIP_SEC or x['flag'] in SKIP_FLAG:
        continue
    M = mat4(x['w'])
    t = M[:3, 3]
    gt, pa, mt = x['gtype'], x['params'] or {}, x['mat']
    col = mt['color'] if mt['color'] is not None else 0xFFFFFF
    if x['anim'] in ('smoke', 'bubble', 'spinner'):
        continue
    if gt == 'PlaneGeometry' and mt['type'] == 'MeshBasicMaterial' and mt['map'] and x['sec'].startswith('B_'):
        continue  # couches du nom 3D : refaites à part
    if gt == 'PlaneGeometry' and mt['studs']:
        # sol à studs (île, route, biomes, sentier)
        w, h = pa['width'], pa['height']
        R = M[:3, :3] / np.array([np.linalg.norm(M[:3, i]) for i in range(3)])
        # plan couché : sa largeur est sur X, sa profondeur sur Z (rotateX(-PI/2))
        tag = 'Floor'
        if x['sec'].startswith('B_'):
            tag = 'ZoneFloor:' + x['sec'][2:]
        elif x['sec'] == 'ISLAND':
            tag = 'IslandFloor'
        out.append('F,%s,%06X,%s,%s,%s,%s,%s,%s' % (tag, col, f3(w), f3(h), f3(t[0]), f3(t[1]), f3(t[2]), '%g' % round(math.atan2(R[0, 2], R[2, 2]), 5)))
        continue
    if x['pond']:
        out.append('POND,%s,%06X,%s,%s,%s,%s,%s' % (x['pond'], col, f3(pa['radiusTop']), f3(pa['height']), f3(t[0]), f3(t[1]), f3(t[2])))
        continue
    if gt == 'CircleGeometry':
        r = pa['radius']
        CUR['mat'] = 'S'; CUR['tr'] = 0
        emit('C', (0.3, 2 * r, 2 * r), t - np.array([0, 0.15, 0]), Rz(math.pi / 2), col, mat='S', flags=0)
        continue
    if gt == 'BoxGeometry':
        # cascade
        emit('B', (pa['width'], pa['height'], pa['depth']), t, np.eye(3), col, mat='S', tr=round(1 - mt['opacity'], 3), flags=0)
        continue
    if gt == 'TorusGeometry' and x['anim'] == 'spinring':
        group('Ring', 'Maquette/Special', 'Anim=SpinRing;Model=1')
        CUR['mat'] = 'N'; CUR['tr'] = 0
        rad = pa['radius']
        R = M[:3, :3]
        for i in range(16):
            a = (i + 0.5) * 2 * math.pi / 16
            p = np.array([math.cos(a) * rad, math.sin(a) * rad, 0])
            L = 2 * math.pi * rad / 16 * 1.1
            emit('B', (L, 0.36, 0.36), t + R @ p, R @ Rz(a + math.pi / 2), col, mat='N', flags=0)
        group('Special', 'Maquette')
        continue
    if gt == 'PlaneGeometry' and x['sec'] == 'ISLAND':
        out.append('SEA,%s,%06X,%s,%s,%s,%s,%s,%s' % (('deep' if pa['width'] > 9000 else 'ripples' if pa['width'] > 5000 else 'water' if pa['width'] > 3000 else 'foam'),
                   col, f3(pa['width']), f3(pa['height']), f3(t[0]), f3(t[1]), f3(t[2]), '%g' % round(mt['opacity'], 3)))
        continue
    print('unhandled', x['sec'], gt, file=sys.stderr)

for n in d['names']:
    if n['sec'] in SKIP_SEC:
        continue
    w = next((x['params']['width'] for x in d['meshes'] if x['sec'] == n['sec'] and x['gtype'] == 'PlaneGeometry' and x['mat']['map'] and not x['mat']['studs']), 16)
    out.append('NAME,%s,%s,%s,%s,%s,%s,%s' % (n['text'], n['fill'].lstrip('#'), f3(n['pos'][0]), f3(n['pos'][1]), f3(n['pos'][2]), f3(n['height']), f3(w)))
for c in d.get('chests', []):
    if not c['theme'] in ('beach', 'swamp', 'volcano', 'ice', 'void'):
        continue
    e = c['w']
    out.append('CHEST,%s,%s,%s,%s,%s' % (c['theme'], f3(e[12]), f3(e[13]), f3(e[14]), '%g' % round(math.atan2(e[8], e[10]), 5)))
for p in d['smokePts']:
    out.append('SMOKE,%s,%s,%s' % (f3(p[0]), f3(p[1]), f3(p[2])))
for b in d['bub']:
    out.append('BUB,%s,%s,%s,%s,%s,%s,%s,%06X,%s' % (f3(b[0][0]), f3(b[2]), f3(b[0][2]), f3(b[1]), f3(b[3]), f3(b[4]), f3(b[5]), b[6], f3(b[7])))
for l in d['lights']:
    if l['sec'] in SKIP_SEC:
        continue
    out.append('LIGHT,%06X,%s,%s,%s,%s,%s' % (l['color'], f3(l['intensity']), f3(l['distance']), f3(l['pos'][0]), f3(l['pos'][1]), f3(l['pos'][2])))

txt = '\n'.join(out)
open(D + 'data.txt', 'w').write(txt)
print('lines', len(out), 'bytes', len(txt), stats, 'parts', sum(stats.values()))
