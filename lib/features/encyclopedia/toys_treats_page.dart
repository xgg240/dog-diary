// 玩具/零食评分
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class ToysTreatsPage extends StatelessWidget {
  const ToysTreatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('🧸 玩具/零食评分')),
      body: FutureBuilder(
        future: DataLoader.toysTreats(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _toysByCategory(context, d['toys_by_category']),
              const SizedBox(height: 12),
              _smartToys(context, d['interactive_toys']),
              const SizedBox(height: 12),
              _treats(context, d['treats_rating']),
              const SizedBox(height: 12),
              _dangerous(context, d['dangerous_treats']),
              const SizedBox(height: 12),
              _calorie(context, d['treat_calorie_guide']),
            ],
          );
        },
      ),
    );
  }

  Widget _toysByCategory(BuildContext context, d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final cat in (d['categories'] as List).cast<Map>()) _toyCategory(context, cat),
        ]),
      ),
    );
  }

  Widget _toyCategory(BuildContext context, Map c) {
    return ExpansionTile(
      title: Text(c['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('适用: ${c['best_for']}'),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final p in (c['top_picks'] as List).cast<Map>())
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text('⭐${p['rating']} ${p['brand']} - ${p['model']}', style: const TextStyle(fontWeight: FontWeight.bold))),
                      Text('💰 ¥${p['price_cny']}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    ]),
                    if (p['for'] != null) Text('🎯 ${p['for']}', style: const TextStyle(fontSize: 13)),
                    if (p['note'] != null) Text('💡 ${p['note']}', style: const TextStyle(fontSize: 13)),
                  ]),
                ),
              ),
            if (c['warning'] != null) Padding(
              padding: const EdgeInsets.all(4),
              child: Text(c['warning'], style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold)),
            ),
            if (c['tip'] != null) Padding(
              padding: const EdgeInsets.all(4),
              child: Text('💡 ${c['tip']}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontStyle: FontStyle.italic)),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _smartToys(BuildContext context, d) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final t in (d['items'] as List).cast<Map>())
            Card(
              child: ListTile(
                leading: Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.primary),
                title: Text('⭐${t['rating']} ${t['brand']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${t['type']}  💰${t['price_cny']}'),
                  if (t['for'] != null) Text('🎯 ${t['for']}', style: const TextStyle(fontSize: 12)),
                ]),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _treats(BuildContext context, d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final c in (d['categories'] as List).cast<Map>())
            ExpansionTile(
              title: Text(c['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                for (final p in (c['top_picks'] as List).cast<Map>())
                  Card(
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.star, color: Theme.of(context).colorScheme.error),
                      title: Text('⭐${p['rating']} ${p['brand']} - ${p['model']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('💰${p['price_cny']}'),
                        if (p['note'] != null) Text('💡 ${p['note']}', style: const TextStyle(fontSize: 12)),
                      ]),
                    ),
                  ),
              ],
            ),
        ]),
      ),
    );
  }

  Widget _dangerous(BuildContext context, d) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          for (final s in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(s, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _calorie(BuildContext context, d) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('📐 原则: ${d['rule']}'),
          const SizedBox(height: 8),
          const Text('🍪 常见零食热量:', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final c in (d['calories_per_piece'] as List).cast<Map>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• ${c['item']}: ${c['cal']}', style: const TextStyle(fontSize: 13))),
          const SizedBox(height: 4),
          Text('💡 ${d['tip']}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontStyle: FontStyle.italic)),
        ]),
      ),
    );
  }
}
