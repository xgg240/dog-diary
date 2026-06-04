// 医保/费用估算
import 'package:flutter/material.dart';
import 'data_loader.dart';

class InsuranceCostsPage extends StatelessWidget {
  const InsuranceCostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💰 医保/费用估算')),
      body: FutureBuilder(
        future: DataLoader.insurance(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _costTable(d['annual_cost_estimate']),
              const SizedBox(height: 8),
              _surgeryTable(d['annual_cost_estimate']['common_surgery_cost_cny']),
              const SizedBox(height: 8),
              _insuranceGuide(d['insurance_guide']),
            ],
          );
        },
      ),
    );
  }

  Widget _costTable(Map<String, dynamic> d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final e in (d['by_size'] as Map).entries) Card(
              color: Colors.amber.shade50,
              child: ListTile(
                title: Text(_sizeLabelZh(e.key), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('年常规: ¥${(e.value['annual_routine_cny'] as List).join(' - ')}\n'
                    '• 疫苗: ¥${e.value['breakdown']['疫苗']}\n'
                    '• 驱虫: ¥${e.value['breakdown']['驱虫']}\n'
                    '• 体检: ¥${e.value['breakdown']['体检']}\n'
                    '• 日粮: ¥${e.value['breakdown']['日粮(干粮)']}\n'
                    '• 美容: ¥${e.value['breakdown']['美容']}\n'
                    '• 应急: ¥${e.value['breakdown']['意外应急']}'),
                isThreeLine: true,
              ),
            ),
          ]),
        ),
      );

  Widget _surgeryTable(Map<String, dynamic> d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('🛠 常见手术费用', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final e in d.entries) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
              Expanded(child: Text(e.key)),
              Text('¥${(e.value as List).join(' - ')}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ])),
          ]),
        ),
      );

  Widget _insuranceGuide(Map<String, dynamic> d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final p in (d['providers_zh'] as List<dynamic>)) ListTile(
              dense: true,
              title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('月费: ¥${(p['monthly_cny'] as List).join('-')} · ${p['coverage']}'),
            ),
            const SizedBox(height: 8),
            const Text('💡 注意事项:', style: TextStyle(fontWeight: FontWeight.bold)),
            for (final t in (d['tips'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $t')),
            const SizedBox(height: 8),
            Card(color: Colors.amber.shade50, child: Padding(padding: const EdgeInsets.all(8), child: Text(d['recommendation']))),
          ]),
        ),
      );

  String _sizeLabelZh(String s) => switch (s) { 'small' => '🐶 小型犬', 'medium' => '🐕 中型犬', 'large' => '🦮 大型犬', _ => s };
}
