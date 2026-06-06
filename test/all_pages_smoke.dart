// Smoke test - 每个百科子页都 pump 一遍看是否 crash
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
import 'package:dog_diary/features/encyclopedia/human_meds_page.dart';
import 'package:dog_diary/features/encyclopedia/encyclopedia_page.dart';

void main() {
  for (final p in const <(String, Widget)>[
    ('emergency', EmergencyListPage()),
    ('spay_neuter', SpayNeuterPage()),
    ('age_calculator', AgeCalculatorPage()),
    ('bcs', BcsPage()),
    ('breeds', BreedsPage()),
    ('symptoms', SymptomsPage()),
    ('diseases', DiseasesPage()),
    ('human_foods', HumanFoodsPage()),
    ('human_meds', HumanMedsPage()),
    ('vaccine_calendar', VaccineCalendarPage()),
    ('training_library', TrainingLibraryPage()),
    ('adoption', AdoptionPage()),
    ('insurance_costs', InsuranceCostsPage()),
    ('breeding', BreedingPage()),
    ('senior_care', SeniorCarePage()),
    ('grooming', GroomingPage()),
    ('home_safety', HomeSafetyPage()),
    ('toys_treats', ToysTreatsPage()),
    ('travel', TravelPage()),
    ('encyclopedia', EncyclopediaPage()),
  ]) {
    testWidgets('pump ${p.$1}', (tester) async {
      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: p.$2)));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(seconds: 1));
      // 期望没有 crash
      expect(tester.takeException(), isNull, reason: '${p.$1} 渲染异常');
    });
  }
}
