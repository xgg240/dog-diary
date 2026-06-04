// 百科页面文字颜色对比度审计
// 检查每个 Text widget 的颜色 vs 父背景色的对比度
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dog_diary/features/encyclopedia/age_calculator_page.dart';
import 'package:dog_diary/features/encyclopedia/bcs_page.dart';
import 'package:dog_diary/features/encyclopedia/breeds_page.dart';
import 'package:dog_diary/features/encyclopedia/symptoms_page.dart';
import 'package:dog_diary/features/encyclopedia/diseases_page.dart';
import 'package:dog_diary/features/encyclopedia/human_foods_page.dart';
import 'package:dog_diary/features/encyclopedia/vaccine_calendar_page.dart';
import 'package:dog_diary/features/encyclopedia/spay_neuter_page.dart';
import 'package:dog_diary/features/encyclopedia/training_library_page.dart';
import 'package:dog_diary/features/encyclopedia/adoption_page.dart';
import 'package:dog_diary/features/encyclopedia/insurance_costs_page.dart';
import 'package:dog_diary/features/encyclopedia/breeding_page.dart';
import 'package:dog_diary/features/encyclopedia/senior_care_page.dart';
import 'package:dog_diary/features/encyclopedia/grooming_page.dart';
import 'package:dog_diary/features/encyclopedia/home_safety_page.dart';
import 'package:dog_diary/features/encyclopedia/toys_treats_page.dart';
import 'package:dog_diary/features/encyclopedia/travel_page.dart';
import 'package:dog_diary/features/encyclopedia/emergency_page.dart';

void main() {
  // 这个测试不做断言, 只 dump widget tree 信息, 用 --reporter=expanded 看输出
  testWidgets('百科 widget tree dump - 检查 Text 颜色', (tester) async {
    final pages = <(String, Widget)>[
      ('emergency', const EmergencyListPage()),
      ('spay_neuter', const SpayNeuterPage()),
      ('breeding', const BreedingPage()),
      ('senior_care', const SeniorCarePage()),
      ('grooming', const GroomingPage()),
      ('home_safety', const HomeSafetyPage()),
      ('toys_treats', const ToysTreatsPage()),
      ('travel', const TravelPage()),
      ('insurance_costs', const InsuranceCostsPage()),
    ];

    for (final p in pages) {
      try {
        await tester.pumpWidget(ProviderScope(child: MaterialApp(home: p.$2)));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 2));
        await tester.pump(const Duration(seconds: 3));
        await tester.pump(const Duration(seconds: 5));
        // 找所有 Card 用了 shade<200 背景
        final cardFinder = find.byType(Card);
        final cardCount = cardFinder.evaluate().length;
        // 找所有 Text widget
        final textWidgets = find.byType(Text).evaluate();
        // 取前几个非默认色的
        final samples = <String>[];
        for (final el in textWidgets.take(20)) {
          final w = el.widget as Text;
          if (w.style != null && w.style!.color != null) {
            final c = w.style!.color!;
            samples.add('${w.data?.toString().substring(0, w.data!.length.clamp(0, 30))} | color=$c');
          }
        }
        // 输出
        print('${p.$1}: cards=$cardCount, texts=${textWidgets.length}');
        for (final s in samples.take(5)) {
          print('  - $s');
        }
      } catch (e) {
        print('${p.$1}: BUILD FAILED: $e');
      }
    }
  });
}
