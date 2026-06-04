// 绝育助手
import 'package:flutter/material.dart';
import 'data_loader.dart';

class SpayNeuterPage extends StatelessWidget {
  const SpayNeuterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('✂️ 绝育决策助手')),
      body: FutureBuilder(
        future: DataLoader.spay(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!['guide'];
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(color: Colors.amber.shade50, child: Padding(padding: const EdgeInsets.all(12), child: Text(d['summary']))),
              const SizedBox(height: 8),
              _section('🐩 母犬 (Female)', d['female_dog']),
              _section('🐕 公犬 (Male)', d['male_dog']),
              _section('⚠️ 隐睾', d['cryptorchid']),
            ],
          );
        },
      ),
    );
  }

  Widget _section(String t, Map<String, dynamic> data) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (data['recommended_age_months'] is Map) ...[
              const Text('推荐绝育月龄:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Wrap(spacing: 6, children: [
                for (final e in (data['recommended_age_months'] as Map).entries) Chip(label: Text('${e.key}: ${(e.value as List).join('-')}月')),
              ]),
              const SizedBox(height: 8),
            ],
            if (data['benefits'] is List) ...[
              const Text('✅ 好处:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
              for (final b in (data['benefits'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $b')),
              const SizedBox(height: 6),
            ],
            if (data['risks'] is List) ...[
              const Text('⚠️ 风险:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
              for (final r in (data['risks'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $r')),
              const SizedBox(height: 6),
            ],
            if (data['cost_estimate_cny'] is List) Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('💰 参考费用: ¥${(data['cost_estimate_cny'] as List).join('-')}', style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            if (data['note'] != null) Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('💡 ${data['note']}', style: TextStyle(color: Colors.blueGrey.shade700, fontStyle: FontStyle.italic)),
            ),
          ]),
        ),
      );
}
