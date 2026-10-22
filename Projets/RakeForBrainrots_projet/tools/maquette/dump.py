import asyncio, sys
from playwright.async_api import async_playwright
async def main():
    async with async_playwright() as p:
        b = await p.chromium.launch(args=["--use-gl=swiftshader","--enable-webgl","--ignore-gpu-blocklist","--enable-unsafe-swiftshader"])
        pg = await b.new_page(viewport={"width":1440,"height":900})
        msgs=[]
        pg.on("console", lambda m: msgs.append(m.type+": "+m.text))
        pg.on("pageerror", lambda e: msgs.append("ERR: "+str(e)))
        await pg.goto("file://"+sys.argv[1])
        for k in range(40):
            await pg.wait_for_timeout(1000)
            ok = await pg.evaluate("!!window.__DUMP")
            if ok: break
        print("\n".join(msgs[:20]))
        await pg.wait_for_timeout(1500)
        js = await pg.evaluate("window.__DUMP()")
        open(sys.argv[2],"w").write(js)
        print("dumped", len(js))
        await b.close()
asyncio.run(main())
