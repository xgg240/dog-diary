// ============================================================
//  我加一个 - 用户提交新 POI (Day 2 云端 UGC)
// ------------------------------------------------------------
//  - 必填: 名称 / 城市 / 类别 / 坐标
//  - 选填: 区域 / 简介
//  - 坐标: 默认用 LocationService.getMyLocation(), 失败可手填
//  - 提交: 调 SyncService.submitSpot → POST 云端 → 写本地 PoiCache
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/location_service.dart';
import '../../core/sync_service.dart';
import 'dog_play_online.dart' show catLabel;

import '../../core/ui/modern_widgets.dart';
import '../../core/ui/design_tokens.dart';class DogPlayAddPage extends ConsumerStatefulWidget {
  final SyncService sync;
  final String defaultCity;
  const DogPlayAddPage({super.key, required this.sync, required this.defaultCity});

  @override
  ConsumerState<DogPlayAddPage> createState() => _DogPlayAddPageState();
}

class _DogPlayAddPageState extends ConsumerState<DogPlayAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _description = TextEditingController();
  final _lat = TextEditingController();
  final _lng = TextEditingController();

  String _category = 'park';
  bool _locating = false;
  bool _submitting = false;
  String? _locAddr;
  String? _locErr;

  static const _categories = ['park', 'store', 'hospital', 'groom', 'cafe', 'emergency', 'training', 'hotel'];

  @override
  void initState() {
    super.initState();
    _city.text = widget.defaultCity;
    _autoLocate();
  }

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    _district.dispose();
    _description.dispose();
    _lat.dispose();
    _lng.dispose();
    super.dispose();
  }

  /// 自动定位填坐标 (fire-and-forget, 不阻塞 UI)
  /// - LocationService 总超时 8s, macOS 沙箱下可能 hang
  /// - 用户不等, 可立即手填
  Future<void> _autoLocate() async {
    setState(() { _locating = true; _locErr = null; });
    // 不 await, 让用户能同时手填
    () async {
      try {
        final loc = await LocationService.getMyLocation();
        if (!mounted) return;
        if (loc == null) {
          setState(() { _locating = false; _locErr = '定位失败, 请手动填写坐标'; });
          return;
        }
        _lat.text = loc.lat.toStringAsFixed(6);
        _lng.text = loc.lng.toStringAsFixed(6);
        _locAddr = loc.address;
        if (loc.address.isNotEmpty && (_city.text.isEmpty || _city.text == '滁州')) {
          final first = loc.address.split('·').first.trim();
          if (first.isNotEmpty) _city.text = first;
        }
        setState(() { _locating = false; });
      } on Exception catch (e) {
        if (!mounted) return;
        setState(() { _locating = false; _locErr = '$e'; });
      }
    }();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _submitting = true; });
    try {
      final lat = double.parse(_lat.text.trim());
      final lng = double.parse(_lng.text.trim());
      await widget.sync.submitSpot(
        name: _name.text.trim(),
        city: _city.text.trim(),
        district: _district.text.trim().isEmpty ? null : _district.text.trim(),
        category: _category,
        lat: lat,
        lng: lng,
        description: _description.text.trim().isEmpty ? null : _description.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ 已提交, 1 分钟内其他用户可见'), backgroundColor: Theme.of(context).colorScheme.tertiary),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() { _submitting = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ 提交失败: $e'), backgroundColor: Theme.of(context).colorScheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: ModernPageHeader(title: '我加一个'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // 名称
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: '名称 *', hintText: '例: 全椒县太平公园', border: OutlineInputBorder()),
              maxLength: 50,
              validator: (v) => (v == null || v.trim().isEmpty) ? '请输入名称' : null,
            ),
            const SizedBox(height: 12),
            // 城市 + 区域
            Row(children: [
              Expanded(flex: 2, child: TextFormField(
                controller: _city,
                decoration: const InputDecoration(labelText: '城市 *', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? '请输入城市' : null,
              )),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: TextFormField(
                controller: _district,
                decoration: const InputDecoration(labelText: '区域 (选填)', hintText: '例: 襄河镇', border: OutlineInputBorder()),
              )),
            ]),
            const SizedBox(height: 12),
            // 类别
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: '类别 *', border: OutlineInputBorder()),
              items: [
                for (final c in _categories) DropdownMenuItem(value: c, child: Text(catLabel(c))),
              ],
              onChanged: (v) => setState(() => _category = v ?? 'park'),
            ),
            const SizedBox(height: 12),
            // 定位
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.my_location, size: 16),
                  const SizedBox(width: 6),
                  const Text('定位', style: TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  if (_locating) const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                  if (!_locating) TextButton.icon(onPressed: _autoLocate, icon: const Icon(Icons.refresh, size: 14), label: const Text('重定位')),
                ]),
                if (_locAddr != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text('📍 $_locAddr', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.tertiary))),
                if (_locErr != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text('⚠️ $_locErr', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.error))),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: TextFormField(
                    controller: _lat,
                    decoration: const InputDecoration(labelText: '纬度 *', border: OutlineInputBorder(), isDense: true),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return '必填';
                      final d = double.tryParse(v.trim());
                      if (d == null) return '数字';
                      if (d < -90 || d > 90) return '范围';
                      return null;
                    },
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(
                    controller: _lng,
                    decoration: const InputDecoration(labelText: '经度 *', border: OutlineInputBorder(), isDense: true),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return '必填';
                      final d = double.tryParse(v.trim());
                      if (d == null) return '数字';
                      if (d < -180 || d > 180) return '范围';
                      return null;
                    },
                  )),
                ]),
              ]),
            ),
            const SizedBox(height: 12),
            // 简介
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: '简介 (选填)', hintText: '例: 允许带狗, 周末人多', border: OutlineInputBorder()),
              maxLines: 3,
              maxLength: 200,
            ),
            const SizedBox(height: 20),
            // 提示
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 6),
                Expanded(child: Text('提交后云端审核, 1 分钟内其他用户可见。请勿提交虚假/广告/微信/QQ 信息。', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary))),
              ]),
            ),
            const SizedBox(height: 20),
            // 提交按钮
            FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: _submitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.cloud_upload),
              label: Text(_submitting ? '提交中…' : '提交到云端'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ]),
        ),
      ),
    );
  
    return Scaffold(
      appBar: ModernPageHeader(title: '我加一个'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // 名称
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: '名称 *', hintText: '例: 全椒县太平公园', border: OutlineInputBorder()),
              maxLength: 50,
              validator: (v) => (v == null || v.trim().isEmpty) ? '请输入名称' : null,
            ),
            const SizedBox(height: 12),
            // 城市 + 区域
            Row(children: [
              Expanded(flex: 2, child: TextFormField(
                controller: _city,
                decoration: const InputDecoration(labelText: '城市 *', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? '请输入城市' : null,
              )),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: TextFormField(
                controller: _district,
                decoration: const InputDecoration(labelText: '区域 (选填)', hintText: '例: 襄河镇', border: OutlineInputBorder()),
              )),
            ]),
            const SizedBox(height: 12),
            // 类别
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: '类别 *', border: OutlineInputBorder()),
              items: [
                for (final c in _categories) DropdownMenuItem(value: c, child: Text(catLabel(c))),
              ],
              onChanged: (v) => setState(() => _category = v ?? 'park'),
            ),
            const SizedBox(height: 12),
            // 定位
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.my_location, size: 16),
                  const SizedBox(width: 6),
                  const Text('定位', style: TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  if (_locating) const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                  if (!_locating) TextButton.icon(onPressed: _autoLocate, icon: const Icon(Icons.refresh, size: 14), label: const Text('重定位')),
                ]),
                if (_locAddr != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text('📍 $_locAddr', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.tertiary))),
                if (_locErr != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text('⚠️ $_locErr', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.error))),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: TextFormField(
                    controller: _lat,
                    decoration: const InputDecoration(labelText: '纬度 *', border: OutlineInputBorder(), isDense: true),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return '必填';
                      final d = double.tryParse(v.trim());
                      if (d == null) return '数字';
                      if (d < -90 || d > 90) return '范围';
                      return null;
                    },
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(
                    controller: _lng,
                    decoration: const InputDecoration(labelText: '经度 *', border: OutlineInputBorder(), isDense: true),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return '必填';
                      final d = double.tryParse(v.trim());
                      if (d == null) return '数字';
                      if (d < -180 || d > 180) return '范围';
                      return null;
                    },
                  )),
                ]),
              ]),
            ),
            const SizedBox(height: 12),
            // 简介
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: '简介 (选填)', hintText: '例: 允许带狗, 周末人多', border: OutlineInputBorder()),
              maxLines: 3,
              maxLength: 200,
            ),
            const SizedBox(height: 20),
            // 提示
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 6),
                Expanded(child: Text('提交后云端审核, 1 分钟内其他用户可见。请勿提交虚假/广告/微信/QQ 信息。', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary))),
              ]),
            ),
            const SizedBox(height: 20),
            // 提交按钮
            FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: _submitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.cloud_upload),
              label: Text(_submitting ? '提交中…' : '提交到云端'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ]),
        ),
      ),
    );
  }
}
