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
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
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
  TextColumn get type => text()(); // checkup / vaccine / deworm / flea / surgery / medication / other
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get eventDate => dateTime()();
  DateTimeColumn get nextDueDate => dateTime().nullable()();
  TextColumn get frequency => text().nullable()(); // null=once, 'daily', 'weekly', 'monthly' (used when type=medication)
  TextColumn get dosage => text().nullable()(); // 用药剂量 (e.g. "5mg/次")
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
  TextColumn get category => text().withDefault(const Constant('kibble'))(); // kibble / can / snack / supplement / medicine
  TextColumn get brand => text()();
  TextColumn get productName => text()();
  TextColumn get flavor => text().nullable()();
  RealColumn get totalKg => real()();
  RealColumn get remainingKg => real()();
  RealColumn get pricePerKg => real().nullable()();
  BoolColumn get blacklisted => boolean().withDefault(const Constant(false))();
  TextColumn get allergyReason => text().nullable()();
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

@DataClassName('TrainingPlan')
class TrainingPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get petId => integer().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();        // "坐下训练"
  TextColumn get command => text()();      // "sit"
  IntColumn get targetDays => integer()(); // 计划天数
  IntColumn get dailyMinutes => integer().withDefault(const Constant(10))();
  IntColumn get progress => integer().withDefault(const Constant(0))(); // 已完成天数
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
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

// ============================================================
//  v3 新增表（2026-06-05 阶段一重构）
// ------------------------------------------------------------
//  FavoritePlaces  收藏常去的店/医院（高德 POI 缓存）
//  UserPreferences 用户偏好（顶栏当前选中狗、弹窗已读状态等）
//  ExportSettings  加密导出配置（PIN hash + 启用标记）
//  PoiCache        云端 POI 缓存（Day 2: 合并云端增量到本地, 支持离线浏览）
// ============================================================

@DataClassName('PoiCacheEntry')
class PoiCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get amapId => text().unique()();      // 云端 id (高德或后端 uuid), 唯一
  TextColumn get name => text()();
  TextColumn get category => text()();             // hospital / store / groom / emergency
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get city => text().nullable()();      // 城市, 用于按城市过滤
  TextColumn get source => text().withDefault(const Constant('cloud'))(); // cloud / local (用户提交)
  IntColumn get cloudVersion => integer().withDefault(const Constant(0))(); // 云端版本号, 增量同步用
  DateTimeColumn get cloudSyncedAt => dateTime().nullable()();    // 上次从云端拉取/推送时间
  DateTimeColumn get localUpdatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get submittedBy => text().nullable()();               // 提交者 (user_xxx / anon)
  BoolColumn get active => boolean().withDefault(const Constant(true))(); // 软删标记
}

@DataClassName('FavoritePlace')
class FavoritePlaces extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text()(); // hospital / store / groom / emergency
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get amapId => text().nullable()(); // 高德 POI id
  IntColumn get visitCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastVisitedAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();
}

@DataClassName('UserPreference')
class UserPreferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('ExportSetting')
class ExportSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pinHash => text()(); // SHA-256(PIN + salt)
  TextColumn get salt => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
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
  TrainingPlans,
  Settings,
  ForbiddenFoods,
  Contacts,
  FavoritePlaces,
  UserPreferences,
  ExportSettings,
  PoiCache,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedForbiddenFoods();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2: 健康事件 + 用药合并 (HealthEvent 加 frequency/dosage)，饮食分类
            await m.addColumn(healthEvents, healthEvents.frequency);
            await m.addColumn(healthEvents, healthEvents.dosage);
            await m.addColumn(foodItems, foodItems.category);
          }
          if (from < 3) {
            // v3: Stage 1 重构 - 高德 POI 收藏 + 用户偏好 + 加密导出
            await m.createTable(favoritePlaces);
            await m.createTable(userPreferences);
            await m.createTable(exportSettings);
            // 默认选中第一只狗
            final firstPet = await (select(pets)..limit(1)).getSingleOrNull();
            if (firstPet != null) {
              await into(userPreferences).insertOnConflictUpdate(
                UserPreferencesCompanion.insert(key: 'current_pet_id', value: firstPet.id.toString()),
              );
            }
          }
          if (from < 4) {
            // v4: Stage 2 - 训练计划 + 食物黑名单
            await m.createTable(trainingPlans);
            await m.addColumn(foodItems, foodItems.blacklisted);
            await m.addColumn(foodItems, foodItems.allergyReason);
          }
          if (from < 5) {
            // v5: Day 2 - 云端 POI 缓存 (合并云端增量到本地, 11 万目标)
            await m.createTable(poiCache);
            // 建索引加速按城市/分类查询
            await customStatement('CREATE INDEX IF NOT EXISTS idx_poi_cache_city ON poi_cache (city)');
            await customStatement('CREATE INDEX IF NOT EXISTS idx_poi_cache_category ON poi_cache (category)');
            await customStatement('CREATE INDEX IF NOT EXISTS idx_poi_cache_cloud_synced ON poi_cache (cloud_synced_at)');
          }
          // v6 的 description 迁移放到 beforeOpen 里 (幂等), 避免 v6 fresh install 报 duplicate
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
          // 幂等迁移: 给 PoiCache 加 description 字段 (v6 任务, 必须在 v5 create 之后)
          // - 第一次跑: 加上
          // - 第二次跑: 检测到已存在, 跳过
          // - 避免 v6 fresh install 启动时 addColumn 报 duplicate column
          try {
            final cols = await customSelect("PRAGMA table_info(poi_cache)").get();
            final hasDescription = cols.any((r) => r.data['name'] == 'description');
            if (!hasDescription) {
              await customStatement('ALTER TABLE poi_cache ADD COLUMN description TEXT NULL');
            }
          } on Exception catch (e) {
            debugPrint('[db] description 幂等迁移失败: $e (可忽略, 后续同步会 fallback)');
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
