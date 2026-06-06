// 怀孕/发情期
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class BreedingPage extends StatelessWidget {
  const BreedingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('🤰 怀孕/发情期')),
      body: FutureBuilder(
        future: DataLoader.breeding(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _section(ctx, '🌸 发情周期', d['estrus_cycle']),
              const SizedBox(height: 8),
              _section(ctx, '🐶 怀孕期', d['pregnancy']),
              const SizedBox(height: 8),
              _section(ctx, '⏰ 配种时机', d['mating_timing']),
              const SizedBox(height: 8),
              _section(ctx, '🩺 验孕方法', d['pregnancy_detection']),
              const SizedBox(height: 8),
              _section(ctx, '🍼 新生幼犬 0-7 天', d['newborn_care_7d']),
              const SizedBox(height: 8),
              _section(ctx, '🚨 产后并发症', d['complications_after_birth']),
            ],
          );
        },
      ),
    );
  }

  Widget _section(BuildContext context, String t, Map<String, dynamic> data) {
    if (t.contains('发情')) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final s in ((data['stages'] as List<dynamic>?) ?? const <dynamic>[])) Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: ListTile(
                title: Text(s['name_zh']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('📅 ${s['day_range']?.toString() ?? ''}'),
                  Text('🔍 表现: ${(s['signs'] as List?)?.join(' / ') ?? ''}'),
                  Text('💡 ${s['action']?.toString() ?? ''}'),
                ]),
                isThreeLine: true,
              ),
            ),
            Padding(padding: const EdgeInsets.all(8), child: Text('📌 ${data['note']}')),
          ]),
        ),
      );
    } else {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final w in ((data['weekly'] as List<dynamic>?) ?? const <dynamic>[])) ListTile(
              dense: true,
              leading: CircleAvatar(backgroundColor: Colors.pinkAccent.shade100, child: Text('${w['week']}', style: const TextStyle(fontWeight: FontWeight.bold))),
              title: Text('第 ${w['week']} 周'),
              subtitle: Text(w['milestone']?.toString() ?? ''),
            ),
            const Divider(),
            Text('🚨 紧急信号 (立即送医)', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
            for (final a in ((data['delivery_alerts'] as List<dynamic>?) ?? const <dynamic>[])) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('🚨 $a')),
            const SizedBox(height: 8),
            const Text('🩺 产检时间:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(data['vet_visit_timing']?.toString() ?? ''),
          ]),
        ),
      );
    }
  }
}
