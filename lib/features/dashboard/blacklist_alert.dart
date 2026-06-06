// ============================================================
//  食物品牌黑名单提醒（仪表盘 v4 Stage 2）
// ------------------------------------------------------------
//  列出所有 blacklisted=true 的食物，作为仪表盘"慎买"提醒
// ============================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../core/providers.dart';

final _blacklistProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.foodItems)
        ..where((t) => t.blacklisted.equals(true))
        ..orderBy([(t) => drift.OrderingTerm.desc(t.purchaseDate)]))
      .watch();
});

class BlacklistAlertCard extends ConsumerWidget {
  const BlacklistAlertCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(_blacklistProvider);
    return listAsync.maybeWhen(
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.deepOrange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.block, color: Colors.deepOrange.shade700, size: 18),
                    const SizedBox(width: 6),
                    Text('慎买 · 黑名单食物 (${list.length})',
                        style: TextStyle(
                            color: Colors.deepOrange.shade900,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                ...list.take(5).map((f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.fiber_manual_record, size: 6, color: Colors.deepOrange),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${f.brand} · ${f.productName}${f.flavor != null ? " (${f.flavor})" : ""}',
                              style: const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (f.allergyReason != null)
                            Flexible(
                              child: Text(
                                f.allergyReason!,
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    )),
                if (list.length > 5)
                  Text('…等 ${list.length - 5} 项',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
