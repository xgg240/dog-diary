// 训练动作库 - 按 category 分组 (8 大类) + 搜索
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';

class TrainingLibraryPage extends StatefulWidget {
  const TrainingLibraryPage({super.key});
  static Future<List<dynamic>> allTricks() => DataLoader.tricks();
  @override
  State<TrainingLibraryPage> createState() => _S();
}

class _S extends State<TrainingLibraryPage> {
  String _query = '';
  String? _catFilter;
  String? _diffFilter;

  static const _catMap = {
    '基础': ('🎯', '基础服从', 'beginner'),
    '基础服从': ('🎯', '基础服从', 'beginner'),
    '出门': ('🚪', '出门技能', 'beginner'),
    '礼仪': ('🙏', '日常礼仪', 'beginner'),
    '生活': ('🏠', '生活技能', 'beginner'),
    '安全': ('🛡️', '安全防护', 'beginner'),
    '才艺': ('🎭', '才艺展示', 'intermediate'),
    '技巧': ('🪄', '炫酷技巧', 'intermediate'),
    '脑力': ('🧠', '脑力开发', 'intermediate'),
    '高级技能': ('🏆', '高级技能', 'advanced'),
    '高级': ('🏆', '高级技能', 'advanced'),
    '纠正行为': ('🔧', '行为纠正', 'intermediate'),
    '纠正': ('🔧', '行为纠正', 'intermediate'),
    '社交训练': ('👥', '社交训练', 'beginner'),
    '社交': ('👥', '社交训练', 'beginner'),
    '特殊技能': ('⭐', '特殊技能', 'advanced'),
    '互动': ('🤝', '互动游戏', 'beginner'),
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('🎓 训练动作库')),
      body: FutureBuilder(
        future: DataLoader.tricks(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final all = snap.data!;
          var list = all.where((t) {
            if (_query.isNotEmpty) {
              final q = _query.toLowerCase();
              if (!((t['name_zh']?.toString().toLowerCase() ?? '').contains(q)) && !((t['name_en']?.toString().toLowerCase() ?? '').contains(q)) && !((t['category']?.toString().toLowerCase() ?? '').contains(q))) return false;
            }
            if (_catFilter != null && _catMap[t['category']]?.$2 != _catFilter) return false;
            if (_diffFilter != null && t['difficulty'] != _diffFilter) return false;
            return true;
          }).toList();
          // 分组
          final groups = <String, List<dynamic>>{};
          for (final t in list) {
            final key = _catMap[t['category']]?.$2 ?? t['category']?.toString() ?? '其他';
            groups.putIfAbsent(key, () => []).add(t);
          }
          if (list.isEmpty) return Center(child: Text('没有匹配的教程', style: TextStyle(color: cs.onSurfaceVariant)));
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: '搜索: 坐下/握手/召回...',
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
                for (final c in [(null, '全部分类', null), ('基础服从', '🎯 基础服从', null), ('安全防护', '🛡️ 安全', null), ('行为纠正', '🔧 纠正', null), ('社交训练', '👥 社交', null), ('才艺展示', '🎭 才艺', null), ('高级技能', '🏆 高级', null)])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(c.$2),
                      selected: _catFilter == c.$1,
                      onSelected: (_) => setState(() => _catFilter = c.$1),
                    ),
                  ),
              ]),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(children: [
                for (final d in [(null, '全部难度', null), ('beginner', '🟢 入门', null), ('intermediate', '🟡 中级', null), ('advanced', '🔴 高级', null)])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(d.$2),
                      selected: _diffFilter == d.$1,
                      onSelected: (_) => setState(() => _diffFilter = d.$1),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [for (final e in groups.entries) _Group(title: e.key, items: e.value)],
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  const _Group({required this.title, required this.items});

  Color _diffColor(BuildContext context, String d) {
    switch (d) {
      case 'beginner': return Theme.of(context).colorScheme.tertiary;
      case 'intermediate': return Theme.of(context).colorScheme.error;
      case 'advanced': return Theme.of(context).colorScheme.error;
      default: return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  String _diffLabel(String d) {
    switch (d) {
      case 'beginner': return '入门';
      case 'intermediate': return '中级';
      case 'advanced': return '高级';
      default: return d;
    }
  }

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
            initiallyExpanded: true,
            tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
            title: Row(children: [
              Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: cs.onSurface))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(10)),
                child: Text('${items.length}', style: TextStyle(color: cs.onPrimary, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
            children: [for (final t in items) _card(context, t)],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, dynamic t) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TrainingDetailPage(t: t))),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: _diffColor(context, t['difficulty']).withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Center(child: Icon(Icons.school_rounded, color: _diffColor(context, t['difficulty']), size: 20)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t['name_zh'] ?? '', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: cs.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${_diffLabel(t['difficulty'])} · ${t['duration_min']}分钟', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11.5), maxLines: 1, overflow: TextOverflow.ellipsis),
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

class TrainingDetailPage extends StatelessWidget {
  final Map<String, dynamic> t;
  const TrainingDetailPage({required this.t});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('${t['name_zh']}')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: cs.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t['name_en'] ?? '', style: TextStyle(color: cs.onPrimaryContainer, fontSize: 13)),
                const SizedBox(height: 4),
                Text('${t['category']} · ${_diffLabel(t['difficulty'])} · ${t['duration_min']}分钟', style: TextStyle(color: cs.onPrimaryContainer, fontSize: 12)),
              ]),
            ),
          ),
          _section(context, '📋 训练步骤', t['steps'] as List<dynamic>),
          _section(context, '⚠️ 常见错误', [t['common_mistakes']]),
          _section(context, '💡 训练技巧', [t['tips']]),
        ],
      ),
    );
  }

  String _diffLabel(String d) {
    switch (d) {
      case 'beginner': return '入门';
      case 'intermediate': return '中级';
      case 'advanced': return '高级';
      default: return d;
    }
  }

  Widget _section(BuildContext context, String t, List<dynamic> items) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
          const SizedBox(height: 8),
          for (final i in items.where((x) => x != null && x.toString().isNotEmpty)) Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('• $i', style: TextStyle(height: 1.4, color: cs.onSurface)),
          ),
        ]),
      ),
    );
  }
}
