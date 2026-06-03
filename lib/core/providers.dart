// ============================================================
//  全局 Providers
// ============================================================

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';

/// 全局数据库实例
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// 主题模式
final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);

/// 所有宠物 (Stream)
final petsStreamProvider = StreamProvider<List<Pet>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).pets)
        ..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();
});
