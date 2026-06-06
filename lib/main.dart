// ============================================================
//  养狗日记 - 主入口
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_router.dart';
import 'core/notification_service.dart';
import 'core/providers.dart';
import 'core/ui/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[main] starting...');
  await NotificationService.init();
  debugPrint('[main] runApp');
  runApp(const ProviderScope(child: DogDiaryApp()));
}

class DogDiaryApp extends ConsumerWidget {
  const DogDiaryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final scale = ref.watch(textScaleProvider);
    return MaterialApp(
      title: '养狗日记',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      builder: (context, child) {
        // 应用全局字号缩放 (响应用户设置)
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        );
      },
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}
