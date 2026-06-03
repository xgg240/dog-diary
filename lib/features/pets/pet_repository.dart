// ============================================================
//  宠物数据访问
// ============================================================

import 'package:drift/drift.dart';
import '../../db/database.dart';
import '../../core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetRepository {
  final AppDatabase db;
  PetRepository(this.db);

  // CRUD
  Future<int> create({
    required String name,
    String? breed,
    DateTime? birthday,
    required String gender,
    bool neutered = false,
    String? notes,
  }) async {
    return db.into(db.pets).insert(PetsCompanion(
      name: Value(name),
      breed: Value(breed),
      birthday: Value(birthday),
      gender: Value(gender),
      neutered: Value(neutered),
      notes: Value(notes),
    ));
  }

  Future<bool> update(Pet pet) => db.update(db.pets).replace(pet);

  Future<int> delete(int id) => (db.delete(db.pets)..where((t) => t.id.equals(id))).go();

  // 体重
  Future<int> addWeight({
    required int petId,
    required DateTime measuredAt,
    required double weightKg,
    String? notes,
  }) {
    return db.into(db.weightRecords).insert(WeightRecordsCompanion(
      petId: Value(petId),
      measuredAt: Value(measuredAt),
      weightKg: Value(weightKg),
      notes: Value(notes),
    ));
  }

  Future<int> deleteWeight(int id) =>
      (db.delete(db.weightRecords)..where((t) => t.id.equals(id))).go();

  // 体重曲线数据
  Stream<List<WeightRecord>> watchWeights(int petId) {
    return (db.select(db.weightRecords)
          ..where((t) => t.petId.equals(petId))
          ..orderBy([(t) => OrderingTerm.asc(t.measuredAt)]))
        .watch();
  }
}

final petRepoProvider = Provider<PetRepository>((ref) {
  return PetRepository(ref.watch(databaseProvider));
});
