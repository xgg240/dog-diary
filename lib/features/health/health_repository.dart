// ============================================================
//  健康事件 + 用药 数据访问
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../db/database.dart';

class HealthRepository {
  final AppDatabase db;
  HealthRepository(this.db);

  // ---- 健康事件 ----
  Stream<List<HealthEvent>> watchEvents() {
    return (db.select(db.healthEvents)
          ..orderBy([(t) => drift.OrderingTerm.desc(t.eventDate)]))
        .watch();
  }

  Stream<List<HealthEvent>> watchUpcomingDue() {
    final now = DateTime.now();
    final in30 = now.add(const Duration(days: 30));
    return (db.select(db.healthEvents)
          ..where((t) => t.nextDueDate.isSmallerOrEqualValue(in30) & t.nextDueDate.isBiggerOrEqualValue(now))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.nextDueDate)]))
        .watch();
  }

  Stream<List<HealthEvent>> watchOverdue() {
    final now = DateTime.now();
    return (db.select(db.healthEvents)
          ..where((t) => t.nextDueDate.isSmallerThanValue(now))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.nextDueDate)]))
        .watch();
  }

  Future<int> addEvent({
    required int petId,
    required String type,
    required String title,
    String? description,
    required DateTime eventDate,
    DateTime? nextDueDate,
    String? vetName,
    String? vetContact,
    double? cost,
  }) {
    return db.into(db.healthEvents).insert(HealthEventsCompanion(
      petId: drift.Value(petId),
      type: drift.Value(type),
      title: drift.Value(title),
      description: drift.Value(description),
      eventDate: drift.Value(eventDate),
      nextDueDate: drift.Value(nextDueDate),
      vetName: drift.Value(vetName),
      vetContact: drift.Value(vetContact),
      cost: drift.Value(cost),
    ));
  }

  Future<int> deleteEvent(int id) =>
      (db.delete(db.healthEvents)..where((t) => t.id.equals(id))).go();

  // ---- 用药 ----
  Stream<List<Medication>> watchMedications({bool? activeOnly}) {
    final q = db.select(db.medications);
    if (activeOnly == true) {
      q.where((t) => t.active.equals(true));
    }
    q.orderBy([(t) => drift.OrderingTerm.asc(t.startDate)]);
    return q.watch();
  }

  Future<int> addMedication({
    required int petId,
    required String name,
    String? dosage,
    String? frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    // 双写：Medication 表保留（兼容历史 + 快速开关），同时写一条 HealthEvent(type='medication')
    // 让 reminder_service 统一扫到，自动按 frequency 算下次提醒。
    final medId = await db.into(db.medications).insert(MedicationsCompanion(
      petId: drift.Value(petId),
      name: drift.Value(name),
      dosage: drift.Value(dosage),
      frequency: drift.Value(frequency),
      startDate: drift.Value(startDate),
      endDate: drift.Value(endDate),
      notes: drift.Value(notes),
      active: const drift.Value(true),
    ));
    await db.into(db.healthEvents).insert(HealthEventsCompanion(
      petId: drift.Value(petId),
      type: const drift.Value('medication'),
      title: drift.Value(name),
      description: drift.Value(notes),
      eventDate: drift.Value(startDate),
      nextDueDate: drift.Value(_nextDue(startDate, frequency)),
      frequency: drift.Value(frequency),
      dosage: drift.Value(dosage),
    ));
    return medId;
  }

  /// 按 frequency 算下一次到期时间
  static DateTime? _nextDue(DateTime start, String? frequency) {
    if (frequency == null || frequency == 'once') return null;
    switch (frequency) {
      case 'daily':
        return start.add(const Duration(days: 1));
      case 'weekly':
        return start.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(start.year, start.month + 1, start.day);
      default:
        return null;
    }
  }

  Future<int> deleteMedication(int id) =>
      (db.delete(db.medications)..where((t) => t.id.equals(id))).go();

  Future<bool> toggleMedication(Medication m) =>
      db.update(db.medications).replace(m.copyWith(active: !m.active));
}

final healthRepoProvider = Provider<HealthRepository>((ref) {
  return HealthRepository(ref.watch(databaseProvider));
});
