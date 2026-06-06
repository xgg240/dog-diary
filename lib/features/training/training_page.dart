// ============================================================
//  训练日志 + 训练计划（v4 Stage 2）
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../db/database.dart';
import 'training_plan_sheet.dart';

final _trainingsProvider = StreamProvider<List<TrainingLog>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).trainingLogs)
        ..orderBy([(t) => drift.OrderingTerm.desc(t.trainedAt)]))
      .watch();
});

final _trainingPlansProvider = StreamProvider<List<TrainingPlan>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).trainingPlans)
        ..orderBy([(t) => drift.OrderingTerm.asc(t.completed), (t) => drift.OrderingTerm.asc(t.startDate)]))
      .watch();
});

class TrainingPage extends ConsumerWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🎓 训练'),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.list), text: '日志'),
            Tab(icon: Icon(Icons.assignment), text: '计划'),
          ]),
        ),
        floatingActionButton: Builder(
          builder: (ctx) {
            final tab = DefaultTabController.of(ctx).index;
            return FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  showDragHandle: true,
                  builder: (_) => tab == 0 ? const _TrainingSheet() : const TrainingPlanSheet(),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(tab == 0 ? '记录' : '计划'),
            );
          },
        ),
        body: TabBarView(children: [
          _LogsTab(trainingsAsync: ref.watch(_trainingsProvider)),
          _PlansTab(plansAsync: ref.watch(_trainingPlansProvider)),
        ]),
      ),
    );
  }
}

Color _color(String p) {
  switch (p) {
    case 'good': return Colors.green;
    case 'ok': return Colors.orange;
    case 'bad': return Colors.red;
    default: return Colors.grey;
  }
}

class _LogsTab extends ConsumerWidget {
  final AsyncValue<List<TrainingLog>> trainingsAsync;
  const _LogsTab({required this.trainingsAsync});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return trainingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('错误: $e')),
      data: (list) {
        if (list.isEmpty) return const Center(child: Text('暂无训练记录\n点击右下角添加'));
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final t = list[i];
            return Dismissible(
              key: ValueKey('log-${t.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) async {
                final db = ref.read(databaseProvider);
                await (db.delete(db.trainingLogs)..where((tt) => tt.id.equals(t.id))).go();
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
    );
  }
}

class _PlansTab extends ConsumerWidget {
  final AsyncValue<List<TrainingPlan>> plansAsync;
  const _PlansTab({required this.plansAsync});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return plansAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('错误: $e')),
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('暂无训练计划\n点击右下"计划"开始制定', textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final p = list[i];
            final progress = p.targetDays == 0 ? 0.0 : p.progress / p.targetDays;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: p.completed ? Colors.green : Colors.indigo,
                child: Icon(p.completed ? Icons.check : Icons.assignment, color: Colors.white),
              ),
              title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('指令: ${p.command} · 每天 ${p.dailyMinutes} 分 · 计划 ${p.targetDays} 天'),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 2),
                  Text('${p.progress}/${p.targetDays} 天 · ${DateFormat('MM-dd').format(p.startDate)} 开始',
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                tooltip: '打卡 +1',
                onPressed: p.completed ? null : () async {
                  final db = ref.read(databaseProvider);
                  final newProg = (p.progress + 1).clamp(0, p.targetDays);
                  await (db.update(db.trainingPlans)..where((t) => t.id.equals(p.id))).write(
                    TrainingPlansCompanion(
                      progress: drift.Value(newProg),
                      completed: drift.Value(newProg >= p.targetDays),
                    ),
                  );
                },
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  showDragHandle: true,
                  builder: (_) => TrainingPlanSheet(existing: p),
                );
              },
            );
          },
        );
      },
    );
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
    final pid = _petId;
    if (pid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先创建宠物')));
      return;
    }
    if (_commandCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('指令必填')));
      return;
    }
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    await db.into(db.trainingLogs).insert(TrainingLogsCompanion.insert(
      petId: pid,
      command: _commandCtrl.text.trim(),
      durationMin: drift.Value(int.tryParse(_durationCtrl.text)),
      performance: drift.Value(_performance),
      trainedAt: DateTime.now(),
    ));
    if (mounted) Navigator.pop(context);
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
