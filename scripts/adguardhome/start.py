import psutil
import json
import os
from adguardhome import AdGuardHome, AdGuardHomeError
import asyncio


cpu_count = os.cpu_count()

async def wait_cpu():
    loaded = 5
    while loaded > 0:
        load1, load5, load15 = psutil.getloadavg()
        print(load1, load5, load15)
        if load5 > 1:
            print('resetting')
            loaded = 5
        else:
            loaded = loaded -1
        await asyncio.sleep(5)



async def main():
    blacklists = json.load(open('./blacklists.json', 'r'))
    print(blacklists)

    async with AdGuardHome("192.168.1.14", username='admin', password=os.environ['ADGUARD_PASS']) as adguard:

        for _, url in blacklists.items():
            await wait_cpu()
            try:
                await adguard.filtering.enable_url(url=url, allowlist=False)
                await wait_cpu()
                return
            except AdGuardHomeError:
                print("Ran into an error")


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
