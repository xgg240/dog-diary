// ============================================================
//  养狗百科 - 主入口 (含搜索 + 18 大子模块) — 高级版
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'breeds_page.dart';
import 'data_loader.dart';
import 'symptoms_page.dart';
import 'diseases_page.dart';
import 'training_library_page.dart';
import 'human_foods_page.dart';
import 'human_meds_page.dart';
import 'training_library_page.dart';
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
import '../../core/ui/design_tokens.dart';
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
    _Entry(Icons.medical_services_rounded, '症状自查', '24+ 症状 / 自查指南', _CatTone.danger, _SymProxy()),
    _Entry(Icons.local_hospital_rounded, '疾病库', '60+ 类 / 145+ 疾病详解', _CatTone.primary, _DisProxy()),
    _Entry(Icons.vaccines_rounded, '疫苗驱虫日历', '按品种+生日算时间', _CatTone.success, _VacProxy()),
    _Entry(Icons.restaurant_rounded, '人用食物查询', '160+ 食物 能吃/慎吃/禁吃', _CatTone.warning, _FoodProxy()),
    // 选狗
    _Entry(Icons.pets_rounded, '品种百科', '105+ 犬种 性格/体型/寿命', _CatTone.tertiary, _BreedProxy()),
    _Entry(Icons.cake_rounded, '年龄换算', '按体型算人类年龄', _CatTone.tertiary, _AgeProxy()),
    _Entry(Icons.monitor_weight_rounded, '体型评分 BCS', '1-9 分判定胖瘦', _CatTone.info, _BcsProxy()),
    // 决策
    _Entry(Icons.cut_rounded, '绝育助手', '时机/利弊/费用', _CatTone.warning, _SpayProxy()),
    _Entry(Icons.shopping_bag_rounded, '领养/购买指南', '避星期狗+正规清单', _CatTone.primary, _AdoptProxy()),
    _Entry(Icons.account_balance_wallet_rounded, '医保/费用', '年预算+手术费', _CatTone.info, _InsProxy()),
    _Entry(Icons.pregnant_woman_rounded, '怀孕/发情期', '63 天倒计时+发情周期', _CatTone.tertiary, _BreedPreProxy()),
    // 日常
    _Entry(Icons.brush_rounded, '美容/护理', '洗澡/指甲/牙/耳', _CatTone.secondary, _GroomProxy()),
    _Entry(Icons.security_rounded, '居家环境安全', '有毒植物/误食物品', _CatTone.danger, _HomeProxy()),
    _Entry(Icons.smart_toy_rounded, '玩具/零食评分', '6 类玩具 / 6 类零食 / 危险清单', _CatTone.warning, _ToyProxy()),
    _Entry(Icons.flight_rounded, '出行/托运/检疫', '高铁/飞机/国际/检疫', _CatTone.info, _TravelProxy()),
    _Entry(Icons.elderly_rounded, '老年犬护理', '7+ 岁体检/慢病管理', _CatTone.secondary, _SeniorProxy()),
    // 训练
    _Entry(Icons.school_rounded, '训练动作库', '30+ 动作 + 错误纠正', _CatTone.success, _TrainProxy()),
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
          const SizedBox(height: 16),
          _CommonDiseasesQuick(),
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
    final cs = Theme.of(context).colorScheme;
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
          _heroStat(context, '18', '模块'),
          const SizedBox(width: 16),
          _heroStat(context, '100+', '食物'),
          const SizedBox(width: 16),
          _heroStat(context, '31', '急症'),
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
  // 最紧急 9 个, id 用于跳转 EmergencyDetailPage
  static const _items = [
    ('☠️', '中毒', 'poisoning'),
    ('🥵', '中暑', 'heatstroke'),
    ('🚗', '车祸/外伤', 'trauma'),
    ('⚡', '抽搐/癫痫', 'seizure'),
    ('😵', '窒息/噎住', 'choking'),
    ('🌊', '溺水', 'drowning'),
    ('⚡', '触电', 'electrocution'),
    ('🦴', '骨折/扭伤', 'fracture'),
    ('🔥', '烫伤/烧伤', 'burn'),
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
          Text('9 类最紧急 · 点击直达详情', style: TextStyle(color: cs.onErrorContainer.withValues(alpha: 0.7), fontSize: 11)),
        ]),
        const SizedBox(height: 12),
        // 3x3 网格
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.0,
          children: [
            for (final e in _items)
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  // 9 个急症直接跳对应 EmergencyDetailPage (避免与症状自查重复)
                  final list = await DataLoader.emergencies();
                  final em = list.firstWhere((e) => e['id'] == e.$3, orElse: () => null);
                  if (em != null && context.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyDetailPage(emergency: em), fullscreenDialog: true));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.onErrorContainer.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(children: [
                    Text(e.$1, style: const TextStyle(fontSize: 22, height: 1.0)),
                    const SizedBox(width: 6),
                    Flexible(child: Text(e.$2, style: TextStyle(fontSize: 12, color: cs.onErrorContainer, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis)),
                  ]),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyListPage(), fullscreenDialog: true)),
            icon: const Icon(Icons.medical_services_rounded, size: 18),
            label: const Text('查看全部 31 类急症'),
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
    final cs = Theme.of(context).colorScheme;
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
        _searchDiseases(q),
        _searchSymptoms(q),
        _searchFoods(q),
        _searchTraining(q),
        _searchMeds(q),
      ]),
      builder: (ctx, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final results = <(String, String, Widget Function())>[];
        for (final m in (snap.data![0] as List)) {
          results.add((m['name_zh'], '🐶 品种', () => BreedDetailPage(breed: m as Map<String, dynamic>)));
        }
        for (final m in (snap.data![1] as List)) {
          results.add((m['name_zh'], '🏥 疾病', () => DiseaseDetailPage(d: m as Map<String, dynamic>)));
        }
        for (final m in (snap.data![2] as List)) {
          results.add((m['name_zh'], '🤒 症状', () => SymptomDetailPage(symptom: m as Map<String, dynamic>)));
        }
        for (final m in (snap.data![3] as List)) {
          results.add(('${m['name_zh']} (${m['safe'] ? '✅' : '❌'})', '🥗 食物', () => HumanFoodsPage(scrollTo: m['name_zh'])));
        }
        for (final m in (snap.data![4] as List)) {
          results.add((m['name_zh'], '🎓 训练', () => TrainingDetailPage(t: m as Map<String, dynamic>)));
        }
        for (final m in (snap.data![5] as List)) {
          results.add((m['name_zh'], '💊 人药', () => HumanMedsPage(scrollTo: m['name_zh'])));
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
                child: Text(r.$2.substring(0, 2), style: const TextStyle(fontSize: 14)),
              ),
              title: Text(r.$1),
              subtitle: Text(r.$2),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                close(ctx, r.$1);
                Navigator.push(ctx, MaterialPageRoute(builder: (_) => r.$3()));
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
  Future<List<dynamic>> _searchDiseases(String q) async {
    try {
      final d = await DataLoader.diseases();
      return d.where((e) {
        final n = (e['name_zh']?.toString() ?? '').toLowerCase();
        final ne = (e['name_en']?.toString() ?? '').toLowerCase();
        final c = (e['category']?.toString() ?? '').toLowerCase();
        final sym = e['symptoms'] is List ? (e['symptoms'] as List).join(' ').toLowerCase() : (e['symptoms']?.toString() ?? '').toLowerCase();
        final treat = (e['treatment']?.toString() ?? '').toLowerCase();
        final note = (e['note']?.toString() ?? '').toLowerCase();
        final med = e['medication'] is Map ? (e['medication'] as Map).values.map((v) => v is List ? v.join(' ') : v.toString()).join(' ').toLowerCase() : '';
        return n.contains(q) || ne.contains(q) || c.contains(q) || sym.contains(q) || treat.contains(q) || note.contains(q) || med.contains(q);
      }).take(30).toList();
    } catch (_) { return []; }
  }
  Future<List<dynamic>> _searchSymptoms(String q) async {
    final s = await SymptomsPage.allSymptoms();
    return s.where((e) => (e['name_zh'] as String).toLowerCase().contains(q)).take(20).toList();
  }
  Future<List<dynamic>> _searchFoods(String q) async {
    final f = await HumanFoodsPage.allFoods();
    return f.where((e) => (e['name_zh'] as String).toLowerCase().contains(q)).take(20).toList();
  }
  Future<List<dynamic>> _searchTraining(String q) async {
    final t = await DataLoader.tricks();
    return t.where((e) => (e['name_zh'] as String).toLowerCase().contains(q) || ((e['category'] as String?) ?? '').toLowerCase().contains(q)).take(20).toList();
  }
  Future<List<dynamic>> _searchMeds(String q) async {
    final m = await DataLoader.humanMeds();
    return (m['medications'] as List? ?? const []).where((e) => (e['name_zh'] as String).toLowerCase().contains(q) || ((e['generic_name'] as String?) ?? '').toLowerCase().contains(q)).take(20).toList();
  }
}

class _CommonDiseasesQuick extends StatelessWidget {
  const _CommonDiseasesQuick();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: DataLoader.diseases(),
      builder: (ctx, snap) {
        if (!snap.hasData) return const SizedBox.shrink();
        // 最常见的 8 种病 (按 id 匹配 8 种真常见病)
        const wantIds = ['cold_common', 'allergic_dermatitis', 'hot_spot', 'acute_gastroenteritis', 'ear_mites', 'flea_allergy', 'distemper', 'parvo'];
        final all = snap.data! as List;
        final common = <dynamic>[];
        for (final id in wantIds) {
          try {
            final d = all.firstWhere((e) => e['id'] == id);
            common.add(d);
          } catch (_) {}
        }
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.tertiaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.tertiary.withValues(alpha: 0.25), width: 0.5),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.medical_services_rounded, color: cs.tertiary, size: 20),
              const SizedBox(width: 8),
              Text('常见病直达', style: TextStyle(color: cs.onTertiaryContainer, fontSize: 16, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('点 → 详情', style: TextStyle(color: cs.onTertiaryContainer.withValues(alpha: 0.65), fontSize: 11)),
            ]),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final d in common)
                  Material(
                    color: d['urgency'] == 'emergency' ? cs.errorContainer : cs.surface,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseDetailPage(d: d as Map<String, dynamic>))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (d['urgency'] == 'emergency') Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(color: cs.error, borderRadius: BorderRadius.circular(4)),
                            child: Text('急', style: TextStyle(color: cs.onError, fontSize: 9, fontWeight: FontWeight.w700)),
                          ),
                          if (d['urgency'] == 'emergency') const SizedBox(width: 5),
                          Text(d['name_zh'], style: TextStyle(color: cs.onSurface, fontSize: 12.5, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                  ),
              ],
            ),
          ]),
        );
      },
    );
  }
}
