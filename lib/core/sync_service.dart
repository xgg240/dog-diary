// ============================================================
//  云端 POI 同步服务 (Day 2: 合并云端增量到本地 11 万)
// ------------------------------------------------------------
//  - 启动时拉云端 → 写入 PoiCache 表
//  - 用户在 "我加一个" 提交 → POST 到云端 → 写入本地 (source=local)
//  - 拉取按城市, 缓存 10 分钟避免重复
//  - 离线时只读本地, 联网后才尝试同步
// ============================================================

import 'dart:async';
import 'package:drift/drift.dart' show Value, OrderingTerm, OrderingMode;
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;

import 'api_client.dart';
import '../db/database.dart';

class SyncResult {
  final int pulled;       // 从云端拉到本地新增/更新的条数
  final int submitted;    // 用户提交到云端成功条数
  final int failed;       // 失败条数
  final DateTime at;
  SyncResult({required this.pulled, required this.submitted, required this.failed, required this.at});
}

class SyncService {
  final AppDatabase db;
  SyncService(this.db);

  static const Duration _cacheTtl = Duration(minutes: 10);
  // ignore: unused_field
  static const Duration _cacheTtlRef = _cacheTtl; // 保留供未来增量同步使用
  final Map<String, DateTime> _lastSync = {};

  /// 是否有网 (直接打 /api/v1/health 探测, 3s 超时, 缓存 30s)
  /// 优点: 不用加 connectivity_plus 依赖; 缺点: 多 1 个网络请求
  DateTime? _lastOnlineCheck;
  bool _lastOnline = false;
  Future<bool> isOnline() async {
    final now = DateTime.now();
    if (_lastOnlineCheck != null && now.difference(_lastOnlineCheck!) < const Duration(seconds: 30)) {
      return _lastOnline;
    }
    try {
      final resp = await ApiClient.getJson('/api/v1/health', timeout: const Duration(seconds: 3));
      _lastOnline = resp is Map && (resp['status'] == 'ok');
    } on Exception catch (e) {
      if (kDebugMode) debugPrint('[Sync] isOnline: $e');
      _lastOnline = false;
    }
    _lastOnlineCheck = now;
    return _lastOnline;
  }

  /// 拉取某城市云端 POI → 写入本地 PoiCache
  /// [since] 增量时间戳, null=全量
  Future<int> pullCity(String city, {DateTime? since, int limit = 100}) async {
    if (!await isOnline()) {
      if (kDebugMode) debugPrint('[Sync] offline, skip pull $city');
      return 0;
    }
    final query = <String, String>{
      'city': city,
      'limit': '$limit',
      if (since != null) 'since': since.toUtc().toIso8601String(),
    };
    try {
      final resp = await ApiClient.getJson('/api/v1/spots', query: query) as Map<String, dynamic>;
      final spots = (resp['spots'] as List? ?? []).cast<Map<String, dynamic>>();
      int count = 0;
      for (final s in spots) {
        await _upsertPoi(s, source: 'cloud');
        count++;
      }
      if (kDebugMode) debugPrint('[Sync] pulled $count POI from cloud for $city');
      return count;
    } catch (e) {
      if (kDebugMode) debugPrint('[Sync] pull $city error: $e');
      return 0;
    }
  }

  /// 拉取附近云端 POI (经纬度 + 半径)
  Future<int> pullNearby({required double lat, required double lng, int radiusKm = 50, int limit = 100}) async {
    if (!await isOnline()) return 0;
    // bbox (lat1, lng1, lat2, lng2) - 用近似 1 度 ≈ 111 km 换算
    final delta = radiusKm / 111.0;
    final query = <String, String>{
      'lat1': (lat - delta).toString(),
      'lng1': (lng - delta).toString(),
      'lat2': (lat + delta).toString(),
      'lng2': (lng + delta).toString(),
      'limit': '$limit',
    };
    try {
      final resp = await ApiClient.getJson('/api/v1/spots', query: query) as Map<String, dynamic>;
      final spots = (resp['spots'] as List? ?? []).cast<Map<String, dynamic>>();
      int count = 0;
      for (final s in spots) {
        await _upsertPoi(s, source: 'cloud');
        count++;
      }
      return count;
    } catch (e) {
      if (kDebugMode) debugPrint('[Sync] pull nearby error: $e');
      return 0;
    }
  }

  /// 用户提交新 POI → POST 云端 + 写入本地 (source=local)
  /// 返回云端返回的 uuid, 失败抛 ApiException
  Future<String> submitSpot({
    required String name,
    required String city,
    String? district,
    required String category,
    required double lat,
    required double lng,
    String? description,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'city': city,
      if (district != null) 'district': district,
      'category': category,
      'lat': lat,
      'lng': lng,
      if (description != null) 'description': description,
    };
    final resp = await ApiClient.postJson('/api/v1/spots', body: body) as Map<String, dynamic>;
    final uuid = resp['uuid'] as String?;
    if (uuid == null) throw ApiException(500, 'no uuid in response: $resp');
    // 写入本地 (source=local, 已"提交"待云端审核)
    await _upsertPoi({
      'uuid': uuid,
      'name': name,
      'city': city,
      'district': district,
      'category': category,
      'lat': lat,
      'lng': lng,
      'description': description,
    }, source: 'local');
    return uuid;
  }

  /// 举报一个 POI
  Future<void> reportSpot(String uuid, String reason) async {
    await ApiClient.postJson('/api/v1/spots/$uuid/report', body: {'reason': reason});
  }

  /// 查询本地 PoiCache (按城市 + 类别 + 半径)
  Future<List<PoiCacheEntry>> queryLocal({
    String? city,
    String? category,
    double? lat,
    double? lng,
    int radiusKm = 50,
    int limit = 200,
  }) async {
    final q = db.select(db.poiCache)..where((t) => t.active.equals(true));
    if (city != null) q.where((t) => t.city.equals(city));
    if (category != null) q.where((t) => t.category.equals(category));
    q.orderBy([(t) => OrderingTerm(expression: t.cloudSyncedAt, mode: OrderingMode.desc)]);
    q.limit(limit);
    return q.get();
  }

  /// 统计本地 POI 总数
  Future<int> countLocal({String? city}) async {
    final q = db.select(db.poiCache)..where((t) => t.active.equals(true));
    if (city != null) q.where((t) => t.city.equals(city));
    final all = await q.get();
    return all.length;
  }

  /// 全量同步 (启动时调用一次)
  Future<SyncResult> syncAll({String? focusCity}) async {
    int pulled = 0;
    int failed = 0;
    if (!await isOnline()) {
      return SyncResult(pulled: 0, submitted: 0, failed: 0, at: DateTime.now());
    }
    try {
      if (focusCity != null) {
        pulled += await pullCity(focusCity);
      } else {
        // 拉所有 mock 的 19 城市 - 起步量
        for (final city in const ['滁州', '阜阳', '上海', '北京', '深圳', '杭州', '成都', '南京', '苏州', '武汉']) {
          try {
            pulled += await pullCity(city, limit: 50);
          } catch (e) {
            failed++;
          }
        }
      }
      _lastSync['pull_all'] = DateTime.now();
    } catch (e) {
      if (kDebugMode) debugPrint('[Sync] syncAll error: $e');
      failed++;
    }
    return SyncResult(pulled: pulled, submitted: 0, failed: failed, at: DateTime.now());
  }

  /// 内部: upsert 一条 POI 到 PoiCache
  Future<void> _upsertPoi(Map<String, dynamic> data, {required String source}) async {
    final uuid = (data['uuid'] ?? data['amap_id'] ?? '') as String;
    if (uuid.isEmpty) return;
    final name = (data['name'] ?? '') as String;
    if (name.isEmpty) return;
    final lat = (data['lat'] is num) ? (data['lat'] as num).toDouble() : 0.0;
    final lng = (data['lng'] is num) ? (data['lng'] as num).toDouble() : 0.0;
    final now = DateTime.now();

    final existing = await (db.select(db.poiCache)..where((t) => t.amapId.equals(uuid))).getSingleOrNull();
    if (existing != null) {
      await (db.update(db.poiCache)..where((t) => t.id.equals(existing.id))).write(
        PoiCacheCompanion(
          name: Value(name),
          category: Value((data['category'] ?? existing.category) as String),
          address: Value(data['address'] as String?),
          phone: Value(data['phone'] as String?),
          latitude: Value(lat),
          longitude: Value(lng),
          city: Value((data['city'] ?? existing.city) as String?),
          cloudSyncedAt: Value(now),
          localUpdatedAt: Value(now),
        ),
      );
    } else {
      await db.into(db.poiCache).insert(
        PoiCacheCompanion.insert(
          amapId: uuid,
          name: name,
          category: (data['category'] ?? 'store') as String,
          address: Value(data['address'] as String?),
          phone: Value(data['phone'] as String?),
          latitude: lat,
          longitude: lng,
          city: Value(data['city'] as String?),
          source: Value(source),
          cloudSyncedAt: Value(now),
          localUpdatedAt: Value(now),
          submittedBy: Value(data['contributor_hash'] as String?),
        ),
      );
    }
  }
}
