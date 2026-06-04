// 疾病库
import 'package:flutter/material.dart';
import 'data_loader.dart';

class DiseasesPage extends StatelessWidget {
  const DiseasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏥 疾病库')),
      body: FutureBuilder(
        future: DataLoader.diseases(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final d = list[i];
              final urgent = d['urgency'] == 'emergency';
              return Card(
                color: urgent ? Colors.red.shade50 : null,
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: urgent ? Colors.red : Colors.blue, child: const Icon(Icons.medical_services, color: Colors.white)),
                  title: Text(d['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${d['name_en']} · ${d['category']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => _Detail(d: d))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final Map<String, dynamic> d;
  const _Detail({required this.d});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(d['name_zh'])),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _sec('📋 概述', [d['susceptible']]),
          _sec('🔍 症状', d['symptoms'] as List<dynamic>),
          if (d['transmission'] != null) _sec('🦠 传播', [d['transmission']]),
          _sec('💊 治疗', [d['treatment']]),
          _sec('🛡️ 预防', [d['prevention']]),
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                const Icon(Icons.attach_money),
                const SizedBox(width: 8),
                Expanded(child: Text('参考费用: ¥${d['cost_estimate_cny'][0]} - ¥${d['cost_estimate_cny'][1]}')),
              ]),
            ),
          ),
          if (d['mortality'] != null) _sec('⚰️ 死亡率', [d['mortality']]),
          if (d['note'] != null) Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('⚠️ ${d['note']}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sec(String t, List<dynamic> items) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final i in items) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• $i', style: const TextStyle(height: 1.4))),
          ]),
        ),
      );
}
