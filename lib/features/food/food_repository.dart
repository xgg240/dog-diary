// ============================================================
//  狗粮库存 + 喂食 数据访问
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../db/database.dart';

class FoodRepository {
  final AppDatabase db;
  FoodRepository(this.db);

  // 库存
  Stream<List<FoodInventory>> watchInventory() {
    return (db.select(db.foodItems)
          ..orderBy([(t) => drift.OrderingTerm.asc(t.expireDate)]))
        .watch();
  }

  Stream<List<FoodInventory>> watchLowStock({double threshold = 1.0}) {
    return (db.select(db.foodItems)
          ..where((t) => t.remainingKg.isSmallerOrEqualValue(threshold)))
        .watch();
  }

  Future<int> addInventory({
    int? petId,
    required String brand,
    required String productName,
    String? flavor,
    required double totalKg,
    required double remainingKg,
    double? pricePerKg,
    required DateTime purchaseDate,
    DateTime? expireDate,
    String? notes,
  }) {
    return db.into(db.foodItems).insert(FoodItemsCompanion(
      petId: drift.Value(petId),
      brand: drift.Value(brand),
      productName: drift.Value(productName),
      flavor: drift.Value(flavor),
      totalKg: drift.Value(totalKg),
      remainingKg: drift.Value(remainingKg),
      pricePerKg: drift.Value(pricePerKg),
      purchaseDate: drift.Value(purchaseDate),
      expireDate: drift.Value(expireDate),
      notes: drift.Value(notes),
    ));
  }

  Future<int> deleteInventory(int id) =>
      (db.delete(db.foodItems)..where((t) => t.id.equals(id))).go();

  // 喂食
  Stream<List<FeedingRecord>> watchFeedings() {
    return (db.select(db.feedingRecords)
          ..orderBy([(t) => drift.OrderingTerm.desc(t.fedAt)]))
        .watch();
  }

  Future<int> addFeeding({
    required int petId,
    int? foodId,
    required DateTime fedAt,
    required double amountKg,
    String mealType = 'meal',
    String? notes,
  }) async {
    final id = await db.into(db.feedingRecords).insert(FeedingRecordsCompanion(
      petId: drift.Value(petId),
      foodId: drift.Value(foodId),
      fedAt: drift.Value(fedAt),
      amountKg: drift.Value(amountKg),
      mealType: drift.Value(mealType),
      notes: drift.Value(notes),
    ));
    // 扣减库存
    if (foodId != null) {
      final item = await (db.select(db.foodItems)..where((t) => t.id.equals(foodId))).getSingleOrNull();
      if (item != null) {
        final double newRemaining = (item.remainingKg - amountKg).clamp(0.0, double.infinity);
        await (db.update(db.foodItems)..where((t) => t.id.equals(foodId)))
            .write(FoodItemsCompanion(remainingKg: drift.Value(newRemaining)));
      }
    }
    return id;
  }

  Future<int> deleteFeeding(int id) async {
    // 回滚库存
    final rec = await (db.select(db.feedingRecords)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (rec != null && rec.foodId != null) {
      final item = await (db.select(db.foodItems)..where((t) => t.id.equals(rec.foodId!))).getSingleOrNull();
      if (item != null) {
        await (db.update(db.foodItems)..where((t) => t.id.equals(rec.foodId!)))
            .write(FoodItemsCompanion(remainingKg: drift.Value((item.remainingKg + rec.amountKg).toDouble())));
      }
    }
    return (db.delete(db.feedingRecords)..where((t) => t.id.equals(id))).go();
  }
}

final foodRepoProvider = Provider<FoodRepository>((ref) {
  return FoodRepository(ref.watch(databaseProvider));
});
