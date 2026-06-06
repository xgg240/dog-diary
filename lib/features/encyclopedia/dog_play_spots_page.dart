// 宠物友好 - 现代简约版 v3
// 黑白蓝 + 大圆角 + 卡片式 + 类别 chip 筛选
import 'dart:math' as mathx;
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data_loader.dart';
import 'dog_play_online.dart' show OnlinePoi, DogPlayOnline, catLabel;
import 'dog_play_add_page.dart';
import '../../core/location_service.dart' show LocationService, setOverrideCity, overrideCity, kCityCoords, MyLocation;
import '../../core/providers.dart';
import '../../core/sync_service.dart';
import '../../core/ui/design_tokens.dart';
import '../../db/database.dart';

class DogPlaySpotsPage extends ConsumerStatefulWidget {
  const DogPlaySpotsPage({super.key});
  @override
  ConsumerState<DogPlaySpotsPage> createState() => _DogPlaySpotsPageState();
}

class _DogPlaySpotsPageState extends ConsumerState<DogPlaySpotsPage> with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  final _cloudCityCtrl = TextEditingController();
  late final TabController _tab = TabController(length: 3, vsync: this);
  String _query = '';
  String _catFilter = 'all';
  String _cityFilter = '';

  MyLocation? _myLoc;
  List<OnlinePoi> _onlinePois = [];
  bool _loadingOnline = false;
  String _onlineErr = '';

  List<PoiCacheEntry> _cloudPois = [];
  bool _loadingCloud = false;
  String _cloudErr = '';
  String _cloudCity = '滁州';

  @override
  void initState() {
    super.initState();
    // 默认城市 = 手动 override 优先 (用户点过选城市); 没有就走 GPS+北斗+IP 自动定位
    final oc = overrideCity;
    if (oc != null && oc.isNotEmpty) {
      _cloudCity = oc;
      _cloudCityCtrl.text = oc;
    } else {
      _cloudCity = '';
      _cloudCityCtrl.text = '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCloud();
      _refreshOnline();
      // 首次启动主动拉一次 GPS+IP 拿到位置
      // 拿到后: 云端 tab 用 IP 城市名填充 (让用户知道这是 IP 定位), 附近 tab 用坐标查
      // 不写死默认, 拿到什么显示什么
      if (overrideCity == null || overrideCity!.isEmpty) {
        _bootstrapLocation();
      }
    });
  }

  /// GPS+IP 拿到后: 全部 tab 都用真坐标 (云端 + 附近 + 离线)
  Future<void> _bootstrapLocation() async {
    final loc = await LocationService.getMyLocation();
    if (loc == null || !mounted) return;
    // 三个 tab 全部 GPS 优先
    if (_myLoc == null) {
      setState(() { _myLoc = loc; });
    }
    // 云端 tab input 填充 IP 城市名 (让用户知道位置来源, 可手动改)
    if (_cloudCityCtrl.text.isEmpty) {
      final raw = loc.address.split('·').first.trim();
      // 过滤 "GPS 定位" / "GPS" / 空 / 纯数字坐标 等乱住输入框
      final cityName = (raw.isNotEmpty && !raw.startsWith('GPS') && !RegExp(r'^[0-9.,\s-]+$').hasMatch(raw)) ? raw : '';
      if (cityName.isNotEmpty) {
        setState(() {
          _cloudCity = cityName;
          _cloudCityCtrl.text = cityName;
        });
        final matched = _matchCity(cityName);
        if (matched != null) {
          _cloudCity = matched;
          _cloudCityCtrl.text = matched;
        }
      }
    }
    // 云端: 按 GPS 坐标拉 50km (不是按城市字符串)
    _loadCloud();
    // 附近: 按 GPS 坐标查 20km
    _refreshOnline();
    // 离线: 重新 build 会读到 _myLoc 重新 filter
    setState(() {});
  }

  static String? _matchCity(String s) {
    if (s.isEmpty) return null;
    if (kCityCoords.containsKey(s)) return s;
    final lower = s.toLowerCase();
    for (final e in {'beijing': '北京', 'shanghai': '上海', 'guangzhou': '广州', 'shenzhen': '深圳', 'hangzhou': '杭州', 'nanjing': '南京', 'suzhou': '苏州', 'chengdu': '成都', 'wuhan': '武汉', 'xian': '西安', 'chongqing': '重庆', 'chuzhou': '滁州', 'hefei': '合肥', 'quanjiao': '全椒', 'fuyang': '阜阳'}.entries) {
      if (lower.contains(e.key)) return e.value;
    }
    for (final k in kCityCoords.keys) {
      if (lower.contains(k)) return k;
    }
    return null;
  }

  @override
  void dispose() { _searchCtrl.dispose(); _cloudCityCtrl.dispose(); _tab.dispose(); super.dispose(); }

  Future<void> _loadCloud() async {
    setState(() { _loadingCloud = true; _cloudErr = ''; });
    try {
      final db = ref.read(databaseProvider);
      final sync = SyncService(db);
      // GPS 优先: 拉 GPS 位置 50km 内所有云端 POI
      if (_myLoc != null) {
        await sync.pullNearby(lat: _myLoc!.lat, lng: _myLoc!.lng, radiusKm: 50, limit: 100);
        final all = await (db.select(db.poiCache)
              ..where((t) => t.active.equals(true))
              ..orderBy([(t) => OrderingTerm.desc(t.cloudSyncedAt)]))
            .get();
        if (mounted) {
          // 按 GPS 距离排序 + 过滤 50km
          final filtered = all.where((p) {
            final d = _haversineKm(_myLoc!.lat, _myLoc!.lng, p.latitude, p.longitude);
            return d <= 50;
          }).toList();
          filtered.sort((a, b) {
            final da = _haversineKm(_myLoc!.lat, _myLoc!.lng, a.latitude, a.longitude);
            final db = _haversineKm(_myLoc!.lat, _myLoc!.lng, b.latitude, b.longitude);
            return da.compareTo(db);
          });
          setState(() {
            _cloudPois = filtered;
            _loadingCloud = false;
            if (filtered.isEmpty) _cloudErr = '附近 50km 还没有人提交, 你是第一个！';
          });
        }
      } else {
        // GPS 还没拿到 → 调一次再拉
        final loc = await LocationService.getMyLocation();
        if (loc == null) {
          setState(() { _loadingCloud = false; _cloudErr = '定位失败, 顶部点"选城市"修正'; });
          return;
        }
        setState(() { _myLoc = loc; });
        await sync.pullNearby(lat: loc.lat, lng: loc.lng, radiusKm: 50, limit: 100);
        final all = await (db.select(db.poiCache)
              ..where((t) => t.active.equals(true)))
            .get();
        final filtered = all.where((p) {
          final d = _haversineKm(loc.lat, loc.lng, p.latitude, p.longitude);
          return d <= 50;
        }).toList()..sort((a, b) {
          final da = _haversineKm(loc.lat, loc.lng, a.latitude, a.longitude);
          final db = _haversineKm(loc.lat, loc.lng, b.latitude, b.longitude);
          return da.compareTo(db);
        });
        if (mounted) {
          setState(() {
            _cloudPois = filtered;
            _loadingCloud = false;
            if (filtered.isEmpty) _cloudErr = '附近 50km 还没有人提交, 你是第一个！';
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() { _loadingCloud = false; _cloudErr = '云端失败: $e (可点"我加一个"贡献数据)'; });
    }
  }

  Future<void> _refreshOnline() async {
    setState(() { _loadingOnline = true; _onlineErr = ''; });
    final loc = await LocationService.getMyLocation();
    if (loc == null) {
      setState(() { _loadingOnline = false; _onlineErr = '定位失败, 顶部点"选城市"修正'; });
      return;
    }
    setState(() { _myLoc = loc; });
    // GPS+北斗+IP 真实坐标 → 查 20km 内 (包含在线高德 + 离线 11k POI)
    final onlinePois = DogPlayOnline.searchByLatLng(lat: loc.lat, lng: loc.lng, radiusM: 20000);
    final offlinePois = _offlineNearby(loc.lat, loc.lng, radiusKm: 20);
    final results = await Future.wait([onlinePois, offlinePois]);
    final o = results[0] as List<OnlinePoi>;
    final off = results[1] as List<OnlinePoi>;
    setState(() {
      _loadingOnline = false;
      _onlinePois = [...o, ...off];
      if (_onlinePois.isEmpty) _onlineErr = '附近 20km 未找到';
    });
  }

  Future<List<OnlinePoi>> _offlineNearby(double lat, double lng, {double radiusKm = 20}) async {
    try {
      final data = await DataLoader.dogPlay();
      final spots = (data['spots'] as List?) ?? [];
      final results = <OnlinePoi>[];
      for (final s in spots) {
        final sLat = (s['lat'] as num?)?.toDouble();
        final sLng = (s['lng'] as num?)?.toDouble();
        if (sLat == null || sLng == null) continue;
        final d = _haversineKm(lat, lng, sLat, sLng);
        if (d > radiusKm) continue;
        results.add(OnlinePoi(
          id: s['id']?.toString() ?? '',
          name: s['name']?.toString() ?? '',
          category: s['category']?.toString() ?? 'park',
          address: '${s['city']?.toString() ?? ''} ${s['address']?.toString() ?? ''}'.trim(),
          lat: sLat,
          lng: sLng,
          distance: d,
          source: 'offline',
        ));
      }
      results.sort((a, b) => (a.distance ?? 9999).compareTo(b.distance ?? 9999));
      return results;
    } catch (_) { return []; }
  }

  List<String> _allCities(List<dynamic> spots) {
    final cities = {for (final s in spots) s['city']?.toString()}.whereType<String>().toList()..sort();
    return cities;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.black : const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(children: [
          _modernHeader(isDark),
          _modernTabBar(isDark),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: DataLoader.dogPlay(),
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return _emptyState('加载失败', snap.error.toString(), Icons.error_outline);
                }
                if (!snap.hasData) return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                final data = snap.data!;
                final categories = (data['categories'] as List?)?.cast<String>() ?? const [];
                final spots = (data['spots'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                final cities = _allCities(spots);
                return TabBarView(
                  controller: _tab,
                  children: [
                    _offlineView(ctx, categories, cities, spots, isDark),
                    _cloudView(ctx, isDark),
                    _nearbyView(ctx, isDark),
                  ],
                );
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tab,
        builder: (_, __) => _tab.index == 1 || _tab.index == 2
            ? Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                  borderRadius: BorderRadius.circular(28),
                ),
                child: FloatingActionButton.extended(
                  onPressed: _openAddPage,
                  backgroundColor: AppColors.blue,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('我加一个', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  // ============= 现代 Header =============
  Widget _modernHeader(bool isDark) {
    final canPop = Navigator.canPop(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
      child: Row(children: [
        // 返回箭头 (如果是被 push 进来的)
        if (canPop)
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDark ? AppColors.white : AppColors.black),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
          ),
        if (canPop) const SizedBox(width: 8),
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(12)),
          child: const Center(child: Text('🐾', style: TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('宠物友好', style: AppTypography.titleLarge.copyWith(color: isDark ? AppColors.white : AppColors.black)),
            const SizedBox(height: 2),
            Row(children: [
              Text('宠物友好地点 · 全部共享', style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textTertiary : AppColors.textSecondary)),
              const SizedBox(width: 8),
              // 城市快捷切换 (点弹 BottomSheet 选)
              InkWell(
                onTap: _pickCity,
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.full)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.location_on_rounded, size: 11, color: AppColors.blue),
                    const SizedBox(width: 2),
                    Text(_cloudCity, style: const TextStyle(fontSize: 11, color: AppColors.blue, fontWeight: FontWeight.w600)),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 12, color: AppColors.blue),
                  ]),
                ),
              ),
            ]),
          ]),
        ),
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: isDark ? AppColors.white : AppColors.black),
          onPressed: () { _loadCloud(); _refreshOnline(); },
        ),
      ]),
    );
  }

  Widget _modernTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : AppColors.border.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tab,
        indicator: BoxDecoration(color: isDark ? AppColors.white : AppColors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1))]),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.black,
        unselectedLabelColor: isDark ? AppColors.textSecondary : AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        tabs: const [Tab(text: '离线'), Tab(text: '云端'), Tab(text: '附近')],
      ),
    );
  }

  // ============= 离线 =============
  Widget _offlineView(BuildContext ctx, List<String> categories, List<String> cities, List<Map<String, dynamic>> spots, bool isDark) {
    if (spots.isEmpty) return _emptyState('暂无数据', 'assets 没数据', Icons.inbox_outlined);
    // GPS 优先: GPS 拿到的城市反查 assets city 字段 (assets POI 没 lat/lng, 用 city string 退而求其次)
    final myLat = _myLoc?.lat;
    final myLng = _myLoc?.lng;
    final myCity = _myLoc?.address?.split('·').first.trim() ?? '';
    // 从 _myLoc.address 拿不到 city 时, 用 _cloudCity 兑底
    final effectiveCity = myCity.isNotEmpty && !myCity.startsWith('当前位置') ? myCity : _cloudCity;
    final filtered = spots.where((s) {
      if (_catFilter != 'all' && s['category'] != _catFilter) return false;
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        final ok = (s['name']?.toString().toLowerCase().contains(q) ?? false) ||
            (s['city']?.toString().toLowerCase().contains(q) ?? false) ||
            (s['address']?.toString().toLowerCase().contains(q) ?? false) ||
            (s['description']?.toString().toLowerCase().contains(q) ?? false);
        if (!ok) return false;
      }
      // GPS 拿到后: 只显示该城市的 POI (assets 没 lat 用 city 反查, 有 lat 走 haversine)
      if (effectiveCity.isNotEmpty && _myLoc != null) {
        final sCity = s['city']?.toString() ?? '';
        // 同一城市 OR 热门/默认 (并上海/北京/广州/深圳/杭州) OR 府所在城市
        if (sCity.isNotEmpty && sCity != effectiveCity) {
          // 同名匹配 (例如 '滁州' 匹配 '安徽省滁州市')
          if (!sCity.contains(effectiveCity) && !effectiveCity.contains(sCity)) {
            // 都不同: 检查是否在同一直辖市
            final sameDirect = {'北京', '上海', '广州', '深圳', '杭州', '南京', '苏州', '成都', '武汉', '西安', '重庆', '合肥', '天津'};
            if (!(sameDirect.contains(effectiveCity) && sameDirect.contains(sCity))) return false;
          }
        }
      }
      return true;
    }).toList();
    // 计算距离 (有 lat 的才计算)
    List<Map<String, dynamic>> withDist = [];
    for (final s in filtered) {
      final sLat = (s['lat'] as num?)?.toDouble();
      final sLng = (s['lng'] as num?)?.toDouble();
      double? dist;
      if (sLat != null && sLng != null && myLat != null && myLng != null) {
        dist = _haversineKm(myLat, myLng, sLat, sLng);
      }
      withDist.add({...s, '_dist': dist});
    }
    // 距离优先 → 评分高
    withDist.sort((a, b) {
      final da = a['_dist'] as double?;
      final db = b['_dist'] as double?;
      if (da != null && db != null) return da.compareTo(db);
      if (da != null) return -1;
      if (db != null) return 1;
      return (b['rating'] as num? ?? 0).compareTo(a['rating'] as num? ?? 0);
    });
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: _searchField(ctx, isDark, hint: '搜索 ${withDist.length} 个推荐点')),
      SliverToBoxAdapter(child: _categoryStrip(ctx, categories, isDark)),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xxxl),
        sliver: SliverToBoxAdapter(child: _resultBar(withDist.length, isDark, showReset: _catFilter != 'all' || _query.isNotEmpty, onReset: () { _searchCtrl.clear(); setState(() { _query = ''; _catFilter = 'all'; }); })),
      ),
      if (withDist.isEmpty)
        SliverFillRemaining(hasScrollBody: false, child: _emptyState('附近 50km 暂无推荐', myLat == null ? '请允许位置权限' : '试试其他类别', Icons.search_off_rounded))
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl),
          sliver: SliverList.separated(
            itemCount: withDist.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _modernSpotCard(ctx, withDist[i], isDark),
          ),
        ),
    ]);
  }

  Widget _searchField(BuildContext ctx, bool isDark, {required String hint}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
        ),
        child: TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDark ? AppColors.textTertiary : AppColors.textTertiary, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: isDark ? AppColors.textTertiary : AppColors.textTertiary, size: 20),
            suffixIcon: _query.isEmpty ? null : IconButton(icon: const Icon(Icons.close_rounded, size: 18), onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); }),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 12),
          ),
          onChanged: (v) => setState(() => _query = v.trim()),
        ),
      ),
    );
  }

  Widget _categoryStrip(BuildContext ctx, List<String> categories, bool isDark) {
    final items = <_CatItem>[
      const _CatItem(id: 'all', label: '全部', emoji: '✨'),
      ...categories.map((c) => _CatItem(id: c, label: _catLabel(c), emoji: _catEmoji(c))),
    ];
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final it = items[i];
          final selected = _catFilter == it.id;
          return GestureDetector(
            onTap: () => setState(() => _catFilter = it.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              decoration: BoxDecoration(
                color: selected ? AppColors.blue : (isDark ? const Color(0xFF1A1A1A) : AppColors.white),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: selected ? AppColors.blue : (isDark ? AppColors.borderDark : AppColors.border)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(it.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text(it.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? AppColors.white : (isDark ? AppColors.textSecondary : AppColors.textSecondary)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
          );
        },
      ),
    );
  }


  Widget _resultBar(int count, bool isDark, {bool showReset = false, VoidCallback? onReset}) {
    return Row(children: [
      Text('$count 个结果', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textSecondary : AppColors.textSecondary)),
      const Spacer(),
      if (showReset && onReset != null)
        TextButton(onPressed: onReset, child: const Text('重置', style: TextStyle(fontSize: 12))),
    ]);
  }

  Widget _modernSpotCard(BuildContext ctx, dynamic s, bool isDark) {
    final cat = s['category']?.toString() ?? '';
    final rating = (s['rating'] as num?)?.toDouble();
    final dist = s['_dist'] as double?;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => _showDetail(s, isDark),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262626) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(child: Text(_catEmoji(cat), style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(s['name']?.toString() ?? '', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.white : AppColors.black), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  if (dist != null) Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Text('${dist.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 10, color: AppColors.blue, fontWeight: FontWeight.w700)),
                  ),
                  if (rating != null) Row(children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 14),
                    const SizedBox(width: 2),
                    Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textSecondary : AppColors.textSecondary)),
                  ]),
                ]),
                const SizedBox(height: 4),
                Text('${s['city']}  ·  ${_catLabel(cat)}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiary : AppColors.textSecondary)),
                const SizedBox(height: 6),
                if ((s['description']?.toString() ?? '').isNotEmpty) Text(s['description'].toString(), style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiary : AppColors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                if ((s['tag'] as List?)?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Wrap(spacing: 4, runSpacing: 4, children: [
                    for (final t in (s['tag'] as List).take(4)) Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: isDark ? const Color(0xFF262626) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(AppRadius.full)),
                      child: Text(t.toString(), style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiary : AppColors.textSecondary)),
                    ),
                  ]),
                ],
              ])),
            ]),
          ),
        ),
      ),
    );
  }

  // ============= 云端 =============
  Widget _cloudView(BuildContext ctx, bool isDark) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: _cloudHeader(isDark)),
      SliverToBoxAdapter(child: _cloudCityField(isDark)),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 4),
        sliver: SliverToBoxAdapter(child: Row(children: [
          Text(_loadingCloud ? '正在同步...' : '${_cloudPois.length} 个共享', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textSecondary : AppColors.textSecondary)),
        ])),
      ),
      if (_loadingCloud)
        const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
      else if (_cloudErr.isNotEmpty && _cloudPois.isEmpty)
        SliverFillRemaining(hasScrollBody: false, child: _emptyState(_cloudErr, '点右下角"我加一个"贡献', Icons.cloud_off_rounded, action: '重试', onAction: _loadCloud))
      else if (_cloudPois.isEmpty)
        SliverFillRemaining(hasScrollBody: false, child: _emptyState('还没有 POI', '你是这个城市第一个贡献者', Icons.add_location_alt_outlined))
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl),
          sliver: SliverList.separated(
            itemCount: _cloudPois.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _cloudCard(ctx, _cloudPois[i], isDark),
          ),
        ),
    ]);
  }

  Widget _cloudHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
      child: Row(children: [
        Icon(Icons.cloud_queue_rounded, size: 18, color: isDark ? AppColors.textSecondary : AppColors.textSecondary),
        const SizedBox(width: 6),
        Text('云端共享 POI', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.white : AppColors.black)),
      ]),
    );
  }

  Widget _cloudCityField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
            ),
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                hintText: '城市 (例: 北京/上海/南京)',
                hintStyle: TextStyle(color: isDark ? AppColors.textTertiary : AppColors.textTertiary, fontSize: 14),
                prefixIcon: Icon(Icons.location_city_rounded, color: isDark ? AppColors.textTertiary : AppColors.textTertiary, size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 12),
              ),
              controller: _cloudCityCtrl,  // 持久 controller, 不会覆盖用户输入
              onChanged: (v) { setState(() => _cloudCity = v.trim()); },  // 实时同步状态
              onSubmitted: (v) { setState(() => _cloudCity = v.trim()); _loadCloud(); },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: IconButton(
            onPressed: () {
              // 搜索按钮: 拿 _cloudCityCtrl 当前文本, 同步 + 加载
              setState(() => _cloudCity = _cloudCityCtrl.text.trim());
              if (_cloudCity.isNotEmpty) {
                setOverrideCity(_cloudCity);  // 跨页面共享
              }
              _loadCloud();
            },
            icon: const Icon(Icons.search_rounded, color: AppColors.white, size: 20),
          ),
        ),
      ]),
    );
  }

  Widget _cloudCard(BuildContext ctx, PoiCacheEntry p, bool isDark) {
    final isLocal = p.source == 'local';
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => _naviTo(p.name, p.city ?? '', p.latitude, p.longitude),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: (isLocal ? AppColors.success : AppColors.blue).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.md)),
                child: Center(child: Text(_catEmoji(p.category), style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(p.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.white : AppColors.black), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: (isLocal ? AppColors.success : AppColors.blue).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Text(isLocal ? '我的' : '共享', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: isLocal ? AppColors.success : AppColors.blue)),
                  ),
                ]),
                const SizedBox(height: 4),
                Text('${p.address ?? ""} ${p.city != null ? "· ${p.city}" : ""}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiary : AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              const SizedBox(width: 8),
              Icon(Icons.directions_rounded, size: 18, color: isDark ? AppColors.textTertiary : AppColors.textTertiary),
            ]),
          ),
        ),
      ),
    );
  }

  // ============= 附近 =============
  Widget _nearbyView(BuildContext ctx, bool isDark) {
    if (_loadingOnline) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (_onlineErr.isNotEmpty && _onlinePois.isEmpty) {
      return _emptyState(_onlineErr, '点底部按钮重新定位', Icons.location_off_rounded, action: '重新定位', onAction: _refreshOnline);
    }
    if (_onlinePois.isEmpty) {
      return _emptyState('附近 20km 暂无', '试试扩大范围或添加新地点', Icons.pets_rounded, action: '我加一个', onAction: _openAddPage);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
          ),
          child: Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: AppColors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: const Icon(Icons.my_location_rounded, color: AppColors.blue, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_myLoc?.address ?? '当前位置', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.white : AppColors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text('20km 范围内 ${_onlinePois.length} 个', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiary : AppColors.textSecondary)),
            ])),
            IconButton(icon: const Icon(Icons.refresh_rounded, size: 18), onPressed: _refreshOnline, visualDensity: VisualDensity.compact),
          ]),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final p in _onlinePois) ...[
          _modernOnlineCard(ctx, p, isDark),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }

  Widget _modernOnlineCard(BuildContext ctx, OnlinePoi p, bool isDark) {
    final isOffline = p.source == 'offline';
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => _naviTo(p.name, p.address, p.lat, p.lng),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: (isOffline ? AppColors.success : AppColors.blue).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.md)),
                child: Center(child: Text(_catEmoji(p.category), style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(p.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.white : AppColors.black), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  if (p.distance != null) Text('${p.distance!.toStringAsFixed(1)} km', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.blue)),
                ]),
                const SizedBox(height: 4),
                Text(p.address, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiary : AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: (isOffline ? AppColors.success : AppColors.blue).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Text(isOffline ? '离线' : '在线', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: isOffline ? AppColors.success : AppColors.blue)),
                  ),
                  const SizedBox(width: 6),
                  Text(catLabel(p.category), style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiary : AppColors.textTertiary)),
                ]),
              ])),
            ]),
          ),
        ),
      ),
    );
  }

  // ============= 选城市 (Header 跳, 同步到 LocationService 全局) =============
  Future<void> _pickCity() async {
    final hotCities = ['北京', '上海', '广州', '深圳', '杭州', '南京', '苏州', '成都', '武汉', '西安', '重庆', '滁州', '全椒', '合肥'];
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: isDarkMode() ? const Color(0xFF1A1A1A) : AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          const Text('选城市', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('同步到附近医院 / 云端 / 附近狗玩', style: TextStyle(fontSize: 12, color: isDarkMode() ? AppColors.textTertiary : AppColors.textSecondary)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final city in hotCities)
              ChoiceChip(
                label: Text(city),
                selected: _cloudCity == city,
                onSelected: (_) => Navigator.pop(ctx, city),
                selectedColor: AppColors.blue,
                labelStyle: TextStyle(color: _cloudCity == city ? AppColors.white : null, fontSize: 13),
              ),
          ]),
          const SizedBox(height: 8),
          const Divider(),
          TextField(
            decoration: const InputDecoration(hintText: '手动输入其他城市', isDense: true, border: OutlineInputBorder()),
            onSubmitted: (v) { if (v.trim().isNotEmpty) Navigator.pop(ctx, v.trim()); },
          ),
        ]),
      )),
    );
    if (picked == null || picked.isEmpty) return;
    setState(() {
      _cloudCity = picked;
      _cloudCityCtrl.text = picked;
      // 同步 _myLoc 坐标 (让离线 tab 也立刻 filter)
      final c = kCityCoords[picked];
      if (c != null) {
        _myLoc = MyLocation(lat: c.$1, lng: c.$2, address: picked, source: 'city');
      }
    });
    setOverrideCity(picked);
    _loadCloud();
    _refreshOnline();
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  // ============= 我加一个 =============
  Future<void> _openAddPage() async {
    final loc = await LocationService.getMyLocation();
    final city = loc?.address.split(' · ').first ?? _cloudCity;
    final db = ref.read(databaseProvider);
    final sync = SyncService(db);
    if (!mounted) return;
    await Navigator.push(context, MaterialPageRoute(builder: (_) => DogPlayAddPage(sync: sync, defaultCity: city)));
    _loadCloud();
  }

  // ============= 详情 Modal =============
  void _showDetail(dynamic s, bool isDark) {
    final cat = s['category']?.toString() ?? '';
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.3, expand: false,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: AppSpacing.lg),
            Row(children: [
              Container(width: 56, height: 56, decoration: BoxDecoration(color: isDark ? const Color(0xFF262626) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(AppRadius.md)), child: Center(child: Text(_catEmoji(cat), style: const TextStyle(fontSize: 28)))),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s['name']?.toString() ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.white : AppColors.black)),
                const SizedBox(height: 4),
                Text('${s['city']} · ${_catLabel(cat)}', style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiary : AppColors.textSecondary)),
                if ((s['rating'] as num?) != null) Padding(padding: const EdgeInsets.only(top: 4), child: Row(children: [const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)), Text(' ${(s['rating'] as num).toDouble().toStringAsFixed(1)}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiary : AppColors.textSecondary))])),
              ])),
            ]),
            const SizedBox(height: AppSpacing.lg),
            _detailRow('📍 地址', s['address']?.toString() ?? '无', isDark),
            _detailRow('📝 介绍', s['description']?.toString() ?? '无', isDark),
            if (s['best_time'] != null) _detailRow('⏰ 最佳时间', s['best_time'].toString(), isDark),
            if ((s['tag'] as List?)?.isNotEmpty == true) Padding(padding: const EdgeInsets.only(top: AppSpacing.sm), child: Wrap(spacing: 6, runSpacing: 6, children: [for (final t in s['tag'] as List) Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: isDark ? const Color(0xFF262626) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(AppRadius.full)), child: Text(t.toString(), style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondary : AppColors.textSecondary)))])),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { Navigator.pop(context); _naviTo(s['name']?.toString() ?? '', s['city']?.toString() ?? '', (s['lat'] as num?)?.toDouble() ?? 0, (s['lng'] as num?)?.toDouble() ?? 0); },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: AppColors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)), elevation: 0),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.directions_rounded, size: 18), SizedBox(width: 6), Text('导航过去', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 76, child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textTertiary : AppColors.textTertiary))),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: isDark ? AppColors.white : AppColors.black, height: 1.5))),
      ]),
    );
  }

  // ============= 导航 =============
  Future<void> _naviTo(String name, String city, double lat, double lng) async {
    final hasCoord = lat != 0 && lng != 0;
    final encoded = Uri.encodeComponent(name);
    final encodedCity = Uri.encodeComponent(city);
    final List<Uri> urls;
    if (hasCoord) {
      urls = [
        Uri.parse('https://uri.amap.com/navigation?to=$lng,$lat,$encoded&mode=car&policy=1&src=dog_diary'),
        Uri.parse('https://maps.apple.com/?daddr=$lat,$lng&q=$encoded'),
      ];
    } else {
      urls = [
        Uri.parse('https://uri.amap.com/search?keyword=$encodedCity+$encoded&src=dog_diary'),
        Uri.parse('https://maps.apple.com/?q=$encodedCity+$encoded'),
      ];
    }
    for (final u in urls) {
      try {
        if (await canLaunchUrl(u)) {
          await launchUrl(u, mode: LaunchMode.externalApplication);
          return;
        }
      } catch (_) { continue; }
    }
  }

  // ============= Empty State =============
  Widget _emptyState(String title, String subtitle, IconData icon, {String? action, VoidCallback? onAction}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
            child: Icon(icon, size: 28, color: isDark ? AppColors.textTertiary : AppColors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.white : AppColors.black)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiary : AppColors.textSecondary), textAlign: TextAlign.center),
          if (action != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(onPressed: onAction, style: OutlinedButton.styleFrom(foregroundColor: AppColors.blue, side: const BorderSide(color: AppColors.blue), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md))), child: Text(action)),
          ],
        ]),
      ),
    );
  }
}

class _CatItem {
  final String id, label, emoji;
  const _CatItem({required this.id, required this.label, required this.emoji});
}

String _catEmoji(String cat) {
  if (cat.contains('hotel') || cat.contains('酒店') || cat.contains('民宿') || cat.contains('寄养')) return '🏨';
  if (cat.contains('cafe') || cat.contains('咖啡')) return '☕';
  if (cat.contains('restaurant') || cat.contains('餐') || cat.contains('食')) return '🍽️';
  if (cat.contains('snow')) return '⛷️';
  if (cat.contains('beach') || cat.contains('海')) return '🏖️';
  if (cat.contains('garden')) return '🌷';
  if (cat.contains('park') || cat.contains('公园')) return '🌳';
  if (cat.contains('run') || cat.contains('跑') || cat.contains('场')) return '🏃';
  if (cat.contains('train') || cat.contains('训练')) return '🎓';
  if (cat.contains('shop') || cat.contains('店') || cat.contains('商店')) return '🛍️';
  if (cat.contains('hospital') || cat.contains('医院') || cat.contains('诊所')) return '🏥';
  return '📍';
}

String _catLabel(String cat) {
  if (cat.contains('hotel') || cat.contains('酒店')) return '宠物酒店';
  if (cat.contains('cafe') || cat.contains('咖啡')) return '宠物咖啡';
  if (cat.contains('restaurant')) return '宠物餐厅';
  if (cat.contains('snow')) return '雪场';
  if (cat.contains('beach') || cat.contains('海')) return '宠物海滩';
  if (cat.contains('garden')) return '宠物花园';
  if (cat.contains('park') || cat.contains('公园')) return '宠物公园';
  if (cat.contains('run') || cat.contains('跑')) return '宠物跑场';
  if (cat.contains('train') || cat.contains('训练')) return '宠物训练';
  if (cat.contains('shop')) return '宠物商店';
  if (cat.contains('hospital') || cat.contains('医院')) return '宠物医院';
  if (cat.contains('groom')) return '宠物美容';
  return cat;
}

double _haversineKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  final dLat = (lat2 - lat1) * 0.017453292519943295;
  final dLng = (lng2 - lng1) * 0.017453292519943295;
  final a = (mathx.sin(dLat / 2) * mathx.sin(dLat / 2)) +
      (mathx.cos(lat1 * 0.017453292519943295) * mathx.cos(lat2 * 0.017453292519943295) * mathx.sin(dLng / 2) * mathx.sin(dLng / 2));
  return r * 2 * mathx.atan2(mathx.sqrt(a), mathx.sqrt(1 - a));
}
