// ============================================================
//  路由
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/contacts/contacts_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/finance/finance_page.dart';
import '../features/food/food_page.dart';
import '../features/health/health_page.dart';
import '../features/pets/pet_detail_page.dart';
import '../features/pets/pets_page.dart';
import '../features/tools/tools_page.dart';
import '../features/training/training_page.dart';
import '../features/walks/walks_page.dart';
import '../features/food/forbidden_foods_page.dart';
import 'app_shell.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/': return MaterialPageRoute(builder: (_) => const AppShell());
      case '/dashboard': return MaterialPageRoute(builder: (_) => const DashboardPage());
      case '/pets': return MaterialPageRoute(builder: (_) => const PetsPage());
      case '/pet-detail': return MaterialPageRoute(builder: (_) => const PetDetailPage(petId: 0));
      case '/health': return MaterialPageRoute(builder: (_) => const HealthPage());
      case '/food': return MaterialPageRoute(builder: (_) => const FoodPage());
      case '/finance': return MaterialPageRoute(builder: (_) => const FinancePage());
      case '/tools': return MaterialPageRoute(builder: (_) => const ToolsPage());
      case '/contacts': return MaterialPageRoute(builder: (_) => const ContactsPage());
      case '/walks': return MaterialPageRoute(builder: (_) => const WalksPage());
      case '/training': return MaterialPageRoute(builder: (_) => const TrainingPage());
      case '/forbidden-foods': return MaterialPageRoute(builder: (_) => const ForbiddenFoodsPage());
    }
    return null;
  }
}

// 重导出以便 main.dart 用
class AppRouterDelegate extends RouterDelegate<RouteSettings> with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  RouteSettings get currentConfiguration => const RouteSettings(name: '/');

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }

  @override
  Future<void> setNewRoutePath(RouteSettings configuration) async {}
}
