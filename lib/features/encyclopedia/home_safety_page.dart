// 居家环境安全
import 'package:flutter/material.dart';
import 'data_loader.dart';

class HomeSafetyPage extends StatelessWidget {
  const HomeSafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏠 居家环境安全')),
      body: FutureBuilder(
        future: DataLoader.homeSafety(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _plants(d['toxic_plants'], d['pet_safe_plants']),
              const SizedBox(height: 12),
              _chemicals(d['household_chemicals']),
              const SizedBox(height: 12),
              _foodRecap(d['human_food_recap']),
              const SizedBox(height: 12),
              _smallObjs(d['small_object_hazards']),
              const SizedBox(height: 12),
              _dangers(d['home_dangers']),
              const SizedBox(height: 12),
              _seasonal(d['seasonal_hazards']),
              const SizedBox(height: 12),
              _checklist(d['safety_checklist']),
            ],
          );
        },
      ),
    );
  }

  Widget _plants(List toxic, List safe) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🌿 有毒植物 (致命/严重)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          for (final p in toxic.cast<Map>())
            ListTile(
              dense: true,
              leading: _severityIcon(p['severity']),
              title: Text(p['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${p['symptoms']} ${p['note'] != null && p['note'] != "" ? "\n${p['note']}" : ""}'),
              isThreeLine: p['note'] != null && p['note'] != "",
            ),
          const SizedBox(height: 12),
          const Text('✅ 安全植物 (可养)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [for (final s in safe.cast<String>()) Chip(label: Text(s))],
          ),
        ]),
      ),
    );
  }

  Widget _severityIcon(s) {
    final color = s.toString().contains('lethal') ? Colors.red : s.toString().contains('severe') ? Colors.orange : Colors.amber;
    return CircleAvatar(backgroundColor: color, radius: 12, child: const Icon(Icons.warning, size: 12, color: Colors.white));
  }

  Widget _chemicals(d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final c in (d['items'] as List).cast<Map>())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🧪 ${c['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('⚠️ 风险: ${c['risk']}', style: const TextStyle(color: Colors.red, fontSize: 13)),
                Text('💡 ${c['tip']}', style: const TextStyle(fontSize: 13)),
              ]),
            ),
        ]),
      ),
    );
  }

  Widget _foodRecap(d) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          for (final f in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(f, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _smallObjs(d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final o in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• $o', style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _dangers(d) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final h in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(h, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _seasonal(d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🌤️ 季节危险', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _season('☀️ 夏天', d['summer'], Colors.orange),
          _season('❄️ 冬天', d['winter'], Colors.blue),
          _season('🌸 春天', d['spring'], Colors.pink),
          _season('🍂 秋天', d['autumn'], Colors.brown),
        ]),
      ),
    );
  }

  Widget _season(String title, List items, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        for (final s in items.cast<String>()) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $s', style: const TextStyle(fontSize: 13))),
      ]),
    );
  }

  Widget _checklist(d) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 8),
          for (final c in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(c, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }
}
