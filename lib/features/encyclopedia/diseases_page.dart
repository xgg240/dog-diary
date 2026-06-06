// 疾病库 - 按 category 分组 (60+ 类), 每类内可展开看每种病的治疗/用药
import 'package:flutter/material.dart';
import 'data_loader.dart';

class DiseasesPage extends StatefulWidget {
  const DiseasesPage({super.key});
  @override
  State<DiseasesPage> createState() => _S();
}

class _S extends State<DiseasesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏥 疾病库')),
      body: FutureBuilder(
        future: DataLoader.diseases(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final all = snap.data!;

          // 按 category 分组
          final grouped = <String, List<Map<String, dynamic>>>{};
          for (final d in all) {
            final cat = (d['category'] as String?) ?? '其他';
            grouped.putIfAbsent(cat, () => []).add(d as Map<String, dynamic>);
          }
          // 每组按 urgency 排 (emergency 前面)
          for (final g in grouped.values) {
            g.sort((a, b) {
              final ae = a['urgency'] == 'emergency' ? 0 : 1;
              final be = b['urgency'] == 'emergency' ? 0 : 1;
              return ae.compareTo(be);
            });
          }
          final sortedCats = grouped.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: sortedCats.length,
            itemBuilder: (_, i) {
              final cat = sortedCats[i];
              final items = grouped[cat]!;
              return _CategoryGroup(category: cat, items: items);
            },
          );
        },
      ),
    );
  }
}

class _CategoryGroup extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  const _CategoryGroup({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: items.any((d) => d['urgency'] == 'emergency'),
            tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
            title: Row(children: [
              Icon(_catIcon(category), size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(category, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: cs.onSurface))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(10)),
                child: Text('${items.length}', style: TextStyle(color: cs.onPrimaryContainer, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
            children: [
              for (final d in items) _DiseaseCard(d: d),
            ],
          ),
        ),
      ),
    );
  }

  IconData _catIcon(String cat) {
    if (cat.contains('皮肤')) return Icons.healing_rounded;
    if (cat.contains('消化')) return Icons.restaurant_rounded;
    if (cat.contains('呼吸')) return Icons.air_rounded;
    if (cat.contains('神经')) return Icons.psychology_rounded;
    if (cat.contains('心脏') || cat.contains('心血管')) return Icons.favorite_rounded;
    if (cat.contains('泌尿')) return Icons.water_drop_rounded;
    if (cat.contains('眼')) return Icons.visibility_rounded;
    if (cat.contains('耳')) return Icons.hearing_rounded;
    if (cat.contains('骨骼') || cat.contains('骨科')) return Icons.accessibility_new_rounded;
    if (cat.contains('中毒')) return Icons.warning_amber_rounded;
    if (cat.contains('肿瘤') || cat.contains('癌症')) return Icons.coronavirus_rounded;
    if (cat.contains('寄生虫')) return Icons.bug_report_rounded;
    if (cat.contains('传染')) return Icons.coronavirus_outlined;
    if (cat.contains('代谢') || cat.contains('内分泌')) return Icons.science_rounded;
    if (cat.contains('血液')) return Icons.bloodtype_rounded;
    if (cat.contains('口腔')) return Icons.medical_information_rounded;
    if (cat.contains('免疫')) return Icons.shield_rounded;
    if (cat.contains('行为') || cat.contains('心理')) return Icons.psychology_alt_rounded;
    if (cat.contains('遗传')) return Icons.account_tree_rounded;
    if (cat.contains('老年')) return Icons.elderly_rounded;
    if (cat.contains('创伤')) return Icons.medical_services_rounded;
    if (cat.contains('急症')) return Icons.emergency_rounded;
    if (cat.contains('营养')) return Icons.set_meal_rounded;
    if (cat.contains('蜱')) return Icons.bug_report_outlined;
    return Icons.local_hospital_rounded;
  }
}

class _DiseaseCard extends StatelessWidget {
  final Map<String, dynamic> d;
  const _DiseaseCard({required this.d});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final urgent = d['urgency'] == 'emergency';
    final symptoms = (d['symptoms'] as List<dynamic>?)?.cast<String>() ?? const [];
    final treat = (d['treatment'] as String?) ?? '';
    final isClickable = d['note'] != null || d['mortality'] != null || symptoms.length > 3 || treat.length > 80;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: urgent ? cs.errorContainer.withValues(alpha: 0.35) : cs.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseDetailPage(d: d))),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Flexible(child: Text(d['name_zh'] ?? '', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: cs.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      if (urgent) ...[const SizedBox(width: 6), Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(color: cs.error, borderRadius: BorderRadius.circular(6)),
                        child: Text('急症', style: TextStyle(color: cs.onError, fontSize: 10, fontWeight: FontWeight.w700)),
                      )],
                    ]),
                    const SizedBox(height: 2),
                    Text(d['name_en'] ?? '', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ]),
                ),
                Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant.withValues(alpha: 0.5), size: 18),
              ]),
              if (symptoms.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '症状: ${symptoms.take(3).join(' · ')}${symptoms.length > 3 ? ' 等 ${symptoms.length} 项' : ''}',
                  style: TextStyle(color: cs.onSurface, fontSize: 12, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (treat.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '💊 治疗: $treat',
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.85), fontSize: 11.5, height: 1.4),
                  maxLines: isClickable ? 3 : 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

class DiseaseDetailPage extends StatelessWidget {
  final Map<String, dynamic> d;
  const DiseaseDetailPage({required this.d});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('${d['name_zh']} 详情')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _sec(context, '📋 概述', [d['susceptible']]),
          _sec(context, '🔍 症状', d['symptoms'] as List<dynamic>),
          if (d['transmission'] != null) _sec(context, '🦠 传播', [d['transmission']]),
          _sec(context, '💊 治疗', [d['treatment']]),
          // medication 详细用药
          if (d['medication'] is Map) _medicationBlock(context, d['medication'] as Map),
          _sec(context, '🛡️ 预防', [d['prevention']]),
          Card(
            color: cs.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Icon(Icons.attach_money, color: cs.onTertiaryContainer),
                const SizedBox(width: 8),
                Expanded(child: Text('参考费用: ¥${d['cost_estimate_cny'][0]} - ¥${d['cost_estimate_cny'][1]}', style: TextStyle(color: cs.onTertiaryContainer))),
              ]),
            ),
          ),
          if (d['mortality'] != null) _sec(context, '⚰️ 死亡率', [d['mortality']]),
          if (d['note'] != null) Card(
            color: cs.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('⚠️ ${d['note']}', style: TextStyle(color: cs.onErrorContainer)),
            ),
          ),
        ],
      ),
    );
  }


  Widget _medicationBlock(BuildContext context, Map m) {
    final cs = Theme.of(context).colorScheme;
    Widget row(String emoji, String title, dynamic content, Color color) {
      final items = content is List ? content.cast<String>() : (content?.toString().isNotEmpty == true ? [content.toString()] : <String>[]);
      if (items.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$emoji $title', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: color)),
          const SizedBox(height: 4),
          for (final item in items.where((x) => x.isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(left: 6, top: 2, bottom: 2),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('• ', style: TextStyle(color: color, fontSize: 13, height: 1.5)),
                Expanded(child: Text(item, style: TextStyle(height: 1.5, fontSize: 12.5, color: cs.onSurface))),
              ]),
            ),
        ]),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.medication_rounded, color: cs.error, size: 18),
            const SizedBox(width: 6),
            Text('💊 用药详细说明', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
          ]),
          const SizedBox(height: 8),
          row('🐕', '狗用兽药', m['dog_meds'], cs.primary),
          row('👤', '✅ 人用可代替 (咨询兽医)', m['safe_human'], cs.tertiary),
          row('❌', '禁用人药', m['unsafe_human'], cs.error),
          row('🏥', '兽医专用', m['vet_only'], cs.error),
        ]),
      ),
    );
  }

  Widget _sec(BuildContext context, String t, List<dynamic> items) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
          const SizedBox(height: 8),
          for (final i in items) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• $i', style: TextStyle(height: 1.4, color: cs.onSurface))),
        ]),
      ),
    );
  }
}
