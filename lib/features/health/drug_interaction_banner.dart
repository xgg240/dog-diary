// ============================================================
//  健康页 - 药品冲突警告 banner（v4 Stage 2）
// ------------------------------------------------------------
//  自动检查当前狗的所有活跃用药，发现冲突顶部红色 banner
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/drug_interactions.dart';
import '../../core/pet_switcher_provider.dart';
import '../../core/providers.dart';

final _activeMedsProvider = StreamProvider.autoDispose<List<String>>((ref) {
  final petId = ref.watch(currentPetIdProvider);
  final db = ref.watch(databaseProvider);
  final q = db.select(db.medications)
    ..where((t) => t.active.equals(true));
  if (petId != null) q.where((t) => t.petId.equals(petId));
  return q.watch().map((list) => list.map((m) => m.name).toList());
});

class DrugInteractionBanner extends ConsumerWidget {
  const DrugInteractionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medsAsync = ref.watch(_activeMedsProvider);
    return medsAsync.maybeWhen(
      data: (meds) {
        if (meds.length < 2) return const SizedBox.shrink();
        final conflicts = DrugInteractionChecker.checkAll(meds);
        if (conflicts.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border.all(color: Colors.red.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('⚠️ 检测到 ${conflicts.length} 组药品冲突',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                            fontSize: 13)),
                    const SizedBox(height: 4),
                    ...conflicts.map((c) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '• [${c.severity}] ${c.description}',
                            style: TextStyle(color: Colors.red.shade900, fontSize: 12),
                          ),
                        )),
                    const SizedBox(height: 4),
                    Text('仅作提醒，实际用药遵医嘱',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
