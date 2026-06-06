// ============================================================
//  体重趋势卡（仪表盘 v3 Stage 1）
// ------------------------------------------------------------
//  fl_chart LineChart 渲染最近 30 天体重曲线
// ============================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import "../../core/pet_switcher_provider.dart";
import '../../core/providers.dart';
import '../../db/database.dart';

final _weightRecordsProvider = StreamProvider.autoDispose((ref) {
  final petId = ref.watch(currentPetIdProvider);
  final db = ref.watch(databaseProvider);
  final q = db.select(db.weightRecords)
    ..orderBy([(t) => drift.OrderingTerm.asc(t.measuredAt)]);
  if (petId != null) {
    q.where((t) => t.petId.equals(petId));
  }
  return q.watch();
});

class WeightChartCard extends ConsumerWidget {
  const WeightChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(_weightRecordsProvider);
    final currentPet = ref.watch(currentPetProvider);
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行 + 宠物下拉
            Row(
              children: [
                const Icon(Icons.monitor_weight_outlined, size: 18),
                const SizedBox(width: 6),
                Text('体重趋势', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                _PetDropdownChip(),
                const Spacer(),
                Text(
                  '${recordsAsync.value?.length ?? 0} 条记录',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: recordsAsync.when(
                data: (records) => records.length < 2
                    ? const Center(
                        child: Text('记录 ≥2 条才能画曲线\n体重页加几条试试',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey)),
                      )
                    : _buildChart(records),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('加载失败: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<dynamic> records) {
    final sorted = List<dynamic>.from(records);
    sorted.sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    final spots = <FlSpot>[];
    final base = sorted.first.measuredAt.millisecondsSinceEpoch.toDouble();
    for (final r in sorted) {
      final x = (r.measuredAt.millisecondsSinceEpoch - base) / (86400000.0); // 天
      spots.add(FlSpot(x, r.weightKg));
    }
    final weights = sorted.map((r) => r.weightKg as double).toList();
    final minY = (weights.reduce((a, b) => a < b ? a : b) - 0.5).floorToDouble();
    final maxY = (weights.reduce((a, b) => a > b ? a : b) + 0.5).ceilToDouble();
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (v, meta) => Text(
                v.toStringAsFixed(1),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: (spots.length / 3).clamp(1, 30).toDouble(),
              getTitlesWidget: (v, meta) {
                final dt = DateTime.fromMillisecondsSinceEpoch(
                    (base + v * 86400000).toInt());
                return Text(
                  DateFormat('M/d').format(dt),
                  style: const TextStyle(fontSize: 9),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.teal,
            barWidth: 2.5,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.teal.withOpacity(0.15),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touched) => touched.map((s) {
              final dt = DateTime.fromMillisecondsSinceEpoch(
                  (base + s.x * 86400000).toInt());
              return LineTooltipItem(
                '${DateFormat('M/d').format(dt)}\n${s.y.toStringAsFixed(2)} 公斤',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


// ============================================================
//  体重卡顶部宠物下拉 (切狗 → 体重数据跟随 currentPetIdProvider)
// ============================================================
class _PetDropdownChip extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsStreamProvider);
    final pets = petsAsync.value ?? const <Pet>[];
    final currentPetId = ref.watch(currentPetIdProvider);
    final currentPet = ref.watch(currentPetProvider);
    if (pets.isEmpty) return const SizedBox.shrink();
    // 修复: 用 DropdownButton 替代 PopupMenuButton (切换 "全部" 偶发失效)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.indigo.shade200, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          isDense: true,
          value: currentPetId,  // null = 全部
          icon: const Icon(Icons.arrow_drop_down, size: 18, color: Colors.indigo),
          style: const TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.w600),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Row(children: [Text('🐾 全部', style: TextStyle(fontSize: 12))]),
            ),
            for (final p in pets)
              DropdownMenuItem<int?>(
                value: p.id,
                child: Text('🐕 ${p.name}', style: const TextStyle(fontSize: 12)),
              ),
          ],
          onChanged: (v) {
            // v 可能是 null (选全部) 或 int (选某只狗)
            ref.read(currentPetIdProvider.notifier).state = v;
          },
        ),
      ),
    );
  }
}
