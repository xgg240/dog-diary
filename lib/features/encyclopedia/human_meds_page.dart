// 人用药物查询 - 80+ 常见人用药物对狗安全性
import 'package:flutter/material.dart';
import 'data_loader.dart';

import '../../core/ui/modern_widgets.dart';
import '../../core/ui/design_tokens.dart';class HumanMedsPage extends StatefulWidget {
  const HumanMedsPage({super.key, this.scrollTo});
  final String? scrollTo;
  @override
  State<HumanMedsPage> createState() => _HumanMedsPageState();
}

class _HumanMedsPageState extends State<HumanMedsPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  @override
  void initState() {
    super.initState();
    if (widget.scrollTo != null) {
      _query = widget.scrollTo!;
      _searchCtrl.text = widget.scrollTo!;
    }
  }
  String _statusFilter = '全部';
  String _catFilter = '全部';

  static const _statusOrder = ['禁用', '慎用', '安全可用', '兽医处方'];

  Color _statusColor(String s, BuildContext context) {
    switch (s) {
      case '禁用': return Theme.of(context).colorScheme.error;
      case '慎用': return Theme.of(context).colorScheme.error;
      case '安全可用': return Theme.of(context).colorScheme.tertiary;
      case '兽医处方': return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  void _openPickerSheet(BuildContext ctx, String title, List<String> options, String current, ValueChanged<String> onPick) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (sctx, scrollCtrl) => Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Column(children: [
            // 拖把
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2)),
            ),
            // 标题
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('共 ${options.length} 项', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
              ]),
            ),
            const Divider(height: 1),
            // 列表 - 全部用 ListView 一行一项, iOS/Android 单指滑动
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                itemCount: options.length,
                itemBuilder: (_, i) {
                  final o = options[i];
                  final selected = o == current;
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      selected ? Icons.check_circle : Icons.circle_outlined,
                      color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                      size: 22,
                    ),
                    title: Text(o, style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
                    onTap: () {
                      onPick(o);
                      Navigator.pop(sctx);
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: ModernPageHeader(title: '人用药物查询'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: DataLoader.humanMeds(),
        builder: (ctx, snap) {
          if (snap.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('加载失败: ${snap.error}', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 11))));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final data = snap.data!;
          final intro = data['intro']?.toString() ?? '';
          final meds = (data['medications'] as List?) ?? [];
          // 分类列表
          final cats = ['全部', ...{for (final m in meds) m['category']?.toString()}.whereType<String>().toList()..sort()];
          // 筛选
          final filtered = meds.where((m) {
            if (_statusFilter != '全部' && m['status'] != _statusFilter) return false;
            if (_catFilter != '全部' && m['category'] != _catFilter) return false;
            if (_query.isEmpty) return true;
            final q = _query.toLowerCase();
            return (m['name_zh']?.toString().toLowerCase().contains(q) ?? false) ||
                (m['name_pinyin']?.toString().toLowerCase().contains(q) ?? false) ||
                (m['category']?.toString().toLowerCase().contains(q) ?? false);
          }).toList();
          return Column(children: [
            // 介绍横幅
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Text(intro, style: TextStyle(fontSize: 12, height: 1.5, color: Theme.of(context).colorScheme.tertiary)),
            ),
            // 搜索
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: '搜索药物... 共 ${meds.length} 种',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty ? null : IconButton(icon: const Icon(Icons.close), onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); }),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            // 两个大按钮: 状态 + 分类
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(children: [
                Expanded(child: _BigFilterBtn(
                  icon: _statusIcon(context, _statusFilter), color: _statusColor(_statusFilter, ctx),
                  label: '状态', value: _statusFilter, count: _statusOrder.length,
                  onTap: () => _openPickerSheet(ctx, '💊 选择状态', ['全部', ..._statusOrder], _statusFilter, (v) => setState(() => _statusFilter = v)),
                )),
                const SizedBox(width: 6),
                Expanded(child: _BigFilterBtn(
                  icon: Icons.category_rounded, color: Theme.of(context).colorScheme.tertiary,
                  label: '分类', value: _catFilter, count: cats.length,
                  onTap: () => _openPickerSheet(ctx, '📂 选择分类', cats, _catFilter, (v) => setState(() => _catFilter = v)),
                )),
              ]),
            ),
            // 统计
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Row(children: [
                Text('显示 ${filtered.length} 条', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
                const Spacer(),
                if (_statusFilter != '全部' || _catFilter != '全部' || _query.isNotEmpty)
                  TextButton.icon(
                    onPressed: () { _searchCtrl.clear(); setState(() { _query = ''; _statusFilter = '全部'; _catFilter = '全部'; }); },
                    icon: const Icon(Icons.refresh, size: 14),
                    label: const Text('重置', style: TextStyle(fontSize: 12)),
                  ),
              ]),
            ),
            // 列表
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('没有匹配的药物'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final m = filtered[i];
                        final status = m['status']?.toString() ?? '';
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          child: ExpansionTile(
                            leading: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: _statusColor(status, context).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.medication_rounded, color: _statusColor(status, context), size: 20),
                            ),
                            title: Text('${m['name_zh']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${m['category'] ?? ''}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _statusColor(status, context).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(status.substring(0, status.length > 2 ? 2 : 1), style: TextStyle(color: _statusColor(status, context), fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  if (m['human_dose'] != null) _detailRow(context, '👤 人用剂量', m['human_dose']?.toString() ?? '', Theme.of(context).colorScheme.primary),
                                  if (m['dog_safe_dose'] != null) _detailRow(context, '🐕 狗用剂量', m['dog_safe_dose']?.toString() ?? '', Theme.of(context).colorScheme.tertiary),
                                  if (m['dog_toxic_dose'] != null) _detailRow(context, '⚠️ 中毒剂量', m['dog_toxic_dose']?.toString() ?? '', Theme.of(context).colorScheme.error),
                                ]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ]);
        },
      ),
    );
  
    return Scaffold(
      appBar: ModernPageHeader(title: '人用药物查询'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: DataLoader.humanMeds(),
        builder: (ctx, snap) {
          if (snap.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('加载失败: ${snap.error}', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 11))));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final data = snap.data!;
          final intro = data['intro']?.toString() ?? '';
          final meds = (data['medications'] as List?) ?? [];
          // 分类列表
          final cats = ['全部', ...{for (final m in meds) m['category']?.toString()}.whereType<String>().toList()..sort()];
          // 筛选
          final filtered = meds.where((m) {
            if (_statusFilter != '全部' && m['status'] != _statusFilter) return false;
            if (_catFilter != '全部' && m['category'] != _catFilter) return false;
            if (_query.isEmpty) return true;
            final q = _query.toLowerCase();
            return (m['name_zh']?.toString().toLowerCase().contains(q) ?? false) ||
                (m['name_pinyin']?.toString().toLowerCase().contains(q) ?? false) ||
                (m['category']?.toString().toLowerCase().contains(q) ?? false);
          }).toList();
          return Column(children: [
            // 介绍横幅
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Text(intro, style: TextStyle(fontSize: 12, height: 1.5, color: Theme.of(context).colorScheme.tertiary)),
            ),
            // 搜索
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: '搜索药物... 共 ${meds.length} 种',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty ? null : IconButton(icon: const Icon(Icons.close), onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); }),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            // 两个大按钮: 状态 + 分类
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(children: [
                Expanded(child: _BigFilterBtn(
                  icon: _statusIcon(context, _statusFilter), color: _statusColor(_statusFilter, ctx),
                  label: '状态', value: _statusFilter, count: _statusOrder.length,
                  onTap: () => _openPickerSheet(ctx, '💊 选择状态', ['全部', ..._statusOrder], _statusFilter, (v) => setState(() => _statusFilter = v)),
                )),
                const SizedBox(width: 6),
                Expanded(child: _BigFilterBtn(
                  icon: Icons.category_rounded, color: Theme.of(context).colorScheme.tertiary,
                  label: '分类', value: _catFilter, count: cats.length,
                  onTap: () => _openPickerSheet(ctx, '📂 选择分类', cats, _catFilter, (v) => setState(() => _catFilter = v)),
                )),
              ]),
            ),
            // 统计
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Row(children: [
                Text('显示 ${filtered.length} 条', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
                const Spacer(),
                if (_statusFilter != '全部' || _catFilter != '全部' || _query.isNotEmpty)
                  TextButton.icon(
                    onPressed: () { _searchCtrl.clear(); setState(() { _query = ''; _statusFilter = '全部'; _catFilter = '全部'; }); },
                    icon: const Icon(Icons.refresh, size: 14),
                    label: const Text('重置', style: TextStyle(fontSize: 12)),
                  ),
              ]),
            ),
            // 列表
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('没有匹配的药物'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final m = filtered[i];
                        final status = m['status']?.toString() ?? '';
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          child: ExpansionTile(
                            leading: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: _statusColor(status, context).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.medication_rounded, color: _statusColor(status, context), size: 20),
                            ),
                            title: Text('${m['name_zh']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${m['category'] ?? ''}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _statusColor(status, context).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(status.substring(0, status.length > 2 ? 2 : 1), style: TextStyle(color: _statusColor(status, context), fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  if (m['human_dose'] != null) _detailRow(context, '👤 人用剂量', m['human_dose']?.toString() ?? '', Theme.of(context).colorScheme.primary),
                                  if (m['dog_safe_dose'] != null) _detailRow(context, '🐕 狗用剂量', m['dog_safe_dose']?.toString() ?? '', Theme.of(context).colorScheme.tertiary),
                                  if (m['dog_toxic_dose'] != null) _detailRow(context, '⚠️ 中毒剂量', m['dog_toxic_dose']?.toString() ?? '', Theme.of(context).colorScheme.error),
                                ]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ]);
        },
      ),
    );
  }

  IconData _statusIcon(BuildContext context, String s) {
    switch (s) {
      case '禁用': return Icons.block;
      case '慎用': return Icons.warning_amber_rounded;
      case '安全可用': return Icons.check_circle;
      case '兽医处方': return Icons.medical_services;
      case '全部': return Icons.all_inclusive;
      default: return Icons.help;
    }
  }

  Widget _detailRow(BuildContext context, String label, String text, Color c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: c.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(6), border: Border.all(color: c.withValues(alpha: 0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: c, fontWeight: FontWeight.w600, fontSize: 12)),
            const SizedBox(height: 4),
            Text(text, style: const TextStyle(fontSize: 12, height: 1.5)),
          ]),
        ),
      );
}

class _BigFilterBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final int count;
  final VoidCallback onTap;
  const _BigFilterBtn({required this.icon, required this.color, required this.label, required this.value, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
            Text(value == '全部' ? '全部' : value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          Text('$count', style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 10)),
          const Icon(Icons.unfold_more, size: 16),
        ]),
      ),
    );
  
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
            Text(value == '全部' ? '全部' : value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          Text('$count', style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 10)),
          const Icon(Icons.unfold_more, size: 16),
        ]),
      ),
    );
  }
}
