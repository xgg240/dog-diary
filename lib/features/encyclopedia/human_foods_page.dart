// 人用食物查询
import 'package:flutter/material.dart';
import 'data_loader.dart';

class HumanFoodsPage extends StatefulWidget {
  const HumanFoodsPage({super.key});
  static Future<List<dynamic>> allFoods() => DataLoader.humanFoods();
  @override
  State<HumanFoodsPage> createState() => _S();
}

class _S extends State<HumanFoodsPage> {
  String _filter = 'all';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🥗 人用食物查询'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '搜索食物 (如: 苹果, 葡萄, 巧克力)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final f in [
              ('all', '全部', null),
              ('safe', '✅ 能吃', Colors.green),
              ('watch', '⚠️ 少量', Colors.amber),
              ('unsafe', '❌ 禁吃', Colors.red),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(f.$2),
                  selected: _filter == f.$1,
                  onSelected: (_) => setState(() => _filter = f.$1),
                ),
              ),
          ]),
        ),
        Expanded(
          child: FutureBuilder(
            future: DataLoader.humanFoods(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              var list = snap.data!;
              if (_query.isNotEmpty) {
                list = list.where((e) => (e['name_zh'] as String).toLowerCase().contains(_query)).toList();
              }
              if (_filter == 'safe') list = list.where((e) => e['safe'] == true).toList();
              if (_filter == 'unsafe') list = list.where((e) => e['safe'] == false).toList();
              if (_filter == 'watch') list = list.where((e) => e['note'].toString().contains('⚠️') || e['note'].toString().contains('少量')).toList();
              if (list.isEmpty) return const Center(child: Text('无结果'));
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final f = list[i];
                  final safe = f['safe'] as bool;
                  return Card(
                    color: safe ? Colors.green.shade50 : Colors.red.shade50,
                    child: ListTile(
                      leading: Text(safe ? '✅' : '❌', style: const TextStyle(fontSize: 24)),
                      title: Text(f['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(f['note']),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
