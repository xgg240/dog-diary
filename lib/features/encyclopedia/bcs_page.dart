// 体型评分 BCS
import 'package:flutter/material.dart';
import 'data_loader.dart';

class BcsPage extends StatelessWidget {
  const BcsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚖️ 体型评分 BCS')),
      body: FutureBuilder(
        future: DataLoader.bcsLevels(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                color: Colors.amber.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('如何判断？', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Text('1. 双手轻按肋骨: 能数得清 = 偏瘦; 摸得到但有肉 = 理想; 摸不到 = 偏胖'),
                    SizedBox(height: 4),
                    Text('2. 从上看: 腰线明显收 = 理想; 直筒/梨形 = 偏胖'),
                    SizedBox(height: 4),
                    Text('3. 侧面看腹部: 收起 = 理想; 平/鼓 = 偏胖'),
                  ]),
                ),
              ),
              const SizedBox(height: 8),
              for (final l in list) Card(
                color: _colorFor(l['score'] as int).withValues(alpha: 0.15),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _colorFor(l['score'] as int),
                    child: Text('${l['score']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(l['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${l['description']}\n💡 ${l['action']}'),
                  isThreeLine: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _colorFor(int s) {
    if (s <= 3) return Colors.red;
    if (s <= 4) return Colors.orange;
    if (s == 5) return Colors.green;
    if (s <= 6) return Colors.amber;
    return Colors.red;
  }
}
