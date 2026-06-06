// 症状自查 - 按 urgency 分组 (急症/紧急/中度/观察/常规), 每组可展开
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});
  static Future<List<dynamic>> allSymptoms() => DataLoader.symptoms();
  @override
  State<SymptomsPage> createState() => _S();
}

class _S extends State<SymptomsPage> {
  String _query = '';
  String? _urgency;

  static const _groupOrder = [
    ('emergency', '🚨 急症 - 立即送医', 'error'),
    ('urgent', '🟠 紧急 - 数小时内送医', 'error'),
    ('severe', '🔴 严重 - 24h 内就医', 'tertiary'),
    ('moderate', '🟡 中度 - 持续观察', 'primary'),
    ('watch', '👀 观察 - 不必立即就医', 'secondary'),
    ('routine', '🟢 常规护理', 'tertiary'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('🤒 症状自查')),
      body: FutureBuilder(
        future: DataLoader.symptoms(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final all = snap.data!;
          var list = all.where((s) {
            if (_query.isNotEmpty && !(s['name_zh'] as String).toLowerCase().contains(_query.toLowerCase())) return false;
            if (_urgency != null && s['urgency'] != _urgency) return false;
            return true;
          }).toList();
          // 按 urgency 分组
          final groups = <String, List<dynamic>>{};
          for (final s in list) {
            final u = s['urgency'] as String? ?? 'other';
            groups.putIfAbsent(u, () => []).add(s);
          }
          if (list.isEmpty) {
            return Center(child: Text('没有匹配结果', style: TextStyle(color: cs.onSurfaceVariant)));
          }
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: '搜索: 呕吐/腹泻/抽搐/跛行...',
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixText: '${list.length}/${all.length}',
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(children: [
                for (final g in [
                  (null, '全部', null),
                  ..._groupOrder,
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(g.$2),
                      selected: _urgency == g.$1,
                      onSelected: (_) => setState(() => _urgency = g.$1),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  for (final g in _groupOrder.where((g) => groups[g.$1] != null))
                    _SymptomGroup(urgency: g.$1, label: g.$2, tone: g.$3, items: groups[g.$1]!),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _SymptomGroup extends StatelessWidget {
  final String urgency;
  final String label;
  final String tone;
  final List<dynamic> items;
  const _SymptomGroup({required this.urgency, required this.label, required this.tone, required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color accent = cs.primary;
    switch (tone) {
      case 'error': accent = cs.error; break;
      case 'tertiary': accent = cs.tertiary; break;
      case 'primary': accent = cs.primary; break;
      case 'secondary': accent = cs.secondary; break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: urgency == 'emergency' || urgency == 'urgent',
            tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
            title: Row(children: [
              Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: cs.onSurface))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10)),
                child: Text('${items.length}', style: TextStyle(color: cs.surface, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
            children: [for (final s in items) _SymptomCard(s: s)],
          ),
        ),
      ),
    );
  }
}

class _SymptomCard extends StatelessWidget {
  final Map<String, dynamic> s;
  const _SymptomCard({required this.s});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final urgent = s['urgency'] == 'emergency' || s['urgency'] == 'urgent';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: urgent ? cs.errorContainer.withValues(alpha: 0.35) : cs.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SymptomDetailPage(symptom: s))),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: cs.surfaceContainerHighest, shape: BoxShape.circle),
                child: Center(child: Text(s['icon'] ?? '⚠️', style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Flexible(child: Text(s['name_zh'] ?? '', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: cs.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ]),
                  const SizedBox(height: 2),
                  Text(urgent ? '🚨 急症 - 立即送医' : '⚠️ 观察 - 见详情', style: TextStyle(color: urgent ? cs.error : cs.onSurfaceVariant, fontSize: 11.5)),
                ]),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant.withValues(alpha: 0.5), size: 18),
            ]),
          ),
        ),
      ),
    );
  }
}

class SymptomDetailPage extends StatelessWidget {
  final Map<String, dynamic> symptom;
  const SymptomDetailPage({super.key, required this.symptom});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final urgent = symptom['urgency'] == 'emergency';
    return Scaffold(
      appBar: AppBar(
        title: Text('${symptom['icon']} ${symptom['name_zh']}'),
        backgroundColor: urgent ? cs.errorContainer : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (urgent) _emergencyBanner(context),
          if (!urgent) _watchBanner(context),
          _section(context, '🔍 可能原因', symptom['possible_causes'] as List<dynamic>),
          _section(context, '🏠 居家护理', [symptom['home_care']]),
          _section(context, '🚑 何时送医', [symptom['vet_urgent']]),
          if ((symptom['red_flags'] as List).isNotEmpty)
            Card(
              color: cs.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🚨 高危信号', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.error)),
                  const SizedBox(height: 8),
                  Text(symptom['red_flags'].join(' · '), style: TextStyle(color: cs.onErrorContainer)),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _emergencyBanner(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.error,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Icon(Icons.emergency_rounded, color: cs.onError, size: 24),
          const SizedBox(width: 10),
          Expanded(child: Text('🚨 这是急症症状 - 立即送医!', style: TextStyle(color: cs.onError, fontWeight: FontWeight.w700, fontSize: 14))),
        ]),
      ),
    );
  }

  Widget _watchBanner(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Icon(Icons.visibility_rounded, color: cs.onTertiaryContainer, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text('⚠️ 密切观察 - 如恶化立即送医', style: TextStyle(color: cs.onTertiaryContainer, fontWeight: FontWeight.w600, fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _section(BuildContext context, String t, List<dynamic> items) {
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
