// 绝育助手
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class SpayNeuterPage extends StatelessWidget {
  const SpayNeuterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('✂️ 绝育决策助手')),
      body: FutureBuilder(
        future: DataLoader.spay(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!['guide'];
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(color: Theme.of(context).colorScheme.errorContainer, child: Padding(padding: const EdgeInsets.all(12), child: Text(d['summary']))),
              const SizedBox(height: 8),
              _section(context, '🐩 母犬 (Female)', d['female_dog']),
              _section(context, '🐕 公犬 (Male)', d['male_dog']),
              _section(context, '⚠️ 隐睾', d['cryptorchid']),
              const SizedBox(height: 8),
              _surgicalTechniques(context, d['surgical_techniques']),
              const SizedBox(height: 8),
              _behaviorTimeline(context, d['behavioral_changes_timeline']),
            ],
          );
        },
      ),
    );
  }

  Widget _section(BuildContext context, String t, Map<String, dynamic> data) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (data['recommended_age_months'] is Map) ...[
              const Text('推荐绝育月龄:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Wrap(spacing: 6, children: [
                for (final e in (data['recommended_age_months'] as Map).entries) Chip(label: Text('${e.key}: ${(e.value as List).join('-')}月')),
              ]),
              const SizedBox(height: 8),
            ],
            if (data['benefits'] is List) ...[
              Text('✅ 好处:', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.tertiary)),
              for (final b in (data['benefits'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $b')),
              const SizedBox(height: 6),
            ],
            if (data['risks'] is List) ...[
              Text('⚠️ 风险:', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.error)),
              for (final r in (data['risks'] as List<dynamic>)) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $r')),
              const SizedBox(height: 6),
            ],
            if (data['cost_estimate_cny'] is List) Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('💰 参考费用: ¥${(data['cost_estimate_cny'] as List).join('-')}', style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            if (data['note'] != null) Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('💡 ${data['note']}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic)),
            ),
          ]),
        ),
      );
}

  Widget _surgicalTechniques(BuildContext context, Map<String, dynamic> data) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.tertiaryContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data['title'] ?? '🔪 术式选择', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onTertiaryContainer)),
          const SizedBox(height: 8),
          for (final m in (data['methods'] as List? ?? const []).cast<Map>())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🔪 ${m['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text('📋 ${m['description'] ?? ''}', style: const TextStyle(fontSize: 12.5, height: 1.4)),
                if (m['pros'] is List) Text('✅ 优点: ${(m['pros'] as List).join(' / ')}', style: const TextStyle(fontSize: 12, height: 1.4)),
                if (m['cons'] is List) Text('❌ 缺点: ${(m['cons'] as List).join(' / ')}', style: const TextStyle(fontSize: 12, height: 1.4)),
                Text('🎯 适合: ${m['best_for'] ?? ''}', style: const TextStyle(fontSize: 12, color: Color(0xFF1565C0))),
              ]),
            ),
        ]),
      ),
    );
  }

  Widget _behaviorTimeline(BuildContext context, Map<String, dynamic> data) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.primaryContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data['title'] ?? '⏰ 绝育后行为变化', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onPrimaryContainer)),
          const SizedBox(height: 8),
          for (final p in (data['phases'] as List? ?? const []).cast<Map>())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(8)),
                  child: Text(p['stage'] ?? '', style: TextStyle(color: cs.onPrimary, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(p['behavior'] ?? '', style: const TextStyle(fontSize: 13, height: 1.4))),
              ]),
            ),
        ]),
      ),
    );
  }
