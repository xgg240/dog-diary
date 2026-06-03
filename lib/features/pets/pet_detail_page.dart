// ============================================================
//  宠物详情 + 体重曲线 + 体重录入
// ============================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../db/database.dart';
import 'pet_edit_sheet.dart';
import 'pet_repository.dart';

class PetDetailPage extends ConsumerWidget {
  final int petId;
  const PetDetailPage({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsStreamProvider);
    final weightsAsync = ref.watch(_weightsProvider(petId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('宠物详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final pet = petsAsync.valueOrNull?.firstWhere(
                (p) => p.id == petId,
                orElse: () => throw Exception('not found'),
              );
              if (pet != null) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  showDragHandle: true,
                  builder: (_) => PetEditSheet(existing: pet),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addWeight(context, ref),
        icon: const Icon(Icons.monitor_weight),
        label: const Text('记体重'),
      ),
      body: petsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
        data: (pets) {
          Pet? pet;
          try {
            pet = pets.firstWhere((p) => p.id == petId);
          } catch (_) {
            return const Center(child: Text('宠物不存在'));
          }
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(pet.name.isNotEmpty ? pet.name[0] : '🐕',
                                style: const TextStyle(fontSize: 32)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pet.name, style: Theme.of(context).textTheme.headlineSmall),
                                Text('${pet.breed ?? '未填品种'} · ${pet.gender == 'male' ? '♂ 公' : '♀ 母'}${pet.neutered ? ' · 已绝育' : ''}'),
                                if (pet.birthday != null)
                                  Text('生日: ${DateFormat('yyyy-MM-dd').format(pet.birthday!)}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (pet.notes != null && pet.notes!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(pet.notes!, style: const TextStyle(color: Colors.black54)),
                      ],
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📈 体重曲线', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: weightsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, st) => Center(child: Text('错误: $e')),
                          data: (list) {
                            if (list.isEmpty) {
                              return const Center(
                                child: Text('暂无体重数据\n点击右下角 "记体重" 添加', textAlign: TextAlign.center),
                              );
                            }
                            return _WeightChart(weights: list);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📋 历史记录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      weightsAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (e, st) => Text('错误: $e'),
                        data: (list) {
                          if (list.isEmpty) return const Text('无');
                          final sorted = list.reversed.toList();
                          return Column(
                            children: [
                              for (int i = 0; i < sorted.length; i++)
                                Dismissible(
                                  key: ValueKey(sorted[i].id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16),
                                    color: Colors.red,
                                    child: const Icon(Icons.delete, color: Colors.white),
                                  ),
                                  onDismissed: (_) async {
                                    await ref.read(petRepoProvider).deleteWeight(sorted[i].id);
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.monitor_weight, color: Colors.orange),
                                    title: Text('${sorted[i].weightKg.toStringAsFixed(2)} kg'),
                                    subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(sorted[i].measuredAt)),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addWeight(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    DateTime measuredAt = DateTime.now();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) => Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('记体重', style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ctrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: '体重 (kg) *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('测量时间'),
                    subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(measuredAt)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        initialDate: measuredAt,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (d != null) {
                        if (!ctx.mounted) return;
                        final t = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay.fromDateTime(measuredAt),
                        );
                        if (t != null) {
                          setState(() => measuredAt = DateTime(d.year, d.month, d.day, t.hour, t.minute));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      final w = double.tryParse(ctrl.text.trim());
                      if (w == null || w <= 0) return;
                      Navigator.pop(ctx, true);
                    },
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (result == true) {
      final w = double.parse(ctrl.text.trim());
      await ref.read(petRepoProvider).addWeight(
            petId: petId,
            measuredAt: measuredAt,
            weightKg: w,
          );
    }
  }
}

final _weightsProvider = StreamProvider.family.autoDispose<List<WeightRecord>, int>((ref, petId) {
  return ref.watch(petRepoProvider).watchWeights(petId);
});

class _WeightChart extends StatelessWidget {
  final List<WeightRecord> weights;
  const _WeightChart({required this.weights});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (int i = 0; i < weights.length; i++) {
      spots.add(FlSpot(i.toDouble(), weights[i].weightKg));
    }
    final minY = weights.map((w) => w.weightKg).reduce((a, b) => a < b ? a : b) - 0.5;
    final maxY = weights.map((w) => w.weightKg).reduce((a, b) => a > b ? a : b) + 0.5;
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (weights.length / 4).clamp(1, double.infinity).toDouble(),
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= weights.length) return const SizedBox.shrink();
                return Text(DateFormat('MM-dd').format(weights[i].measuredAt), style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
