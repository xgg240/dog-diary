// ============================================================
//  记账 数据访问
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../db/database.dart';

class FinanceRepository {
  final AppDatabase db;
  FinanceRepository(this.db);

  Stream<List<Expense>> watchAll() {
    return (db.select(db.expenses)
          ..orderBy([(t) => drift.OrderingTerm.desc(t.spentAt)]))
        .watch();
  }

  Stream<List<Expense>> watchMonth(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    return (db.select(db.expenses)
          ..where((t) => t.spentAt.isBetweenValues(start, end))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.spentAt)]))
        .watch();
  }

  Future<int> add({
    int? petId,
    required DateTime spentAt,
    required double amount,
    required String category,
    String? description,
    String? paymentMethod,
  }) {
    return db.into(db.expenses).insert(ExpensesCompanion(
      petId: drift.Value(petId),
      spentAt: drift.Value(spentAt),
      amount: drift.Value(amount),
      category: drift.Value(category),
      description: drift.Value(description),
      paymentMethod: drift.Value(paymentMethod),
    ));
  }

  Future<int> delete(int id) =>
      (db.delete(db.expenses)..where((t) => t.id.equals(id))).go();

  Future<int> updateExpense(
    int id, {
    int? petId,
    DateTime? spentAt,
    double? amount,
    String? category,
    String? description,
    String? paymentMethod,
  }) async {
    return (db.update(db.expenses)..where((t) => t.id.equals(id))).write(ExpensesCompanion(
      petId: petId != null ? drift.Value(petId) : const drift.Value.absent(),
      spentAt: spentAt != null ? drift.Value(spentAt) : const drift.Value.absent(),
      amount: amount != null ? drift.Value(amount) : const drift.Value.absent(),
      category: category != null ? drift.Value(category) : const drift.Value.absent(),
      description: description != null ? drift.Value(description) : const drift.Value.absent(),
      paymentMethod: paymentMethod != null ? drift.Value(paymentMethod) : const drift.Value.absent(),
    ));
  }
}

final financeRepoProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepository(ref.watch(databaseProvider));
});
