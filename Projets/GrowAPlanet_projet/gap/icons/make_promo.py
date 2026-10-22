# Icône du jeu (512) + miniature (1920x1080), même style cartoon que les icônes.
import cairosvg, random
INK = '#0d1626'
random.seed(4)
def stars(w, h, n):
    out = ''
    for _ in range(n):
        x, y, r = random.uniform(0, w), random.uniform(0, h), random.choice([1.2, 1.6, 2.2, 3])
        out += f'<circle cx="{x:.0f}" cy="{y:.0f}" r="{r}" fill="#ffffff" opacity="{random.uniform(0.4, 1):.2f}"/>'
    return out
def sparkle(cx, cy, r, c='#fff6a8'):
    i = r * 0.3
    return f'<path d="M {cx} {cy-r} L {cx+i} {cy-i} L {cx+r} {cy} L {cx+i} {cy+i} L {cx} {cy+r} L {cx-i} {cy+i} L {cx-r} {cy} L {cx-i} {cy-i} Z" fill="{c}"/>'
def thick(d, color, w, sw=16):
    return (f'<path d="{d}" fill="none" stroke="{INK}" stroke-width="{w+sw}" stroke-linecap="round"/>'
            f'<path d="{d}" fill="none" stroke="{color}" stroke-width="{w}" stroke-linecap="round"/>')
# planète mignonne : boule + taches + reflet + visage + anneau
def planet(cx, cy, r, c1, c2, ring=None, face=True, gid='p'):
    g = f'<radialGradient id="{gid}" cx="0.35" cy="0.3" r="0.8"><stop offset="0" stop-color="{c1}"/><stop offset="1" stop-color="{c2}"/></radialGradient>'
    s = ''
    if ring:
        s += thick(f'M {cx-r*1.75} {cy+r*0.25} C {cx-r*1.6} {cy-r*0.45} {cx+r*1.6} {cy-r*0.75} {cx+r*1.75} {cy-r*0.2}', ring, r * 0.22, r * 0.12)
    s += f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="url(#{gid})" stroke="{INK}" stroke-width="{r*0.11}" paint-order="stroke"/>'
    s += f'<ellipse cx="{cx-r*0.45}" cy="{cy+r*0.42}" rx="{r*0.2}" ry="{r*0.13}" fill="#000" opacity="0.15"/><ellipse cx="{cx+r*0.5}" cy="{cy-r*0.5}" rx="{r*0.14}" ry="{r*0.1}" fill="#000" opacity="0.15"/>'
    s += f'<ellipse cx="{cx-r*0.42}" cy="{cy-r*0.5}" rx="{r*0.26}" ry="{r*0.15}" fill="#fff" opacity="0.8" transform="rotate(-30 {cx-r*0.42} {cy-r*0.5})"/>'
    if face:
        e = r * 0.13
        s += f'<ellipse cx="{cx-r*0.3}" cy="{cy+r*0.02}" rx="{e}" ry="{e*1.3}" fill="{INK}"/><ellipse cx="{cx+r*0.3}" cy="{cy+r*0.02}" rx="{e}" ry="{e*1.3}" fill="{INK}"/>'
        s += f'<circle cx="{cx-r*0.27}" cy="{cy-r*0.05}" r="{e*0.4}" fill="#fff"/><circle cx="{cx+r*0.33}" cy="{cy-r*0.05}" r="{e*0.4}" fill="#fff"/>'
        s += f'<path d="M {cx-r*0.14} {cy+r*0.28} Q {cx} {cy+r*0.42} {cx+r*0.14} {cy+r*0.28}" fill="none" stroke="{INK}" stroke-width="{r*0.07}" stroke-linecap="round"/>'
        s += f'<ellipse cx="{cx-r*0.55}" cy="{cy+r*0.25}" rx="{r*0.12}" ry="{r*0.07}" fill="#ff7aa8" opacity="0.7"/><ellipse cx="{cx+r*0.55}" cy="{cy+r*0.25}" rx="{r*0.12}" ry="{r*0.07}" fill="#ff7aa8" opacity="0.7"/>'
    if ring:
        s += thick(f'M {cx+r*1.75} {cy-r*0.2} C {cx+r*1.85} {cy+r*0.5} {cx-r*1.4} {cy+r*0.95} {cx-r*1.75} {cy+r*0.25}', ring, r * 0.22, r * 0.12)
    return g, s
def galaxy(cx, cy, s, c1='#c77dff', c2='#5ee7ff'):
    def t(d, c, w): return thick(d, c, w * s, 14 * s)
    out = t(f'M {cx} {cy} C {cx+44*s} {cy-30*s} {cx+82*s} {cy+4*s} {cx+70*s} {cy+44*s} C {cx+60*s} {cy+80*s} {cx+10*s} {cy+94*s} {cx-30*s} {cy+76*s}', c1, 26)
    out += t(f'M {cx} {cy} C {cx-44*s} {cy+30*s} {cx-82*s} {cy-4*s} {cx-70*s} {cy-44*s} C {cx-60*s} {cy-80*s} {cx-10*s} {cy-94*s} {cx+30*s} {cy-76*s}', c2, 26)
    out += f'<circle cx="{cx}" cy="{cy}" r="{38*s}" fill="#ffe3f6" stroke="{INK}" stroke-width="{14*s}" paint-order="stroke"/>'
    out += f'<ellipse cx="{cx-12*s}" cy="{cy-14*s}" rx="{12*s}" ry="{7*s}" fill="#fff"/>'
    return out
def title(x, y, size, text, fill='#ffe14a', anchor='middle', rot=0):
    st = size * 0.16
    base = f'x="{x}" font-family="Lilita One" font-size="{size}" text-anchor="{anchor}" stroke-linejoin="round"'
    return (f'<g transform="rotate({rot} {x} {y})">'
            f'<text {base} y="{y+size*0.07}" fill="{INK}" stroke="{INK}" stroke-width="{st*2}">{text}</text>'
            f'<text {base} y="{y}" fill="{INK}" stroke="{INK}" stroke-width="{st*2}">{text}</text>'
            f'<text {base} y="{y}" fill="{fill}">{text}</text></g>')
bg = lambda w, h: (f'<radialGradient id="bg" cx="0.5" cy="0.4" r="0.75"><stop offset="0" stop-color="#5b2bb5"/><stop offset="0.55" stop-color="#2a1466"/><stop offset="1" stop-color="#0b0a2a"/></radialGradient>'
                   f'<radialGradient id="neb1" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="#ff4fd8" stop-opacity="0.45"/><stop offset="1" stop-color="#ff4fd8" stop-opacity="0"/></radialGradient>'
                   f'<radialGradient id="neb2" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="#29c6ff" stop-opacity="0.45"/><stop offset="1" stop-color="#29c6ff" stop-opacity="0"/></radialGradient>')

# ICÔNE 512
g1, p1 = planet(256, 250, 120, '#ffb36b', '#e2541c', '#ffd23f', True, 'pA')
g2, p2 = planet(410, 110, 46, '#8be9ff', '#2a8de0', None, False, 'pB')
g3, p3 = planet(96, 400, 36, '#b6ff8a', '#2fae3a', None, False, 'pC')
icon = (f'<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512"><defs>{bg(512,512)}{g1}{g2}{g3}</defs>'
        f'<rect width="512" height="512" fill="url(#bg)"/><ellipse cx="120" cy="140" rx="200" ry="140" fill="url(#neb1)"/><ellipse cx="400" cy="390" rx="220" ry="150" fill="url(#neb2)"/>'
        + stars(512, 512, 90) + galaxy(110, 120, 0.85) + p2 + p3 + p1
        + sparkle(440, 250, 18) + sparkle(60, 270, 12) + sparkle(330, 470, 14)
        + title(256, 486, 58, 'GROW A PLANET') + '</svg>')
cairosvg.svg2png(bytestring=icon.encode(), write_to='GameIcon_512.png', output_width=512, output_height=512)

# MINIATURE 1920x1080
W, H = 1920, 1080
ga, pa = planet(1180, 600, 230, '#ffb36b', '#e2541c', '#ffd23f', True, 'tA')
gb, pb = planet(1640, 300, 95, '#8be9ff', '#2a8de0', None, True, 'tB')
gc, pc = planet(1600, 860, 80, '#e3a6ff', '#8a35e8', '#5ee7ff', True, 'tC')
gd, pd = planet(760, 860, 70, '#b6ff8a', '#2fae3a', None, True, 'tD')
thumb = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}"><defs>{bg(W,H)}{ga}{gb}{gc}{gd}</defs>'
         f'<rect width="{W}" height="{H}" fill="url(#bg)"/><ellipse cx="400" cy="300" rx="600" ry="380" fill="url(#neb1)"/><ellipse cx="1500" cy="800" rx="700" ry="400" fill="url(#neb2)"/>'
         + stars(W, H, 260) + galaxy(330, 760, 1.9, '#ffd23f', '#ff5c8a') + galaxy(1700, 560, 0.9)
         + pb + pc + pd + pa
         + sparkle(1000, 230, 40) + sparkle(1450, 1000, 30) + sparkle(560, 560, 26) + sparkle(1850, 120, 22)
         + title(560, 250, 190, 'GROW A', '#ffffff', 'middle', -4) + title(560, 450, 220, 'PLANET!', '#ffe14a', 'middle', -4)
         + title(560, 600, 80, 'HATCH GALAXIES', '#7dfcff', 'middle', -4) + '</svg>')
cairosvg.svg2png(bytestring=thumb.encode(), write_to='Thumbnail_1920.png', output_width=W, output_height=H)
print('ok')
