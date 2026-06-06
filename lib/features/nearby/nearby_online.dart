// 附近服务 - 高德 Web API v5
// 全部用 key, 全国 POI 数据, 一次拉 4 类
// 类别: hospital/store/groom/emergency
// 严格兜底, 不阻塞 UI
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/location_service.dart';

class NearbyPoi {
  final String id;
  final String name;
  final String category;
  final String address;
  final double lat;
  final double lng;
  final double? distance;
  final String? phone;

  const NearbyPoi({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.lat,
    required this.lng,
    this.distance,
    this.phone,
  });
}

// 高德 Web API Key (永久, 父 2026-06-07 02:09 明确提供, 已存 SOUL.md 顶)
// 编译时可用 --dart-define=AMAP_KEY=... 覆盖
const _kAmapKey = String.fromEnvironment('AMAP_KEY', defaultValue: '62b07f765e9eaaeee9628eb98da73b5a');

String nearbyCatEmoji(String cat) {
  switch (cat) {
    case 'hospital': return '🏥';
    case 'store': return '🏪';
    case 'groom': return '✂️';
    case 'emergency': return '🚑';
    default: return '📍';
  }
}

class NearbyService {
  /// GPS 定位 (强兜底 5s)
  static Future<MyLocation?> getLocation() async {
    try {
      return await LocationService.getMyLocation()
          .timeout(const Duration(seconds: 5), onTimeout: () => null);
    } catch (_) { return null; }
  }

  /// 按城市名查 (高德 geocode - 拿真实坐标, 解决 IP 不准问题)
  static Future<MyLocation?> geocodeCity(String city) async {
    if (_kAmapKey.isEmpty) return null;
    try {
      final resp = await http.get(Uri.https('restapi.amap.com', '/v3/geocode/geo', {
        'key': _kAmapKey,
        'address': city,
        'city': '',
        'extensions': 'base',
      })).timeout(const Duration(seconds: 4));
      if (resp.statusCode != 200) return null;
      final j = jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
      if (j['status']?.toString() != '1') return null;
      final geocodes = (j['geocodes'] as List?) ?? [];
      if (geocodes.isEmpty) return null;
      final first = geocodes.first as Map<String, dynamic>;
      final loc = first['location']?.toString() ?? '';
      final parts = loc.split(',');
      if (parts.length != 2) return null;
      final lng = double.tryParse(parts[0]) ?? 0;
      final lat = double.tryParse(parts[1]) ?? 0;
      return MyLocation(lat: lat, lng: lng, address: city, source: 'city');
    } catch (e) {
      debugPrint('[NearbyService] geocodeCity error: $e');
      return null;
    }
  }

  /// 按 lat/lng 查某类别 (高德, 强兜底 5s)
  static Future<List<NearbyPoi>> search({
    required double lat,
    required double lng,
    required String category,
    int radiusM = 10000,
  }) async {
    if (_kAmapKey.isEmpty) return [];
    final params = _amapParams(category, lat, lng, radiusM);
    final url = Uri.https('restapi.amap.com', '/v5/place/around', params);
    debugPrint('[NearbyService] key=${_kAmapKey.substring(0, 6)}..(${_kAmapKey.length}) lat=$lat lng=$lng cat=$category url=$url');
    try {
      final resp = await http.get(url).timeout(const Duration(seconds: 5));
      final bodyStr = utf8.decode(resp.bodyBytes);
      final bodyPreview = bodyStr.length > 200 ? bodyStr.substring(0, 200) : bodyStr;
      debugPrint('[NearbyService] status=${resp.statusCode} body=$bodyPreview');
      if (resp.statusCode != 200) return [];
      final j = jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
      if (j['status']?.toString() != '1') return [];
      final pois = (j['pois'] as List?) ?? [];
      return pois.map<NearbyPoi>((e) {
        final m = e as Map<String, dynamic>;
        final loc = (m['location']?.toString() ?? '').split(',');
        final lng1 = loc.isNotEmpty ? double.tryParse(loc[0]) ?? lng : lng;
        final lat1 = loc.length > 1 ? double.tryParse(loc[1]) ?? lat : lat;
        return NearbyPoi(
          id: m['id']?.toString() ?? '',
          name: m['name']?.toString() ?? '宠物服务',
          category: category,
          address: m['address']?.toString() ?? (m['adname']?.toString() ?? ''),
          lat: lat1,
          lng: lng1,
          distance: _haversine(lat, lng, lat1, lng1),
          phone: (m['tel']?.toString()?.isNotEmpty ?? false) ? m['tel'].toString() : null,
        );
      }).toList();
    } on TimeoutException { return []; } catch (e) {
      debugPrint('[NearbyService] search error: $e');
      return [];
    }
  }

  static Map<String, String> _amapParams(String cat, double lat, double lng, int radius) {
    final base = {
      'key': _kAmapKey,
      'location': '$lng,$lat',
      'radius': radius.clamp(100, 50000).toString(),
      'sortrule': 'distance',
      'offset': '25',
      'extensions': 'base',
    };
    switch (cat) {
      case 'hospital':
        return { ...base, 'keywords': '宠物医院|动物医院', 'types': '090701' };
      case 'store':
        return { ...base, 'keywords': '宠物店|宠物用品', 'types': '061211' };
      case 'groom':
        return { ...base, 'keywords': '宠物美容|宠物洗澡', 'types': '090202' };
      case 'emergency':
        return { ...base, 'keywords': '24小时宠物|宠物急诊|夜诊宠物', 'types': '090701' };
      default:
        return { ...base, 'keywords': '宠物医院|宠物店', 'types': '090701|061211' };
    }
  }
}

double _haversine(double lat1, double lng1, double lat2, double lng2) {
  const R = 6371.0;
  final dLat = (lat2 - lat1) * math.pi / 180;
  final dLng = (lng2 - lng1) * math.pi / 180;
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * math.pi / 180) * math.cos(lat2 * math.pi / 180) *
      math.sin(dLng / 2) * math.sin(dLng / 2);
  return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}
