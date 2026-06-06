// ============================================================
//  顶栏宠物切换器 Provider（v3 Stage 1）
// ------------------------------------------------------------
//  全局维护 currentPetId，dashboard / health / food / walk 默认筛选
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import 'providers.dart';

/// 当前选中的宠物 ID（可空 = 全部）
final currentPetIdProvider = StateProvider<int?>((ref) => null);

/// 当前选中的宠物对象（联动 stream，删除宠物时自动重置）
final currentPetProvider = Provider<Pet?>((ref) {
  final id = ref.watch(currentPetIdProvider);
  if (id == null) return null;
  final pets = ref.watch(petsStreamProvider).value ?? [];
  for (final p in pets) {
    if (p.id == id) return p;
  }
  return null;
});
