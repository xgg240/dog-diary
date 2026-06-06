// 狗玩地方 - 在线 POI 服务 (高德 v5, 全 key)
//  全部用高德 keywords+types 查: 宠物公园 / 宠物咖啡 / 宠物海滩 / 宠物友好餐厅 / 宠物酒店
//  强兜底 5s, 不卡死
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/location_service.dart';
import '../../core/ui/modern_widgets.dart';

class OnlinePoi {
  final String id;
  final String name;
  final String category;
  final String address;
  final String? cityname;
  final double lat;
  final double lng;
  final double? distance;   // km
  final String? phone;
  final String source;      // 'amap'

  const OnlinePoi({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    this.cityname,
    required this.lat,
    required this.lng,
    this.distance,
    this.phone,
    this.source = 'amap',
  });
}

// 高德 Web API Key (父 2026-06-07 02:09 提供, 永久 SOUL.md)
const _kAmapKey = String.fromEnvironment('AMAP_KEY', defaultValue: '62b07f765e9eaaeee9628eb98da73b5a');

/// 狗玩 POI 6 类 (不含医院/店/美容, 那些在 nearby 页)
const kPoiSpec = {
  'park':       ('宠物公园|宠物乐园|萌宠乐园|宠物友好公园', '080100|080300|110100|110101|110102|110200|110201|110202'),
  'cafe':       ('宠物咖啡|宠物咖啡馆|萌宠咖啡',          '061000|050000'),
  'beach':      ('宠物海滩|宠物友好海滩|宠物沙滩',         '110200|110201'),
  'garden':     ('宠物花园|宠物友好公园',                  '110100|110200|080100'),
  'hotel':      ('宠物友好酒店|宠物酒店|允许宠物酒店|宠物民宿|宠物寄养', '100100|100200'),
  'restaurant': ('宠物友好餐厅|宠物餐厅|宠物主题餐厅|宠物咖啡', '050000|061000'),
};

/// 附近服务 POI 3 类 (nearby 页用)
const kNearbyPoiSpec = {
  'hospital': ('宠物医院|动物医院|宠物诊所|24小时宠物医院|夜间宠物医院', '090701'),
  'store':    ('宠物店|宠物用品店|宠物超市',                '061211'),
  'groom':    ('宠物美容|宠物洗澡|宠物造型',                '090202'),
};

String catLabel(String cat) {
  switch (cat) {
    case 'park': return '🌳 宠物公园';
    case 'cafe': return '☕ 宠物咖啡';
    case 'beach': return '🏖️ 宠物海滩';
    case 'garden': return '🌸 宠物花园';
    case 'hotel': return '🏨 宠物酒店';
    case 'restaurant': return '🍴 宠物餐厅';
    case 'hospital': return '🏥 宠物医院';
    case 'store': return '🏪 宠物店';
    case 'groom': return '✂️ 宠物美容';
    case 'mall': return '🛍️ 宠物商场';
    case 'snow': return '❄️ 宠物雪场';
    case 'training': return '🎓 宠物训练';
    default: return '📍 宠物友好';
  }
}

String catEmoji(String cat) => catLabel(cat).split(' ').first;

class DogPlayOnline {
  /// 按 lat/lng 查某类别 (高德, 强兜底 5s)
  static Future<List<OnlinePoi>> searchByLatLng({
    required double lat,
    required double lng,
    String category = 'park',
    int radiusM = 10000,
  }) async {
    if (_kAmapKey.isEmpty) return [];
    final spec = kPoiSpec[category] ?? kPoiSpec['park']!;
    final url = Uri.https('restapi.amap.com', '/v5/place/around', {
      'key': _kAmapKey,
      'location': '$lng,$lat',
      'keywords': spec.$1,
      'types': spec.$2,
      'radius': radiusM.clamp(100, 50000).toString(),
      'sortrule': 'distance',
      'offset': '25',
      'extensions': 'base',
    });
    try {
      final resp = await http.get(url).timeout(const Duration(seconds: 5));
      if (resp.statusCode != 200) return [];
      final j = jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
      if (j['status']?.toString() != '1') return [];
      final pois = (j['pois'] as List?) ?? [];
      return pois.map<OnlinePoi>((e) {
        final m = e as Map<String, dynamic>;
        final loc = (m['location']?.toString() ?? '').split(',');
        final lng1 = loc.isNotEmpty ? double.tryParse(loc[0]) ?? lng : lng;
        final lat1 = loc.length > 1 ? double.tryParse(loc[1]) ?? lat : lat;
        return OnlinePoi(
          id: m['id']?.toString() ?? '',
          name: m['name']?.toString() ?? '宠物服务',
          category: category,
          address: m['address']?.toString() ?? (m['adname']?.toString() ?? ''),
          cityname: m['cityname']?.toString() ?? m['adname']?.toString(),
          lat: lat1,
          lng: lng1,
          distance: haversineKm(lat, lng, lat1, lng1),
          phone: (m['tel']?.toString()?.isNotEmpty ?? false) ? m['tel'].toString() : null,
        );
      }).toList();
    } on TimeoutException { return []; } catch (e) {
      debugPrint('[DogPlayOnline] error: $e');
      return [];
    }
  }

  /// 按城市名查 (高德 v5/place/text - region=城市名/adcode 都能查)
  static Future<List<OnlinePoi>> searchByCity(String city, {String category = 'park', int radiusM = 30000}) async {
    if (_kAmapKey.isEmpty) return [];
    try {
      // 先 geocode 拿中心点坐标 (算距离用), region 优先用 city name (高德原生支持, 不依赖 geocode 成功)
      double cLng = 0, cLat = 0;
      try {
        final geo = await http.get(Uri.https('restapi.amap.com', '/v3/geocode/geo', {
          'key': _kAmapKey,
          'address': city,
          'city': '',
          'extensions': 'base',
        })).timeout(const Duration(seconds: 4));
        if (geo.statusCode == 200) {
          final gj = jsonDecode(utf8.decode(geo.bodyBytes)) as Map<String, dynamic>;
          if (gj['status']?.toString() == '1') {
            final geocodes = (gj['geocodes'] as List?) ?? [];
            if (geocodes.isNotEmpty) {
              final first = geocodes.first as Map<String, dynamic>;
              final loc = first['location']?.toString() ?? '';
              final parts = loc.split(',');
              if (parts.length == 2) {
                cLng = double.tryParse(parts[0]) ?? 0;
                cLat = double.tryParse(parts[1]) ?? 0;
              }
            }
          }
        }
      } catch (_) {}

      // 查 POI - 关键词+types 按类别, region=城市名 (高德原生态直接拿)
      final spec = kPoiSpec[category] ?? kPoiSpec['park']!;
      final params = {
        'key': _kAmapKey,
        'keywords': spec.$1,
        'types': spec.$2,
        'region': city,    // 城市名直接当 region, 不用 adcode
        'sortrule': 'weight',
        'offset': '25',
        'extensions': 'base',
        'page_size': '25',
      };
      final url = Uri.https('restapi.amap.com', '/v5/place/text', params);
      final resp = await http.get(url).timeout(const Duration(seconds: 5));
      if (resp.statusCode != 200) return [];
      final j = jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
      if (j['status']?.toString() != '1') return [];
      final pois = (j['pois'] as List?) ?? [];
      return pois.map<OnlinePoi>((e) {
        final m = e as Map<String, dynamic>;
        final lloc = (m['location']?.toString() ?? '').split(',');
        final llng = lloc.isNotEmpty ? double.tryParse(lloc[0]) ?? cLng : cLng;
        final llat = lloc.length > 1 ? double.tryParse(lloc[1]) ?? cLat : cLat;
        return OnlinePoi(
          id: m['id']?.toString() ?? '',
          name: m['name']?.toString() ?? '宠物服务',
          category: category,
          address: m['address']?.toString() ?? (m['adname']?.toString() ?? ''),
          cityname: m['cityname']?.toString() ?? m['adname']?.toString(),
          lat: llat,
          lng: llng,
          distance: (cLat != 0 || cLng != 0) ? haversineKm(cLat, cLng, llat, llng) : null,
          phone: (m['tel']?.toString()?.isNotEmpty ?? false) ? m['tel'].toString() : null,
        );
      }).toList()
        ..sort((a, b) => (a.distance ?? 9999).compareTo(b.distance ?? 9999));
    } on TimeoutException { return []; } catch (e) {
      debugPrint('[DogPlayOnline] searchByCity error: $e');
      return [];
    }
  }

  /// 一次性查全部 9 类 (用 Future.wait 并行, 总 5s)
  static Future<Map<String, List<OnlinePoi>>> searchAllByLatLng({
    required double lat,
    required double lng,
    int radiusM = 10000,
  }) async {
    final results = await Future.wait(
      kPoiSpec.keys.map((cat) async {
        final list = await searchByLatLng(lat: lat, lng: lng, category: cat, radiusM: radiusM);
        return MapEntry(cat, list);
      }),
    ).timeout(const Duration(seconds: 6), onTimeout: () => <MapEntry<String, List<OnlinePoi>>>[]);
    return { for (final e in results) e.key: e.value };
  }
}

double haversineKm(double lat1, double lng1, double lat2, double lng2) {
  const R = 6371.0;
  final dLat = (lat2 - lat1) * math.pi / 180;
  final dLng = (lng2 - lng1) * math.pi / 180;
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * math.pi / 180) * math.cos(lat2 * math.pi / 180) *
      math.sin(dLng / 2) * math.sin(dLng / 2);
  return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

/// GPS 定位 (强兜底 5s)
class DogPlayLocation {
  static Future<MyLocation?> get() async {
    try {
      return await LocationService.getMyLocation()
          .timeout(const Duration(seconds: 5), onTimeout: () => null);
    } catch (_) { return null; }
  }
}
