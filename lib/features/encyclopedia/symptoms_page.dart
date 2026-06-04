// 症状自查
import 'package:flutter/material.dart';
import 'data_loader.dart';

class SymptomsPage extends StatelessWidget {
  const SymptomsPage({super.key});
  static Future<List<dynamic>> allSymptoms() => DataLoader.symptoms();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🤒 症状自查')),
      body: FutureBuilder(
        future: DataLoader.symptoms(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final s = list[i];
              final urgent = s['urgency'] == 'emergency';
              return Card(
                color: urgent ? Colors.red.shade50 : null,
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: urgent ? Colors.red : Colors.orange, child: Text(s['icon'] ?? '⚠️', style: const TextStyle(fontSize: 20))),
                  title: Text(s['name_zh'], style: TextStyle(fontWeight: FontWeight.bold, color: urgent ? Colors.red.shade900 : null)),
                  subtitle: Text(urgent ? '🚨 急症 - 立即送医' : '⚠️ 观察 - 见详情'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => SymptomDetailPage(symptom: s))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SymptomDetailPage extends StatelessWidget {
  final Map<String, dynamic> symptom;
  const SymptomDetailPage({super.key, required this.symptom});

  @override
  Widget build(BuildContext context) {
    final urgent = symptom['urgency'] == 'emergency';
    return Scaffold(
      appBar: AppBar(
        title: Text('${symptom['icon']} ${symptom['name_zh']}'),
        backgroundColor: urgent ? Colors.red.shade400 : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (urgent) _emergencyBanner(),
          if (!urgent) _watchBanner(),
          _section('🔍 可能原因', symptom['possible_causes'] as List<dynamic>),
          _section('🏠 居家护理', [symptom['home_care']]),
          _section('🚑 何时送医', [symptom['vet_urgent']]),
          if ((symptom['red_flags'] as List).isNotEmpty)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('🚨 高危信号', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 8),
                  Text(symptom['red_flags'].join(' · ')),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _emergencyBanner() => Card(
        color: Colors.red.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const Text('🚨', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            const Text('急症', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 4),
            const Text('如有以下情况，请立即送医！', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {},
              child: const Text('📞 拨打附近宠物医院电话'),
            ),
          ]),
        ),
      );

  Widget _watchBanner() => Card(
        color: Colors.amber.shade50,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Row(children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(child: Text('密切观察症状变化, 出现红色信号立即送医')),
          ]),
        ),
      );

  Widget _section(String title, List<dynamic> items) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final i in items) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• $i', style: const TextStyle(height: 1.4))),
          ]),
        ),
      );
}
