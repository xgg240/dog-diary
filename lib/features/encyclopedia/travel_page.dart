// 出行/托运/检疫
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class TravelPage extends StatelessWidget {
  const TravelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('✈️ 出行/托运/检疫')),
      body: FutureBuilder(
        future: DataLoader.travel(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _domestic(context, d['domestic_travel']),
              const SizedBox(height: 12),
              _international(context, d['international_travel']),
              const SizedBox(height: 12),
              _docs(context, d['documents_checklist']),
              const SizedBox(height: 12),
              _cage(context, d['airline_cage']),
              const SizedBox(height: 12),
              _cityWalk(context, d['city_walk']),
              const SizedBox(height: 12),
              _boarding(context, d['boarding']),
              const SizedBox(height: 12),
              _weather(context, d['weather_quick']),
            ],
          );
        },
      ),
    );
  }

  Widget _domestic(BuildContext context, d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final m in (d['methods'] as List).cast<Map>()) _travelMethod(context, m),
        ]),
      ),
    );
  }

  Widget _travelMethod(BuildContext context, Map m) {
    return ExpansionTile(
      title: Text(m['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📋 规则', style: TextStyle(fontWeight: FontWeight.bold)),
            for (final r in (m['rules'] as List).cast<String>())
              Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text(r, style: const TextStyle(fontSize: 13))),
            if (m['process'] != null) ...[
              const SizedBox(height: 4),
              const Text('流程', style: TextStyle(fontWeight: FontWeight.bold)),
              for (final p in (m['process'] as List).cast<String>())
                Text(p, style: const TextStyle(fontSize: 13)),
            ],
            if (m['car_sickness'] != null) ...[
              const SizedBox(height: 4),
              Text('🤢 晕车', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
              for (final s in (m['car_sickness'] as List).cast<String>())
                Text('• $s', style: const TextStyle(fontSize: 13)),
            ],
          ]),
        ),
      ],
    );
  }

  Widget _international(BuildContext context, d) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('🔄 一般流程', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final p in (d['general_process'] as List).cast<String>())
            Text(p, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          const Text('🌏 主要目的地要求', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final c in (d['by_destination'] as List).cast<Map>())
            ExpansionTile(
              title: Text(c['country'], style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    for (final r in (c['requirements'] as List).cast<String>())
                      Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $r', style: const TextStyle(fontSize: 13))),
                    if (c['warning'] != null)
                      Padding(padding: const EdgeInsets.all(4), child: Text(c['warning'], style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold))),
                  ]),
                ),
              ],
            ),
          const SizedBox(height: 4),
          for (final w in [d['warning']]) Text(w, style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _docs(BuildContext context, d) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final i in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _cage(BuildContext context, d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('📐 选尺寸: ${d['size_rule']}'),
          const SizedBox(height: 8),
          for (final s in (d['common_sizes'] as List).cast<Map>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• ${s['for']}: ${s['size']}')),
          const SizedBox(height: 8),
          const Text('✅ 必备:', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final m in (d['must_have'] as List).cast<String>())
            Text(m, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          const Text('🏆 推荐品牌:', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final b in (d['brand_picks'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $b', style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _cityWalk(BuildContext context, d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final t in (d['tips'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(t, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _boarding(BuildContext context, d) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final o in (d['options'] as List).cast<Map>())
            ExpansionTile(
              title: Text(o['type'], style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (o['pros'] != null) Text('✅ 优点', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
                    if (o['pros'] != null) for (final p in (o['pros'] as List).cast<String>()) Text('• $p', style: const TextStyle(fontSize: 13)),
                    if (o['cons'] != null) const SizedBox(height: 4),
                    if (o['cons'] != null) Text('❌ 缺点', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
                    if (o['cons'] != null) for (final c in (o['cons'] as List).cast<String>()) Text('• $c', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
                    if (o['tips'] != null) const SizedBox(height: 4),
                    if (o['tips'] != null) const Text('💡 提示', style: TextStyle(fontWeight: FontWeight.bold)),
                    if (o['tips'] != null) for (final t in (o['tips'] as List).cast<String>()) Text('• $t', style: const TextStyle(fontSize: 13)),
                    if (o['platforms'] != null) const SizedBox(height: 4),
                    if (o['platforms'] != null) const Text('🌐 平台', style: TextStyle(fontWeight: FontWeight.bold)),
                    if (o['platforms'] != null) for (final p in (o['platforms'] as List).cast<String>()) Text('• $p', style: const TextStyle(fontSize: 13)),
                  ]),
                ),
              ],
            ),
          const SizedBox(height: 8),
          const Text('📋 寄养清单:', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final c in (d['checklist'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text(c, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _weather(BuildContext context, d) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final i in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }
}
