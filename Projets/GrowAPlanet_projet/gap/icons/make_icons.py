# Icônes du jeu en SVG -> PNG transparent 512 px, style du kit : contour bleu nuit épais, couleurs vives, reflet blanc.
import cairosvg
INK = '#0d1626'
def grad(id, a, b):
    return f'<linearGradient id="{id}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{a}"/><stop offset="1" stop-color="{b}"/></linearGradient>'
def svg(body, defs=''):
    return f'<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256"><defs>{defs}</defs>{body}</svg>'
# contour : on dessine la forme avec un gros trait foncé derrière (paint-order)
def shape(d, fill, sw=18):
    return f'<path d="{d}" fill="{fill}" stroke="{INK}" stroke-width="{sw}" stroke-linejoin="round" paint-order="stroke"/>'
def circ(cx, cy, r, fill, sw=18):
    return f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{fill}" stroke="{INK}" stroke-width="{sw}" paint-order="stroke"/>'
def thick(d, color, w):
    return (f'<path d="{d}" fill="none" stroke="{INK}" stroke-width="{w+18}" stroke-linecap="round" stroke-linejoin="round"/>'
            f'<path d="{d}" fill="none" stroke="{color}" stroke-width="{w}" stroke-linecap="round" stroke-linejoin="round"/>')
def shine(cx, cy, rx, ry, rot):
    return f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="#ffffff" opacity="0.85" transform="rotate({rot} {cx} {cy})"/>'
def star(cx, cy, r, color='#fff6a8'):
    i = r * 0.35
    d = f'M {cx} {cy-r} L {cx+i} {cy-i} L {cx+r} {cy} L {cx+i} {cy+i} L {cx} {cy+r} L {cx-i} {cy+i} L {cx-r} {cy} L {cx-i} {cy-i} Z'
    return f'<path d="{d}" fill="{color}"/>'
dollar = 'M 150 92 C 150 78 136 70 122 70 C 104 70 92 80 92 94 C 92 112 108 118 128 124 C 150 131 164 138 164 158 C 164 176 148 186 128 186 C 110 186 94 178 92 162 M 128 52 L 128 204'

icons = {
 'galaxy': svg(
   thick('M 128 128 C 172 98 210 132 198 172 C 188 208 138 222 98 204', '#c77dff', 30) +
   thick('M 128 128 C 84 158 46 124 58 84 C 68 48 118 34 158 52', '#5ee7ff', 30) +
   circ(128, 128, 42, 'url(#g1)') + shine(112, 108, 14, 9, -20) +
   star(212, 52, 14) + star(44, 200, 11) + star(206, 214, 9) + star(50, 44, 8),
   grad('g1', '#ffffff', '#ff8de1')),
 'planet': svg(
   thick('M 26 156 C 34 116 222 84 230 112', '#ffd23f', 22) +
   circ(128, 120, 72, 'url(#g2)') +
   '<ellipse cx="98" cy="146" rx="18" ry="13" fill="#b8401a" opacity="0.55"/><ellipse cx="152" cy="94" rx="13" ry="9" fill="#b8401a" opacity="0.55"/><ellipse cx="160" cy="150" rx="10" ry="7" fill="#b8401a" opacity="0.55"/>' +
   shine(100, 82, 18, 10, -28) +
   thick('M 230 112 C 238 142 62 196 26 156', '#ffd23f', 22),
   grad('g2', '#ffa35c', '#e2541c')),
 'settings': svg(
   ''.join(f'<rect x="112" y="18" width="32" height="44" rx="8" fill="url(#g3)" stroke="{INK}" stroke-width="16" paint-order="stroke" transform="rotate({a} 128 128)"/>' for a in range(0, 360, 45)) +
   circ(128, 128, 78, 'url(#g3)') + circ(128, 128, 30, '#2c3648', 16) + shine(96, 92, 20, 10, -35),
   grad('g3', '#d9e2ee', '#7f8ea6')),
 'upgrade': svg(shape('M 128 22 L 228 128 L 168 128 L 168 232 L 88 232 L 88 128 L 28 128 Z', 'url(#g4)') + shine(108, 82, 12, 28, -35), grad('g4', '#b6ff5c', '#2fbf3a')),
 'money': svg(circ(122, 140, 84, 'url(#g5b)') + circ(132, 122, 84, 'url(#g5)') +
   f'<path d="{dollar}" fill="none" stroke="{INK}" stroke-width="34" stroke-linecap="round" stroke-linejoin="round" transform="translate(4 -6)"/>' +
   f'<path d="{dollar}" fill="none" stroke="#ffffff" stroke-width="16" stroke-linecap="round" stroke-linejoin="round" transform="translate(4 -6)"/>' +
   shine(92, 74, 18, 10, -30), grad('g5', '#ffe86b', '#ffb21f') + grad('g5b', '#ffcf3a', '#c96f08')),
 'codes': svg('<g transform="rotate(-12 128 128)">' + shape('M 26 74 L 230 74 L 230 112 C 208 112 208 148 230 148 L 230 186 L 26 186 L 26 148 C 48 148 48 112 26 112 Z', 'url(#g6)') +
   '<rect x="68" y="104" width="120" height="14" rx="7" fill="#ffffff" opacity="0.9"/><rect x="68" y="134" width="84" height="14" rx="7" fill="#ffffff" opacity="0.9"/></g>', grad('g6', '#ffb347', '#f0660f')),
 'sell': svg(shape('M 122 24 L 230 24 L 230 132 L 122 240 L 16 134 Z', 'url(#g7)') + circ(188, 66, 14, '#ffffff', 10) +
   f'<g transform="translate(-4 14) rotate(45 128 128) scale(0.62) translate(78 70)"><path d="{dollar}" fill="none" stroke="{INK}" stroke-width="40" stroke-linecap="round"/><path d="{dollar}" fill="none" stroke="#ffffff" stroke-width="20" stroke-linecap="round"/></g>',
   grad('g7', '#ff7a7a', '#d8263a')),
 'base': svg(shape('M 52 118 L 204 118 L 204 230 L 52 230 Z', 'url(#g8)') + shape('M 18 128 L 128 28 L 238 128 Z', 'url(#g9)') +
   shape('M 104 230 L 104 172 C 104 150 152 150 152 172 L 152 230 Z', '#ffd23f', 12) + shine(96, 70, 22, 10, -40),
   grad('g8', '#8be3ff', '#2a8de0') + grad('g9', '#c77dff', '#7a2fe0')),
 'luck': svg('<g transform="translate(128 128) scale(1.45) translate(-128 -128)">' + ''.join(shape(f'M 128 128 C 80 128 58 92 76 70 C 92 50 120 62 128 86 C 136 62 164 50 180 70 C 198 92 176 128 128 128 Z', 'url(#ga)', 12).replace('<path', f'<path transform="rotate({a} 128 128)"') for a in (0, 90, 180, 270)) + '</g>' + circ(128, 128, 18, '#2fbf3a', 12), grad('ga', '#9dff6a', '#2fae3a')),
 'hatch': svg(shape('M 128 26 C 190 26 220 110 220 152 C 220 204 180 234 128 234 C 76 234 36 204 36 152 C 36 110 66 26 128 26 Z', 'url(#gb)') +
   shape('M 44 130 L 80 112 L 104 138 L 128 110 L 152 138 L 176 112 L 212 130', 'none', 12).replace('fill="none"', 'fill="none"') + shine(96, 72, 18, 26, -20), grad('gb', '#e7c6ff', '#9a4dff')),
 'robuxgalaxy': svg(thick('M 128 128 C 172 98 210 132 198 172 C 188 208 138 222 98 204', '#ffd23f', 30) + thick('M 128 128 C 84 158 46 124 58 84 C 68 48 118 34 158 52', '#ff5c8a', 30) + circ(128, 128, 42, 'url(#gc)') + shine(112, 108, 14, 9, -20), grad('gc', '#ffffff', '#ffd23f')),
}
for name, s in icons.items():
    cairosvg.svg2png(bytestring=s.encode(), write_to=f'icon_{name}.png', output_width=512, output_height=512)
print('ok', len(icons))
