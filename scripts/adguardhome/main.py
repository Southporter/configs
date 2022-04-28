from adguardhome import AdGuardHome, AdGuardHomeError

import asyncio
import os
import traceback


clients = [
    {
        "name": "Dad's Phone",
        "ids": ["192.168.1.64"],
        "tags": ["device_phone", "user_regular", "os_android"],
        "use_global_block_settings": True,
        "use_global_blocked_services": True,
    },
    {
        "name": "Mom's Phone",
        "ids": ["192.168.1.65"],
        "tags": ["device_phone", "user_regular", "os_android"],
        "use_global_block_settings": True,
        "use_global_blocked_services": True,
    },
    {
        "name": "Mom's Laptop",
        "ids": ["192.168.1.66"],
        "tags": ["device_laptop", "user_admin", "os_windows"],
        "use_global_block_settings": True,
        "use_global_blocked_services": True,
    },
    {
        "name": "Work Laptop Ethernet C",
        "ids": ["192.168.1.72"],
        "tags": ["device_laptop", "user_admin", "os_macos"],
        "use_global_block_settings": True,
    },
    {
        "name": "Work Laptop Wifi C",
        "ids": ["192.168.1.73"],
        "tags": ["device_laptop", "user_admin", "os_macos"],
        "use_global_block_settings": True,
    },
    {
        "name": "Work Laptop Ethernet O",
        "ids": ["192.168.1.74"],
        "tags": ["device_laptop", "user_admin", "os_macos"],
        "use_global_block_settings": True,
    },
]

async def manage_clients(adguard: AdGuardHome):
    configured = await adguard.request('clients')
    configured_clients = configured['clients']
    print(configured_clients)
    for client in clients:
        try:
            if configured_clients is not None and next(c for c in configured_clients if c['name'] == client['name']) is not None:
                await adguard.request('clients/update', method='POST', json_data={'name': client['name'], 'data': client })
            else:
                await adguard.request('clients/add', method='POST', json_data=client)
                print(f"Added client {client['name']}")
        except AdGuardHomeError as age:
            print(age)

blacklists = {
    "abuse": "https://blocklistproject.github.io/Lists/adguard/abuse-ags.txt",
    "ads": "https://blocklistproject.github.io/Lists/adguard/ads-ags.txt",
    "crypto": "https://blocklistproject.github.io/Lists/adguard/crypto-ags.txt",
    "drugs": "https://blocklistproject.github.io/Lists/adguard/drugs-ags.txt",
    "fraud": "https://blocklistproject.github.io/Lists/adguard/fraud-ags.txt",
    "gambling": "https://blocklistproject.github.io/Lists/adguard/gambling-ags.txt",
    "malware": "https://blocklistproject.github.io/Lists/adguard/malware-ags.txt",
    "phishing": "https://blocklistproject.github.io/Lists/adguard/phishing-ags.txt",
    "piracy": "https://blocklistproject.github.io/Lists/adguard/piracy-ags.txt",
    "porn": "https://blocklistproject.github.io/Lists/adguard/porn-ags.txt",
    "ransomware": "https://blocklistproject.github.io/Lists/adguard/ransomware-ags.txt",
    "redirect": "https://blocklistproject.github.io/Lists/adguard/redirect-ags.txt",
    "scam": "https://blocklistproject.github.io/Lists/adguard/scam-ags.txt",
    "tiktok": "https://blocklistproject.github.io/Lists/adguard/tiktok-ags.txt",
    "tracking": "https://blocklistproject.github.io/Lists/adguard/tracking-ags.txt",
}

async def manage_filters(adguard: AdGuardHome):
    status = await adguard.request('filtering/status')
    filters = status['filters']
    for key, value in blacklists.items():
        found = None
        if filters is not None:
            try:
                found = next(item for item in filters if item['url'] == value)
            except StopIteration:
                pass
        try:
            if found is not None:
                print("Already added")
                continue

            await adguard.filtering.add_url(url=value, allowlist=False, name=key)
            await adguard.filtering.disable_url(url=value, allowlist=False)
            print(f"Added {key}")
        except AdGuardHomeError as age:
            print(f"Error adding {key}")
            print(age)
        except:
            print("Error occured")
            traceback.print_exc()


upstream_config = {
        'bootstrap_dns': ["1.0.0.3:53", "1.1.1.3:53", "208.67.222.123:53", "208.67.220.123:53", "2606:4700:4700::1113", "2606:4700:4700::1003"],
    'upstream_dns': ["https://family.cloudflare-dns.com/dns-query", "https://dns.quad9.net/dns-query"],
    'private_dns': ["192.168.1.1"],
    'local_ptr_upstreams': ['192.168.1.1'],
}

async def manage_dns_config(adguard: AdGuardHome):
    res = await adguard.request('test_upstream_dns', method='POST', json_data=upstream_config)

    print(res)
    res = await adguard.request('dns_info')
    print(res)
    res = await adguard.request('dns_config', method='POST', json_data=upstream_config)
    print(res)


blocked_apps = ["twitter", "tiktok", "instagram"]

async def manage_blocked_apps(adguard: AdGuardHome):
    res = await adguard.request('blocked_services/list')
    print(res)
    res = await adguard.request('blocked_services/set', method='POST', json_data=blocked_apps)

async def main():
    async with AdGuardHome("192.168.1.14", username='admin', password=os.environ['ADGUARD_PASS']) as adguard:

        await manage_blocked_apps(adguard)
        await manage_dns_config(adguard)
        await manage_filters(adguard)
        await manage_clients(adguard)


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
