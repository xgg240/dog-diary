// 体型评分 BCS
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class BcsPage extends StatelessWidget {
  const BcsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                color: Theme.of(context).colorScheme.errorContainer,
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
                color: _colorFor(ctx, l['score'] as int).withValues(alpha: 0.15),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _colorFor(ctx, l['score'] as int),
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

  Color _colorFor(BuildContext context, int s) {
    if (s <= 3) return Theme.of(context).colorScheme.error;
    if (s <= 4) return Theme.of(context).colorScheme.error;
    if (s == 5) return Theme.of(context).colorScheme.tertiary;
    if (s <= 6) return Theme.of(context).colorScheme.error;
    return Theme.of(context).colorScheme.error;
  }
}
