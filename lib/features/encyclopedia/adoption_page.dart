// 领养/购买指南
import 'package:flutter/material.dart';
import 'data_loader.dart';

class AdoptionPage extends StatelessWidget {
  const AdoptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏠 领养/购买指南')),
      body: FutureBuilder(
        future: DataLoader.adoption(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final data = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _section('🐶 购买指南', data['buying_guide']),
              _section('🤝 领养指南', data['adoption_guide']),
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
            if (data['red_flags'] != null) ...[
              Text(data['red_flags']['title'], style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
              for (final i in (data['red_flags']['items'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('⚠️ $i')),
              const SizedBox(height: 8),
            ],
            if (data['green_flags'] != null) ...[
              Text(data['green_flags']['title'], style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
              for (final i in (data['green_flags']['items'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('✅ $i')),
              const SizedBox(height: 8),
            ],
            if (data['checklist'] != null) ...[
              Text(data['checklist']['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
              for (final i in (data['checklist']['items'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('☐ $i')),
              const SizedBox(height: 8),
            ],
            if (data['channels'] != null) ...[
              const Text('📡 渠道:', style: TextStyle(fontWeight: FontWeight.w600)),
              for (final c in (data['channels'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $c')),
              const SizedBox(height: 8),
            ],
            if (data['process'] != null) ...[
              const Text('📋 流程:', style: TextStyle(fontWeight: FontWeight.w600)),
              for (var i = 0; i < (data['process'] as List).length; i++) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('${i+1}. ${data['process'][i]}')),
              const SizedBox(height: 8),
            ],
            if (data['tips'] != null) ...[
              const Text('💡 贴士:', style: TextStyle(fontWeight: FontWeight.w600)),
              for (final t in (data['tips'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $t')),
            ],
          ]),
        ),
      );
}
