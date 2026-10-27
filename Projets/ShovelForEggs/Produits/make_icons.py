from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os
S='/tmp/claude-0/-home-claude/0522e506-4ff5-515c-bb01-904cbde954ec/scratchpad'
FIP=S+'/fip/Free Icon Pack 3.0.1 (Basic)/'
def fip(p): return Image.open(FIP+p).convert('RGBA')
def egg(k): return Image.open(S+f'/eggs/Egg512_{k}.png').convert('RGBA')
N=512; OUT=(4,4,53)
def font(sz):
    f=ImageFont.truetype(S+'/Montserrat.ttf', sz)
    try: f.set_variation_by_name('Black')
    except Exception: f.set_variation_by_name('ExtraBold')
    return f
def lerp(a,b,t): return tuple(int(a[i]+(b[i]-a[i])*t) for i in range(3))
def bg(top, bot):
    im=Image.new('RGBA',(N,N),(0,0,0,0)); d=ImageDraw.Draw(im)
    d.rounded_rectangle([0,0,N-1,N-1],radius=56,fill=OUT+(255,))
    inner=Image.new('RGBA',(N,N),(0,0,0,0)); di=ImageDraw.Draw(inner)
    for y in range(N):
        di.line([(0,y),(N,y)],fill=lerp(top,bot,y/N)+(255,))
    m=Image.new('L',(N,N),0); ImageDraw.Draw(m).rounded_rectangle([18,18,N-19,N-19],radius=42,fill=255)
    im.paste(inner,(0,0),m)
    # studs (motif du kit)
    st=Image.new('RGBA',(N,N),(0,0,0,0)); ds=ImageDraw.Draw(st)
    for gy in range(40,N-30,64):
        for gx in range(40,N-30,64):
            ds.rounded_rectangle([gx,gy,gx+34,gy+34],radius=8,outline=(255,255,255,38),width=5)
    st.putalpha(Image.composite(st.split()[3],Image.new('L',(N,N),0),m))
    im.alpha_composite(st)
    # reflet en haut
    hl=Image.new('RGBA',(N,N),(0,0,0,0)); ImageDraw.Draw(hl).rounded_rectangle([30,28,N-31,150],radius=36,fill=(255,255,255,40))
    hl.putalpha(Image.composite(hl.split()[3],Image.new('L',(N,N),0),m))
    im.alpha_composite(hl)
    # liseré clair intérieur
    ImageDraw.Draw(im).rounded_rectangle([18,18,N-19,N-19],radius=42,outline=lerp(top,(255,255,255),0.45)+(255,),width=6)
    return im
def place(im, icon, size, cx, cy, rot=0):
    ic=icon.resize((size,size),Image.LANCZOS)
    if rot: ic=ic.rotate(rot,resample=Image.BICUBIC,expand=True)
    sh=Image.new('RGBA',ic.size,(0,0,0,0)); sh.putalpha(ic.split()[3].point(lambda a:int(a*0.35)))
    sh=sh.filter(ImageFilter.GaussianBlur(6))
    im.alpha_composite(sh,(cx-ic.width//2+6,cy-ic.height//2+10))
    im.alpha_composite(ic,(cx-ic.width//2,cy-ic.height//2))
def text(im, s, cx, cy, sz, fill=(255,255,255)):
    d=ImageDraw.Draw(im); f=font(sz)
    w=d.textlength(s,font=f)
    stroke=max(8,sz//7)
    # ombre
    d.text((cx-w/2+5,cy-sz*0.62+8),s,font=f,fill=OUT,stroke_width=stroke,stroke_fill=OUT)
    d.text((cx-w/2,cy-sz*0.62),s,font=f,fill=fill,stroke_width=stroke,stroke_fill=OUT)
GOLD=((255,214,70),(235,140,20)); GREEN=((110,225,90),(30,140,60)); 
icons={}
gold=egg('GoldenEgg')
# Golden eggs
def golden(n, label):
    im=bg(*GOLD)
    if n==1: place(im,gold,340,256,250)
    elif n==5:
        place(im,gold,230,160,270,10); place(im,gold,230,352,270,-10); place(im,gold,280,256,230)
    else:
        for (x,y,s,r) in ((130,300,200,14),(382,300,200,-14),(190,215,210,8),(322,215,210,-8),(256,270,270,0)): place(im,gold,s,x,y,r)
        if n==40: place(im,fip('Item/Crown/256px/Crown 1st Outline 256px.png'),170,256,95)
    text(im,label,360,430,110)
    return im
icons['Limited1']=golden(1,'x1'); icons['Limited2']=golden(5,'x5'); icons['Limited3']=golden(15,'x15'); icons['Limited4']=golden(40,'x40')
zone={'EggSnow':('SnowEgg',((150,205,255),(60,120,220))),'EggPine':('PineEgg',((130,230,120),(30,130,60))),'EggFrozen':('FrozenEgg',((120,225,255),(30,140,210))),
      'EggCrystal':('CrystalEgg',((190,150,255),(100,50,200))),'EggGlacier':('GlacierEgg',((190,225,255),(90,150,220))),'EggAurora':('AuroraEgg',((255,140,220),(110,40,170)))}
for key,(e,col) in zone.items():
    im=bg(*col); eg=egg(e)
    place(im,eg,250,150,280,10); place(im,eg,250,362,280,-10); place(im,eg,300,256,230)
    text(im,'x3',380,430,120); icons[key]=im
cash=fip('Currency/Cash/256px/Green Cash 1st Outline 256px.png'); cash2=fip('Currency/Cash/256px/Green Cash 2nd Outline 256px.png')
for key,label,n in (('Cash1','$5K',1),('Cash2','$50K',2),('Cash3','$250K',3),('Cash4','$1M',4),('Cash5','$5M',5)):
    im=bg(*GREEN)
    pos={1:[(256,220,320,0)],2:[(190,230,270,10),(320,220,290,-8)],3:[(160,250,250,12),(352,250,250,-12),(256,200,290,0)],
         4:[(150,260,240,14),(362,260,240,-14),(200,170,240,6),(312,170,240,-6),(256,230,280,0)],
         5:[(140,270,230,16),(372,270,230,-16),(190,170,230,8),(322,170,230,-8),(256,110,220,0),(256,250,290,0)]}[n]
    for (x,y,s,r) in pos: place(im,cash if s<280 else cash2,s,x,y,r)
    text(im,label,256,430,108); icons[key]=im
# Starter pack : coffre + pièces
im=bg((255,150,210),(200,60,170)); place(im,fip('Item/Chest/256px/Chest 1st Outline 256px.png'),330,256,235)
place(im,fip('Currency/Coin/256px/Golden Coin 1st Outline 256px.png'),130,110,350,-12); place(im,fip('Currency/Cash/256px/Green Cash 1st Outline 256px.png'),150,410,340,12)
text(im,'STARTER',256,440,82); icons['Starter']=im
# Hatch now : horloge + éclair
im=bg((255,190,90),(230,100,30)); place(im,fip('Item/Clock/256px/Clock 1st Outline 256px.png'),300,230,235)
place(im,fip('Main/Lighting/256px/Lighting 1st Outline 256px.png'),180,370,300,-10); place(im,gold,150,130,340,12)
text(im,'NOW!',256,440,100); icons['SkipEgg']=im
# Gift skip : cadeau + horloge
im=bg((200,150,255),(110,60,210)); place(im,fip('Item/Gift/256px/Red Gift 1st Outline 256px.png'),300,230,235)
place(im,fip('Item/Clock/256px/Golden Clock 1st Outline 256px.png'),170,380,320,-10)
text(im,'GIFT',256,440,100); icons['GiftSkip']=im
# x2 offline : pièces + lune
im=bg((90,110,220),(30,30,110))
for (x,y,s,r) in ((180,260,230,10),(330,250,250,-8)): place(im,fip('Currency/Coin/256px/Golden Coin 1st Outline 256px.png'),s,x,y,r)
place(im,fip('Main/Star/256px/Golden Star 1st Outline 256px.png'),120,400,110,10); place(im,fip('Main/Star/256px/Blue Star 1st Outline 256px.png'),80,110,110,-10)
text(im,'x2',256,440,120); icons['OfflineX2']=im
os.makedirs('out',exist_ok=True)
sheet=Image.new('RGBA',(170*7,170*3),(40,40,50,255))
for i,(k,im) in enumerate(icons.items()):
    im.save(f'out/Product_{k}.png',optimize=True)
    sheet.alpha_composite(im.resize((160,160),Image.LANCZOS),((i%7)*170+5,(i//7)*170+5))
sheet.save('sheet.png'); print(len(icons))
