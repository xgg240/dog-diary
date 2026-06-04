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
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
          children: [
            _PetsHero(count: pets.length),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _StatCard(
                icon: Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
                bg: Theme.of(context).colorScheme.errorContainer,
                title: '已逾期',
                async: overdueAsync,
                format: (l) => '${l.length}',
              )),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(
                icon: Icons.alarm_rounded,
                color: Theme.of(context).colorScheme.tertiary,
                bg: Theme.of(context).colorScheme.tertiaryContainer,
                title: '30 天内',
                async: upcomingAsync,
                format: (l) => '${l.length}',
              )),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _StatCard(
                icon: Icons.kitchen_rounded,
                color: Theme.of(context).colorScheme.secondary,
                bg: Theme.of(context).colorScheme.secondaryContainer,
                title: '低库存',
                async: lowAsync,
                format: (l) => '${l.length}',
              )),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(
                icon: Icons.account_balance_wallet_rounded,
                color: Theme.of(context).colorScheme.primary,
                bg: Theme.of(context).colorScheme.primaryContainer,
                title: '本月支出',
                async: monthExpAsync,
                format: (v) => '¥${v.toStringAsFixed(0)}',
              )),
            ]),
            const SizedBox(height: 18),
            const _SectionHeader(label: '快捷入口'),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Row(children: [
                  Expanded(child: _QuickAction(emoji: '🚫', label: '禁食库', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForbiddenFoodsPage())))),
                  Expanded(child: _QuickAction(emoji: '🏥', label: '紧急电话', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsPage())))),
                  Expanded(child: _QuickAction(emoji: '🚶', label: '遛狗', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalksPage())))),
                  Expanded(child: _QuickAction(emoji: '🎓', label: '训练', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainingPage())))),
                ]),
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
  final Color? bg;
  const _StatCard({required this.icon, required this.color, required this.title, required this.async, required this.format, this.bg});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: bg,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.75), fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 8),
          async.when(
            loading: () => const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (e, st) => Text('!', style: TextStyle(color: cs.error, fontSize: 22, fontWeight: FontWeight.w700)),
            data: (v) => Text(format(v), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface, height: 1.1)),
          ),
        ]),
      ),
    );
  }
}

class _PetsHero extends StatelessWidget {
  final int count;
  const _PetsHero({required this.count});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [cs.primary, cs.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: cs.onPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(child: Text('🐕', style: TextStyle(fontSize: 30, color: cs.onPrimary, height: 1.0))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('我的宠物', style: TextStyle(color: cs.onPrimary.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text('$count 只', style: TextStyle(color: cs.onPrimary, fontSize: 28, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5)),
          ]),
        ),
        Icon(Icons.chevron_right_rounded, color: cs.onPrimary.withValues(alpha: 0.6)),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(children: [
        Container(width: 3, height: 14, decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: 0.2)),
      ]),
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
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 36,
            height: 36,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(emoji, style: const TextStyle(fontSize: 26, height: 1.0)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }
}
