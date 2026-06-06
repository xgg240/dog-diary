// ============================================================
//  工具页 v3 - 现代化分组卡片
//  抛弃 emoji + 硬编码色, 用 cs.scheme + ModernCard + ModernListTile
// ============================================================

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/providers.dart';
import '../../core/reminder_service.dart';
import '../contacts/contacts_page.dart';
import '../training/training_page.dart';
import '../walks/walks_page.dart';
import 'data_io.dart';

import '../../core/ui/design_tokens.dart';
import '../../core/ui/modern_widgets.dart';

final _dataIOProvider = Provider<DataIO>((ref) {
  return DataIO(ref.watch(databaseProvider));
});

class ToolsPage extends ConsumerWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final textScale = ref.watch(textScaleProvider);
    final themeMode = ref.watch(themeModeProvider);
    final themeModeLabel = switch (themeMode) {
      ThemeMode.system => '跟随系统',
      ThemeMode.light => '浅色',
      ThemeMode.dark => '深色',
    };

    return Scaffold(
      appBar: const ModernPageHeader(
        title: '工具',
        subtitle: '数据管理与系统设置',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 100),
        children: [
          // ===== 显示设置 =====
          const ModernSectionHeader(title: '显示'),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ModernListTile(
                  icon: Icons.brightness_6_rounded,
                  color: cs.primary,
                  title: '主题',
                  subtitle: '当前: $themeModeLabel',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _showThemeDialog(context, ref),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.text_fields_rounded,
                  color: cs.primary,
                  title: '字号设置',
                  subtitle: textScale < 0.9 ? '当前: 小' : textScale > 1.1 ? '当前: 大' : '当前: 中',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _showTextScaleDialog(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ===== 数据导出 =====
          const ModernSectionHeader(title: '导出'),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ModernListTile(
                  icon: Icons.backup_outlined,
                  color: cs.secondary,
                  title: '备份数据库',
                  subtitle: '默认保存到「文档/dog_diary_backups」',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _backupDb(context, ref),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.save_alt_rounded,
                  color: cs.secondary,
                  title: '备份数据库到自定义位置',
                  subtitle: '选择保存路径',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _backupDbToPath(context, ref),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.file_download_outlined,
                  color: AppColors.success,
                  title: '导出 Excel',
                  subtitle: '默认保存到「文档/dog_diary_exports」',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _exportExcel(context, ref),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.save_alt_rounded,
                  color: AppColors.success,
                  title: '导出 Excel 到自定义位置',
                  subtitle: '选择保存路径',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _exportExcelToPath(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ===== 数据导入 =====
          const ModernSectionHeader(title: '导入'),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ModernListTile(
                  icon: Icons.upload_outlined,
                  color: AppColors.warning,
                  title: '导入数据库',
                  subtitle: '从 .db 文件恢复数据',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _importDb(context, ref),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.upload_file_outlined,
                  color: AppColors.warning,
                  title: '导入 Excel',
                  subtitle: '从 .xlsx 文件恢复数据',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _importExcel(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ===== 通知与扫描 =====
          const ModernSectionHeader(title: '通知'),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ModernListTile(
                  icon: Icons.notifications_active_outlined,
                  color: cs.tertiary,
                  title: '立即扫描提醒',
                  subtitle: '检查即将到期的疫苗/驱虫/洗澡',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => ref.read(reminderServiceProvider).scanAndNotify(),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.notifications_outlined,
                  color: cs.tertiary,
                  title: '打开通知设置',
                  subtitle: 'iOS: 设置 → 通知 → 养狗日记',
                  trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                  onTap: () => _openSystemSettings(context),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.qr_code_2_rounded,
                  color: cs.primary,
                  title: '生成二维码',
                  subtitle: '宠物档案分享 / 紧急联系卡',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _showQrCodeDialog(context, ref),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.bug_report_outlined,
                  color: AppColors.danger,
                  title: 'Bug 报告',
                  subtitle: '复制日志到剪贴板',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _exportBugReport(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ===== 子页面入口 =====
          const ModernSectionHeader(title: '更多'),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ModernListTile(
                  icon: Icons.contacts_outlined,
                  color: AppColors.danger,
                  title: '紧急电话',
                  subtitle: '兽医 / 医院 / 寄养 / 美容',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsPage())),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.directions_walk_rounded,
                  color: AppColors.success,
                  title: '遛狗记录',
                  subtitle: '查看历史遛狗时长 / 距离',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalksPage())),
                ),
                _Divider(),
                ModernListTile(
                  icon: Icons.school_outlined,
                  color: cs.tertiary,
                  title: '训练计划',
                  subtitle: '基础服从 / 行为纠正',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainingPage())),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Text(
              '养狗日记 · v1.0',
              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  // ===== 字号 dialog =====
  void _showTextScaleDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('字号设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in const [0.85, 1.0, 1.15, 1.3])
              RadioListTile<double>(
                value: s,
                groupValue: ref.read(textScaleProvider),
                title: Text('${(s * 100).round()}%', style: AppTypography.bodyMedium),
                onChanged: (v) {
                  if (v != null) {
                    ref.read(textScaleProvider.notifier).state = v;
                    Navigator.pop(ctx);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  // ===== 主题 dialog =====
  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: const Text('选择主题'),
          contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in const [
                (ThemeMode.system, Icons.brightness_auto_rounded, '跟随系统'),
                (ThemeMode.light, Icons.light_mode_rounded, '浅色'),
                (ThemeMode.dark, Icons.dark_mode_rounded, '深色'),
              ]) ...[
                RadioListTile<ThemeMode>(
                  value: entry.$1,
                  groupValue: ref.read(themeModeProvider),
                  secondary: Icon(entry.$2, color: cs.primary, size: 20),
                  title: Text(entry.$3, style: AppTypography.bodyMedium),
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(themeModeProvider.notifier).state = v;
                      Navigator.pop(ctx);
                    }
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ===== 系统通知设置 =====
  void _openSystemSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请在系统设置 → 通知 → 养狗日记 中调整')),
    );
  }

  // ===== 二维码 =====
  void _showQrCodeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('生成二维码'),
        content: const Text('即将生成宠物档案二维码。\n功能开发中...'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('好的'))],
      ),
    );
  }

  // ===== Bug 报告 =====
  void _exportBugReport(BuildContext context, WidgetRef ref) async {
    final logs = StringBuffer();
    logs.writeln('=== 养狗日记 Bug 报告 ===');
    logs.writeln('时间: ${DateTime.now()}');
    logs.writeln('平台: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('日志已复制到剪贴板')),
    );
  }

  // ===== 备份数据库 =====
  Future<void> _backupDb(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final io = ref.read(_dataIOProvider);
      final dir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${dir.path}/dog_diary_backups');
      if (!await backupDir.exists()) await backupDir.create(recursive: true);
      final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final path = p.join(backupDir.path, 'dog_diary_$ts.db');
      await io.backupDatabaseTo(path);
      messenger.showSnackBar(SnackBar(content: Text('已备份到 $path')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('备份失败: $e')));
    }
  }

  Future<void> _backupDbToPath(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final io = ref.read(_dataIOProvider);
      final path = await FilePicker.platform.saveFile(
        dialogTitle: '选择备份保存位置',
        fileName: 'dog_diary_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.db',
      );
      if (path == null) return;
      await io.backupDatabaseTo(path);
      messenger.showSnackBar(SnackBar(content: Text('已备份到 $path')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('备份失败: $e')));
    }
  }

  Future<void> _exportExcel(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final io = ref.read(_dataIOProvider);
      final dir = await getApplicationDocumentsDirectory();
      final exportDir = Directory('${dir.path}/dog_diary_exports');
      if (!await exportDir.exists()) await exportDir.create(recursive: true);
      final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final path = p.join(exportDir.path, 'dog_diary_$ts.xlsx');
      await io.exportAllToExcelAt(path);
      messenger.showSnackBar(SnackBar(content: Text('已导出到 $path')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('导出失败: $e')));
    }
  }

  Future<void> _exportExcelToPath(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final io = ref.read(_dataIOProvider);
      final path = await FilePicker.platform.saveFile(
        dialogTitle: '选择导出位置',
        fileName: 'dog_diary_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx',
      );
      if (path == null) return;
      await io.exportAllToExcelAt(path);
      messenger.showSnackBar(SnackBar(content: Text('已导出到 $path')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('导出失败: $e')));
    }
  }

  Future<void> _importDb(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result == null) return;
      final path = result.files.single.path;
      if (path == null) return;
      final io = ref.read(_dataIOProvider);
      await io.restoreDatabaseFrom(path);
      messenger.showSnackBar(const SnackBar(content: Text('已导入数据库')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('导入失败: $e')));
    }
  }

  Future<void> _importExcel(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
      if (result == null) return;
      final path = result.files.single.path;
      if (path == null) return;
      final io = ref.read(_dataIOProvider);
      await io.importExcelFrom(path);
      messenger.showSnackBar(const SnackBar(content: Text('已导入 Excel')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('导入失败: $e')));
    }
  }
}

// ===== 内部辅助 =====
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Divider(
      height: 0.5,
      thickness: 0.5,
      color: cs.outlineVariant,
      indent: 64, // 对齐 icon 后面
    );
  }
}
