// ============================================================
//  主壳 - 7 个底部 Tab (含养狗百科) + 红色 SOS 急症按钮
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dashboard/dashboard_page.dart';
import '../features/pets/pets_page.dart';
import '../features/health/health_page.dart';
import '../features/food/food_page.dart';
import '../features/finance/finance_page.dart';
import '../features/tools/tools_page.dart';
import '../features/encyclopedia/encyclopedia_page.dart';
import '../features/encyclopedia/emergency_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _idx = 0;

  final _pages = const [
    DashboardPage(),
    PetsPage(),
    HealthPage(),
    FoodPage(),
    FinancePage(),
    ToolsPage(),
    EncyclopediaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_idx]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: '仪表盘'),
          NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: '宠物'),
          NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), selectedIcon: Icon(Icons.health_and_safety), label: '健康'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: '饮食'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: '记账'),
          NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: '工具'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: '百科'),
        ],
      ),
      // 红色 SOS 急症按钮 - 救命功能
      floatingActionButton: _SOSButton(onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmergencyListPage(), fullscreenDialog: true),
        );
      }),
    );
  }
}

class _SOSButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SOSButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.5), blurRadius: 12, spreadRadius: 2)],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.red.shade600,
        onPressed: onTap,
        child: const Text('SOS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
