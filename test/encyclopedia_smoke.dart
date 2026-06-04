// 百科页面冒烟测试 - 检查 build 异常 + 文字颜色对比度
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
  for (final p in <(String, Widget)>[
    ('age_calculator', const AgeCalculatorPage()),
    ('bcs', const BcsPage()),
    ('breeds', const BreedsPage()),
    ('symptoms', const SymptomsPage()),
    ('diseases', const DiseasesPage()),
    ('human_foods', const HumanFoodsPage()),
    ('vaccine_calendar', const VaccineCalendarPage()),
    ('spay_neuter', const SpayNeuterPage()),
    ('training_library', const TrainingLibraryPage()),
    ('adoption', const AdoptionPage()),
    ('insurance_costs', const InsuranceCostsPage()),
    ('breeding', const BreedingPage()),
    ('senior_care', const SeniorCarePage()),
    ('grooming', const GroomingPage()),
    ('home_safety', const HomeSafetyPage()),
    ('toys_treats', const ToysTreatsPage()),
    ('travel', const TravelPage()),
    ('emergency', const EmergencyListPage()),
  ]) {
    testWidgets('百科 ${p.$1} page builds', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: p.$2),
        ),
      );
      // 等 FutureBuilder 跑完 + 任何异步操作
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 2));
      // 不能有 FlutterError
      expect(tester.takeException(), isNull, reason: '${p.$1} build threw an exception');
    });
  }
}
