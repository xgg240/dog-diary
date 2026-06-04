// 训练动作库
import 'package:flutter/material.dart';
import 'data_loader.dart';

class TrainingLibraryPage extends StatelessWidget {
  const TrainingLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎓 训练动作库')),
      body: FutureBuilder(
        future: DataLoader.tricks(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final t = list[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: _diffColor(t['difficulty']).withValues(alpha: 0.2), child: Icon(Icons.school, color: _diffColor(t['difficulty']))),
                  title: Text('${t['name_zh']} (${t['name_en']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${t['category']} · ${_diffLabel(t['difficulty'])} · ${t['duration_min']}分钟'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => _Detail(t: t))),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _diffColor(String d) => switch (d) { 'beginner' => Colors.green, 'intermediate' => Colors.orange, 'advanced' => Colors.red, _ => Colors.grey };
  String _diffLabel(String d) => switch (d) { 'beginner' => '入门', 'intermediate' => '中级', 'advanced' => '高级', _ => d };
}

class _Detail extends StatelessWidget {
  final Map<String, dynamic> t;
  const _Detail({required this.t});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${t['name_zh']}')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t['name_zh'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(t['name_en'], style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Text('⏱️ 训练时长: ${t['duration_min']} 分钟/次'),
              ]),
            ),
          ),
          _sec('📝 步骤', (t['steps'] as List<dynamic>).asMap().entries.map((e) => '${e.key + 1}. ${e.value}').toList()),
          if ((t['common_mistakes'] as List).isNotEmpty) _sec('❌ 常见错误', (t['common_mistakes'] as List<dynamic>).map((e) => '• $e').toList()),
          if (t['tips'] != null) Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('💡 小贴士', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(t['tips']),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sec(String t, List<String> items) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final i in items) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: const TextStyle(height: 1.4))),
          ]),
        ),
      );
}
