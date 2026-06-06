// ============================================================
//  禁食食物库
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../db/database.dart';

import '../../core/ui/modern_widgets.dart';
final _forbiddenFoodsProvider = StreamProvider<List<ForbiddenFood>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).forbiddenFoods)
        ..orderBy([(t) => drift.OrderingTerm.asc(t.severity)]))
      .watch();
});

class ForbiddenFoodsPage extends ConsumerStatefulWidget {
  const ForbiddenFoodsPage({super.key});
  @override
  ConsumerState<ForbiddenFoodsPage> createState() => _S();
}

class _S extends ConsumerState<ForbiddenFoodsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final foodsAsync = ref.watch(_forbiddenFoodsProvider);
    return Scaffold(
      appBar: ModernPageHeader(title: '禁食食物库'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '搜索食物...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: foodsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('错误: $e')),
              data: (list) {
                final filtered = _query.isEmpty
                    ? list
                    : list.where((f) =>
                        f.name.toLowerCase().contains(_query) ||
                        (f.nameEn ?? '').toLowerCase().contains(_query) ||
                        f.reason.toLowerCase().contains(_query)).toList();
                if (filtered.isEmpty) return const Center(child: Text('无匹配结果'));
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final f = filtered[i];
                    final sev = _sev(f.severity);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: sev.color.withValues(alpha: 0.2),
                        child: Icon(sev.icon, color: sev.color),
                      ),
                      title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (f.nameEn != null) Text(f.nameEn!, style: const TextStyle(fontSize: 12)),
                          Text(f.reason),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: sev.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: Text(sev.label, style: TextStyle(color: sev.color, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _Sev _sev(String s) {
    switch (s) {
      case 'fatal': return _Sev('致命', Colors.red, Icons.dangerous);
      case 'severe': return _Sev('严重', Colors.orange, Icons.warning);
      default: return _Sev('轻度', Colors.amber, Icons.info);
    }
  }
}

class _Sev {
  final String label;
  final Color color;
  final IconData icon;
  _Sev(this.label, this.color, this.icon);
}
