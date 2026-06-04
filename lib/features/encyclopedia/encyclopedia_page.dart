// ============================================================
//  养狗百科 - 主入口 (含搜索 + 9 大子模块)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class EncyclopediaPage extends ConsumerWidget {
  const EncyclopediaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 养狗百科'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '快速搜索',
            onPressed: () => showSearch(
              context: context,
              delegate: _EncyclopediaSearchDelegate(),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _hero(),
          const SizedBox(height: 12),
          // 急症快查 - 顶部红色 SOS 入口
          _emergencyQuickAccess(context),
          const SizedBox(height: 16),
          _section('🐶 选狗 / 了解自家狗', [
            _item(context, Icons.pets, '品种百科', '15+ 犬种性格/体高/寿命/疾病', Colors.brown, const BreedsPage()),
            _item(context, Icons.cake, '年龄换算', '不只 ×7，按体型算人类年龄', Colors.pink, const AgeCalculatorPage()),
            _item(context, Icons.monitor_weight, '体型评分 BCS', '看图选 1-9 分，判定胖瘦', Colors.deepPurple, const BcsPage()),
          ]),
          _section('❤️ 健康 / 安全', [
            _item(context, Icons.medical_services, '症状自查', '15+ 症状，紧急程度判断', Colors.red, const SymptomsPage()),
            _item(context, Icons.local_hospital, '疾病库', '13+ 常见病详解', Colors.indigo, const DiseasesPage()),
            _item(context, Icons.vaccines, '疫苗驱虫日历', '按品种+生日算疫苗时间', Colors.green, const VaccineCalendarPage()),
            _item(context, Icons.food_bank, '人用食物查询', '能/不能/看情况，搜 100+ 食物', Colors.orange, const HumanFoodsPage()),
          ]),
          _section('🎓 训练 / 行为', [
            _item(context, Icons.school, '训练动作库', '12+ 基础动作，步骤+常见错误', Colors.teal, const TrainingLibraryPage()),
          ]),
          _section('💰 决策 / 费用', [
            _item(context, Icons.cut, '绝育助手', '最佳绝育时机/利弊/费用', Colors.deepOrange, const SpayNeuterPage()),
            _item(context, Icons.shopping_bag, '领养/购买指南', '避星期狗+正规购犬清单', Colors.purple, const AdoptionPage()),
            _item(context, Icons.account_balance_wallet, '医保/费用估算', '年医疗预算+手术费', Colors.blueGrey, const InsuranceCostsPage()),
            _item(context, Icons.pregnant_woman, '怀孕/发情期', '63 天倒计时+发情周期', Colors.pinkAccent, const BreedingPage()),
          ]),
        ],
      ),
    );
  }

  Widget _emergencyQuickAccess(BuildContext ctx) {
    final emergencies = [
      ('☠️', '中毒', Colors.purple),
      ('🥵', '中暑', Colors.deepOrange),
      ('🚗', '车祸', Colors.red),
      ('⚡', '抽搐', Colors.amber),
      ('🦴', '骨折', Colors.brown),
      ('😵', '窒息', Colors.pink),
      ('⚡', '触电', Colors.cyan),
      ('🌊', '溺水', Colors.blue),
    ];
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.warning_amber, color: Colors.red),
            SizedBox(width: 8),
            Text('急症快查 (黄金时间窗内必须送医)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
          ]),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.95,
            children: [
              for (final e in emergencies)
                InkWell(
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EmergencyListPage(), fullscreenDialog: true)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: e.$3.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: Center(child: Text(e.$1, style: const TextStyle(fontSize: 24))),
                    ),
                    const SizedBox(height: 4),
                    Text(e.$2, style: const TextStyle(fontSize: 12)),
                  ]),
                ),
            ],
          ),
          const SizedBox(height: 4),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const EmergencyListPage(), fullscreenDialog: true)),
            icon: const Icon(Icons.medical_services),
            label: const Text('查看全部 13 类急症'),
          ),
        ]),
      ),
    );
  }

  Widget _hero() => Card(
        color: Colors.amber.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const Text('📚', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('养狗大全', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                const SizedBox(height: 4),
                Text('离线百科 · 紧急自查 · 决策助手', style: TextStyle(color: Colors.amber.shade800)),
              ]),
            ),
          ]),
        ),
      );

  Widget _section(String title, List<Widget> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 4),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ...items,
        ],
      );

  Widget _item(BuildContext ctx, IconData icon, String title, String subtitle, Color color, Widget page) => Card(
        child: ListTile(
          leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.2), child: Icon(icon, color: color)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => page)),
        ),
      );
}

// 通用搜索
class _EncyclopediaSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => '搜索：症状 / 食物 / 疾病 / 品种 / 训练...';
  @override
  List<Widget>? buildActions(BuildContext ctx) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  @override
  Widget? buildLeading(BuildContext ctx) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(ctx, null));

  @override
  Widget buildResults(BuildContext ctx) => _buildList(ctx);
  @override
  Widget buildSuggestions(BuildContext ctx) => _buildList(ctx);

  Widget _buildList(BuildContext ctx) {
    if (query.trim().isEmpty) return Center(child: Text('输入关键词搜索', style: TextStyle(color: Colors.grey.shade600)));
    final q = query.toLowerCase();
    // 简版：从 5 个高频入口同时搜
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
          results.add((m['name_zh'], '🐶 品种', BreedsPage()));
        }
        for (final m in (snap.data![1] as List)) {
          results.add((m['name_zh'], '🤒 症状', SymptomsPage()));
        }
        for (final m in (snap.data![2] as List)) {
          results.add(('${m['name_zh']} (${m['safe'] ? '✅' : '❌'})', '🥗 食物', HumanFoodsPage()));
        }
        return ListView(
          children: [
            for (final r in results.where((x) => x.$1.toLowerCase().contains(q) || true))
              ListTile(
                title: Text(r.$1),
                subtitle: Text(r.$2),
                onTap: () {
                  close(ctx, r.$1);
                  Navigator.push(ctx, MaterialPageRoute(builder: (_) => r.$3));
                },
              ),
          ],
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
