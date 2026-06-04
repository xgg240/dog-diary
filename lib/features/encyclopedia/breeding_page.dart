// 怀孕/发情期
import 'package:flutter/material.dart';
import 'data_loader.dart';

class BreedingPage extends StatelessWidget {
  const BreedingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              _section('🌸 发情周期', d['estrus_cycle']),
              _section('🐶 怀孕期', d['pregnancy']),
            ],
          );
        },
      ),
    );
  }

  Widget _section(String t, Map<String, dynamic> data) {
    if (t.contains('发情')) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final s in (data['stages'] as List<dynamic>)) Card(
              color: Colors.pink.shade50,
              child: ListTile(
                title: Text(s['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('📅 ${s['day_range']}'),
                  Text('🔍 表现: ${(s['signs'] as List).join(' / ')}'),
                  Text('💡 ${s['action']}'),
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
            for (final w in (data['weekly'] as List<dynamic>)) ListTile(
              dense: true,
              leading: CircleAvatar(backgroundColor: Colors.pinkAccent.shade100, child: Text('${w['week']}', style: const TextStyle(fontWeight: FontWeight.bold))),
              title: Text('第 ${w['week']} 周'),
              subtitle: Text(w['milestone']),
            ),
            const Divider(),
            const Text('🚨 紧急信号 (立即送医)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            for (final a in (data['delivery_alerts'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('🚨 $a')),
            const SizedBox(height: 8),
            const Text('🩺 产检时间:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(data['vet_visit_timing']),
          ]),
        ),
      );
    }
  }
}
