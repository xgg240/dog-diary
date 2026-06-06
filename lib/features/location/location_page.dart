// ============================================================
//  位置详情页 (仪表盘位置卡 → 跳转这里)
//  - 进页面自动定位
//  - 显示城市/坐标/3 个最近 POI
//  - 点 POI 弹底部 sheet 详情
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/location_service.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  MyLocation? _loc;
  bool _loading = false;
  String _err = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  Future<void> _fetch() async {
    if (_loading) return;
    setState(() { _loading = true; _err = ''; });
    try {
      final l = await LocationService.getMyLocation();
      if (!mounted) return;
      setState(() { _loc = l; _loading = false; });
      if (l != null) MyLocationCache.current = l;
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _err = '$e'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasData = _loc != null;
    final city = hasData ? _loc!.address.split(' · ').first : '未定位';
    final pois = hasData ? _pickPois(_loc!) : <_LocPoi>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的位置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新定位',
            onPressed: _loading ? null : _fetch,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 顶部位置信息大卡
          Card(
            color: hasData ? Colors.green.shade50 : cs.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: (hasData ? Colors.green : cs.tertiary).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_loading ? Icons.hourglass_top : (hasData ? Icons.public : Icons.location_off),
                      color: hasData ? Colors.green.shade700 : cs.tertiary, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('当前位置', style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.7))),
                  const SizedBox(height: 4),
                  _loading
                      ? const Text('定位中...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.grey))
                      : _err.isNotEmpty
                          ? Text('定位失败', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: cs.error))
                          : Text(city, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (hasData) Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${_loc!.lat.toStringAsFixed(5)}, ${_loc!.lng.toStringAsFixed(5)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(
                          _loc!.source == 'gps' ? Icons.gps_fixed : Icons.cloud_outlined,
                          size: 12,
                          color: _loc!.source == 'gps' ? Colors.green.shade700 : Colors.blueGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _loc!.source == 'gps'
                            ? 'GPS + 北斗 · 精度 ±${_loc!.accuracy?.toStringAsFixed(0) ?? "?"} 米'
                            : 'IP 定位 (GPS 不可用)',
                          style: TextStyle(
                            fontSize: 11,
                            color: _loc!.source == 'gps' ? Colors.green.shade700 : Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]),
                    ]),
                  ),
                ])),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          // 附近门店
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(children: [
              const Icon(Icons.store, size: 18),
              const SizedBox(width: 6),
              const Text('附近宠物店 / 医院', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (hasData) Text('共 ${pois.length} 家', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ),
          const SizedBox(height: 8),
          if (!hasData && !_loading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('请先完成上方定位', style: TextStyle(color: Colors.grey))),
            )
          else if (pois.isEmpty && hasData)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('附近暂无宠物店 / 医院数据', style: TextStyle(color: Colors.grey))),
            )
          else
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < pois.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    _poiTile(context, pois[i], _loc!),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _poiTile(BuildContext context, _LocPoi p, MyLocation me) {
    final km = _distKm(me, p);
    return InkWell(
      onTap: () => _showPoiSheet(context, p, me, km),
      child: ListTile(
        leading: Text(_emoji(p), style: const TextStyle(fontSize: 24)),
        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${p.address} · 距你 ${km.toStringAsFixed(1)} km'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  void _showPoiSheet(BuildContext context, _LocPoi p, MyLocation me, double km) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(_emoji(p), style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(child: Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
              ]),
              const SizedBox(height: 16),
              _row(Icons.place_outlined, '地址', p.address),
              const SizedBox(height: 8),
              _row(Icons.straighten, '距离', '${km.toStringAsFixed(1)} km'),
              if (p.phone.isNotEmpty) ...[
                const SizedBox(height: 8),
                _row(Icons.phone_outlined, '电话', p.phone),
              ],
              const SizedBox(height: 20),
              Row(children: [
                if (p.phone.isNotEmpty) Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.call, size: 18),
                    label: const Text('拨号'),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final uri = Uri.parse('tel:${p.phone}');
                      try { await launchUrl(uri); } catch (_) {}
                    },
                  ),
                ),
                if (p.phone.isNotEmpty) const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.tonalIcon(
                    icon: const Icon(Icons.navigation, size: 18),
                    label: const Text('导航'),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final amap = Uri.parse('https://uri.amap.com/search?keyword=${Uri.encodeComponent(p.name)}&dev=0&center=${me.lng},${me.lat}');
                      try {
                        if (await canLaunchUrl(amap)) {
                          await launchUrl(amap, mode: LaunchMode.externalApplication);
                        }
                      } catch (_) {}
                    },
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 16, color: Colors.grey),
      const SizedBox(width: 8),
      Text('$label: ', style: const TextStyle(fontSize: 13, color: Colors.grey)),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
    ]);
  }
}

// ============================================================
//  POI 数据 (复用 dashboard 相同示例集)
// ============================================================
class _LocPoi {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String phone;
  const _LocPoi(this.name, this.address, this.lat, this.lng, [this.phone = '']);
}

const _locPois = <_LocPoi>[
  _LocPoi('瑞鹏宠物医院', '市中心 · 24h 急诊', 41.8836, -87.6324, '400-800-1234'),
  _LocPoi('安安宠物诊所', '社区 · 综合门诊', 41.8760, -87.6280, '021-5888-9999'),
  _LocPoi('小佩宠物店', '商场 · 洗护美容', 41.8840, -87.6240),
  _LocPoi('萌宠之家', '街角 · 食品用品', 41.8790, -87.6310),
  _LocPoi('贝贝宠物美容', '社区 · 专业美容', 41.8810, -87.6270),
  _LocPoi('爱诺宠物医院', '主路 · 大型综合', 41.8850, -87.6350, '400-700-5678'),
];

List<_LocPoi> _pickPois(MyLocation me) {
  final list = List<_LocPoi>.from(_locPois);
  list.sort((a, b) => _distKm(me, a).compareTo(_distKm(me, b)));
  return list;
}

double _distKm(MyLocation me, _LocPoi poi) {
  final dLat = (poi.lat - me.lat).abs();
  final dLng = (poi.lng - me.lng).abs();
  return sqrt(dLat * dLat + dLng * dLng) * 111.0;
}

String _emoji(_LocPoi p) {
  if (p.name.contains('医院') || p.name.contains('诊所')) return '🏥';
  if (p.name.contains('美容')) return '✂️';
  return '🏪';
}
