// ============================================================
//  提醒服务: 扫描健康事件 + 库存, 调度通知
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import 'notification_service.dart';
import 'providers.dart';

class ReminderService {
  final AppDatabase db;
  ReminderService(this.db);

  Future<int> scanAndNotify() async {
    if (kIsWeb) return 0;
    int count = 0;
    final now = DateTime.now();
    final in3 = now.add(const Duration(days: 3));

    // 健康事件 - 即将到期
    final upcoming = await (db.select(db.healthEvents)
          ..where((t) => t.nextDueDate.isSmallerOrEqualValue(in3) & t.nextDueDate.isBiggerOrEqualValue(now.subtract(const Duration(days: 30)))))
        .get();
    for (final e in upcoming) {
      final daysLeft = e.nextDueDate!.difference(now).inDays;
      final text = daysLeft < 0
          ? '已逾期 ${-daysLeft} 天'
          : daysLeft == 0
              ? '今天到期'
              : '还有 $daysLeft 天';
      await NotificationService.showNow(
        id: 1000 + e.id,
        title: '🏥 ${e.title}',
        body: '$text - ${_typeLabel(e.type)}',
      );
      count++;
    }

    // 低库存
    final low = await (db.select(db.foodItems)..where((t) => t.remainingKg.isSmallerOrEqualValue(1.0))).get();
    for (final f in low) {
      await NotificationService.showNow(
        id: 2000 + f.id,
        title: '🍖 库存不足',
        body: '${f.brand} · ${f.productName} 只剩 ${f.remainingKg.toStringAsFixed(1)}kg',
      );
      count++;
    }
    return count;
  }

  String _typeLabel(String t) {
    switch (t) {
      case 'checkup': return '体检';
      case 'vaccine': return '疫苗';
      case 'deworm': return '驱虫';
      case 'flea': return '跳蚤';
      case 'surgery': return '手术';
      default: return '其他';
    }
  }
}

final reminderServiceProvider = Provider<ReminderService>((ref) {
  return ReminderService(ref.watch(databaseProvider));
});
