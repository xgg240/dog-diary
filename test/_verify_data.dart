import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dog_diary/features/encyclopedia/data_loader.dart';

void main() {
  testWidgets('verify', (tester) async {
    final d = await DataLoader.homeSafety();
    final hd = d['home_dangers'];
    final areas = hd['areas'];
    int maps = 0, strs = 0;
    for (final a in areas) {
      if (a is Map) maps++; else strs++;
    }
    print('home_dangers.areas: maps=$maps strs=$strs');
    if (strs > 0) {
      for (final s in areas) if (s is! Map) print('  STRING: $s');
    }
    final sh = d['seasonal_hazards'];
    final seasons = sh['seasons'];
    int maps2 = 0, strs2 = 0;
    for (final a in seasons) {
      if (a is Map) maps2++; else strs2++;
    }
    print('seasonal.seasons: maps=$maps2 strs=$strs2');
  });
}
