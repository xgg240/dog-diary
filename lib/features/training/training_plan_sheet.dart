// ============================================================
//  训练计划 - 创建/编辑 sheet（v4 Stage 2）
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/pet_switcher_provider.dart';
import '../../core/providers.dart';
import '../../db/database.dart';

class TrainingPlanSheet extends ConsumerStatefulWidget {
  final TrainingPlan? existing;
  const TrainingPlanSheet({super.key, this.existing});

  @override
  ConsumerState<TrainingPlanSheet> createState() => _TrainingPlanSheetState();
}

class _TrainingPlanSheetState extends ConsumerState<TrainingPlanSheet> {
  late final _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
  late final _commandCtrl = TextEditingController(text: widget.existing?.command ?? '');
  late int _targetDays = widget.existing?.targetDays ?? 7;
  late int _dailyMin = widget.existing?.dailyMinutes ?? 10;
  late int _progress = widget.existing?.progress ?? 0;
  late DateTime _startDate = widget.existing?.startDate ?? DateTime.now();
  late final _notesCtrl = TextEditingController(text: widget.existing?.notes ?? '');

  static const _commandSuggestions = [
    'sit', 'stay', 'down', 'come', 'heel', 'leave_it', 'drop_it', 'shake', 'roll_over', 'spin',
    '坐', '等', '卧', '来', '随行', '不', '吐', '握手', '打滚', '转圈',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _commandCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final petId = ref.read(currentPetIdProvider);
    if (petId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先在仪表盘选一只狗')),
      );
      return;
    }
    if (_titleCtrl.text.trim().isEmpty || _commandCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('标题和指令必填')),
      );
      return;
    }
    final db = ref.read(databaseProvider);
    final companion = TrainingPlansCompanion(
      petId: drift.Value(petId),
      title: drift.Value(_titleCtrl.text.trim()),
      command: drift.Value(_commandCtrl.text.trim()),
      targetDays: drift.Value(_targetDays),
      dailyMinutes: drift.Value(_dailyMin),
      progress: drift.Value(_progress),
      startDate: drift.Value(_startDate),
      endDate: drift.Value(_startDate.add(Duration(days: _targetDays))),
      notes: drift.Value(_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
    );
    if (widget.existing != null) {
      await (db.update(db.trainingPlans)..where((t) => t.id.equals(widget.existing!.id))).write(companion);
    } else {
      await db.into(db.trainingPlans).insert(companion);
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.existing == null) return;
    final db = ref.read(databaseProvider);
    await (db.delete(db.trainingPlans)..where((t) => t.id.equals(widget.existing!.id))).go();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.existing != null ? '编辑训练计划' : '新建训练计划',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: '计划标题', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commandCtrl,
              decoration: InputDecoration(
                labelText: '指令',
                border: const OutlineInputBorder(),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (v) => setState(() => _commandCtrl.text = v),
                  itemBuilder: (_) => _commandSuggestions
                      .map((s) => PopupMenuItem(value: s, child: Text(s)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('计划天数'),
                Expanded(
                  child: Slider(
                    value: _targetDays.toDouble(),
                    min: 3, max: 60,
                    divisions: 57,
                    label: '$_targetDays 天',
                    onChanged: (v) => setState(() => _targetDays = v.toInt()),
                  ),
                ),
                Text('$_targetDays'),
              ],
            ),
            Row(
              children: [
                const Text('每天时长'),
                Expanded(
                  child: Slider(
                    value: _dailyMin.toDouble(),
                    min: 5, max: 60,
                    divisions: 11,
                    label: '$_dailyMin 分钟',
                    onChanged: (v) => setState(() => _dailyMin = v.toInt()),
                  ),
                ),
                Text('$_dailyMin 分'),
              ],
            ),
            Row(
              children: [
                const Text('已练'),
                Expanded(
                  child: Slider(
                    value: _progress.toDouble(),
                    min: 0, max: _targetDays.toDouble(),
                    divisions: _targetDays,
                    label: '$_progress / $_targetDays',
                    onChanged: (v) => setState(() => _progress = v.toInt()),
                  ),
                ),
                Text('$_progress/$_targetDays'),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('开始日期'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_startDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => _startDate = picked);
              },
            ),
            TextField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: '备注（可选）', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (widget.existing != null)
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('删除', style: TextStyle(color: Colors.red)),
                    onPressed: _delete,
                  ),
                const Spacer(),
                FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('保存'),
                  onPressed: _save,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
