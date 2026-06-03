// ============================================================
//  数据导入导出 (db 备份 / Excel 导出 / 恢复 / 导入)
// ============================================================

import 'dart:io';
import 'package:drift/drift.dart' show Value, Variable;
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../db/database.dart';

class DataIO {
  final AppDatabase db;
  DataIO(this.db);

  /// 关闭 db（恢复前必须关）
  Future<void> _closeDb() async {
    await db.close();
  }

  /// 备份数据库到默认目录 (Documents/dog_diary_backups/)
  Future<File> backupDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(dir.path, 'dog_diary_backups'));
    if (!await backupDir.exists()) await backupDir.create(recursive: true);
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final backupFile = File(p.join(backupDir.path, 'dog_diary_$timestamp.db'));
    final dbFile = File(p.join(dir.path, 'dog_diary.db'));
    await dbFile.copy(backupFile.path);
    return backupFile;
  }

  /// 备份数据库到用户指定路径
  /// [targetPath] 用户选的完整路径（含文件名 .db）
  Future<File> backupDatabaseTo(String targetPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, 'dog_diary.db'));
    final target = File(targetPath);
    await target.parent.create(recursive: true);
    await dbFile.copy(target.path);
    return target;
  }

  /// 从指定 .db 文件恢复数据库
  /// 流程：先备份当前 → 关闭 db → 覆盖 → 重新打开
  Future<void> restoreDatabaseFrom(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'dog_diary.db');

    // 1. 先自动备份当前
    await backupDatabase();

    // 2. 关闭 db
    await _closeDb();

    // 3. 覆盖
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw Exception('源文件不存在: $sourcePath');
    }
    final target = File(dbPath);
    await source.copy(target.path);
  }

  /// 导出全表为 Excel 到默认目录
  Future<File> exportAllToExcel() async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(dir.path, 'dog_diary_exports'));
    if (!await exportDir.exists()) await exportDir.create(recursive: true);
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File(p.join(exportDir.path, 'dog_diary_$timestamp.xlsx'));
    return exportAllToExcelAt(file.path);
  }

  /// 导出全表为 Excel 到用户指定路径
  Future<File> exportAllToExcelAt(String targetPath) async {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Pets');

    _addSheet(excel, 'Pets', ['ID', '名字', '品种', '生日', '性别', '绝育', '备注', '创建时间'],
        await db.select(db.pets).get(),
        (Pet p) => [p.id, p.name, p.breed ?? '', p.birthday?.toIso8601String() ?? '', p.gender, p.neutered ? 1 : 0, p.notes ?? '', p.createdAt.toIso8601String()]);

    _addSheet(excel, 'Weights', ['ID', '宠物ID', '测量时间', '体重(kg)', '备注'],
        await db.select(db.weightRecords).get(),
        (WeightRecord w) => [w.id, w.petId, w.measuredAt.toIso8601String(), w.weightKg, w.notes ?? '']);

    _addSheet(excel, 'Health', ['ID', '宠物ID', '类型', '标题', '描述', '日期', '下次提醒', '医生', '费用'],
        await db.select(db.healthEvents).get(),
        (HealthEvent h) => [h.id, h.petId, h.type, h.title, h.description ?? '', h.eventDate.toIso8601String(), h.nextDueDate?.toIso8601String() ?? '', h.vetName ?? '', h.cost ?? 0]);

    _addSheet(excel, 'Medications', ['ID', '宠物ID', '药物名', '剂量', '频率', '开始', '结束', '备注', '在用'],
        await db.select(db.medications).get(),
        (Medication m) => [m.id, m.petId, m.name, m.dosage ?? '', m.frequency ?? '', m.startDate.toIso8601String(), m.endDate?.toIso8601String() ?? '', m.notes ?? '', m.active ? 1 : 0]);

    _addSheet(excel, 'FoodInventory', ['ID', '宠物ID', '品牌', '产品', '口味', '总(kg)', '余(kg)', '元/kg', '购买日', '过期日'],
        await db.select(db.foodItems).get(),
        (FoodInventory f) => [f.id, f.petId ?? '', f.brand, f.productName, f.flavor ?? '', f.totalKg, f.remainingKg, f.pricePerKg ?? 0, f.purchaseDate.toIso8601String(), f.expireDate?.toIso8601String() ?? '']);

    _addSheet(excel, 'Feeding', ['ID', '宠物ID', '狗粮ID', '时间', '量(kg)', '类型', '备注'],
        await db.select(db.feedingRecords).get(),
        (FeedingRecord f) => [f.id, f.petId, f.foodId ?? '', f.fedAt.toIso8601String(), f.amountKg, f.mealType, f.notes ?? '']);

    _addSheet(excel, 'Expenses', ['ID', '宠物ID', '时间', '金额', '类别', '说明', '支付方式'],
        await db.select(db.expenses).get(),
        (Expense e) => [e.id, e.petId ?? '', e.spentAt.toIso8601String(), e.amount, e.category, e.description ?? '', e.paymentMethod ?? '']);

    _addSheet(excel, 'Walks', ['ID', '宠物ID', '时间', '时长(分)', '距离(km)', '路线', '备注'],
        await db.select(db.walkRecords).get(),
        (WalkRecord w) => [w.id, w.petId, w.walkedAt.toIso8601String(), w.durationMin, w.distanceKm ?? 0, w.route ?? '', w.notes ?? '']);

    _addSheet(excel, 'Training', ['ID', '宠物ID', '指令', '时长(分)', '表现', '时间', '备注'],
        await db.select(db.trainingLogs).get(),
        (TrainingLog t) => [t.id, t.petId, t.command, t.durationMin ?? 0, t.performance ?? '', t.trainedAt.toIso8601String(), t.notes ?? '']);

    _addSheet(excel, 'Forbidden', ['ID', '名字', '英文', '原因', '严重度'],
        await db.select(db.forbiddenFoods).get(),
        (ForbiddenFood f) => [f.id, f.name, f.nameEn ?? '', f.reason, f.severity]);

    final bytes = excel.encode();
    if (bytes == null) throw Exception('Excel 编码失败');
    final target = File(targetPath);
    await target.parent.create(recursive: true);
    await target.writeAsBytes(bytes);
    return target;
  }

  /// 从 Excel 导入数据
  /// [sourcePath] 用户选的 .xlsx
  /// 策略：按 ID 匹配，存在的更新，不存在的插入
  /// 报告：每张表插入了多少条 / 更新了多少条 / 跳过了多少条
  Future<ImportReport> importExcelFrom(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw Exception('文件不存在: $sourcePath');
    }
    final bytes = await source.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    final report = ImportReport();

    for (final sheetName in excel.tables.keys) {
      final sheet = excel.tables[sheetName];
      if (sheet == null) continue;
      final rows = sheet.rows;
      if (rows.isEmpty) continue;

      try {
        switch (sheetName) {
          case 'Pets':
            await _importPets(rows, report);
            break;
          case 'Weights':
            await _importWeights(rows, report);
            break;
          case 'Health':
            await _importHealth(rows, report);
            break;
          case 'Medications':
            await _importMedications(rows, report);
            break;
          case 'FoodInventory':
            await _importFoodInventory(rows, report);
            break;
          case 'Feeding':
            await _importFeeding(rows, report);
            break;
          case 'Expenses':
            await _importExpenses(rows, report);
            break;
          case 'Walks':
            await _importWalks(rows, report);
            break;
          case 'Training':
            await _importTraining(rows, report);
            break;
          case 'Forbidden':
            await _importForbidden(rows, report);
            break;
          default:
            report.skipped.add(sheetName);
        }
      } catch (e) {
        report.failed.add('$sheetName: $e');
      }
    }
    return report;
  }

  Future<void> _importPets(List<List<dynamic>> rows, ImportReport r) async {
    // 第一行是 header, 跳过
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final id = _toInt(row[0]);
        final name = _toStr(row[1]) ?? '';
        if (name.isEmpty) { r.skipped.add('Pets[$i]'); continue; }
        final existing = id != null ? await (db.select(db.pets)..where((t) => t.id.equals(id))).getSingleOrNull() : null;
        if (existing != null) {
          await db.update(db.pets).replace(PetsCompanion(
            id: Value(id!),
            name: Value(name),
            breed: Value(_toStr(row[2])),
            birthday: Value(_toDate(row[3])),
            gender: Value(_toStr(row[4]) ?? 'unknown'),
            neutered: Value(_toInt(row[5]) == 1),
            notes: Value(_toStr(row[6])),
            createdAt: Value(_toDate(row[7]) ?? DateTime.now()),
          ));
          r.updated.add('Pets[$id]');
        } else {
          final newId = await db.into(db.pets).insert(PetsCompanion.insert(
            name: name,
            gender: _toStr(row[4]) ?? 'unknown',
            breed: Value(_toStr(row[2])),
            birthday: Value(_toDate(row[3])),
            neutered: Value(_toInt(row[5]) == 1),
            notes: Value(_toStr(row[6])),
            createdAt: Value(_toDate(row[7]) ?? DateTime.now()),
          ));
          r.inserted.add('Pets[$newId]');
        }
      } catch (e) {
        r.failed.add('Pets[$i]: $e');
      }
    }
  }

  Future<void> _importWeights(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final petId = _toInt(row[1]);
        if (petId == null) { r.skipped.add('Weights[$i]'); continue; }
        final measuredAt = _toDate(row[2]) ?? DateTime.now();
        final existing = await db.customSelect(
          'SELECT * FROM weight_records WHERE pet_id = ? AND measured_at = ? LIMIT 1',
          variables: [Variable.withInt(petId), Variable.withDateTime(measuredAt)],
          readsFrom: {db.weightRecords},
        ).getSingleOrNull();
        if (existing != null) {
          r.skipped.add('Weights[$i](exists)');
          continue;
        }
        if (existing != null) {
          r.skipped.add('Weights[$i](exists)');
          continue;
        }
        await db.into(db.weightRecords).insert(WeightRecordsCompanion.insert(
          petId: petId,
          measuredAt: measuredAt,
          weightKg: _toDouble(row[3]) ?? 0.0,
          notes: Value(_toStr(row[4])),
        ));
        r.inserted.add('Weights[$i]');
      } catch (e) {
        r.failed.add('Weights[$i]: $e');
      }
    }
  }

  Future<void> _importHealth(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final petId = _toInt(row[1]);
        if (petId == null) { r.skipped.add('Health[$i]'); continue; }
        await db.into(db.healthEvents).insert(HealthEventsCompanion.insert(
          petId: petId,
          type: _toStr(row[2]) ?? 'other',
          title: _toStr(row[3]) ?? '',
          description: Value(_toStr(row[4])),
          eventDate: _toDate(row[5]) ?? DateTime.now(),
          nextDueDate: Value(_toDate(row[6])),
          vetName: Value(_toStr(row[7])),
          cost: Value(_toDouble(row[8])),
        ));
        r.inserted.add('Health[$i]');
      } catch (e) {
        r.failed.add('Health[$i]: $e');
      }
    }
  }

  Future<void> _importMedications(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final petId = _toInt(row[1]);
        if (petId == null) { r.skipped.add('Medications[$i]'); continue; }
        await db.into(db.medications).insert(MedicationsCompanion.insert(
          petId: petId,
          name: _toStr(row[2]) ?? '',
          dosage: Value(_toStr(row[3])),
          frequency: Value(_toStr(row[4])),
          startDate: _toDate(row[5]) ?? DateTime.now(),
          endDate: Value(_toDate(row[6])),
          notes: Value(_toStr(row[7])),
          active: Value(_toInt(row[8]) == 1),
        ));
        r.inserted.add('Medications[$i]');
      } catch (e) {
        r.failed.add('Medications[$i]: $e');
      }
    }
  }

  Future<void> _importFoodInventory(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final petId = _toInt(row[1]);
        await db.into(db.foodItems).insert(FoodItemsCompanion.insert(
          petId: Value(petId),
          brand: _toStr(row[2]) ?? '',
          productName: _toStr(row[3]) ?? '',
          flavor: Value(_toStr(row[4])),
          totalKg: _toDouble(row[5]) ?? 0.0,
          remainingKg: _toDouble(row[6]) ?? 0.0,
          pricePerKg: Value(_toDouble(row[7])),
          purchaseDate: _toDate(row[8]) ?? DateTime.now(),
          expireDate: Value(_toDate(row[9])),
        ));
        r.inserted.add('FoodInventory[$i]');
      } catch (e) {
        r.failed.add('FoodInventory[$i]: $e');
      }
    }
  }

  Future<void> _importFeeding(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final petId = _toInt(row[1]);
        if (petId == null) { r.skipped.add('Feeding[$i]'); continue; }
        await db.into(db.feedingRecords).insert(FeedingRecordsCompanion.insert(
          petId: petId,
          fedAt: _toDate(row[3]) ?? DateTime.now(),
          amountKg: _toDouble(row[4]) ?? 0.0,
          foodId: Value(_toInt(row[2])),
          mealType: Value(_toStr(row[5]) ?? 'meal'),
          notes: Value(_toStr(row[6])),
        ));
        r.inserted.add('Feeding[$i]');
      } catch (e) {
        r.failed.add('Feeding[$i]: $e');
      }
    }
  }

  Future<void> _importExpenses(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final petId = _toInt(row[1]);
        await db.into(db.expenses).insert(ExpensesCompanion.insert(
          petId: Value(petId),
          spentAt: _toDate(row[2]) ?? DateTime.now(),
          amount: _toDouble(row[3]) ?? 0.0,
          category: _toStr(row[4]) ?? 'other',
          description: Value(_toStr(row[5])),
          paymentMethod: Value(_toStr(row[6])),
        ));
        r.inserted.add('Expenses[$i]');
      } catch (e) {
        r.failed.add('Expenses[$i]: $e');
      }
    }
  }

  Future<void> _importWalks(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final petId = _toInt(row[1]);
        if (petId == null) { r.skipped.add('Walks[$i]'); continue; }
        await db.into(db.walkRecords).insert(WalkRecordsCompanion.insert(
          petId: petId,
          walkedAt: _toDate(row[2]) ?? DateTime.now(),
          durationMin: _toInt(row[3]) ?? 0,
          distanceKm: Value(_toDouble(row[4])),
          route: Value(_toStr(row[5])),
          notes: Value(_toStr(row[6])),
        ));
        r.inserted.add('Walks[$i]');
      } catch (e) {
        r.failed.add('Walks[$i]: $e');
      }
    }
  }

  Future<void> _importTraining(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final petId = _toInt(row[1]);
        if (petId == null) { r.skipped.add('Training[$i]'); continue; }
        await db.into(db.trainingLogs).insert(TrainingLogsCompanion.insert(
          petId: petId,
          command: _toStr(row[2]) ?? '',
          durationMin: Value(_toInt(row[3])),
          performance: Value(_toStr(row[4])),
          trainedAt: _toDate(row[5]) ?? DateTime.now(),
          notes: Value(_toStr(row[6])),
        ));
        r.inserted.add('Training[$i]');
      } catch (e) {
        r.failed.add('Training[$i]: $e');
      }
    }
  }

  Future<void> _importForbidden(List<List<dynamic>> rows, ImportReport r) async {
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      try {
        final name = _toStr(row[1]) ?? '';
        if (name.isEmpty) { r.skipped.add('Forbidden[$i]'); continue; }
        final existing = await (db.select(db.forbiddenFoods)..where((t) => t.name.equals(name))).getSingleOrNull();
        if (existing != null) { r.skipped.add('Forbidden[$name]'); continue; }
        await db.into(db.forbiddenFoods).insert(ForbiddenFoodsCompanion.insert(
          name: name,
          nameEn: Value(_toStr(row[2])),
          reason: _toStr(row[3]) ?? '',
          severity: _toStr(row[4]) ?? 'high',
        ));
        r.inserted.add('Forbidden[$name]');
      } catch (e) {
        r.failed.add('Forbidden[$i]: $e');
      }
    }
  }

  // ============ Helpers ============
  String? _toStr(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString().trim());
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString().trim());
  }

  DateTime? _toDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is int) {
      // Excel serial date: days since 1900-01-01 (with 1900 leap year bug)
      try {
        return DateTime(1900, 1, 1).add(Duration(days: v - 2));
      } catch (_) {
        return null;
      }
    }
    if (v is double) {
      try {
        return DateTime(1900, 1, 1).add(Duration(days: v.toInt() - 2));
      } catch (_) {
        return null;
      }
    }
    return DateTime.tryParse(v.toString().trim());
  }

  void _addSheet<T>(Excel excel, String name, List<String> headers, List<T> rows, List<Object?> Function(T) mapper) {
    final sheet = excel[name];
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    for (final r in rows) {
      final cells = mapper(r).map((v) {
        if (v == null) return TextCellValue('');
        if (v is int) return IntCellValue(v);
        if (v is double) return DoubleCellValue(v);
        return TextCellValue(v.toString());
      }).toList();
      sheet.appendRow(cells);
    }
  }
}

class ImportReport {
  final List<String> inserted = [];
  final List<String> updated = [];
  final List<String> skipped = [];
  final List<String> failed = [];

  String summary() {
    return '插入: ${inserted.length}, 更新: ${updated.length}, 跳过: ${skipped.length}, 失败: ${failed.length}';
  }
}
