// 真实加载 JSON 跑所有百科页面 - 验证数据流
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
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
  // 1. mock rootBundle: 拦截 flutter/assets channel
  final root = '/Users/xiaochib/Desktop/养狗日记源码';
  final assetMap = <String, String>{};
  for (final jp in Directory('$root/assets/data').listSync()) {
    if (jp is File && jp.path.endsWith('.json')) {
      // 试两个 key 格式
      assetMap['assets/data/${jp.uri.pathSegments.last}'] = jp.readAsStringSync();
      assetMap['packages/dog_diary/assets/data/${jp.uri.pathSegments.last}'] = jp.readAsStringSync();
    }
  }
  print('Loaded ${assetMap.length} JSON entries');

  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMessageHandler('flutter/assets', (message) async {
    final key = utf8.decode((message! as ByteData).buffer.asUint8List());
    if (assetMap.containsKey(key)) {
      return ByteData.sublistView(Uint8List.fromList(utf8.encode(assetMap[key]!)));
    }
    return null;
  });

  // 2. 跑每个页面
  final pages = <(String, Widget)>[
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
  ];

  for (final p in pages) {
    testWidgets('百科真实加载 ${p.$1}', (tester) async {
      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: p.$2)));
      // 跑真异步
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();
      // 找 loading indicator
      final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      // 找 Text 数量
      final textCount = find.byType(Text).evaluate().length;
      // 不能有 cast 异常
      final err = tester.takeException();
      print('${p.$1}: loading=$hasLoading, textCount=$textCount, err=$err');
      expect(err, isNull, reason: '${p.$1} build error');
      // vaccine_calendar / age_calculator 需要 db, 在测试环境 db loading - 跳过
      if (p.$1 == 'vaccine_calendar' || p.$1 == 'age_calculator') {
        return;
      }
      expect(textCount, greaterThan(3), reason: '${p.$1} 没数据 (textCount=$textCount, loading=$hasLoading)');
    });
  }
}
