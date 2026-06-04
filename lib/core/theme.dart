// ============================================================
//  主题 — 高级感 Material 3 设计
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // 主品牌: 温暖琥珀 + 深可可
  static const Color _seed = Color(0xFFE76F51); // 陶土红, 高级温暖
  static const Color _accent = Color(0xFF2A9D8F); // 静谧青绿

  // 语义色
  static const Color success = Color(0xFF52B788);
  static const Color warning = Color(0xFFF4A261);
  static const Color danger = Color(0xFFE63946);
  static const Color info = Color(0xFF457B9D);

  // 中性灰阶 — 高级灰 (带蓝绿调)
  static const Color surfaceLight = Color(0xFFFBF9F6); // 米白
  static const Color surfaceDark = Color(0xFF1A1D23); // 深炭
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF242830);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
      secondary: _accent,
      surface: surfaceLight,
    );
    return _build(scheme, Brightness.light);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      secondary: _accent,
      surface: surfaceDark,
    );
    return _build(scheme, Brightness.dark);
  }

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scheme.surface,
      // 字体: 系统字体, 大号默认, 紧凑
      fontFamily: '.SF Pro Text',
      visualDensity: VisualDensity.standard,
      // AppBar — 透明 + 模糊
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      // 卡片 — 大圆角 + 轻阴影
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: isDark ? cardDark : cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4), width: 0.5),
        ),
      ),
      // 按钮
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        extendedTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      // 输入
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? scheme.surfaceContainerHigh : scheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      // NavigationBar
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: scheme.onSurface),
        ),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.onPrimaryContainer, size: 24);
          }
          return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
        }),
      ),
      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: scheme.onSurfaceVariant,
      ),
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primaryContainer,
        labelStyle: TextStyle(fontSize: 13, color: scheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      // Dialog
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: isDark ? cardDark : cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // Divider
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.4),
        thickness: 0.5,
        space: 1,
      ),
      // 文字主题
      textTheme: TextTheme(
        displayLarge: TextStyle(color: scheme.onSurface, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displayMedium: TextStyle(color: scheme.onSurface, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.3),
        headlineLarge: TextStyle(color: scheme.onSurface, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.2),
        headlineMedium: TextStyle(color: scheme.onSurface, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.1),
        titleLarge: TextStyle(color: scheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: scheme.onSurface, fontSize: 15, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: scheme.onSurface, fontSize: 13, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: scheme.onSurface, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
        bodyMedium: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
        bodySmall: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w400, height: 1.35),
        labelLarge: TextStyle(color: scheme.onSurface, fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3),
      ),
    );
  }
}
