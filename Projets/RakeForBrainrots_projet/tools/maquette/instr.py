import json, sys, re
D = '/tmp/claude-0/-home-claude/9dbbe67a-9d1b-5c2e-a9db-532cbeb69f8b/scratchpad/'
s = open(D + 'mapdesign/map.html', encoding='utf-8').read()
tag = '<script type="__bundler/template">'
i = s.find(tag) + len(tag)
j = s.find('</script>', i)
t = json.loads(s[i:j])

def rep(old, new, count=1):
    global t
    n = t.count(old)
    assert n >= 1, ('missing', old[:80])
    if count == 1:
        assert n == 1, ('multiple', n, old[:80])
    t = t.replace(old, new)

R = 'window.__REC'
rep("    const scene = new THREE.Scene();\n",
    "    const scene = new THREE.Scene();\n"
    "    window.__REC = { prims: [], sec: 'pre', flag: '', mm: 0, mmCur: 0, names: [], labels: [] };\n"
    "    const __sa = scene.add.bind(scene); scene.add = (...o) => { o.forEach((x) => { if (x && x.userData && !x.userData.__sec) { x.userData.__sec = window.__REC.sec; x.userData.__flag = window.__REC.flag; } }); return __sa(...o); };\n")
rep("    // ---------- merger", "    const __TN = new Map(Object.entries(T).map(([k, v]) => [v, k]));\n    // ---------- merger")
rep("      mg.add(t, _m, color);\n    };",
    "      mg.add(t, _m, color);\n"
    "      window.__REC.prims.push([window.__REC.sec, window.__REC.flag, __TN.get(t), mg === GL ? 'GL' : mg === TR ? 'TR' : 'T', window.__REC.mmCur || 0, Array.from(_m.elements), new THREE.Color(color).getHex()]);\n    };")
rep("        g.computeBoundingSphere();\n        return g;", "        g.computeBoundingSphere(); g.userData.merged = true;\n        return g;")
rep("    const addToFrame = (obj) => { obj.applyMatrix4(F); scene.add(obj); return obj; };",
    "    const addToFrame = (obj) => { obj.userData.__sec = window.__REC.sec; obj.userData.__flag = window.__REC.flag; obj.applyMatrix4(F); scene.add(obj); return obj; };")
rep("    const name3D = (text, fill, x, y, z, height) => {\n",
    "    const name3D = (text, fill, x, y, z, height) => {\n      window.__REC.names.push({ sec: window.__REC.sec, flag: window.__REC.flag, text: text, fill: fill, pos: worldPos(x, y, z).toArray(), height: height, ry: Math.atan2(F.elements[8], F.elements[10]) });\n")
rep("    const label = (text, x, y, z, height, o) => {\n",
    "    const label = (text, x, y, z, height, o) => {\n      window.__REC.labels.push({ sec: window.__REC.sec, flag: window.__REC.flag, text: text, o: o || {}, pos: worldPos(x, y, z).toArray(), height: height });\n")
# characters flagged
rep("    const character = (x, yb, z, ry, shirt, pants, o) => {", "    const __character = (x, yb, z, ry, shirt, pants, o) => {")
rep("    // =====================================================\n    //  ISLAND & WATER",
    "    const character = (...a) => { const pf = window.__REC.flag; window.__REC.flag = 'CHAR'; const r = __character(...a); window.__REC.flag = pf; return r; };\n"
    "    // =====================================================\n    //  ISLAND & WATER")
rep("        // portal at the back\n", "        // portal at the back\n        window.__REC.flag = 'PORTAL';\n")
rep("spinners.push(portal2);", "spinners.push(portal2); window.__REC.flag = '';")
rep("    const lootChest = (theme) => {", "    const __lootChest = (theme) => {")
rep("    const pondMat = {", "    const lootChest = (theme) => { window.__REC.chests = window.__REC.chests || []; window.__REC.chests.push({ theme: theme, w: Array.from(F.elements) }); const pf = window.__REC.flag; window.__REC.flag = 'CHEST'; __lootChest(theme); window.__REC.flag = pf; };\n    const pondMat = {")
# makeMesh
rep("      F = new THREE.Matrix4(); TGT = new Merger();\n      fn();",
    "      F = new THREE.Matrix4(); TGT = new Merger(); const __id = ++window.__REC.mm; const __pm = window.__REC.mmCur; window.__REC.mmCur = __id;\n      fn(); window.__REC.mmCur = __pm;")
rep("      const m = new THREE.Mesh(g, mat);\n      m.castShadow = true;",
    "      const m = new THREE.Mesh(g, mat); m.userData.__mm = __id; (window.__MMS = window.__MMS || {})[__id] = m;\n      m.castShadow = true;")
# sections
for name, key in [('REUSABLE PROPS (detailed)', 'PROPS'), ('ISLAND & WATER', 'ISLAND'), ('PATHS & ROAD', 'PATHS'), ('LOBBY', 'LOBBY'),
                  ('PENS', 'PENS'), ('BIOMES', 'BIOMES'), ('ISLAND SCATTER', 'SCATTER'), ('CAMERA RIG & CONTROLS', 'CAMERA'), ('LOOP', 'LOOP')]:
    rep("    //  " + name + "\n", "    //  " + name + "\n    window.__REC.sec = '" + key + "';\n")
# biome tracking: per-biome flag inside BIOMES.forEach
rep("      const zc = ZC(i), last = i === BIOMES.length - 1, Y = 0.5;", "      const zc = ZC(i), last = i === BIOMES.length - 1, Y = 0.5; window.__REC.sec = 'B_' + bm.id;")
# dump
DUMP = r'''
    window.__DUMP = () => {
      scene.updateMatrixWorld(true);
      const tagSets = [['smoke', (animated || []).filter((a) => a.type === 'smoke').map((a) => a.m)], ['bubble', (bubbles || []).map((b) => b.m)],
        ['cloud', clouds || []], ['spin3d', spinners3d || []], ['spinring', spinRings || []], ['spinner', spinners || []]];
      const tagOf = new Map();
      tagSets.forEach(([n, arr]) => arr.forEach((m) => { if (m) tagOf.set(m, n); }));
      const meshes = [], mm = [];
      const walk = (o, sec, flag, anim) => {
        sec = (o.userData && o.userData.__sec) || sec; flag = (o.userData && o.userData.__flag != null ? o.userData.__flag : flag); anim = tagOf.get(o) || anim;
        if ((o.isMesh || o.isSprite) && o.geometry) {
          const g = o.geometry, mat = o.material || {};
          if (g.userData && g.userData.merged) {
            if (o.userData.__mm) mm.push({ id: o.userData.__mm, w: Array.from(o.matrixWorld.elements), sec: sec, flag: flag, anim: anim || '', mat: { type: mat.type, color: mat.color ? mat.color.getHex() : null, opacity: mat.opacity, transparent: mat.transparent, vc: !!mat.vertexColors } });
          } else {
            let pm = null;
            if (mat === pondMat.volcano) pm = 'volcano'; else if (mat === pondMat.void) pm = 'void'; else if (mat === pondMat.beach) pm = 'beach'; else if (mat === pondMat.swamp) pm = 'swamp'; else if (mat === pondMat.ice) pm = 'ice';
            const key = mat.customProgramCacheKey ? String(mat.customProgramCacheKey()) : '';
            meshes.push({ sec: sec, flag: flag, anim: anim || '', pond: pm, sprite: !!o.isSprite, gtype: g.type, params: g.parameters || null,
              bbox: (g.computeBoundingBox(), [g.boundingBox.min.toArray(), g.boundingBox.max.toArray()]),
              mat: { type: mat.type, color: mat.color ? mat.color.getHex() : null, opacity: mat.opacity, transparent: mat.transparent, studs: key.indexOf('studs') === 0, map: !!mat.map, vc: !!mat.vertexColors, blend: mat.blending, emissive: mat.emissive ? mat.emissive.getHex() : null, rough: mat.roughness, metal: mat.metalness },
              w: Array.from(o.matrixWorld.elements), name: o.name || '' });
          }
        }
        (o.children || []).forEach((c) => walk(c, sec, flag, anim));
      };
      scene.children.forEach((c) => walk(c, '', '', ''));
      const lights = [];
      scene.traverse((o) => { if (o.isPointLight) { const v = new THREE.Vector3(); o.getWorldPosition(v); lights.push({ sec: o.userData.__sec || '', color: o.color.getHex(), intensity: o.intensity, distance: o.distance, pos: v.toArray() }); } });
      const bub = bubbles.map((b) => [b.m.position.toArray(), b.m.scale.x, b.y, b.amp, b.sp, b.ph, b.m.material.color.getHex(), b.m.material.opacity]);
      return JSON.stringify({ prims: window.__REC.prims, meshes: meshes, mm: mm, names: window.__REC.names, labels: window.__REC.labels, smokePts: smoke.map((v) => v.toArray()), chests: window.__REC.chests || [], bub: bub, lights: lights });
    };
'''
rep("    let fpsAcc = 0, fpsN = 0;\n    loop();", "    let fpsAcc = 0, fpsN = 0;\n" + DUMP + "    loop();")

enc = json.dumps(t).replace('</', '<\\u002F')
out = s[:i] + '\n' + enc + '\n  ' + s[j:]
open(D + 'conv/map_instr.html', 'w', encoding='utf-8').write(out)
print('ok', len(out))
