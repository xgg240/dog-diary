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
    String category = 'kibble', // kibble / can / snack / supplement / medicine
    required String brand,
    required String productName,
    String? flavor,
    required double totalKg,
    required double remainingKg,
    double? pricePerKg,
    required DateTime purchaseDate,
    DateTime? expireDate,
    String? notes,
    bool blacklisted = false,
    String? allergyReason,
  }) {
    return db.into(db.foodItems).insert(FoodItemsCompanion(
      petId: drift.Value(petId),
      category: drift.Value(category),
      brand: drift.Value(brand),
      productName: drift.Value(productName),
      flavor: drift.Value(flavor),
      totalKg: drift.Value(totalKg),
      remainingKg: drift.Value(remainingKg),
      pricePerKg: drift.Value(pricePerKg),
      purchaseDate: drift.Value(purchaseDate),
      expireDate: drift.Value(expireDate),
      notes: drift.Value(notes),
      blacklisted: drift.Value(blacklisted),
      allergyReason: drift.Value(allergyReason),
    ));
  }

  Future<int> deleteInventory(int id) =>
      (db.delete(db.foodItems)..where((t) => t.id.equals(id))).go();

  Future<int> updateInventory(
    int id, {
    int? petId,
    String? category,
    String? brand,
    String? productName,
    String? flavor,
    double? totalKg,
    double? pricePerKg,
    DateTime? purchaseDate,
    DateTime? expireDate,
    String? notes,
    bool? blacklisted,
    String? allergyReason,
  }) async {
    return (db.update(db.foodItems)..where((t) => t.id.equals(id))).write(FoodItemsCompanion(
      petId: petId != null ? drift.Value(petId) : const drift.Value.absent(),
      category: category != null ? drift.Value(category) : const drift.Value.absent(),
      brand: brand != null ? drift.Value(brand) : const drift.Value.absent(),
      productName: productName != null ? drift.Value(productName) : const drift.Value.absent(),
      flavor: flavor != null ? drift.Value(flavor) : const drift.Value.absent(),
      totalKg: totalKg != null ? drift.Value(totalKg) : const drift.Value.absent(),
      pricePerKg: pricePerKg != null ? drift.Value(pricePerKg) : const drift.Value.absent(),
      purchaseDate: purchaseDate != null ? drift.Value(purchaseDate) : const drift.Value.absent(),
      expireDate: expireDate != null ? drift.Value(expireDate) : const drift.Value.absent(),
      notes: notes != null ? drift.Value(notes) : const drift.Value.absent(),
      blacklisted: blacklisted != null ? drift.Value(blacklisted) : const drift.Value.absent(),
      allergyReason: allergyReason != null ? drift.Value(allergyReason) : const drift.Value.absent(),
    ));
  }

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

  Future<int> updateFeeding(
    int id, {
    int? petId,
    int? foodId,
    DateTime? fedAt,
    double? amountKg,
    String? mealType,
    String? notes,
  }) async {
    return (db.update(db.feedingRecords)..where((t) => t.id.equals(id))).write(FeedingRecordsCompanion(
      petId: petId != null ? drift.Value(petId) : const drift.Value.absent(),
      foodId: foodId != null ? drift.Value(foodId) : const drift.Value.absent(),
      fedAt: fedAt != null ? drift.Value(fedAt) : const drift.Value.absent(),
      amountKg: amountKg != null ? drift.Value(amountKg) : const drift.Value.absent(),
      mealType: mealType != null ? drift.Value(mealType) : const drift.Value.absent(),
      notes: notes != null ? drift.Value(notes) : const drift.Value.absent(),
    ));
  }
}

final foodRepoProvider = Provider<FoodRepository>((ref) {
  return FoodRepository(ref.watch(databaseProvider));
});
