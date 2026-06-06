// ============================================================
//  月度 PDF 报告（v4 Stage 2）
// ------------------------------------------------------------
//  给兽医的"病史简报"—— 一页 PDF 包含:
//    宠物基本信息 / 体重趋势 / 健康事件 / 用药 / 本月消费
// ============================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/pet_switcher_provider.dart';
import '../../core/providers.dart';
import '../../db/database.dart';

class MonthlyReportPage extends ConsumerStatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  ConsumerState<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends ConsumerState<MonthlyReportPage> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month, 1);
  bool _building = false;

  Future<pw.Document> _buildPdf(Pet pet) async {
    final db = ref.read(databaseProvider);
    final start = _month;
    final end = DateTime(_month.year, _month.month + 1, 1);

    // 体重记录
    final weights = await (db.select(db.weightRecords)
          ..where((t) =>
              t.petId.equals(pet.id) &
              t.measuredAt.isBetweenValues(start, end))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.measuredAt)]))
        .get();

    // 健康事件
    final events = await (db.select(db.healthEvents)
          ..where((t) =>
              t.petId.equals(pet.id) &
              t.eventDate.isBetweenValues(start, end))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.eventDate)]))
        .get();

    // 活跃用药
    final meds = await (db.select(db.medications)
          ..where((t) => t.petId.equals(pet.id) & t.active.equals(true)))
        .get();

    // 本月消费
    final expenses = await (db.select(db.expenses)
          ..where((t) =>
              t.petId.equals(pet.id) &
              t.spentAt.isBetweenValues(start, end)))
        .get();
    final totalExp = expenses.fold<double>(0, (s, e) => s + e.amount);

    // 遛狗 + 训练次数
    final walks = await (db.select(db.walkRecords)
          ..where((t) =>
              t.petId.equals(pet.id) &
              t.walkedAt.isBetweenValues(start, end)))
        .get();
    final trainings = await (db.select(db.trainingLogs)
          ..where((t) =>
              t.petId.equals(pet.id) &
              t.trainedAt.isBetweenValues(start, end)))
        .get();

    final pdf = pw.Document();
    final df = DateFormat('yyyy-MM-dd');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (ctx) => [
          // 标题
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('养狗日记 · 月度健康简报',
                    style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.Text('${df.format(start)} ~ ${df.format(end.subtract(const Duration(days: 1)))}',
                    style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
              ],
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Divider(),
          pw.SizedBox(height: 12),

          // 宠物基本信息
          pw.Text('🐕 宠物信息', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Bullet(text: '名字: ${pet.name}'),
          if (pet.breed != null) pw.Bullet(text: '品种: ${pet.breed}'),
          pw.Bullet(text: '性别: ${pet.gender}'),
          if (pet.birthday != null)
            pw.Bullet(text: '生日: ${df.format(pet.birthday!)} (${_ageString(pet.birthday!)})'),
          pw.Bullet(text: '绝育: ${pet.neutered ? "是" : "否"}'),
          pw.SizedBox(height: 12),

          // 体重
          pw.Text('⚖️ 体重记录 (${weights.length} 次)', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          if (weights.isEmpty)
            pw.Text('本月无体重记录', style: const pw.TextStyle(color: PdfColors.grey600))
          else
            pw.TableHelper.fromTextArray(
              headers: ['日期', '体重(公斤)'],
              data: weights.map((w) => [df.format(w.measuredAt), w.weightKg.toStringAsFixed(2)]).toList(),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          pw.SizedBox(height: 12),

          // 健康事件
          pw.Text('🏥 健康事件 (${events.length} 次)', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          if (events.isEmpty)
            pw.Text('本月无健康事件', style: const pw.TextStyle(color: PdfColors.grey600))
          else
            pw.TableHelper.fromTextArray(
              headers: ['日期', '类型', '标题', '下次到期'],
              data: events.map((e) => [
                df.format(e.eventDate),
                e.type,
                e.title,
                e.nextDueDate != null ? df.format(e.nextDueDate!) : '-',
              ]).toList(),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          pw.SizedBox(height: 12),

          // 活跃用药
          pw.Text('💊 当前活跃用药 (${meds.length} 种)', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          if (meds.isEmpty)
            pw.Text('当前无活跃用药', style: const pw.TextStyle(color: PdfColors.grey600))
          else
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: meds.map((m) => pw.Bullet(text: '${m.name} · ${m.dosage ?? "-"} · ${m.frequency ?? "-"} · ${df.format(m.startDate)} 起')).toList(),
            ),
          pw.SizedBox(height: 12),

          // 活动统计
          pw.Text('📊 活动统计', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Bullet(text: '遛狗 ${walks.length} 次 (总时长 ${walks.fold<int>(0, (s, w) => s + w.durationMin)} 分钟)'),
          pw.Bullet(text: '训练 ${trainings.length} 次'),
          pw.SizedBox(height: 12),

          // 消费
          pw.Text('💰 本月消费', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Bullet(text: '合计: ¥${totalExp.toStringAsFixed(2)}'),
          for (final cat in _groupExpenseByCategory(expenses).entries)
            pw.Bullet(text: '${cat.key}: ¥${cat.value.toStringAsFixed(2)}'),

          pw.SizedBox(height: 24),
          pw.Divider(),
          pw.Text('本简报由养狗日记 App 自动生成 · ${df.format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
        ],
      ),
    );
    return pdf;
  }

  String _ageString(DateTime birthday) {
    final now = DateTime.now();
    final years = now.year - birthday.year;
    final months = now.month - birthday.month;
    return '$years 岁 ${months < 0 ? months + 12 : months} 月';
  }

  Map<String, double> _groupExpenseByCategory(List<Expense> list) {
    final m = <String, double>{};
    for (final e in list) {
      m[e.category] = (m[e.category] ?? 0) + e.amount;
    }
    return m;
  }

  Future<void> _generate() async {
    final pet = ref.read(currentPetProvider);
    if (pet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先在仪表盘选一只狗')),
      );
      return;
    }
    setState(() => _building = true);
    try {
      final pdf = await _buildPdf(pet);
      // 写入文件
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'report_${pet.name}_${DateFormat('yyyyMM').format(_month)}.pdf'));
      await file.writeAsBytes(await pdf.save());

      // 弹出打印预览（也可分享/保存）
      if (!mounted) return;
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: '${pet.name}_月度报告_${DateFormat('yyyyMM').format(_month)}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('生成失败: $e')));
      }
    } finally {
      if (mounted) setState(() => _building = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(currentPetProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('月度报告 (PDF)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('选择月份'),
                subtitle: Text(DateFormat('yyyy 年 M 月').format(_month)),
                trailing: const Icon(Icons.edit_calendar),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _month,
                    firstDate: DateTime(2020, 1, 1),
                    lastDate: DateTime.now(),
                    helpText: '选择月份',
                  );
                  if (picked != null) {
                    setState(() => _month = DateTime(picked.year, picked.month, 1));
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            if (pet == null)
              const Card(
                color: Colors.amber,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.warning),
                      SizedBox(width: 8),
                      Expanded(child: Text('请先在仪表盘顶部选择一只狗')),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: ListTile(
                  leading: const Icon(Icons.pets, color: Colors.teal),
                  title: Text('为 ${pet.name} 生成报告'),
                  subtitle: const Text('PDF 含体重/健康/用药/消费汇总'),
                ),
              ),
            const Spacer(),
            FilledButton.icon(
              icon: _building
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.picture_as_pdf),
              label: Text(_building ? '生成中...' : '生成并预览 PDF'),
              onPressed: _building ? null : _generate,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
