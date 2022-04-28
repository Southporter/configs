from ruamel.yaml import YAML
from pathlib import Path


always_on_filters = [
    'https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt',
    'https://blocklistproject.github.io/Lists/adguard/ads-ags.txt',
]

file = Path('/var/lib/AdGuardHome/AdGuardHome.yaml')

yaml = YAML()
data = yaml.load(file)
for filter in data['filters']:
    if filter['url'] not in always_on_filters:
        filter['enabled'] = False
yaml.dump(data, file)
    
