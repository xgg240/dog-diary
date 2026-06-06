#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""OSM 批量拉取中国 33 个省级 dog play POI (重启继续, 增量保存, 容错)"""
import json, urllib.request, urllib.parse, time, os, sys, signal

OUT = '/Users/xiaochib/Desktop/养狗日记源码/assets/data/dog_play_spots_osm_raw.json'

PROVINCES = [
    ('北京', 39.9, 116.4), ('天津', 39.1, 117.2), ('上海', 31.2, 121.5), ('重庆', 29.6, 106.5),
    ('河北', 38.0, 114.5), ('山西', 37.9, 112.5), ('内蒙古', 40.8, 111.7),
    ('辽宁', 41.8, 123.4), ('吉林', 43.9, 125.3), ('黑龙江', 45.7, 126.5),
    ('江苏', 32.0, 118.8), ('浙江', 29.1, 120.0), ('安徽', 31.8, 117.3),
    ('福建', 26.1, 119.3), ('江西', 28.7, 115.9), ('山东', 36.7, 117.0),
    ('河南', 33.9, 113.6), ('湖北', 30.6, 114.3), ('湖南', 27.6, 111.7),
    ('广东', 23.1, 113.3), ('广西', 23.8, 108.4), ('海南', 19.6, 110.0),
    ('四川', 30.7, 104.1), ('贵州', 26.6, 106.7), ('云南', 24.9, 102.7),
    ('陕西', 34.3, 108.9), ('甘肃', 35.7, 103.8), ('青海', 36.6, 96.4),
    ('宁夏', 38.5, 106.3), ('新疆', 43.8, 87.6),
    ('台湾', 23.7, 121.0), ('香港', 22.3, 114.2), ('澳门', 22.2, 113.5),
]

def query(s, w, n, e, timeout=15):
    q = f'''[out:json][timeout:{timeout}];
(
node["leisure"="park"]({s},{w},{n},{e});
node["leisure"="garden"]({s},{w},{n},{e});
node["natural"="beach"]({s},{w},{n},{e});
node["amenity"="cafe"]({s},{w},{n},{e});
node["amenity"="restaurant"]({s},{w},{n},{e});
node["tourism"="hotel"]({s},{w},{n},{e});
node["shop"="pet"]({s},{w},{n},{e});
node["amenity"="veterinary"]({s},{w},{n},{e});
node["leisure"="dog_park"]({s},{w},{n},{e});
);
out center tags 1500;'''
    mirrors = ['https://overpass-api.de/api/interpreter',
               'https://overpass.kumi.systems/api/interpreter',
               'https://overpass.osm.ch/api/interpreter']
    data = urllib.parse.urlencode({'data': q}).encode('utf-8')
    for m in mirrors:
        try:
            req = urllib.request.Request(m, data=data, method='POST', headers={'User-Agent': 'dog_diary/1.0'})
            with urllib.request.urlopen(req, timeout=timeout+5) as r:
                return json.loads(r.read().decode('utf-8')).get('elements', [])
        except Exception as e:
            print(f'    {m[:30]} err: {str(e)[:60]}', file=sys.stderr, flush=True)
            time.sleep(1)
    return []

# 加载已存
all_elems = []
done = set()
if os.path.exists(OUT):
    all_elems = json.load(open(OUT, encoding='utf-8'))
    done = set(e.get('_province') for e in all_elems)
    print(f'已存 {len(all_elems)} 个, 跳过 {len(done)} 省', flush=True)

# 处理 SIGINT 优雅保存
def save():
    with open(OUT, 'w', encoding='utf-8') as f:
        json.dump(all_elems, f, ensure_ascii=False)
    print(f'💾 已存 {len(all_elems)} 个 → {OUT}', flush=True)
signal.signal(signal.SIGINT, lambda s,f: (save(), sys.exit(0)))
signal.signal(signal.SIGTERM, lambda s,f: (save(), sys.exit(0)))

for i, (name, lat, lng) in enumerate(PROVINCES):
    if name in done:
        print(f'  [{i+1:2d}/{len(PROVINCES)}] {name} ✓ 跳过', flush=True)
        continue
    s, w, n, e = lat-1.5, lng-1.5, lat+1.5, lng+1.5
    print(f'→ [{i+1:2d}/{len(PROVINCES)}] {name} ({s:.1f},{w:.1f})-({n:.1f},{e:.1f})', flush=True)
    t0 = time.time()
    elems = query(s, w, n, e, timeout=12)
    print(f'  {len(elems)} 个, {time.time()-t0:.1f}s', flush=True)
    for x in elems:
        x['_province'] = name
    all_elems.extend(elems)
    save()
    time.sleep(2)

print(f'\n✓ 完成: {len(all_elems)} 个 elem', flush=True)
