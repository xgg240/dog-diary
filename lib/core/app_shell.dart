// ============================================================
//  主壳 - 7 个底部 Tab (含养狗百科) + 红色 SOS 急症按钮
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dashboard/dashboard_page.dart';
import '../features/dashboard/due_modal.dart';
import '../features/pets/pets_page.dart';
import 'pet_switcher_provider.dart';
import 'app_router.dart';
import '../features/health/health_page.dart';
import '../features/food/food_page.dart';
import '../features/finance/finance_page.dart';
import '../features/tools/tools_page.dart';
import '../features/encyclopedia/encyclopedia_page.dart';
import '../features/encyclopedia/emergency_page.dart';
import '../features/encyclopedia/data_loader.dart';
import '../features/encyclopedia/adoption_page.dart';
import '../features/encyclopedia/breeds_page.dart';
import '../features/encyclopedia/diseases_page.dart';
import '../features/encyclopedia/symptoms_page.dart';
import '../features/encyclopedia/human_foods_page.dart';
import '../features/encyclopedia/human_meds_page.dart';
import '../features/encyclopedia/dog_play_spots_page.dart';
import '../features/encyclopedia/training_library_page.dart';
import '../features/encyclopedia/spay_neuter_page.dart';
import '../features/encyclopedia/breeding_page.dart';
import '../features/encyclopedia/senior_care_page.dart';
import '../features/encyclopedia/grooming_page.dart';
import '../features/encyclopedia/home_safety_page.dart';
import '../features/encyclopedia/toys_treats_page.dart';
import '../features/encyclopedia/travel_page.dart';
import '../features/nearby/nearby_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _idx = const int.fromEnvironment('START_TAB', defaultValue: 0);

  final _pages = const [
    DashboardPage(),
    PetsPage(),
    HealthPage(),
    FoodPage(),
    FinancePage(),
    ToolsPage(),
    EncyclopediaPage(),
  ];

  // START_PAGE: 可选打开后立即跳转到指定子页面 (如 encyclopediapages)
  static const _startPage = String.fromEnvironment('START_PAGE');

  @override
  void initState() {
    super.initState();
    debugPrint('[app_shell] initState startPage=$_startPage');
    if (_startPage.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) { debugPrint('[app_shell] unmounted skip'); return; }
        debugPrint('[app_shell] pushing $_startPage');
        if (_startPage == 'encyclopedia') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EncyclopediaPage()));
        } else if (_startPage == 'nearby') {
          debugPrint('[app_shell] push NearbyPage...');
          // 不 push, 工具 tab 内自带"附近服务"入口, 切到工具 tab
          setState(() => _idx = 5);
        } else if (_startPage == 'diseases') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DiseasesPage()));
        } else if (_startPage == 'meds') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HumanMedsPage()));
        } else if (_startPage == 'play') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DogPlaySpotsPage()));
        } else if (_startPage == 'symptoms') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SymptomsPage()));
        } else if (_startPage == 'breeds') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BreedsPage()));
        } else if (_startPage == 'foods') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HumanFoodsPage()));
        } else if (_startPage == 'training') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TrainingLibraryPage()));
        } else if (_startPage == 'home_safety') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomeSafetyPage()));
        } else if (_startPage == 'toys_treats') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ToysTreatsPage()));
        } else if (_startPage == 'emergency') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyListPage(), fullscreenDialog: true));
        } else if (_startPage.startsWith('emergency_')) {
          // 调试: 打开指定 id 的急症详情 (如 emergency_poisoning)
          final id = _startPage.substring('emergency_'.length);
          DataLoader.emergencies().then((list) {
            final match = list.cast<Map<String, dynamic>>().firstWhere(
              (e) => e['id'] == id,
              orElse: () => list.first as Map<String, dynamic>,
            );
            if (mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => EmergencyDetailPage(emergency: match),
                fullscreenDialog: true,
              ));
            }
          });
        } else if (_startPage == 'spay_neuter') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SpayNeuterPage()));
        } else if (_startPage == 'breeding') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BreedingPage()));
        } else if (_startPage == 'senior_care') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SeniorCarePage()));
        } else if (_startPage == 'grooming') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GroomingPage()));
        } else if (_startPage == 'home_safety') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomeSafetyPage()));
        } else if (_startPage == 'toys_treats') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ToysTreatsPage()));
        } else if (_startPage == 'travel') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TravelPage()));
        } else if (_startPage == 'tools') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ToolsPage()));
        }
      });
    }
    // 启动时检查到期提醒
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        await DueReminderModal.checkAndShow(ctx, ref);
      }
    });
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,  // 删 AppShell 顶层 AppBar (PetSwitcher + 定位图标), 改用各 page 自己的 AppBar
      body: SafeArea(child: _pages[_idx]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '首页'),
          NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: '宠物'),
          NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), selectedIcon: Icon(Icons.health_and_safety), label: '健康'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: '饮食'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: '记账'),
          NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: '工具'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: '百科'),
        ],
      ),
      // 红色 SOS 急症按钮 - 只在仪表盘显示, 不影响其他 tab
      floatingActionButton: _idx == 0
          ? _SOSButton(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SymptomsPage(), fullscreenDialog: true),
              );
            })
          : null,
    );
  }
}

class _SOSButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SOSButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: cs.error.withValues(alpha: 0.4), blurRadius: 14, spreadRadius: 2)],
      ),
      child: FloatingActionButton(
        backgroundColor: cs.error,
        foregroundColor: cs.onError,
        onPressed: onTap,
        shape: const CircleBorder(),
        child: const Text('SOS', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 1)),
      ),
    );
  }
}
