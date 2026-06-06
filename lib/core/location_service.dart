// ============================================================
//  定位服务 (真 GPS + 北斗优先, IP 兜底)
// ------------------------------------------------------------
//  GPS / 北斗: geolocator (macOS / iOS / Android)
//  - 优先高精度 (GPS + 北斗双模)
//  - 失败回退 IP 定位 (ipwho.is)
//  - 缓存避免重复请求
// ============================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

/// 热门城市离线坐标 (高德 geocode 等价, 无 key 也能用)
const Map<String, (double lat, double lng)> kCityCoords = {
  '北京':   (39.9042, 116.4074),
  '上海':   (31.2304, 121.4737),
  '广州':   (23.1291, 113.2644),
  '深圳':   (22.5431, 114.0579),
  '杭州':   (30.2741, 120.1551),
  '南京':   (32.0603, 118.7969),
  '苏州':   (31.2989, 120.5853),
  '成都':   (30.5728, 104.0668),
  '武汉':   (30.5928, 114.3055),
  '西安':   (34.3416, 108.9398),
  '重庆':   (29.5630, 106.5516),
  '滁州':   (32.3019, 118.3167),  // 狗主所在
  '合肥':   (31.8206, 117.2272),
  '全椒':   (32.0853, 118.2736),  // 滁州下辖, 后端 POI 集中地
  '阜阳':   (32.8901, 115.8147),
  '天津':   (39.3434, 117.3616),
  '长沙':   (28.2282, 112.9388),
  '青岛':   (36.0671, 120.3826),
  '厦门':   (24.4798, 118.0894),
  '宁波':   (29.8683, 121.5440),
  '无锡':   (31.4912, 120.3119),
  '福州':   (26.0745, 119.2965),
  '郑州':   (34.7466, 113.6253),
  '济南':   (36.6512, 117.1201),
  '沈阳':   (41.8057, 123.4315),
  '大连':   (38.9140, 121.6147),
  '昆明':   (25.0389, 102.7183),
  '海口':   (20.0444, 110.1989),
  '三亚':   (18.2528, 109.5119),
  '拉萨':   (29.6520, 91.1721),
  '乌鲁木齐': (43.8256, 87.6168),
  '哈尔滨': (45.8038, 126.5350),
  '长春':   (43.8868, 125.3245),
  '石家庄': (38.0428, 114.5149),
  '太原':   (37.8706, 112.5489),
  '兰州':   (36.0611, 103.8343),
  '西宁':   (36.6232, 101.7804),
  '银川':   (38.4872, 106.2309),
  '南昌':   (28.6820, 115.8579),
  '贵阳':   (26.6470, 106.6302),
  '南宁':   (22.8170, 108.3665),
};

/// IP 拿到的英文/拼音城市 → 中文 key 映射
const Map<String, String> _ipCityToKey = {
  'beijing': '北京', 'shanghai': '上海', 'guangzhou': '广州', 'shenzhen': '深圳',
  'hangzhou': '杭州', 'nanjing': '南京', 'suzhou': '苏州', 'chengdu': '成都',
  'wuhan': '武汉', "xi'an": '西安', 'xian': '西安', 'chongqing': '重庆',
  'chuzhou': '滁州', 'hefei': '合肥', 'quanjiao': '全椒', 'fuyang': '阜阳',
  'tianjin': '天津', 'changsha': '长沙', 'qingdao': '青岛', 'xiamen': '厦门',
  'ningbo': '宁波', 'wuxi': '无锡', 'fuzhou': '福州', 'zhengzhou': '郑州',
  'jinan': '济南', 'shenyang': '沈阳', 'dalian': '大连', 'kunming': '昆明',
  'haikou': '海口', 'sanya': '三亚', 'lhasa': '拉萨', 'wulumuqi': '乌鲁木齐',
  'harbin': '哈尔滨', 'changchun': '长春', 'shijiazhuang': '石家庄',
  'taiyuan': '太原', 'lanzhou': '兰州', 'xining': '西宁', 'yinchuan': '银川',
  'nanchang': '南昌', 'guiyang': '贵阳', 'nanning': '南宁',
};

/// 匹配 IP 给的城市名 (中文/英文) → kCityCoords 的 key
String matchCityForTest(String s) => _matchCity(s) ?? "未匹配";
String? _matchCity(String cityStr) {
  if (cityStr.isEmpty) return null;
  // 1) 直接匹配 (中文)
  if (kCityCoords.containsKey(cityStr)) return cityStr;
  // 2) 英文/拼音 映射
  final lower = cityStr.toLowerCase();
  if (_ipCityToKey.containsKey(lower)) return _ipCityToKey[lower];
  // 3) 模糊包含 (例如 "Chuzhou City" → 滁州)
  for (final e in _ipCityToKey.entries) {
    if (lower.contains(e.key)) return e.value;
  }
  for (final k in kCityCoords.keys) {
    if (lower.contains(k)) return k;
  }
  return null;
}

class MyLocation {
  final double lat;
  final double lng;
  final String address;
  final String source; // 'gps' / 'ip' / 'city' / 'cache' / 'denied'
  final double? accuracy; // GPS 精度 (米)
  final DateTime? fetchedAt; // 缓存时间
  const MyLocation({required this.lat, required this.lng, required this.address, required this.source, this.accuracy, this.fetchedAt});
}

/// 用户手动选城市 (跨页面共享, GPS+IP 不准时用)
String? _overrideCity;
String? get overrideCity => _overrideCity;
void setOverrideCity(String? city) {
  _overrideCity = city;
  if (city == null || city.isEmpty) {
    MyLocationCache.clear();
    return;
  }
  final coord = kCityCoords[city];
  if (coord != null) {
    MyLocationCache.set(MyLocation(lat: coord.$1, lng: coord.$2, address: city, source: 'city'));
  } else {
    MyLocationCache.clear();
  }
}

/// 全局缓存 (10 分钟内直接返回, 避免重复请求)
class MyLocationCache {
  static MyLocation? current;
  static const Duration maxAge = Duration(minutes: 10);
  static bool isValid() {
    if (current == null) return false;
    if (current!.fetchedAt == null) return false;
    return DateTime.now().difference(current!.fetchedAt!) < maxAge;
  }
  static void set(MyLocation loc) { current = loc; }
  static void clear() { current = null; }
}

class LocationService {
  /// 真 GPS 定位 (优先 GPS + 北斗双模, 8s 超时)
  static LocationSettings _getBestLocationSettings() {
    if (Platform.isAndroid) {
      // Android: 优先 GPS+北斗 (Android 12+ GPS 已默认支持北斗, 不强制 forceLocationManager 避免 ANR)
      return AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 8),
        distanceFilter: 0,
        intervalDuration: const Duration(seconds: 0),
      );
    } else if (Platform.isIOS) {
      // iOS 15+: CLLocationManager 默认支持 GPS+GLONASS+Galileo+BeiDou
      return AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 8),
        distanceFilter: 0,
      );
    } else if (Platform.isMacOS) {
      // macOS CoreLocation: GPS+WiFi+IP, 不支持北斗 (Mac 没蜂窝)
      return AppleSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 6),
        distanceFilter: 0,
      );
    }
    return const LocationSettings(accuracy: LocationAccuracy.bestForNavigation, timeLimit: Duration(seconds: 8), distanceFilter: 0);
  }

  static Future<MyLocation?> getGpsLocation() async {
    try {
      print('[Location] check permission start (platform=${Platform.operatingSystem})');
      // 1) 检查/请求权限 - macOS sandbox 这里可能 hang, 6s 兑底
      LocationPermission perm = await Geolocator.checkPermission()
          .timeout(const Duration(seconds: 6), onTimeout: () => LocationPermission.denied);
      print('[Location] checkPermission → $perm');
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission()
            .timeout(const Duration(seconds: 6), onTimeout: () => LocationPermission.denied);
        print('[Location] requestPermission → $perm');
      }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        print('[Location] permission denied');
        return null;
      }

      // 2) 检查服务开启 - 也可能 hang
      final serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
      print('[Location] serviceEnabled → $serviceEnabled');
      if (!serviceEnabled) {
        print('[Location] service disabled');
        return null;
      }

      // 3) 获取当前位置 (高精度)
      print('[Location] getCurrentPosition start');
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: _getBestLocationSettings(),
      );
      print('[Location] getCurrentPosition ok');

      print('[Location] GPS: lat=${pos.latitude}, lng=${pos.longitude}, accuracy=${pos.accuracy}m, altitude=${pos.altitude}m, speed=${pos.speed}');

      return MyLocation(
        lat: pos.latitude,
        lng: pos.longitude,
        address: '当前位置',
        source: 'gps',
        accuracy: pos.accuracy,
        fetchedAt: DateTime.now(),
      );
    } on TimeoutException {
      print('[Location] GPS timeout');
      return null;
    } catch (e) {
      print('[Location] GPS error: $e');
      return null;
    }
  }

  /// IP 定位 (兜底, 速度最快但精度差, 城市级 ~5-50km)
  static Future<MyLocation?> getIpLocation() async {
    try {
      final client = http.Client();
      final resp = await client.get(
        Uri.parse('https://ipwho.is/'),
        headers: {'User-Agent': 'dog_diary/1.0', 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 4));
      client.close();
      if (resp.statusCode != 200) return null;
      final j = jsonDecode(resp.body) as Map<String, dynamic>;
      if (j['success'] == false) return null;
      final lat = (j['latitude'] as num?)?.toDouble();
      final lng = (j['longitude'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;
      final city = j['city'] ?? '';
      final region = j['region'] ?? '';
      final country = j['country'] ?? '';
      final addr = [city, region, country].where((s) => s.toString().isNotEmpty).join(' · ');
      print('[Location] IP: $addr ($lat, $lng)');
      // IP 只返回位置, 不设 override (父 02:55 要 GPS+北斗+IP 兑底, 不写死默认位置)
      return MyLocation(
        lat: lat,
        lng: lng,
        address: addr.isEmpty ? '$lat, $lng' : addr,
        source: 'ip',
        accuracy: 50000, // IP 城市级精度 ~50km
        fetchedAt: DateTime.now(),
      );
    } catch (e) {
      print('[Location] IP error: $e');
      return null;
    }
  }

  /// 统一入口: override 城市 > 缓存 > GPS > IP, 总超时 8s 防止 UI 卡死
  static Future<MyLocation?> getMyLocation() async {
    // 0) override 城市优先 (macOS GPS 被拒/IP 偏时用)
    if (_overrideCity != null && _overrideCity!.isNotEmpty) {
      final c = kCityCoords[_overrideCity!];
      if (c != null) {
        print('[Location] override city $_overrideCity → (${c.$1},${c.$2})');
        return MyLocation(lat: c.$1, lng: c.$2, address: _overrideCity!, source: 'city');
      }
    }
    // 1) 缓存优先 (10 分钟内)
    if (MyLocationCache.isValid()) {
      print('[Location] cache hit (${MyLocationCache.current?.source})');
      return MyLocationCache.current;
    }
    try {
      print('[Location] getMyLocation start');
      final loc = await Future.any<MyLocation?>([
        _gpsThenIp(),
        Future<MyLocation?>.delayed(const Duration(seconds: 8), () {
          print('[Location] 8s timeout, returning null');
          return null;
        }),
      ]);
      print('[Location] getMyLocation done → ${loc?.source} (${loc?.lat},${loc?.lng})');
      if (loc != null) MyLocationCache.set(loc);
      return loc;
    } catch (e) {
      print('[Location] getMyLocation error: $e');
      return null;
    }
  }

  static Future<MyLocation?> _gpsThenIp() async {
    final gps = await getGpsLocation();
    if (gps != null) return gps;
    return await getIpLocation();
  }

  /// 两点距离 (km) - Haversine
  static double distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLng = (lng2 - lng1) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) * math.cos(lat2 * math.pi / 180) *
        math.sin(dLng / 2) * math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }
}
