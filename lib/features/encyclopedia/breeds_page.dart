// 品种百科
import 'package:flutter/material.dart';
import 'data_loader.dart';

class BreedsPage extends StatelessWidget {
  const BreedsPage({super.key});
  static Future<List<dynamic>> allBreeds() => DataLoader.breeds();

  Color _sizeColor(String? s) {
    switch (s) {
      case 'toy':
        return Colors.pink;
      case 'small':
        return Colors.orange;
      case 'medium':
        return Colors.green;
      case 'large':
        return Colors.blue;
      case 'giant':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  String _sizeIcon(String? s) {
    switch (s) {
      case 'toy':
        return '🧸';
      case 'small':
        return '🐕';
      case 'medium':
        return '🐶';
      case 'large':
        return '🦮';
      case 'giant':
        return '🐕‍🦺';
      default:
        return '🐾';
    }
  }

  String _sizeLabel(String? s) {
    switch (s) {
      case 'toy':
        return '玩赏犬';
      case 'small':
        return '小型';
      case 'medium':
        return '中型';
      case 'large':
        return '大型';
      case 'giant':
        return '巨型';
      default:
        return s ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🐶 品种百科')),
      body: FutureBuilder(
        future: DataLoader.breeds(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final b = list[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: _sizeColor(b['size']).withValues(alpha: 0.2), child: Text(_sizeIcon(b['size']), style: const TextStyle(fontSize: 24))),
                  title: Text(b['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${b['name_en']} · ${_sizeLabel(b['size'])} · 寿命 ${b['lifespan_years']}年'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => BreedDetailPage(breed: b))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BreedDetailPage extends StatelessWidget {
  final Map<String, dynamic> breed;
  const BreedDetailPage({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breed['name_zh'])),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: _sizeColor(breed['size']).withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(_sizeIcon(breed['size']), style: const TextStyle(fontSize: 48)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(breed['name_zh'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(breed['name_en'], style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(height: 4),
                      Text('📍 起源: ${breed['origin']}'),
                    ]),
                  ),
                ]),
                const SizedBox(height: 12),
                Text(breed['personality'], style: const TextStyle(fontSize: 14, height: 1.5)),
              ]),
            ),
          ),
          _statsCard(),
          _healthCard(),
          _careCard(),
        ],
      ),
    );
  }

  Widget _statsCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📊 基本数据', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _row('体型', _sizeLabel(breed['size'])),
            _row('体重', '${breed['weight_kg'][0]}-${breed['weight_kg'][1]} kg'),
            _row('体高', '${breed['height_cm'][0]}-${breed['height_cm'][1]} cm'),
            _row('寿命', '${breed['lifespan_years'][0]}-${breed['lifespan_years'][1]} 年'),
            _row('运动需求', '${breed['exercise_min']} 分钟/天'),
            _row('美容频率', _groomingLabel(breed['grooming'])),
            _row('掉毛', _sheddingLabel(breed['shedding'])),
            _row('吠叫', _barkLabel(breed['bark_tendency'])),
            _row('能量', _energyLabel(breed['energy'])),
            _row('可训练性', _trainLabel(breed['trainability'])),
          ]),
        ),
      );

  Widget _healthCard() {
    final list = breed['common_health'] as List<dynamic>;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🏥 常见健康问题', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 4, children: [
            for (final h in list) Chip(label: Text(h, style: const TextStyle(fontSize: 11)), backgroundColor: Colors.red.shade50),
          ]),
        ]),
      ),
    );
  }

  Widget _careCard() {
    final apt = breed['apartment_friendly'] as bool;
    final kid = breed['kid_friendly'] as bool;
    final beg = breed['beginner_friendly'] as bool;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('👨‍👩‍👧 适合度', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _row('公寓饲养', apt ? '✅ 适合' : '❌ 不适合'),
          _row('儿童家庭', kid ? '✅ 友好' : '⚠️ 谨慎'),
          _row('新手主人', beg ? '✅ 推荐' : '⚠️ 需经验'),
        ]),
      ),
    );
  }

  Widget _row(String k, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
        SizedBox(width: 80, child: Text(k, style: TextStyle(color: Colors.grey.shade700))),
        Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w500))),
      ]));

  String _sizeLabel(String s) => switch (s) { 'toy' => '玩具犬', 'small' => '小型犬', 'medium' => '中型犬', 'large' => '大型犬', 'giant' => '巨型犬', _ => s };
  String _sizeIcon(String s) => switch (s) { 'toy' => '🐹', 'small' => '🐶', 'medium' => '🐕', 'large' => '🦮', 'giant' => '🐎', _ => '🐶' };
  Color _sizeColor(String s) => switch (s) { 'toy' => Colors.pink, 'small' => Colors.orange, 'medium' => Colors.blue, 'large' => Colors.indigo, 'giant' => Colors.deepPurple, _ => Colors.grey };
  String _groomingLabel(String s) => switch (s) { 'daily' => '每天', 'weekly' => '每周', 'monthly' => '每月', _ => s };
  String _sheddingLabel(String s) => switch (s) { 'low' => '少', 'medium' => '中等', 'high' => '多', 'very_high' => '非常多', _ => s };
  String _barkLabel(String s) => switch (s) { 'low' => '安静', 'medium' => '一般', 'high' => '爱叫', 'very_high' => '非常爱叫', _ => s };
  String _energyLabel(String s) => switch (s) { 'low' => '低', 'medium' => '中', 'high' => '高', 'very_high' => '极高', _ => s };
  String _trainLabel(String s) => switch (s) { 'low' => '难训', 'medium' => '一般', 'high' => '好训', 'very_high' => '极好训', _ => s };
}
