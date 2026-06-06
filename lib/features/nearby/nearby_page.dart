// 附近宠物服务 - 彻底重写版
// 单一页面 + chip 切换类别, 不嵌套 TabBarView
// 全部用高德 API, 强兜底, 不卡死
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/location_service.dart';
import 'nearby_online.dart';

class NearbyPage extends StatefulWidget {
  const NearbyPage({super.key});
  @override
  State<NearbyPage> createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  static const _cats = [
    ('hospital', '宠物医院', Icons.local_hospital, Colors.red),
    ('store', '宠物店', Icons.store, Colors.blue),
    ('groom', '宠物美容', Icons.content_cut, Colors.purple),
    ('emergency', '24h 急诊', Icons.emergency, Colors.orange),
  ];

  String _cat = 'hospital';
  MyLocation? _loc;
  List<NearbyPoi> _items = [];
  bool _loading = false;
  String _err = '';
  int _gen = 0; // 防止过期回调
  String? _overrideCity; // 用户手动选的城市, 优先于 IP

  // 12 热门城市 (手选)
  static const _hotCities = ['北京', '上海', '广州', '深圳', '杭州', '南京', '苏州', '成都', '武汉', '西安', '重庆', '滁州'];

  @override
  void initState() {
    super.initState();
    print('[NearbyPage] initState');
    // 不写死城市! GPS 拿到 → 自动设 override; IP 拿到 → 自动设 override;
    // 用户点 _pickCity → 手动设 override
    _overrideCity = overrideCity;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[NearbyPage] postFrame _loadAll');
      _loadAll();
    });
  }

  Future<void> _loadAll() async {
    final gen = ++_gen;
    setState(() { _loading = true; _err = ''; });
    // 1) 定位 - override 城市 (本地坐标库) > GPS > IP
    MyLocation? loc = await LocationService.getMyLocation();
    if (gen != _gen || !mounted) return;
    setState(() { _loc = loc; });
    if (loc == null) {
      setState(() { _loading = false; _err = '定位失败, 请允许位置权限或在顶部选城市'; });
      return;
    }
    // 2) 查当前类别 (高德 v5/place/around, 有 AMAP_KEY)
    final items = await NearbyService.search(
      lat: loc.lat, lng: loc.lng, category: _cat, radiusM: 10000,
    );
    if (gen != _gen || !mounted) return;
    setState(() { _items = items; _loading = false; _err = items.isEmpty ? '附近 10km 未找到, 试试其他类别' : ''; });
  }

  void _switchCat(String c) {
    if (c == _cat) return;
    setState(() { _cat = c; _items = []; });
    _loadAll();
  }

  /// 弹出 12 热门城市选择 + 手动输入
  Future<void> _pickCity() async {
    final c = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('选你的城市', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('macOS 上用 IP 定位可能不准 (如你是 Fuyang 但其实在滁州), 选你的真实城市', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final city in _hotCities)
                ChoiceChip(
                  label: Text(city, style: const TextStyle(fontSize: 12)),
                  selected: _overrideCity == city,
                  onSelected: (_) => Navigator.pop(ctx, city),
                ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(
                decoration: const InputDecoration(
                  hintText: '或输入其他城市名, 例: 滁州',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (v) { if (v.trim().isNotEmpty) Navigator.pop(ctx, v.trim()); },
              )),
            ]),
            const SizedBox(height: 4),
            TextButton(onPressed: () { _overrideCity = null; Navigator.pop(ctx, '__AUTO__'); }, child: const Text('清除, 用自动定位', style: TextStyle(fontSize: 11))),
          ]),
        ));
      },
    );
    if (c == null) return;
    if (c == '__AUTO__') {
      setOverrideCity(null);
      setState(() { _overrideCity = null; });
    } else {
      // 同步到 LocationService 全局, dog_play 附近也受益
      setOverrideCity(c);
      setState(() { _overrideCity = c; });
    }
    _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('附近宠物服务'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新定位',
            onPressed: _loadAll,
          ),
        ],
      ),
      body: Column(
        children: [
          // 状态条
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: Row(children: [
              Icon(_loc != null ? Icons.location_on : Icons.location_off, size: 16, color: _loc != null ? Colors.green : Colors.grey),
              const SizedBox(width: 6),
              Expanded(child: Text(
                _loc == null ? '正在定位...' : (_loc!.source == 'gps' ? 'GPS 实时定位 · ${_loc!.address}' : (_loc!.source == 'city' ? '手动城市: ${_loc!.address}' : 'IP 城市定位 · 可能不准')),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )),
              // 手动选城市按钮
              TextButton.icon(
                onPressed: _pickCity,
                icon: const Icon(Icons.edit_location_alt, size: 14),
                label: const Text('选城市', style: TextStyle(fontSize: 11)),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6), minimumSize: const Size(0, 28)),
              ),
              if (_loading) const SizedBox(width: 8, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
            ]),
          ),
          // GPS 被拒 提示
          if (_loc == null && !_loading)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.withValues(alpha: 0.3))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange), const SizedBox(width: 6), const Text('未获得位置权限', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))]),
                const SizedBox(height: 4),
                const Text('macOS 请到 系统设置 → 隐私与安全性 → 定位服务 → 启用 dog_diary, 重启 app', style: TextStyle(fontSize: 11, height: 1.4)),
              ]),
            ),
          // IP 城市提示
          if (_loc != null && _loc!.source == 'ip')
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(6)),
              child: Row(children: [const Icon(Icons.info_outline, size: 14, color: Colors.blue), const SizedBox(width: 6), Expanded(child: Text('IP 定位到 ${_loc!.address}, 精度 50km, 顶部点 "选城市" 修正', style: const TextStyle(fontSize: 11)))], mainAxisSize: MainAxisSize.min),
            ),
          // 类别 chip
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: _cats.map((c) {
                final sel = c.$1 == _cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    selected: sel,
                    avatar: Icon(c.$3, size: 14, color: sel ? Colors.white : c.$4),
                    label: Text(c.$2),
                    labelStyle: TextStyle(color: sel ? Colors.white : null, fontSize: 12),
                    selectedColor: c.$4,
                    backgroundColor: c.$4.withValues(alpha: 0.1),
                    onSelected: (_) => _switchCat(c.$1),
                  ),
                );
              }).toList()),
            ),
          ),
          const SizedBox(height: 8),
          // 内容
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_err.isNotEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.location_off, size: 36, color: Colors.grey),
          const SizedBox(height: 8),
          Text(_err, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          FilledButton.tonal(onPressed: _loadAll, child: const Text('重试')),
        ]),
      ));
    }
    if (_loading && _items.isEmpty) {
      return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(), SizedBox(height: 12), Text('查询中...', style: TextStyle(color: Colors.grey)),
      ]));
    }
    if (_items.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text('没有数据', style: TextStyle(color: Colors.grey[600])),
      ));
    }
    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final p = _items[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _catColor(p.category).withValues(alpha: 0.15),
            child: Text(nearbyCatEmoji(p.category), style: const TextStyle(fontSize: 18)),
          ),
          title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${p.address} · ${(p.distance ?? 0).toStringAsFixed(1)}km', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
          trailing: IconButton(
            icon: const Icon(Icons.directions, color: Colors.blue),
            tooltip: '高德导航',
            onPressed: () => _openAmap(p),
          ),
        );
      },
    );
  }

  Color _catColor(String c) {
    for (final x in _cats) { if (x.$1 == c) return x.$4; }
    return Colors.grey;
  }

  Future<void> _openAmap(NearbyPoi p) async {
    if (_loc == null) return;
    final lat = p.lat, lng = p.lng;
    final name = Uri.encodeComponent(p.name);
    final urls = [
      Uri.parse('iosamap://navi?sourceApplication=dog_diary&lat=$lat&lon=$lng&name=$name&dev=0&style=2'),
      Uri.parse('androidamap://navi?sourceApplication=dog_diary&lat=$lat&lon=$lng&name=$name&dev=0&style=2'),
      Uri.parse('https://uri.amap.com/navigation?to=$lng,$lat,$name&mode=car&policy=1&src=dog_diary'),
      Uri.parse('https://maps.apple.com/?daddr=$lat,$lng&q=$name'),
    ];
    for (final u in urls) {
      try {
        if (await canLaunchUrl(u)) {
          await launchUrl(u, mode: LaunchMode.externalApplication);
          return;
        }
      } catch (_) {}
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('未安装高德/Apple 地图')));
    }
  }
}

// 兼容旧引用 (附近医院卡片)
class NearbyPoiListAdapter {
  static Future<MyLocation?> getCurrentPosition() => NearbyService.getLocation();
  static Future<List<NearbyPoi>> searchByLatLng(double lat, double lng, {double radiusKm = 8, String? category}) {
    return NearbyService.search(lat: lat, lng: lng, category: category ?? 'hospital', radiusM: (radiusKm * 1000).toInt());
  }
}
