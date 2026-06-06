// 居家环境安全
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class HomeSafetyPage extends StatelessWidget {
  const HomeSafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('🏠 居家环境安全')),
      body: FutureBuilder(
        future: DataLoader.homeSafety(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          // 6 大分类导航
          final groups = [
            {'emoji': '🌿', 'title': '植物安全', 'color': cs.tertiary, 'sub': '有毒植物 / 安全植物', 'items': [
              _plants(ctx, d['toxic_plants'], d['pet_safe_plants']),
            ]},
            {'emoji': '🧪', 'title': '家居化学品', 'color': cs.error, 'sub': '清洁剂/消毒剂/防冻液/药物', 'items': [
              _chemicals(ctx, d['household_chemicals']),
            ]},
            {'emoji': '🍫', 'title': '人用食物速查', 'color': cs.primary, 'sub': '危险食物 / 安全零食', 'items': [
              _foodRecap(ctx, d['human_food_recap']),
            ]},
            {'emoji': '⚠️', 'title': '小物件隐患', 'color': cs.secondary, 'sub': '小电池/针线/绳带/塑料袋', 'items': [
              _smallObjs(d['small_object_hazards']),
            ]},
            {'emoji': '🏠', 'title': '房间分区风险', 'color': cs.tertiary, 'sub': '厨房/卫生间/客厅/卧室/阳台/车库', 'items': [
              _dangers(ctx, d['home_dangers']),
            ]},
            {'emoji': '🌸', 'title': '季节性风险', 'color': cs.primary, 'sub': '春/夏/秋/冬 防护', 'items': [
              _seasonal(ctx, d['seasonal_hazards']),
            ]},
            {'emoji': '✅', 'title': '安全检查清单', 'color': cs.tertiary, 'sub': '接狗前 / 第一周 / 持续维护', 'items': [
              _checklist(ctx, d['safety_checklist']),
            ]},
            {'emoji': '🧰', 'title': '急救包必备', 'color': cs.error, 'sub': '家庭常备 15+ 种', 'items': [
              _firstAidKit(ctx, d['first_aid_kit']),
            ]},
            {'emoji': '🚗', 'title': '出行安全', 'color': cs.secondary, 'sub': '乘车/自驾/飞机/酒店', 'items': [
              _travelSafety(ctx, d['travel_safety']),
            ]},
          ];
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              // 顶部分类导航 (3列按钮)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final g in groups) ActionChip(
                      avatar: Text(g['emoji'] as String, style: const TextStyle(fontSize: 14)),
                      label: Text(g['title'] as String),
                      backgroundColor: (g['color'] as Color).withValues(alpha: 0.12),
                      side: BorderSide(color: (g['color'] as Color).withValues(alpha: 0.4)),
                      onPressed: () {
                        // 滚动到对应 ID - 简化: 不滚动, 只显示
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 16),
              for (var i = 0; i < groups.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  color: (groups[i]['color'] as Color).withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: (groups[i]['color'] as Color).withValues(alpha: 0.3)),
                  ),
                  child: Theme(
                    data: Theme.of(ctx).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: i == 0,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                      leading: Text(groups[i]['emoji'] as String, style: const TextStyle(fontSize: 24)),
                      title: Text(groups[i]['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: groups[i]['color'] as Color)),
                      subtitle: Text(groups[i]['sub'] as String, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                      children: [
                        ...(groups[i]['items'] as List).cast<Widget>().map((w) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: w,
                        )),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _plants(BuildContext context, List toxic, List safe) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('🌿 有毒植物 (致命/严重)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          for (final p in toxic.whereType<Map>())
            ListTile(
              dense: true,
              leading: _severityIcon(context, p['severity']),
              title: Text(p['name_zh'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${p['symptoms']} ${p['note'] != null && p['note'] != "" ? "\n${p['note']}" : ""}'),
              isThreeLine: p['note'] != null && p['note'] != "",
            ),
          const SizedBox(height: 12),
          Text('✅ 安全植物 (可养)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [for (final s in safe.whereType<dynamic>()) Chip(label: Text(s is Map ? (s['name_zh']?.toString() ?? '') : s.toString()))],
          ),
        ]),
      ),
    );
  }

  Widget _severityIcon(BuildContext context, s) {
    final color = s.toString().contains('lethal') ? Theme.of(context).colorScheme.error : s.toString().contains('severe') ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.error;
    return CircleAvatar(backgroundColor: color, radius: 12, child: const Icon(Icons.warning, size: 12, color: Colors.white));
  }

  Widget _chemicals(BuildContext context, d) {
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
                Text('🧪 ${c['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if ((c['danger']?.toString() ?? '').isNotEmpty) Text('⚠️ 危险度: ${c['danger']}', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                if ((c['note']?.toString() ?? '').isNotEmpty) Text('💡 ${c['note']}', style: const TextStyle(fontSize: 12, height: 1.4)),
              ]),
            ),
        ]),
      ),
    );
  }

  Widget _foodRecap(BuildContext context, d) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          for (final f in (d['items'] as List).cast<Map>())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🍫 ${f['food']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                if ((f['danger']?.toString() ?? '').isNotEmpty) Text('  ${f['danger']}', style: const TextStyle(fontSize: 11.5, color: Color(0xFFB71C1C))),
                if ((f['symptom']?.toString() ?? '').isNotEmpty) Text('  症状: ${f['symptom']}', style: const TextStyle(fontSize: 11.5, height: 1.3)),
              ]),
            ),
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
          for (final o in (d['items'] as List).cast<Map>())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('⚠️ ${o['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                if ((o['note']?.toString() ?? '').isNotEmpty) Text('  ${o['note']}', style: const TextStyle(fontSize: 11.5, height: 1.3)),
              ]),
            ),
        ]),
      ),
    );
  }

  Widget _dangers(BuildContext context, d) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'] ?? '家庭环境危险点', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onErrorContainer)),
          const SizedBox(height: 8),
          for (final a in (d['areas'] as List? ?? const []).cast<Map>())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🏠 ${a['area']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('⚠️ 风险: ${(a['risks'] is List ? (a['risks'] as List).join(' / ') : a['risks']?.toString() ?? '')}', style: const TextStyle(fontSize: 12.5, height: 1.4)),
                Text('🔧 修复: ${a['fix'] ?? ''}', style: const TextStyle(fontSize: 12.5, height: 1.4, color: Color(0xFF2E7D32))),
              ]),
            ),
        ]),
      ),
    );
  }

  Widget _seasonal(BuildContext context, d) {
    final cs = Theme.of(context).colorScheme;
    final iconMap = {'summer': ('☀️ 夏天', cs.error), 'winter': ('❄️ 冬天', cs.primary), 'spring': ('🌸 春天', cs.tertiary), 'autumn': ('🍂 秋天', cs.tertiary), 'all_year': ('🗓️ 常年', cs.secondary)};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title'] ?? '🌤️ 季节危险', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final s in (d['seasons'] as List? ?? const []).cast<Map>())
            Builder(builder: (_) {
              final info = iconMap[s['season']] ?? ('🗓️ ${s['season']}', cs.secondary);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(info.$1, style: TextStyle(fontWeight: FontWeight.bold, color: info.$2, fontSize: 14)),
                  Text('⚠️ 风险: ${(s['risks'] is List ? (s['risks'] as List).join(' / ') : s['risks']?.toString() ?? '')}', style: const TextStyle(fontSize: 12.5, height: 1.4)),
                  Text('🔧 修复: ${s['fix'] ?? ''}', style: const TextStyle(fontSize: 12.5, height: 1.4, color: Color(0xFF2E7D32))),
                ]),
              );
            }),
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

  Widget _checklist(BuildContext context, d) {
    final cs = Theme.of(context).colorScheme;
    Widget section(String emoji, String title, dynamic content) {
      final items = content is List ? content.cast<String>() : [content.toString()];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$emoji $title', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: cs.onTertiaryContainer)),
          const SizedBox(height: 4),
          for (final item in items.where((x) => x.isNotEmpty)) Padding(
            padding: const EdgeInsets.only(left: 4, top: 1, bottom: 1),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('☑️ ', style: TextStyle(color: cs.onTertiaryContainer, fontSize: 12)),
              Expanded(child: Text(item, style: TextStyle(fontSize: 12.5, height: 1.4, color: cs.onTertiaryContainer))),
            ]),
          ),
        ]),
      );
    }
    return Card(
      color: cs.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['title']?.toString() ?? '新家养犬安全检查', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.tertiary)),
          const SizedBox(height: 8),
          if (d['before_dog_arrives'] != null) section('🏠', '接狗前准备', d['before_dog_arrives']),
          if (d['first_week'] != null) section('📅', '第一周', d['first_week']),
          if (d['ongoing'] != null) section('🔄', '持续维护', d['ongoing']),
        ]),
      ),
    );
  }
}

  Widget _firstAidKit(BuildContext context, Map<String, dynamic> data) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.errorContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.medical_services_rounded, color: cs.error, size: 18),
            const SizedBox(width: 8),
            Text('🧰 家庭急救包必备', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onErrorContainer)),
          ]),
          const SizedBox(height: 10),
          ...((data['essential_items'] as List?) ?? const []).cast<String>().map((i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('• $i', style: TextStyle(height: 1.4, color: cs.onSurface)),
          )),
          if (data['meds_to_avoid'] != null) ...[
            const SizedBox(height: 12),
            Text('⚠️ 绝对不能给狗吃的人药', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: cs.error)),
            const SizedBox(height: 6),
            ...((data['meds_to_avoid'] as List).cast<String>()).map((i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $i', style: TextStyle(height: 1.4, color: cs.onSurface)),
            )),
          ],
        ]),
      ),
    );
  }

  Widget _travelSafety(BuildContext context, Map<String, dynamic> data) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.tertiaryContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.directions_car_rounded, color: cs.tertiary, size: 18),
            const SizedBox(width: 8),
            Text('🚗 出行安全', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onTertiaryContainer)),
          ]),
          const SizedBox(height: 10),
          ...((data['car_safety'] as List?) ?? const []).cast<String>().map((i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('• $i', style: TextStyle(height: 1.4, color: cs.onSurface)),
          )),
          if (data['heat_death_car'] != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: cs.errorContainer, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Icon(Icons.thermostat, color: cs.error, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('${data['heat_death_car']}', style: TextStyle(color: cs.onErrorContainer, fontSize: 12.5, height: 1.4))),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
