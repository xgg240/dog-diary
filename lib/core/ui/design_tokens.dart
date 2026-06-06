// Design Tokens v5 - 黑白 + 蓝
// 抛弃灰色 + 紫色 + 青色, 保留 蓝色 accent

import 'package:flutter/material.dart';

class AppColors {
  // 黑白主色
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // 文字灰阶 (必要的中性色, 不能完全没有)
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF525252);
  static const Color textTertiary = Color(0xFFA3A3A3);

  // Border / 分割线 (极浅, 几乎看不见, 但还是必要的)
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF262626);

  // 蓝色 Accent (主品牌)
  static const Color blue = Color(0xFF2563EB); // 主蓝 (浅色模式)
  static const Color blueLight = Color(0xFF3B82F6); // 亮蓝 (深色模式)
  static const Color blueBg = Color(0xFFEFF6FF); // 极淡蓝底
  static const Color blueBgDark = Color(0xFF1E3A8A); // 深蓝底

  // 语义
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
}

class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 9999;
}

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class AppShadow {
  static List<BoxShadow> card(Brightness b) => const [];
  static List<BoxShadow> sheet(Brightness b) => const [];
  static List<BoxShadow> floating(Brightness b) => const [];
}

class AppTypography {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.6,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.4,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );
}
