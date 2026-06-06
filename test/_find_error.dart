import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dog_diary/features/encyclopedia/home_safety_page.dart';

void main() {
  testWidgets('home_safety err', (tester) async {
    FlutterErrorDetails? lastError;
    FlutterError.onError = (d) { lastError = d; };
    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: HomeSafetyPage())));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));
    if (lastError != null) {
      print('ERROR:');
      print(lastError!.exception);
      print(lastError!.stack.toString().split('\n').take(8).join('\n'));
    }
  });
}
