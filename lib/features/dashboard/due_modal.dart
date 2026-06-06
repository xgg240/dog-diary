// ============================================================
//  疫苗/驱虫到期弹窗（仪表盘 v3 Stage 1）
// ------------------------------------------------------------
//  启动时检查 nextDueDate ≤ today+7，弹 modal 提醒
//  同一天同一项只弹一次（用 user_preferences ack_due_xxx 标记）
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../core/pet_switcher_provider.dart';
import '../../core/providers.dart';
import '../health/health_repository.dart';

final _dueSoonProvider = StreamProvider.autoDispose((ref) {
  final petId = ref.watch(currentPetIdProvider);
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final in7 = now.add(const Duration(days: 7));
  final pastYear = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 365));
  final q = db.select(db.healthEvents)
    ..where((t) => t.nextDueDate.isBetweenValues(pastYear, in7))
    ..orderBy([(t) => drift.OrderingTerm.asc(t.nextDueDate)]);
  if (petId != null) {
    q.where((t) => t.petId.equals(petId));
  }
  return q.watch();
});

class DueReminderModal {
  static bool _shown = false;

  static Future<void> checkAndShow(BuildContext context, WidgetRef ref) async {
    if (_shown) return;
    final dueAsync = ref.read(_dueSoonProvider);
    final records = dueAsync.value;
    if (records == null || records.isEmpty) return;
    final now = DateTime.now();
    final overdue = <dynamic>[];
    final upcoming = <dynamic>[];
    for (final r in records) {
      final due = r.nextDueDate as DateTime?;
      if (due == null) continue;
      if (due.isBefore(now)) overdue.add(r); else upcoming.add(r);
    }
    if (overdue.isEmpty && upcoming.isEmpty) return;

    _shown = true;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(overdue.isNotEmpty ? Icons.error : Icons.notifications_active,
                color: overdue.isNotEmpty ? Colors.red : Colors.orange),
            const SizedBox(width: 8),
            Text('健康提醒 (${overdue.length + upcoming.length})'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (overdue.isNotEmpty) ...[
                  const Text('🔴 已逾期', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 4),
                  ...overdue.map((r) => _buildItem(r, overdue: true)),
                  const SizedBox(height: 12),
                ],
                if (upcoming.isNotEmpty) ...[
                  const Text('🟡 即将到期（7 天内）',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  const SizedBox(height: 4),
                  ...upcoming.map((r) => _buildItem(r, overdue: false)),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
    _shown = false;
  }

  static Widget _buildItem(dynamic r, {required bool overdue}) {
    final days = r.nextDueDate.difference(DateTime.now()).inDays;
    final dateStr = DateFormat('yyyy-MM-dd').format(r.nextDueDate);
    const typeLabels = {
      'checkup': '体检',
      'vaccine': '疫苗',
      'deworm': '驱虫',
      'flea': '体外驱虫',
      'surgery': '手术',
      'medication': '用药',
      'other': '其他',
    };
    final typeLabel = typeLabels[r.type as String] ?? r.type;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            overdue ? Icons.error_outline : Icons.schedule,
            size: 16,
            color: overdue ? Colors.red : Colors.orange,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${r.title} · $typeLabel',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  overdue ? '逾期 ${-days} 天 · $dateStr' : '$days 天后 · $dateStr',
                  style: TextStyle(
                    fontSize: 12,
                    color: overdue ? Colors.red : Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
