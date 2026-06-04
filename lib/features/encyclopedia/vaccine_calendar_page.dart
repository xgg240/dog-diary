// 疫苗驱虫日历 - 按生日自动算
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/providers.dart';
import '../../db/database.dart';
import 'data_loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VaccineCalendarPage extends ConsumerWidget {
  const VaccineCalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('💉 疫苗驱虫日历')),
      body: FutureBuilder(
        future: DataLoader.vaccine(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final data = snap.data!;
          final petsAsync = ref.watch(petsStreamProvider);
          return petsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('错误: $e')),
            data: (pets) {
              if (pets.isEmpty) return const Center(child: Text('请先在"宠物"页添加宠物\n才能生成疫苗日历'));
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final p in pets) _petCard(context, p, data),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _petCard(BuildContext ctx, Pet pet, Map<String, dynamic> data) {
    final birthday = pet.birthday;
    if (birthday == null) {
      return Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.pets)),
          title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('⚠️ 未设置生日, 无法生成日历'),
        ),
      );
    }
    final now = DateTime.now();
    final ageWeeks = now.difference(birthday).inDays ~/ 7;
    final ageYears = (ageWeeks / 52).toStringAsFixed(1);

    final vaccines = (data['vaccine_schedule'] as List<dynamic>);
    final items = <Widget>[];

    for (final v in vaccines) {
      final weeks = v['age_weeks'] as int;
      final date = birthday.add(Duration(days: weeks * 7));
      final isPast = date.isBefore(now);
      final upcoming = date.difference(now).inDays;
      items.add(ListTile(
        leading: Icon(
          isPast ? Icons.check_circle : (upcoming < 30 ? Icons.alarm : Icons.vaccines),
          color: isPast ? Colors.green : (upcoming < 30 ? Colors.orange : Colors.blue),
        ),
        title: Text(v['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${DateFormat('yyyy-MM-dd').format(date)} (${weeks}周龄) · ${isPast ? "✅ 已过期" : "$upcoming 天后"}'),
        trailing: v['core'] == true ? Chip(label: const Text('必打', style: TextStyle(fontSize: 10)), backgroundColor: Colors.red.shade50) : null,
      ));
    }

    // 驱虫
    final deworm = data['deworm_schedule'] as Map<String, dynamic>;
    final puppy = deworm['puppy_internal'] as Map<String, dynamic>;
    items.add(Card(
      color: Colors.amber.shade50,
      child: ListTile(
        leading: const Icon(Icons.medication, color: Colors.orange),
        title: const Text('🐛 幼犬体内驱虫', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${puppy['start_age_weeks']} 周起, 每 ${puppy['interval_weeks']} 周一次, 到 ${puppy['until_age_weeks']} 周'),
        trailing: Text('当前: ${ageWeeks}周'),
      ),
    ));

    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.pets),
        title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('生日 ${DateFormat('yyyy-MM-dd').format(birthday)} · ${ageYears}岁 · ${ageWeeks}周龄'),
        children: items,
      ),
    );
  }
}
