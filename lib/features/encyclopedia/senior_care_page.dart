// 老年犬护理
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class SeniorCarePage extends StatelessWidget {
  const SeniorCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('🧓 老年犬护理')),
      body: FutureBuilder(
        future: DataLoader.seniorCare(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _ageThreshold(context, d['age_threshold']),
              const SizedBox(height: 12),
              _healthCheckup(context, d['health_checkup']),
              const SizedBox(height: 12),
              _diseases(context, d['common_diseases']),
              const SizedBox(height: 12),
              _endOfLife(context, d['end_of_life']),
              const SizedBox(height: 12),
              _lifestyle(d['lifestyle_adjustments']),
            ],
          );
        },
      ),
    );
  }

  Widget _ageThreshold(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final e in (d['by_size'] as Map).entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('🐕 ${e.key}: ${e.value}'),
            ),
        ]),
      ),
    );
  }

  Widget _healthCheckup(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 4),
          Text('📅 ${d['frequency']}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final i in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i)),
        ]),
      ),
    );
  }

  Widget _diseases(BuildContext context, List? list) {
    if (list == null) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text('🏥 老年犬常见病', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      for (final m in list.cast<Map<String, dynamic>>()) _diseaseCard(context, m),
    ]);
  }

  Widget _diseaseCard(BuildContext context, Map<String, dynamic> m) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: Text(m['icon'], style: const TextStyle(fontSize: 24)),
        title: Text(m['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('📊 ${m['prevalence']}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (m['symptoms'] != null) ...[
                Text('🔍 症状', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
                for (final s in (m['symptoms'] as List).cast<String>())
                  Text('• $s'),
                const SizedBox(height: 8),
              ],
              if (m['symptoms_disorientation'] != null) ...[
                Text('🔍 主要症状', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
                for (final s in (m['symptoms_disorientation'] as List).cast<String>())
                  Text('• $s'),
                const SizedBox(height: 8),
              ],
              if (m['symptoms_sleep_changes'] != null) ...[
                Text('😴 睡眠', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                for (final s in (m['symptoms_sleep_changes'] as List).cast<String>())
                  Text('• $s'),
                const SizedBox(height: 8),
              ],
              if (m['symptoms_house_soiling'] != null) ...[
                const Text('🚽 排泄', style: TextStyle(fontWeight: FontWeight.bold, )),
                for (final s in (m['symptoms_house_soiling'] as List).cast<String>())
                  Text('• $s'),
                const SizedBox(height: 8),
              ],
              if (m['symptoms_interaction_changes'] != null) ...[
                Text('💕 互动', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
                for (final s in (m['symptoms_interaction_changes'] as List).cast<String>())
                  Text('• $s'),
                const SizedBox(height: 8),
              ],
              if (m['symptoms_anxiety'] != null) ...[
                Text('😰 焦虑', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
                for (final s in (m['symptoms_anxiety'] as List).cast<String>())
                  Text('• $s'),
                const SizedBox(height: 8),
              ],
              if (m['management'] != null) ...[
                Text('💊 治疗/管理', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
                for (final s in (m['management'] as List).cast<String>())
                  Text('• $s'),
                const SizedBox(height: 8),
              ],
              if (m['warning'] != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer, borderRadius: BorderRadius.circular(4)),
                  child: Text(m['warning'], style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold)),
                ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _endOfLife(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
          const SizedBox(height: 8),
          const Text('🩺 临终关怀', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final i in (d['hospice_care'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i)),
          const SizedBox(height: 8),
          const Text('📊 生活质量评分 (HHHHHMM)', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final i in (d['quality_of_life_scale']['items'] as List).cast<String>())
            Text('• $i'),
          Text('🎯 ${d['quality_of_life_scale']['threshold']}', style: TextStyle(color: Theme.of(context).colorScheme.error, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          const Text('🕊️ 安乐死决策', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final i in (d['euthanasia_decision']['considerations'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i)),
          const SizedBox(height: 4),
          const Text('流程:', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final i in (d['euthanasia_decision']['process'] as List).cast<String>())
            Text(i, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          const Text('💔 主人悲伤', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final i in (d['grief_support']['items'] as List).cast<String>())
            Text('• $i'),
        ]),
      ),
    );
  }

  Widget _lifestyle(d) {
    if (d == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final i in (d['items'] as List).cast<String>())
            Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i)),
        ]),
      ),
    );
  }
}
