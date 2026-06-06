// ============================================================
//  遛狗打卡
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../db/database.dart';

import '../../core/ui/modern_widgets.dart';
final _walksProvider = StreamProvider<List<WalkRecord>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).walkRecords)
        ..orderBy([(t) => drift.OrderingTerm.desc(t.walkedAt)]))
      .watch();
});

class WalksPage extends ConsumerWidget {
  const WalksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walksAsync = ref.watch(_walksProvider);
    return Scaffold(
      appBar: ModernPageHeader(title: '遛狗打卡'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (_) => const _WalkSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('打卡'),
      ),
      body: walksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('暂无遛狗记录\n点击右下角打卡'));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final w = list[i];
              return Dismissible(
                key: ValueKey(w.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await (ref.read(databaseProvider).delete(ref.read(databaseProvider).walkRecords)..where((t) => t.id.equals(w.id))).go();
                },
                child: ListTile(
                  leading: const Icon(Icons.directions_walk, color: Colors.green),
                  title: Text('${w.durationMin} 分钟${w.distanceKm != null ? ' · ${w.distanceKm!.toStringAsFixed(2)} km' : ''}'),
                  subtitle: Text('${DateFormat('MM-dd HH:mm').format(w.walkedAt)}${w.route != null ? ' · ${w.route}' : ''}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _WalkSheet extends ConsumerStatefulWidget {
  const _WalkSheet();
  @override
  ConsumerState<_WalkSheet> createState() => _S();
}

class _S extends ConsumerState<_WalkSheet> {
  final _durationCtrl = TextEditingController();
  final _distanceCtrl = TextEditingController();
  final _routeCtrl = TextEditingController();
  int? _petId;
  DateTime _walkedAt = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _durationCtrl.dispose();
    _distanceCtrl.dispose();
    _routeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_petId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先在 "宠物" 中创建宠物')));
      return;
    }
    final dur = int.tryParse(_durationCtrl.text.trim());
    if (dur == null || dur <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入有效时长')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(databaseProvider).into(ref.read(databaseProvider).walkRecords).insert(
        WalkRecordsCompanion(
          petId: drift.Value(_petId!),
          durationMin: drift.Value(dur),
          distanceKm: drift.Value(double.tryParse(_distanceCtrl.text.trim())),
          route: drift.Value(_routeCtrl.text.trim().isEmpty ? null : _routeCtrl.text.trim()),
          walkedAt: drift.Value(_walkedAt),
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('失败: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(petsStreamProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('遛狗打卡', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            petsAsync.maybeWhen(
              data: (pets) {
                if (pets.isEmpty) return const Text('请先创建宠物');
                _petId ??= pets.first.id;
                return DropdownButtonFormField<int>(
                  initialValue: _petId,
                  decoration: const InputDecoration(labelText: '宠物', border: OutlineInputBorder()),
                  items: [for (final p in pets) DropdownMenuItem(value: p.id, child: Text(p.name))],
                  onChanged: (v) => setState(() => _petId = v),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            TextField(controller: _durationCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '时长 (分钟) *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _distanceCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: '距离 (km)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _routeCtrl, decoration: const InputDecoration(labelText: '路线', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('时间'),
              subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(_walkedAt)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: _walkedAt, firstDate: DateTime(2000), lastDate: DateTime.now());
                if (picked != null) {
                  if (!context.mounted) return;
                  final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_walkedAt));
                  if (t != null) setState(() => _walkedAt = DateTime(picked.year, picked.month, picked.day, t.hour, t.minute));
                }
              },
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '打卡')),
          ],
        ),
      ),
    );
  }
}
