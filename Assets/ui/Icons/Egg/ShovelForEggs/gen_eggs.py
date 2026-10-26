from PIL import Image, ImageDraw, ImageFilter, ImageChops
import math
SRC='/mnt/user-data/uploads/Rake Vault/Assets/ui/Icons/Egg/Egg 1st Outline 256px.png'
base=Image.open(SRC).convert('RGBA')
S=4; N=256*S
big=base.resize((N,N),Image.BICUBIC)
bp=big.load()
OUT=(4,4,53)
# masques
body=Image.new('L',(N,N),0); shine=Image.new('L',(N,N),0)
bpx=body.load(); spx=shine.load()
for y in range(N):
    for x in range(N):
        r,g,b,a=bp[x,y]
        if a>128 and r>150:  # remplissage (orange) ou reflet
            bpx[x,y]=255
            if g>225 and b>200: spx[x,y]=255
body_in=body.filter(ImageFilter.MinFilter(9))

def lerp(a,b,t): return tuple(int(a[i]+(b[i]-a[i])*t) for i in range(3))
def recolor(pal):
    sh,dk,md,lt=pal
    im=big.copy(); p=im.load()
    for y in range(N):
        for x in range(N):
            r,g,b,a=p[x,y]
            if a>0 and r>150 and not (g>225 and b>200):
                t=max(0.0,min(1.0,(g-149)/(187-149)))
                if t<0.4: c=lerp(sh,dk,t/0.4)
                elif t<0.75: c=lerp(dk,md,(t-0.4)/0.35)
                else: c=lerp(md,lt,(t-0.75)/0.25)
                p[x,y]=c+(a,)
    return im

def overlay(im, draw_fn):
    lay=Image.new('RGBA',(N,N),(0,0,0,0)); d=ImageDraw.Draw(lay)
    draw_fn(d)
    m=ImageChops.multiply(lay.split()[3], body)
    lay.putalpha(m)
    im.alpha_composite(lay)
    # reflet par-dessus
    w=Image.new('RGBA',(N,N),(255,255,255,255)); w.putalpha(ImageChops.multiply(shine, Image.new('L',(N,N),235)))
    im.alpha_composite(w)
    return im

def wave(y0, amp, period, phase=0, x0=0, x1=N):
    return [(x, y0+amp*math.sin((x/period)*2*math.pi+phase)) for x in range(x0,x1+8,8)]
def band(d, ytop, ybot, col, amp=18, period=260, phase=0, ow=14):
    top=wave(ytop,amp,period,phase); bot=wave(ybot,amp,period,phase)
    poly=top+bot[::-1]
    d.polygon(poly, fill=col)
    d.line(top, fill=OUT, width=ow); d.line(bot, fill=OUT, width=ow)
def star(d,cx,cy,r,col,ow=12,pts=4):
    P=[]
    for i in range(pts*2):
        ang=math.pi/pts*i-math.pi/2; rr=r if i%2==0 else r*0.38
        P.append((cx+rr*math.cos(ang), cy+rr*math.sin(ang)))
    d.polygon(P, fill=col, outline=OUT, width=ow)
def flake(d,cx,cy,r,col):
    for k in range(3):
        a=math.pi/3*k
        p1=(cx+r*math.cos(a),cy+r*math.sin(a)); p2=(cx-r*math.cos(a),cy-r*math.sin(a))
        d.line([p1,p2],fill=OUT,width=34); 
    for k in range(3):
        a=math.pi/3*k
        p1=(cx+r*math.cos(a),cy+r*math.sin(a)); p2=(cx-r*math.cos(a),cy-r*math.sin(a))
        d.line([p1,p2],fill=col,width=16)
    d.ellipse([cx-24,cy-24,cx+24,cy+24],fill=col,outline=OUT,width=10)
def diamond(d,cx,cy,w,h,col,col2):
    P=[(cx,cy-h),(cx+w,cy),(cx,cy+h),(cx-w,cy)]
    d.polygon(P,fill=col,outline=OUT,width=14)
    d.polygon([(cx,cy-h+18),(cx+w*0.45,cy),(cx,cy+h*0.2)],fill=col2)

EGGS={}
# Snow (Village) : blanc bleuté + écharpe rouge rayée + flocon
def snow(d):
    band(d,560,690,(225,45,60),amp=14,period=300)
    for x in range(100,960,120):
        d.polygon([(x,540),(x+55,540),(x+15,720),(x-40,720)],fill=(255,245,245,255))
    top=wave(560,14,300); bot=wave(690,14,300)
    d.line(top,fill=OUT,width=14); d.line(bot,fill=OUT,width=14)
    flake(d,512,350,130,(120,190,255))
    star(d,330,820,40,(255,255,255)); star(d,690,830,30,(255,255,255))
EGGS['SnowEgg']=(((170,200,230),(205,225,245),(235,245,255),(250,253,255)),snow)
# Pine (Forest) : vert + neige sur le dessus
def pine(d):
    pts=[(0,0),(N,0),(N,300)]
    xs=list(range(N,-1,-16))
    for x in xs:
        y=300+28*math.sin(x/90.0)+ (40 if (x//120)%2==0 else 0)*abs(math.sin(x/120*math.pi))
        pts.append((x,y))
    pts.append((0,300))
    d.polygon(pts,fill=(248,252,255))
    d.line(pts[3:],fill=OUT,width=14)
    for cx,cy in ((360,620),(640,700),(500,820)):
        star(d,cx,cy,40,(255,255,255),ow=10,pts=4)
EGGS['PineEgg']=(((25,110,55),(45,150,75),(70,185,95),(110,215,125)),pine)
# Frozen (Lac gelé) : cyan + fissures de glace
def frozen(d):
    for path in ([(300,240),(380,330),(340,420),(430,520)], [(700,300),(640,400),(700,480),(640,580),(690,660)], [(420,700),(500,780),(470,880)]):
        d.line(path,fill=OUT,width=26,joint='curve'); d.line(path,fill=(240,252,255),width=12,joint='curve')
    star(d,560,470,55,(255,255,255)); star(d,330,640,38,(255,255,255))
EGGS['FrozenEgg']=(((40,140,210),(70,180,235),(110,210,250),(170,235,255)),frozen)
# Crystal (Grotte) : violet + cristaux
def crystal(d):
    diamond(d,330,640,70,150,(255,120,210),(255,200,240))
    diamond(d,520,560,90,200,(120,235,255),(220,250,255))
    diamond(d,710,650,65,140,(255,120,210),(255,200,240))
    star(d,430,330,40,(255,255,255))
EGGS['CrystalEgg']=(((70,35,140),(100,60,180),(135,95,215),(170,135,240)),crystal)
# Glacier : bleu très pâle + bandes de glace
def glacier(d):
    band(d,380,450,(150,200,240),amp=22,period=240)
    band(d,560,640,(110,170,230),amp=22,period=240,phase=1.5)
    band(d,750,820,(150,200,240),amp=22,period=240,phase=3)
EGGS['GlacierEgg']=(((165,195,225),(200,220,240),(228,240,252),(245,250,255)),glacier)
# Aurora : bleu nuit + vagues rose / cyan + étoiles
def aurora(d):
    band(d,430,520,(90,240,210),amp=34,period=320)
    band(d,580,660,(255,110,200),amp=34,period=320,phase=1.2)
    for cx,cy,r in ((340,300,34),(650,330,26),(520,800,30),(330,760,22)):
        star(d,cx,cy,r,(255,240,150),ow=10)
EGGS['AuroraEgg']=(((15,20,65),(30,40,100),(50,60,135),(75,90,170)),aurora)
# North Pole : rouge + rayures sucre d'orge
def northpole(d):
    for k in range(-6,8):
        x=k*170
        d.polygon([(x,0),(x+70,0),(x+70+N,N),(x+N,N)],fill=(255,250,250))
    for k in range(-6,8):
        x=k*170
        d.line([(x,0),(x+N,N)],fill=OUT,width=10); d.line([(x+70,0),(x+70+N,N)],fill=OUT,width=10)
EGGS['NorthPoleEgg']=(((150,15,30),(195,30,45),(230,55,65),(250,100,100)),northpole)
# Golden
def golden(d):
    star(d,400,330,48,(255,255,255)); star(d,640,620,36,(255,255,255)); star(d,420,760,26,(255,255,255))
EGGS['GoldenEgg']=(((210,120,10),(240,160,20),(255,200,40),(255,230,110)),golden)

sheet=Image.new('RGBA',(256*len(EGGS),256),(40,44,70,255))
for i,(k,(pal,fn)) in enumerate(EGGS.items()):
    im=overlay(recolor(pal),fn).resize((256,256),Image.LANCZOS)
    im.save(f'Egg_{k}.png',optimize=True)
    sheet.alpha_composite(im,(i*256,0))
sheet.save('sheet.png')
print('ok')
