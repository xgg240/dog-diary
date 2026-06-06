// 人用食物查询
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class HumanFoodsPage extends StatefulWidget {
  const HumanFoodsPage({super.key, this.scrollTo});
  final String? scrollTo;
  static Future<List<dynamic>> allFoods() => DataLoader.humanFoods();
  @override
  State<HumanFoodsPage> createState() => _S();
}

class _S extends State<HumanFoodsPage> {
  String _filter = 'all';
  String _query = '';
  @override
  void initState() {
    super.initState();
    if (widget.scrollTo != null) {
      _query = widget.scrollTo!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('🥗 人用食物查询'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '搜索食物 (如: 苹果, 葡萄, 巧克力)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final f in [
              ('all', '全部', null),
              ('safe', '✅ 能吃', Theme.of(context).colorScheme.tertiary),
              ('watch', '⚠️ 少量', Theme.of(context).colorScheme.error),
              ('unsafe', '❌ 禁吃', Theme.of(context).colorScheme.error),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(f.$2),
                  selected: _filter == f.$1,
                  onSelected: (_) => setState(() => _filter = f.$1),
                ),
              ),
          ]),
        ),
        Expanded(
          child: FutureBuilder(
            future: DataLoader.humanFoods(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              var list = snap.data!;
              if (_query.isNotEmpty) {
                list = list.where((e) => (e['name_zh'] as String).toLowerCase().contains(_query)).toList();
              }
              if (_filter == 'safe') list = list.where((e) => e['safe'] == true).toList();
              if (_filter == 'unsafe') list = list.where((e) => e['safe'] == false).toList();
              if (_filter == 'watch') list = list.where((e) => e['note'].toString().contains('⚠️') || e['note'].toString().contains('少量')).toList();
              if (list.isEmpty) return Center(child: Text('无结果', style: TextStyle(color: cs.onSurfaceVariant)));
              // 分组: 能吃 / 慎吃 / 禁吃
              final safe = list.where((e) => e['safe'] == true).toList();
              final unsafe = list.where((e) => e['safe'] == false).toList();
              final watch = unsafe.where((e) => (e['note']?.toString() ?? '').contains('⚠️') || (e['note']?.toString() ?? '').contains('少量')).toList();
              final ban = unsafe.where((e) => !((e['note']?.toString() ?? '').contains('⚠️') || (e['note']?.toString() ?? '').contains('少量'))).toList();
              return ListView(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
                children: [
                  if (safe.isNotEmpty) _FoodGroup(cs: cs, title: '✅ 能吃 (${safe.length})', color: cs.tertiary, colorBg: cs.tertiaryContainer, items: safe),
                  if (watch.isNotEmpty) _FoodGroup(cs: cs, title: '⚠️ 慎吃 (${watch.length})', color: cs.error, colorBg: cs.errorContainer.withValues(alpha: 0.4), items: watch),
                  if (ban.isNotEmpty) _FoodGroup(cs: cs, title: '❌ 禁吃 (${ban.length})', color: cs.error, colorBg: cs.errorContainer, items: ban),
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _FoodGroup extends StatelessWidget {
  final ColorScheme cs;
  final String title;
  final Color color;
  final Color colorBg;
  final List<dynamic> items;
  const _FoodGroup({required this.cs, required this.title, required this.color, required this.colorBg, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colorBg,
        borderRadius: BorderRadius.circular(14),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: color)),
            children: [for (final f in items) _foodCard(context, f)],
          ),
        ),
      ),
    );
  }

  Widget _foodCard(BuildContext context, dynamic f) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showModalBottomSheet(context: context, builder: (_) => _FoodDetailSheet(food: f));
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Center(child: Text((f['safe'] as bool) ? '✅' : '❌', style: const TextStyle(fontSize: 16))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(f['name_zh'] ?? '', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: cs.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                  if ((f['name_en'] ?? '').toString().isNotEmpty) Text(f['name_en'], style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(f['note']?.toString() ?? '', style: TextStyle(color: cs.onSurface, fontSize: 12, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _FoodDetailSheet extends StatelessWidget {
  final dynamic food;
  const _FoodDetailSheet({required this.food});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text((food['safe'] as bool) ? '✅' : '❌', style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(food['name_zh'] ?? '', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface)),
                if ((food['name_en'] ?? '').toString().isNotEmpty) Text(food['name_en'], style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (food['safe'] as bool) ? cs.tertiaryContainer : cs.errorContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(food['note']?.toString() ?? '', style: TextStyle(color: (food['safe'] as bool) ? cs.onTertiaryContainer : cs.onErrorContainer, fontSize: 14, height: 1.5)),
          ),
        ]),
      ),
    );
  }
}
