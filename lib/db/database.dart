// ============================================================
//  养狗日记 - 数据库 schema
// ------------------------------------------------------------
//  13 张表覆盖所有功能:
//  pets / weight_records / pet_images / health_events / medications
//  / feeding_records / food_inventory / expenses / walk_records
//  / training_logs / settings / forbidden_foods / contacts
// ============================================================

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName('Pet')
class Pets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get breed => text().nullable()();
  DateTimeColumn get birthday => dateTime().nullable()();
  TextColumn get gender => text()(); // male / female
  BoolColumn get neutered => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('WeightRecord')
class WeightRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().references(Pets, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get measuredAt => dateTime()();
  RealColumn get weightKg => real()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('PetImage')
class PetImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get path => text()();
  DateTimeColumn get takenAt => dateTime().nullable()();
  TextColumn get caption => text().nullable()();
}

@DataClassName('HealthEvent')
class HealthEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()(); // checkup / vaccine / deworm / flea / surgery / other
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get eventDate => dateTime()();
  DateTimeColumn get nextDueDate => dateTime().nullable()();
  TextColumn get vetName => text().nullable()();
  TextColumn get vetContact => text().nullable()();
  RealColumn get cost => real().nullable()();
  TextColumn get attachments => text().nullable()(); // JSON list of paths
}

@DataClassName('Medication')
class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get dosage => text().nullable()();
  TextColumn get frequency => text().nullable()(); // daily / weekly / monthly
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

@DataClassName('FoodInventory')
class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().nullable().references(Pets, #id, onDelete: KeyAction.setNull)();
  TextColumn get brand => text()();
  TextColumn get productName => text()();
  TextColumn get flavor => text().nullable()();
  RealColumn get totalKg => real()();
  RealColumn get remainingKg => real()();
  RealColumn get pricePerKg => real().nullable()();
  DateTimeColumn get purchaseDate => dateTime()();
  DateTimeColumn get expireDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('FeedingRecord')
class FeedingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().references(Pets, #id, onDelete: KeyAction.cascade)();
  IntColumn get foodId => integer().nullable().references(FoodInventory, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get fedAt => dateTime()();
  RealColumn get amountKg => real()();
  TextColumn get mealType => text().withDefault(const Constant('meal'))(); // meal / snack
  TextColumn get notes => text().nullable()();
}

@DataClassName('Expense')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().nullable().references(Pets, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get spentAt => dateTime()();
  RealColumn get amount => real()();
  TextColumn get category => text()(); // food / medical / grooming / toy / training / other
  TextColumn get description => text().nullable()();
  TextColumn get paymentMethod => text().nullable()();
}

@DataClassName('WalkRecord')
class WalkRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().references(Pets, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get walkedAt => dateTime()();
  IntColumn get durationMin => integer()();
  RealColumn get distanceKm => real().nullable()();
  TextColumn get route => text().nullable()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('TrainingLog')
class TrainingLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get command => text()();
  IntColumn get durationMin => integer().nullable()();
  TextColumn get performance => text().nullable()(); // good / ok / bad
  DateTimeColumn get trainedAt => dateTime()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('Setting')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('ForbiddenFood')
class ForbiddenFoods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get reason => text()();
  TextColumn get severity => text()(); // fatal / severe / mild
}

@DataClassName('Contact')
class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get address => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('hospital'))();
  TextColumn get notes => text().nullable()();
}

@DriftDatabase(tables: [
  Pets,
  WeightRecords,
  PetImages,
  HealthEvents,
  Medications,
  FoodItems,
  FeedingRecords,
  Expenses,
  WalkRecords,
  TrainingLogs,
  Settings,
  ForbiddenFoods,
  Contacts,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedForbiddenFoods();
        },
        onUpgrade: (m, from, to) async {
          // schemaVersion 还是 1 → 未来 v2/v3 加迁移步
          // 示例模板 (留给以后):
          // if (from < 2) {
          //   await m.addColumn(pets, pets.newField);
          // }
        },
        beforeOpen: (details) async {
          // 打开前防御：验证数据库完整性
          await customStatement('PRAGMA foreign_keys = ON');
          // 如果是新升级(had upgrade)，自动备份一次
          if (details.hadUpgrade) {
            try {
              await _autoBackupOnUpgrade();
            } catch (_) {
              // backup 失败不应阻断 db 打开
            }
          }
        },
      );

  Future<void> _autoBackupOnUpgrade() async {
    if (kIsWeb) return;
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, 'dog_diary.db'));
    if (!await dbFile.exists()) return;
    final backupDir = Directory(p.join(dir.path, 'dog_diary_backups'));
    if (!await backupDir.exists()) await backupDir.create(recursive: true);
    final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final backup = File(p.join(backupDir.path, 'pre_upgrade_$ts.db'));
    await dbFile.copy(backup.path);
  }

  // ---- 种子数据: 禁食食物 ----
  Future<void> _seedForbiddenFoods() async {
    final foods = [
      ['巧克力', 'chocolate', '可可碱致死, 越黑越危险', 'fatal'],
      ['木糖醇', 'xylitol', '低血糖+肝衰竭, 木糖醇口香糖/无糖牙膏', 'fatal'],
      ['葡萄/葡萄干', 'grape/raisin', '急性肾衰竭', 'fatal'],
      ['洋葱/大蒜', 'onion/garlic', '溶血性贫血', 'fatal'],
      ['澳洲坚果', 'macadamia', '神经毒素, 后肢瘫痪', 'fatal'],
      ['咖啡/咖啡因', 'caffeine', '心律失常/震颤', 'severe'],
      ['酒精', 'alcohol', '昏迷/死亡', 'severe'],
      ['牛油果', 'avocado', '心脏损伤 (含 persin)', 'severe'],
      ['生鸡蛋', 'raw egg', '沙门氏菌 + 抗生物素酶', 'severe'],
      ['生鱼', 'raw fish', '硫胺素酶破坏维生素B1', 'severe'],
      ['牛奶', 'milk', '乳糖不耐受 (成年犬)', 'mild'],
      ['西瓜籽', 'watermelon seeds', '肠梗阻风险', 'mild'],
      ['樱桃/桃李核', 'cherry/peach pit', '氰化物 + 肠梗阻', 'mild'],
      ['高盐食物', 'high salt', '钠中毒', 'mild'],
      ['高糖食物', 'high sugar', '肥胖/糖尿病', 'mild'],
    ];
    for (final f in foods) {
      await into(forbiddenFoods).insert(ForbiddenFoodsCompanion.insert(
        name: f[0],
        nameEn: Value(f[1]),
        reason: f[2],
        severity: f[3],
      ));
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      // Web 平台用 WasmDatabase (需要 sqlite3.wasm)
      throw UnsupportedError(
          'Web 平台需要 drift_flutter ^0.4.0+ 的 WasmDatabase 配置。当前 drift_flutter ^0.2.0 不支持 Web。请使用 Android / iOS / 桌面版，或升级 drift_flutter。');
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'dog_diary.db'));
    return NativeDatabase.createInBackground(file);
  });
}
