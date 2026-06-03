// ============================================================
//  数据工具 + 辅助功能
// ============================================================

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/reminder_service.dart';
import '../contacts/contacts_page.dart';
import '../training/training_page.dart';
import '../walks/walks_page.dart';
import '../food/forbidden_foods_page.dart';
import 'data_io.dart';

final _dataIOProvider = Provider<DataIO>((ref) {
  return DataIO(ref.watch(databaseProvider));
});

class ToolsPage extends ConsumerWidget {
  const ToolsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔧 工具')),
      body: ListView(
        children: [
          const _SectionHeader('导出 (可自定义位置)'),
          ListTile(
            leading: const Icon(Icons.backup, color: Colors.blue),
            title: const Text('备份数据库'),
            subtitle: const Text('默认位置: 文档/dog_diary_backups/'),
            onTap: () => _backupDb(context, ref),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: const Icon(Icons.save_alt, color: Colors.blue),
            title: const Text('备份数据库 → 自定义位置'),
            subtitle: const Text('选择保存路径'),
            onTap: () => _backupDbToPath(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.file_download, color: Colors.green),
            title: const Text('导出 Excel'),
            subtitle: const Text('默认位置: 文档/dog_diary_exports/'),
            onTap: () => _exportExcel(context, ref),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: const Icon(Icons.save_alt, color: Colors.green),
            title: const Text('导出 Excel → 自定义位置'),
            subtitle: const Text('选择保存路径'),
            onTap: () => _exportExcelToPath(context, ref),
          ),
          const Divider(),
          const _SectionHeader('导入'),
          ListTile(
            leading: const Icon(Icons.upload, color: Colors.deepOrange),
            title: const Text('导入数据库 (.db)'),
            subtitle: const Text('恢复数据库到上次备份'),
            onTap: () => _importDb(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file, color: Colors.deepOrange),
            title: const Text('导入 Excel (.xlsx)'),
            subtitle: const Text('从导出的 Excel 恢复数据'),
            onTap: () => _importExcel(context, ref),
          ),
          const Divider(),
          const _SectionHeader('通知'),
          ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.orange),
            title: const Text('立即扫描提醒'),
            subtitle: const Text('健康/库存提醒立即检查并弹通知'),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final count = await ref.read(reminderServiceProvider).scanAndNotify();
              messenger.showSnackBar(SnackBar(content: Text(count == 0 ? '当前无待办' : '已发出 $count 条通知')));
            },
          ),
          const Divider(),
          const _SectionHeader('辅助功能'),
          ListTile(leading: const Text('🚫', style: TextStyle(fontSize: 28)), title: const Text('禁食食物库'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForbiddenFoodsPage()))),
          ListTile(leading: const Text('🏥', style: TextStyle(fontSize: 28)), title: const Text('紧急电话'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsPage()))),
          ListTile(leading: const Text('🚶', style: TextStyle(fontSize: 28)), title: const Text('遛狗打卡'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalksPage()))),
          ListTile(leading: const Text('🎓', style: TextStyle(fontSize: 28)), title: const Text('训练日志'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainingPage()))),
          const Divider(),
          const _SectionHeader('外观'),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('主题'),
            trailing: Consumer(builder: (context, ref, _) {
              final mode = ref.watch(themeModeProvider);
              return SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.phone_iphone, size: 16)),
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode, size: 16)),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode, size: 16)),
                ],
                selected: {mode},
                onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).state = s.first,
              );
            }),
          ),
          const Divider(),
          const _SectionHeader('关于'),
          const ListTile(leading: Icon(Icons.info_outline), title: Text('养狗日记 v0.7.0'), subtitle: Text('纯本地单机养宠管理软件')),
        ],
      ),
    );
  }

  // ============ 备份/导出 (默认位置) ============
  Future<void> _backupDb(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    if (kIsWeb) {
      messenger.showSnackBar(const SnackBar(content: Text('Web 平台不支持数据库备份（浏览器沙箱限制）。请使用 Android / iOS / 桌面版。')));
      return;
    }
    try {
      final file = await ref.read(_dataIOProvider).backupDatabase();
      messenger.showSnackBar(SnackBar(content: Text('已备份: ${file.path}'), duration: const Duration(seconds: 6)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('失败: $e')));
    }
  }

  Future<void> _exportExcel(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    if (kIsWeb) {
      messenger.showSnackBar(const SnackBar(content: Text('Web 平台不支持 Excel 导出。请使用 Android / iOS / 桌面版。')));
      return;
    }
    try {
      messenger.showSnackBar(const SnackBar(content: Text('生成中...')));
      final file = await ref.read(_dataIOProvider).exportAllToExcel();
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text('已导出: ${file.path}'), duration: const Duration(seconds: 6)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('失败: $e')));
    }
  }

  // ============ 备份/导出 (自定义位置) ============
  Future<void> _backupDbToPath(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    if (kIsWeb) {
      messenger.showSnackBar(const SnackBar(content: Text('Web 平台不支持数据库备份（浏览器沙箱限制）。请使用 Android / iOS / 桌面版。')));
      return;
    }
    try {
      final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final result = await FilePicker.platform.saveFile(
        dialogTitle: '选择备份保存位置',
        fileName: 'dog_diary_$ts.db',
        type: FileType.any,
      );
      if (result == null) return;
      final file = await ref.read(_dataIOProvider).backupDatabaseTo(result);
      messenger.showSnackBar(SnackBar(content: Text('已保存: ${file.path}'), duration: const Duration(seconds: 6)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('失败: $e')));
    }
  }

  Future<void> _exportExcelToPath(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    if (kIsWeb) {
      messenger.showSnackBar(const SnackBar(content: Text('Web 平台不支持 Excel 导出。请使用 Android / iOS / 桌面版。')));
      return;
    }
    try {
      messenger.showSnackBar(const SnackBar(content: Text('生成中...')));
      final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final result = await FilePicker.platform.saveFile(
        dialogTitle: '选择 Excel 保存位置',
        fileName: 'dog_diary_$ts.xlsx',
        type: FileType.any,
      );
      if (result == null) {
        messenger.hideCurrentSnackBar();
        return;
      }
      final file = await ref.read(_dataIOProvider).exportAllToExcelAt(result);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text('已保存: ${file.path}'), duration: const Duration(seconds: 6)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('失败: $e')));
    }
  }

  // ============ 导入 ============
  Future<void> _importDb(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    if (kIsWeb) {
      messenger.showSnackBar(const SnackBar(content: Text('Web 平台不支持数据库导入。请使用 Android / iOS / 桌面版。')));
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('导入数据库'),
        content: const Text('导入会先自动备份当前数据库，然后替换。\n\n确定继续？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('继续')),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        dialogTitle: '选择 .db 备份文件',
      );
      if (result == null || result.files.isEmpty) return;
      final path = result.files.first.path;
      if (path == null) {
        messenger.showSnackBar(const SnackBar(content: Text('无法读取文件路径')));
        return;
      }
      await ref.read(_dataIOProvider).restoreDatabaseFrom(path);
      messenger.showSnackBar(const SnackBar(
        content: Text('数据库已恢复！请重启 App 加载新数据'),
        duration: Duration(seconds: 6),
      ));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('失败: $e')));
    }
  }

  Future<void> _importExcel(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    if (kIsWeb) {
      messenger.showSnackBar(const SnackBar(content: Text('Web 平台不支持 Excel 导入。请使用 Android / iOS / 桌面版。')));
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('导入 Excel'),
        content: const Text('会按 ID 匹配: 存在的更新, 不存在的插入, 重复的跳过。\n\n确定继续？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('继续')),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
        dialogTitle: '选择 .xlsx 文件',
      );
      if (result == null || result.files.isEmpty) return;
      final path = result.files.first.path;
      if (path == null) {
        messenger.showSnackBar(const SnackBar(content: Text('无法读取文件路径')));
        return;
      }
      final report = await ref.read(_dataIOProvider).importExcelFrom(path);
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text('导入完成: ${report.summary()}'),
        duration: const Duration(seconds: 10),
      ));
      if (report.failed.isNotEmpty) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('失败 ${report.failed.length} 条'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Text(report.failed.take(20).join('\n') + (report.failed.length > 20 ? '\n...' : '')),
              ),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭'))],
          ),
        );
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('失败: $e')));
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
    );
  }
}
