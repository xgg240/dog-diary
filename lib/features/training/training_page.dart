// ============================================================
//  训练日志
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../db/database.dart';

final _trainingsProvider = StreamProvider<List<TrainingLog>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).trainingLogs)
        ..orderBy([(t) => drift.OrderingTerm.desc(t.trainedAt)]))
      .watch();
});

class TrainingPage extends ConsumerWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingsAsync = ref.watch(_trainingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('🎓 训练日志')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (_) => const _TrainingSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('记录'),
      ),
      body: trainingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('暂无训练记录\n点击右下角添加'));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final t = list[i];
              return Dismissible(
                key: ValueKey(t.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await (ref.read(databaseProvider).delete(ref.read(databaseProvider).trainingLogs)..where((tt) => tt.id.equals(t.id))).go();
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _color(t.performance ?? '').withValues(alpha: 0.2),
                    child: Icon(Icons.school, color: _color(t.performance ?? '')),
                  ),
                  title: Text(t.command),
                  subtitle: Text('${t.durationMin ?? 0} 分钟 · ${t.performance ?? '-'} · ${DateFormat('MM-dd HH:mm').format(t.trainedAt)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _color(String p) {
    switch (p) {
      case 'good': return Colors.green;
      case 'ok': return Colors.orange;
      case 'bad': return Colors.red;
      default: return Colors.grey;
    }
  }
}

class _TrainingSheet extends ConsumerStatefulWidget {
  const _TrainingSheet();
  @override
  ConsumerState<_TrainingSheet> createState() => _S();
}

class _S extends ConsumerState<_TrainingSheet> {
  final _commandCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  int? _petId;
  String _performance = 'good';
  bool _saving = false;

  @override
  void dispose() {
    _commandCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_petId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先创建宠物')));
      return;
    }
    if (_commandCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入指令')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(databaseProvider).into(ref.read(databaseProvider).trainingLogs).insert(
        TrainingLogsCompanion(
          petId: drift.Value(_petId!),
          command: drift.Value(_commandCtrl.text.trim()),
          durationMin: drift.Value(int.tryParse(_durationCtrl.text.trim())),
          performance: drift.Value(_performance),
          trainedAt: const drift.Value.absent(),
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
            Text('训练记录', style: Theme.of(context).textTheme.titleLarge),
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
            TextField(controller: _commandCtrl, decoration: const InputDecoration(labelText: '指令 * (sit/stay/握手...)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _durationCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '时长 (分钟)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const Text('表现'),
            const SizedBox(height: 4),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'good', label: Text('👍 优秀')),
                ButtonSegment(value: 'ok', label: Text('👌 一般')),
                ButtonSegment(value: 'bad', label: Text('👎 差')),
              ],
              selected: {_performance},
              onSelectionChanged: (s) => setState(() => _performance = s.first),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '保存')),
          ],
        ),
      ),
    );
  }
}
