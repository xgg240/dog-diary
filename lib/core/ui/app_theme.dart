// App Theme v6 - 黑白 + 蓝, 卡片有色温区别 (用 primary/secondary/tertiary 增强色彩对比)
// 给 7 种分类卡片明显色彩, 不再单调

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

class AppTheme {
  static ThemeData light() {
    final cs = const ColorScheme.light(
      // 主品牌 - 蓝
      primary: AppColors.blue,
      onPrimary: AppColors.white,
      primaryContainer: Color(0xFFDBEAFE), // 蓝
      onPrimaryContainer: Color(0xFF1E40AF),
      // 第二 - 红 (暖, 紧急/重要)
      secondary: Color(0xFFDC2626),
      onSecondary: AppColors.white,
      secondaryContainer: Color(0xFFFEE2E2), // 红
      onSecondaryContainer: Color(0xFF991B1B),
      // 第三 - 绿 (成功/健康)
      tertiary: Color(0xFF059669),
      onTertiary: AppColors.white,
      tertiaryContainer: Color(0xFFD1FAE5), // 绿
      onTertiaryContainer: Color(0xFF065F46),
      // 错误
      error: AppColors.danger,
      onError: AppColors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF991B1B),
      // 表面
      surface: AppColors.white,
      onSurface: AppColors.textPrimary,
      surfaceContainerLowest: AppColors.white,
      surfaceContainerLow: AppColors.white,
      surfaceContainer: Color(0xFFFAFAFA),
      surfaceContainerHigh: Color(0xFFF5F5F5),
      surfaceContainerHighest: Color(0xFFEEEEEE),
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: Color(0xFFEEEEEE),
      shadow: AppColors.black,
      scrim: Color(0x66000000),
      inverseSurface: AppColors.black,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.blueLight,
    );
    return _build(cs, Brightness.light, SystemUiOverlayStyle.dark);
  }

  static ThemeData dark() {
    final cs = const ColorScheme.dark(
      primary: AppColors.blueLight,
      onPrimary: AppColors.black,
      primaryContainer: Color(0xFF1E3A8A), // 深蓝
      onPrimaryContainer: Color(0xFFDBEAFE),
      secondary: Color(0xFFF87171),
      onSecondary: Color(0xFF450A0A),
      secondaryContainer: Color(0xFF7F1D1D),
      onSecondaryContainer: Color(0xFFFECACA),
      tertiary: Color(0xFF34D399),
      onTertiary: Color(0xFF022C22),
      tertiaryContainer: Color(0xFF064E3B),
      onTertiaryContainer: Color(0xFFA7F3D0),
      error: AppColors.danger,
      onError: AppColors.white,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFECACA),
      surface: AppColors.black,
      onSurface: AppColors.white,
      surfaceContainerLowest: AppColors.black,
      surfaceContainerLow: Color(0xFF0A0A0A),
      surfaceContainer: AppColors.borderDark,
      surfaceContainerHigh: Color(0xFF262626),
      surfaceContainerHighest: Color(0xFF404040),
      onSurfaceVariant: AppColors.textTertiary,
      outline: AppColors.borderDark,
      outlineVariant: Color(0xFF1F1F1F),
      shadow: Colors.black,
      scrim: Color(0xAA000000),
      inverseSurface: AppColors.white,
      onInverseSurface: AppColors.black,
      inversePrimary: AppColors.blue,
    );
    return _build(cs, Brightness.dark, SystemUiOverlayStyle.light);
  }

  static ThemeData _build(ColorScheme cs, Brightness b, SystemUiOverlayStyle overlay) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: b,
      scaffoldBackgroundColor: cs.surface,
      canvasColor: cs.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,

      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSpacing.lg,
        toolbarHeight: 64,
        systemOverlayStyle: overlay,
        iconTheme: IconThemeData(color: cs.onSurface, size: 22),
        titleTextStyle: AppTypography.displayMedium.copyWith(color: cs.onSurface),
      ),

      cardTheme: CardThemeData(
        color: cs.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: cs.outline, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      listTileTheme: ListTileThemeData(
        iconColor: cs.onSurface,
        textColor: cs.onSurface,
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
        minVerticalPadding: 12,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainer,
        hoverColor: cs.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: cs.outline, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: cs.outline, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: cs.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.onSurface,
          side: BorderSide(color: cs.outline, width: 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
          textStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
        extendedTextStyle: AppTypography.titleMedium.copyWith(color: cs.onPrimary),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: cs.surfaceContainer,
        selectedColor: cs.primary,
        secondarySelectedColor: cs.primary,
        labelStyle: AppTypography.bodySmall.copyWith(color: cs.onSurface, fontWeight: FontWeight.w500),
        secondaryLabelStyle: AppTypography.bodySmall.copyWith(color: cs.onPrimary, fontWeight: FontWeight.w600),
        side: BorderSide(color: cs.outline, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        showCheckmark: false,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: cs.outline, width: 0.5),
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(color: cs.onSurface),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: cs.onSurface),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: cs.outline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: cs.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: cs.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),

      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 0.5,
        space: 0.5,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTypography.label.copyWith(fontSize: 11),
        unselectedLabelStyle: AppTypography.label.copyWith(fontSize: 11, color: cs.onSurfaceVariant),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => AppTypography.label.copyWith(
            color: s.contains(WidgetState.selected) ? cs.onPrimaryContainer : cs.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? cs.onPrimaryContainer : cs.onSurfaceVariant,
            size: 22,
          ),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: cs.primary,
        unselectedLabelColor: cs.onSurfaceVariant,
        indicatorColor: cs.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500),
        dividerColor: cs.outlineVariant,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.surfaceContainerHigh,
        circularTrackColor: cs.surfaceContainerHigh,
        strokeWidth: 2,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? cs.primary : cs.outline),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? cs.primaryContainer : cs.surfaceContainerHigh),
        trackOutlineColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? cs.primary : cs.outline),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.surfaceContainerHigh,
        thumbColor: cs.primary,
        overlayColor: cs.primary.withValues(alpha: 0.1),
        trackHeight: 3,
      ),

      iconTheme: IconThemeData(color: cs.onSurface, size: 22),

      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: cs.onSurface),
        displayMedium: AppTypography.displayMedium.copyWith(color: cs.onSurface),
        displaySmall: AppTypography.titleLarge.copyWith(fontSize: 22, color: cs.onSurface),
        headlineLarge: AppTypography.displayLarge.copyWith(color: cs.onSurface),
        headlineMedium: AppTypography.titleLarge.copyWith(fontSize: 20, color: cs.onSurface),
        headlineSmall: AppTypography.titleLarge.copyWith(color: cs.onSurface),
        titleLarge: AppTypography.titleLarge.copyWith(color: cs.onSurface),
        titleMedium: AppTypography.titleMedium.copyWith(color: cs.onSurface),
        titleSmall: AppTypography.bodyLarge.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: cs.onSurface),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: cs.onSurface),
        bodySmall: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
        labelLarge: AppTypography.titleMedium.copyWith(color: cs.onSurface),
        labelMedium: AppTypography.label.copyWith(color: cs.onSurface),
        labelSmall: AppTypography.label.copyWith(fontSize: 10, color: cs.onSurfaceVariant),
      ),

      splashColor: cs.primary.withValues(alpha: 0.06),
      highlightColor: cs.primary.withValues(alpha: 0.04),
      hoverColor: cs.primary.withValues(alpha: 0.04),
    );
  }
}
