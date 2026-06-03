// ============================================================
//  仪表盘 - 接入宠物/健康预警/低库存/本月消费
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/reminder_service.dart';
import '../contacts/contacts_page.dart';
import '../training/training_page.dart';
import '../walks/walks_page.dart';
import '../food/forbidden_foods_page.dart';

final _overdueProvider = StreamProvider<List<dynamic>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).healthEvents)
        ..where((t) => t.nextDueDate.isSmallerThanValue(DateTime.now()))
        ..orderBy([(t) => drift.OrderingTerm.asc(t.nextDueDate)]))
      .watch();
});
final _upcomingProvider = StreamProvider<List<dynamic>>((ref) {
  final in30 = DateTime.now().add(const Duration(days: 30));
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).healthEvents)
        ..where((t) => t.nextDueDate.isSmallerOrEqualValue(in30) & t.nextDueDate.isBiggerOrEqualValue(DateTime.now()))
        ..orderBy([(t) => drift.OrderingTerm.asc(t.nextDueDate)]))
      .watch();
});
final _lowStockProvider = StreamProvider<List<dynamic>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).foodItems)
        ..where((t) => t.remainingKg.isSmallerOrEqualValue(1.0)))
      .watch();
});
final _monthExpenseProvider = StreamProvider<double>((ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 1);
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).expenses)
        ..where((t) => t.spentAt.isBetweenValues(start, end)))
      .watch()
      .map((list) => list.fold<double>(0, (s, e) => s + e.amount));
});

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsStreamProvider);
    final overdueAsync = ref.watch(_overdueProvider);
    final upcomingAsync = ref.watch(_upcomingProvider);
    final lowAsync = ref.watch(_lowStockProvider);
    final monthExpAsync = ref.watch(_monthExpenseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏠 养狗日记'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: '扫描提醒',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final count = await ref.read(reminderServiceProvider).scanAndNotify();
              messenger.showSnackBar(SnackBar(content: Text(count == 0 ? '当前无待办提醒' : '已发出 $count 条提醒')));
            },
          ),
        ],
      ),
      body: petsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
        data: (pets) => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text('🐕', style: TextStyle(fontSize: 48)),
                    const SizedBox(width: 16),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('我的宠物', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('${pets.length} 只', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _StatCard(
                icon: Icons.warning_amber,
                color: Colors.red,
                title: '已逾期',
                async: overdueAsync,
                format: (l) => '${l.length}',
              )),
              const SizedBox(width: 8),
              Expanded(child: _StatCard(
                icon: Icons.alarm,
                color: Colors.orange,
                title: '30 天内',
                async: upcomingAsync,
                format: (l) => '${l.length}',
              )),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _StatCard(
                icon: Icons.kitchen,
                color: Colors.amber,
                title: '低库存',
                async: lowAsync,
                format: (l) => '${l.length}',
              )),
              const SizedBox(width: 8),
              Expanded(child: _StatCard(
                icon: Icons.account_balance_wallet,
                color: Colors.green,
                title: '本月支出',
                async: monthExpAsync,
                format: (v) => '¥${v.toStringAsFixed(0)}',
              )),
            ]),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: [
                    _QuickAction(emoji: '🚫', label: '禁食库', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForbiddenFoodsPage()))),
                    _QuickAction(emoji: '🏥', label: '紧急电话', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsPage()))),
                    _QuickAction(emoji: '🚶', label: '遛狗', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalksPage()))),
                    _QuickAction(emoji: '🎓', label: '训练', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainingPage()))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard<T> extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final AsyncValue<T> async;
  final String Function(T) format;
  const _StatCard({required this.icon, required this.color, required this.title, required this.async, required this.format});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ]),
          const SizedBox(height: 4),
          async.when(
            loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (e, st) => const Text('!', style: TextStyle(color: Colors.red)),
            data: (v) => Text(format(v), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.emoji, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ]),
      ),
    );
  }
}
