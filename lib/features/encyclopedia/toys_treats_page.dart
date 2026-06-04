// 玩具/零食评分
import 'package:flutter/material.dart';
import 'data_loader.dart';

class ToysTreatsPage extends StatelessWidget {
  const ToysTreatsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              _toysByCategory(d['toys_by_category']),
              const SizedBox(height: 12),
              _smartToys(d['interactive_toys']),
              const SizedBox(height: 12),
              _treats(d['treats_rating']),
              const SizedBox(height: 12),
              _dangerous(d['dangerous_treats']),
              const SizedBox(height: 12),
              _calorie(d['treat_calorie_guide']),
            ],
          );
        },
      ),
    );
  }

  Widget _toysByCategory(d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final cat in (d['categories'] as List).cast<Map>()) _toyCategory(cat),
        ]),
      ),
    );
  }

  Widget _toyCategory(Map c) {
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
                      Text('💰 ¥${p['price_cny']}', style: const TextStyle(color: Colors.indigo)),
                    ]),
                    if (p['for'] != null) Text('🎯 ${p['for']}', style: const TextStyle(fontSize: 13)),
                    if (p['note'] != null) Text('💡 ${p['note']}', style: const TextStyle(fontSize: 13)),
                  ]),
                ),
              ),
            if (c['warning'] != null) Padding(
              padding: const EdgeInsets.all(4),
              child: Text(c['warning'], style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            if (c['tip'] != null) Padding(
              padding: const EdgeInsets.all(4),
              child: Text('💡 ${c['tip']}', style: const TextStyle(color: Colors.indigo, fontStyle: FontStyle.italic)),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _smartToys(d) {
    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final t in (d['items'] as List).cast<Map>())
            Card(
              child: ListTile(
                leading: const Icon(Icons.smart_toy, color: Colors.indigo),
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

  Widget _treats(d) {
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
                      leading: const Icon(Icons.star, color: Colors.amber),
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

  Widget _dangerous(d) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          for (final s in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(s, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _calorie(d) {
    return Card(
      color: Colors.green.shade50,
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
          Text('💡 ${d['tip']}', style: const TextStyle(color: Colors.indigo, fontStyle: FontStyle.italic)),
        ]),
      ),
    );
  }
}
