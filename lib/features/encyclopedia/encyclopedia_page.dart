// ============================================================
//  养狗百科 - 主入口 (含搜索 + 18 大子模块) — 高级版
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'breeds_page.dart';
import 'symptoms_page.dart';
import 'diseases_page.dart';
import 'training_library_page.dart';
import 'human_foods_page.dart';
import 'vaccine_calendar_page.dart';
import 'spay_neuter_page.dart';
import 'adoption_page.dart';
import 'insurance_costs_page.dart';
import 'bcs_page.dart';
import 'breeding_page.dart';
import 'age_calculator_page.dart';
import 'emergency_page.dart';
import 'senior_care_page.dart';
import 'grooming_page.dart';
import 'home_safety_page.dart';
import 'toys_treats_page.dart';
import 'travel_page.dart';

// 分类调色 - 用 ColorScheme 语义色, 自适应浅/深
enum _CatTone { primary, secondary, tertiary, danger, warning, success, info }

extension on _CatTone {
  Color container(ColorScheme s) {
    switch (this) {
      case _CatTone.primary: return s.primaryContainer;
      case _CatTone.secondary: return s.secondaryContainer;
      case _CatTone.tertiary: return s.tertiaryContainer;
      case _CatTone.danger: return s.errorContainer;
      case _CatTone.warning: return s.secondaryContainer; // 用 secondary (暖) 避免再开一色
      case _CatTone.success: return s.secondaryContainer;
      case _CatTone.info: return s.tertiaryContainer;
    }
  }
  Color onContainer(ColorScheme s) {
    switch (this) {
      case _CatTone.primary: return s.onPrimaryContainer;
      case _CatTone.secondary: return s.onSecondaryContainer;
      case _CatTone.tertiary: return s.onTertiaryContainer;
      case _CatTone.danger: return s.onErrorContainer;
      case _CatTone.warning: return s.onSecondaryContainer;
      case _CatTone.success: return s.onSecondaryContainer;
      case _CatTone.info: return s.onTertiaryContainer;
    }
  }
}

class _Entry {
  final IconData icon;
  final String title;
  final String subtitle;
  final _CatTone tone;
  final Widget page;
  const _Entry(this.icon, this.title, this.subtitle, this.tone, this.page);
}

class EncyclopediaPage extends ConsumerWidget {
  const EncyclopediaPage({super.key});

  static const _entries = <_Entry>[
    // 健康 / 安全
    _Entry(Icons.medical_services_rounded, '症状自查', '15+ 症状，紧急程度判断', _CatTone.danger, _SymProxy()),
    _Entry(Icons.local_hospital_rounded, '疾病库', '13+ 常见病详解', _CatTone.primary, _DisProxy()),
    _Entry(Icons.vaccines_rounded, '疫苗驱虫日历', '按品种+生日算时间', _CatTone.success, _VacProxy()),
    _Entry(Icons.restaurant_rounded, '人用食物查询', '100+ 食物可/否', _CatTone.warning, _FoodProxy()),
    // 选狗
    _Entry(Icons.pets_rounded, '品种百科', '15+ 犬种性格/体高/寿命', _CatTone.tertiary, _BreedProxy()),
    _Entry(Icons.cake_rounded, '年龄换算', '按体型算人类年龄', _CatTone.tertiary, _AgeProxy()),
    _Entry(Icons.monitor_weight_rounded, '体型评分 BCS', '1-9 分判定胖瘦', _CatTone.info, _BcsProxy()),
    // 决策
    _Entry(Icons.cut_rounded, '绝育助手', '时机/利弊/费用', _CatTone.warning, _SpayProxy()),
    _Entry(Icons.shopping_bag_rounded, '领养/购买指南', '避星期狗+正规清单', _CatTone.primary, _AdoptProxy()),
    _Entry(Icons.account_balance_wallet_rounded, '医保/费用', '年预算+手术费', _CatTone.info, _InsProxy()),
    _Entry(Icons.pregnant_woman_rounded, '怀孕/发情期', '63 天倒计时+周期', _CatTone.tertiary, _BreedPreProxy()),
    // 日常
    _Entry(Icons.brush_rounded, '美容/护理', '洗澡/指甲/牙/耳', _CatTone.secondary, _GroomProxy()),
    _Entry(Icons.security_rounded, '居家环境安全', '有毒植物/误食物品', _CatTone.danger, _HomeProxy()),
    _Entry(Icons.smart_toy_rounded, '玩具/零食评分', '6 类玩具+6 类零食', _CatTone.warning, _ToyProxy()),
    _Entry(Icons.flight_rounded, '出行/托运/检疫', '高铁/飞机/国际', _CatTone.info, _TravelProxy()),
    _Entry(Icons.elderly_rounded, '老年犬护理', '7+ 岁体检/慢病', _CatTone.secondary, _SeniorProxy()),
    // 训练
    _Entry(Icons.school_rounded, '训练动作库', '12+ 动作+常见错误', _CatTone.success, _TrainProxy()),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('养狗百科'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: '搜索',
            onPressed: () => showSearch(
              context: context,
              delegate: _EncyclopediaSearchDelegate(),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
        children: [
          _Hero(cs: cs),
          const SizedBox(height: 16),
          // 急症快查 - 重要: 单独 emergency color section
          _EmergencyHero(),
          const SizedBox(height: 20),
          _SectionHeader(label: '❤️ 健康与安全'),
          const SizedBox(height: 8),
          _GridSection(cs: cs, entries: _entries.sublist(0, 4)),
          const SizedBox(height: 20),
          _SectionHeader(label: '🐶 选狗与了解'),
          const SizedBox(height: 8),
          _GridSection(cs: cs, entries: _entries.sublist(4, 7)),
          const SizedBox(height: 20),
          _SectionHeader(label: '💰 决策与费用'),
          const SizedBox(height: 8),
          _GridSection(cs: cs, entries: _entries.sublist(7, 11)),
          const SizedBox(height: 20),
          _SectionHeader(label: '🛠️ 日常护理'),
          const SizedBox(height: 8),
          _GridSection(cs: cs, entries: _entries.sublist(11, 16)),
          const SizedBox(height: 20),
          _SectionHeader(label: '🎓 训练与行为'),
          const SizedBox(height: 8),
          _GridSection(cs: cs, entries: _entries.sublist(16, 17)),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final ColorScheme cs;
  const _Hero({required this.cs});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [cs.primary, cs.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: cs.onPrimary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.menu_book_rounded, color: cs.onPrimary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('养狗大全', style: TextStyle(color: cs.onPrimary, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
              const SizedBox(height: 2),
              Text('离线百科 · 紧急自查 · 决策助手', style: TextStyle(color: cs.onPrimary.withValues(alpha: 0.85), fontSize: 13)),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          _heroStat(context, '17', '模块'),
          const SizedBox(width: 16),
          _heroStat(context, '100+', '食物'),
          const SizedBox(width: 16),
          _heroStat(context, '13', '急症'),
        ]),
      ]),
    );
  }

  Widget _heroStat(BuildContext ctx, String num, String label) {
    final cs = Theme.of(ctx).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: cs.onPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Text(num, style: TextStyle(color: cs.onPrimary, fontSize: 20, fontWeight: FontWeight.w800, height: 1.1)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: cs.onPrimary.withValues(alpha: 0.85), fontSize: 11)),
        ]),
      ),
    );
  }
}

class _EmergencyHero extends StatelessWidget {
  static const _items = [
    ('☠️', '中毒'),
    ('🥵', '中暑'),
    ('🚗', '车祸'),
    ('⚡', '抽搐'),
    ('🦴', '骨折'),
    ('😵', '窒息'),
    ('⚡', '触电'),
    ('🌊', '溺水'),
  ];
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.error.withValues(alpha: 0.25), width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.emergency_rounded, color: cs.error, size: 22),
          const SizedBox(width: 8),
          Text('急症快查', style: TextStyle(color: cs.onErrorContainer, fontSize: 17, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text('黄金时间窗内必须送医', style: TextStyle(color: cs.onErrorContainer.withValues(alpha: 0.7), fontSize: 11)),
        ]),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.95,
          children: [
            for (final e in _items)
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyListPage(), fullscreenDialog: true)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: cs.onErrorContainer.withValues(alpha: 0.12), shape: BoxShape.circle),
                    child: Center(child: Text(e.$1, style: const TextStyle(fontSize: 20, height: 1.0))),
                  ),
                  const SizedBox(height: 4),
                  Text(e.$2, style: TextStyle(fontSize: 11.5, color: cs.onErrorContainer, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyListPage(), fullscreenDialog: true)),
            icon: const Icon(Icons.medical_services_rounded, size: 18),
            label: const Text('查看全部 13 类急症'),
          ),
        ),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(children: [
        Container(width: 3, height: 14, decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: 0.2)),
      ]),
    );
  }
}

class _GridSection extends StatelessWidget {
  final ColorScheme cs;
  final List<_Entry> entries;
  const _GridSection({required this.cs, required this.entries});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.6,
      children: [for (final e in entries) _entryCard(context, e)],
    );
  }

  Widget _entryCard(BuildContext ctx, _Entry e) {
    final container = e.tone.container(cs);
    final onContainer = e.tone.onContainer(cs);
    return Material(
      color: container,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => e.page)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: onContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(e.icon, color: onContainer, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(e.title, style: TextStyle(color: onContainer, fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(e.subtitle, style: TextStyle(color: onContainer.withValues(alpha: 0.78), fontSize: 11.5, height: 1.25), maxLines: 2, overflow: TextOverflow.ellipsis),
              ]),
            ),
            Icon(Icons.chevron_right_rounded, color: onContainer.withValues(alpha: 0.5), size: 18),
          ]),
        ),
      ),
    );
  }
}

// 代理: 用函数代替直接构造函数 (延迟加载避免 18 个 import 启动开销)
class _SymProxy extends StatelessWidget { const _SymProxy(); @override Widget build(BuildContext c) => const SymptomsPage(); }
class _DisProxy extends StatelessWidget { const _DisProxy(); @override Widget build(BuildContext c) => const DiseasesPage(); }
class _VacProxy extends StatelessWidget { const _VacProxy(); @override Widget build(BuildContext c) => const VaccineCalendarPage(); }
class _FoodProxy extends StatelessWidget { const _FoodProxy(); @override Widget build(BuildContext c) => const HumanFoodsPage(); }
class _BreedProxy extends StatelessWidget { const _BreedProxy(); @override Widget build(BuildContext c) => const BreedsPage(); }
class _AgeProxy extends StatelessWidget { const _AgeProxy(); @override Widget build(BuildContext c) => const AgeCalculatorPage(); }
class _BcsProxy extends StatelessWidget { const _BcsProxy(); @override Widget build(BuildContext c) => const BcsPage(); }
class _SpayProxy extends StatelessWidget { const _SpayProxy(); @override Widget build(BuildContext c) => const SpayNeuterPage(); }
class _AdoptProxy extends StatelessWidget { const _AdoptProxy(); @override Widget build(BuildContext c) => const AdoptionPage(); }
class _InsProxy extends StatelessWidget { const _InsProxy(); @override Widget build(BuildContext c) => const InsuranceCostsPage(); }
class _BreedPreProxy extends StatelessWidget { const _BreedPreProxy(); @override Widget build(BuildContext c) => const BreedingPage(); }
class _GroomProxy extends StatelessWidget { const _GroomProxy(); @override Widget build(BuildContext c) => const GroomingPage(); }
class _HomeProxy extends StatelessWidget { const _HomeProxy(); @override Widget build(BuildContext c) => const HomeSafetyPage(); }
class _ToyProxy extends StatelessWidget { const _ToyProxy(); @override Widget build(BuildContext c) => const ToysTreatsPage(); }
class _TravelProxy extends StatelessWidget { const _TravelProxy(); @override Widget build(BuildContext c) => const TravelPage(); }
class _SeniorProxy extends StatelessWidget { const _SeniorProxy(); @override Widget build(BuildContext c) => const SeniorCarePage(); }
class _TrainProxy extends StatelessWidget { const _TrainProxy(); @override Widget build(BuildContext c) => const TrainingLibraryPage(); }

// 通用搜索
class _EncyclopediaSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => '搜索: 症状/食物/品种/疾病...';
  @override
  List<Widget>? buildActions(BuildContext ctx) => [IconButton(icon: const Icon(Icons.clear_rounded), onPressed: () => query = '')];
  @override
  Widget? buildLeading(BuildContext ctx) => IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => close(ctx, null));

  @override
  Widget buildResults(BuildContext ctx) => _buildList(ctx);
  @override
  Widget buildSuggestions(BuildContext ctx) => _buildList(ctx);

  Widget _buildList(BuildContext ctx) {
    final cs = Theme.of(ctx).colorScheme;
    if (query.trim().isEmpty) {
      return Center(child: Text('输入关键词搜索', style: TextStyle(color: cs.onSurfaceVariant)));
    }
    final q = query.toLowerCase();
    return FutureBuilder(
      future: Future.wait([
        _searchBreeds(q),
        _searchSymptoms(q),
        _searchFoods(q),
      ]),
      builder: (ctx, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final results = <(String, String, Widget)>[];
        for (final m in (snap.data![0] as List)) {
          results.add((m['name_zh'], '🐶 品种', const BreedsPage()));
        }
        for (final m in (snap.data![1] as List)) {
          results.add((m['name_zh'], '🤒 症状', const SymptomsPage()));
        }
        for (final m in (snap.data![2] as List)) {
          results.add(('${m['name_zh']} (${m['safe'] ? '✅' : '❌'})', '🥗 食物', const HumanFoodsPage()));
        }
        if (results.isEmpty) {
          return Center(child: Text('没有匹配结果', style: TextStyle(color: cs.onSurfaceVariant)));
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (_, i) {
            final r = results[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.surfaceContainerHigh,
                child: Text(r.$2, style: const TextStyle(fontSize: 16)),
              ),
              title: Text(r.$1),
              subtitle: Text(r.$2),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                close(ctx, r.$1);
                Navigator.push(ctx, MaterialPageRoute(builder: (_) => r.$3));
              },
            );
          },
        );
      },
    );
  }

  Future<List<dynamic>> _searchBreeds(String q) async {
    final b = await BreedsPage.allBreeds();
    return b.where((e) => (e['name_zh'] as String).toLowerCase().contains(q) || (e['name_en'] as String).toLowerCase().contains(q)).take(20).toList();
  }
  Future<List<dynamic>> _searchSymptoms(String q) async {
    final s = await SymptomsPage.allSymptoms();
    return s.where((e) => (e['name_zh'] as String).toLowerCase().contains(q)).take(20).toList();
  }
  Future<List<dynamic>> _searchFoods(String q) async {
    final f = await HumanFoodsPage.allFoods();
    return f.where((e) => (e['name_zh'] as String).toLowerCase().contains(q)).take(20).toList();
  }
}
