#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""合并现有 dog_play_spots.json (2219 静态) + OSM 拉取 (11561 elem) → 输出统一格式"""
import json, os, sys
from collections import Counter
from math import radians, sin, cos, sqrt, atan2

OLD = '/Users/xiaochib/Desktop/养狗日记源码/assets/data/dog_play_spots.json'
OSM = '/Users/xiaochib/Desktop/养狗日记源码/assets/data/dog_play_spots_osm_raw.json'
OUT = '/Users/xiaochib/Desktop/养狗日记源码/assets/data/dog_play_spots.json'


def cat_of(elem):
    t = elem.get('tags', {})
    if t.get('leisure') == 'dog_park': return 'park'
    if t.get('leisure') == 'park': return 'park'
    if t.get('leisure') == 'garden': return 'garden'
    if t.get('natural') == 'beach': return 'beach'
    if t.get('amenity') == 'cafe': return 'cafe'
    if t.get('amenity') == 'restaurant': return 'restaurant'
    if t.get('amenity') == 'veterinary': return 'hospital'  # 医院
    if t.get('tourism') == 'hotel': return 'hotel'
    if t.get('shop') == 'pet': return 'store'
    return None


def haversine_m(lat1, lng1, lat2, lng2):
    R = 6371000
    dlat = radians(lat2 - lat1)
    dlng = radians(lng2 - lng1)
    a = sin(dlat/2)**2 + cos(radians(lat1))*cos(radians(lat2))*sin(dlng/2)**2
    return R * 2 * atan2(sqrt(a), sqrt(1-a))


def osm_to_spot(elem):
    cat = cat_of(elem)
    if not cat:
        return None
    if elem.get('type') == 'node':
        lat, lng = elem.get('lat'), elem.get('lon')
    else:
        c = elem.get('center', {})
        lat, lng = c.get('lat'), c.get('lon')
    if lat is None or lng is None:
        return None
    tags = elem.get('tags', {})
    name = tags.get('name:zh') or tags.get('name') or tags.get('name:en') or '未命名'
    addr_parts = [tags.get('addr:city'), tags.get('addr:district'), tags.get('addr:street')]
    addr = tags.get('addr:full') or ', '.join(filter(None, addr_parts)) or tags.get('address') or elem.get('_province', '')
    return {
        'id': f"osm-{elem.get('type','x')}-{elem.get('id','')}",
        'name': name,
        'category': cat,
        'city': tags.get('addr:city') or elem.get('_province', '中国'),
        'address': addr,
        'lat': lat,
        'lng': lng,
        'source': 'OSM',
        'osm_id': elem.get('id'),
    }


def main():
    all_spots = []

    # 1) 旧 2219 静态
    if os.path.exists(OLD):
        old = json.load(open(OLD, encoding='utf-8'))
        spots = old.get('spots') or old.get('data') or []
        all_spots.extend(spots)
        print(f'旧静态: {len(spots)} 个', flush=True)

    # 2) OSM 拉取
    osm_count = 0
    if os.path.exists(OSM):
        raw = json.load(open(OSM, encoding='utf-8'))
        for e in raw:
            s = osm_to_spot(e)
            if s:
                all_spots.append(s)
                osm_count += 1
        print(f'OSM 转 spot: {osm_count} 个', flush=True)

    # 3) Dedupe (按 lat/lng 100m + name 头 6 字)
    print(f'去重前: {len(all_spots)}', flush=True)
    seen_keys = set()
    unique = []
    for s in all_spots:
        lat, lng = s.get('lat'), s.get('lng')
        if lat is None or lng is None:
            unique.append(s)
            continue
        # 简化: 同 0.01° (~1.1km) 内同名 → 视为同一
        key = (round(float(lat), 2), round(float(lng), 2), s.get('name', '')[:6])
        if key in seen_keys:
            continue
        seen_keys.add(key)
        unique.append(s)
    print(f'去重后: {len(unique)}', flush=True)

    # 4) 类目统计
    cats = Counter(s.get('category', '') for s in unique)
    print(f'类目: {dict(cats)}', flush=True)
    cities = set(s.get('city', '') for s in unique)
    print(f'城市: {len(cities)} 个', flush=True)

    # 5) 输出 (覆盖原文件)
    out_data = {
        'version': '3.0-osm-merged',
        'updated': __import__('time').strftime('%Y-%m-%d'),
        'total_cities': len(cities),
        'total_spots': len(unique),
        'categories': list(set(s.get('category', '') for s in unique)),
        'spots': unique,
    }
    with open(OUT, 'w', encoding='utf-8') as f:
        json.dump(out_data, f, ensure_ascii=False, indent=1)
    size_mb = os.path.getsize(OUT) / 1024 / 1024
    print(f'\n✓ 写入 {OUT} ({size_mb:.1f} MB)', flush=True)


if __name__ == '__main__':
    main()
