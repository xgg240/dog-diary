// ============================================================
//  紧急电话
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../db/database.dart';

import '../../core/ui/modern_widgets.dart';
final _contactsProvider = StreamProvider<List<Contact>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).contacts)
        ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]))
      .watch();
});

class ContactsPage extends ConsumerWidget {
  const ContactsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(_contactsProvider);
    return Scaffold(
      appBar: ModernPageHeader(title: '紧急电话'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (_) => const _ContactSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('新增'),
      ),
      body: contactsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('暂无联系人\n点击右下角 + 添加'));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final c = list[i];
              return Dismissible(
                key: ValueKey(c.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await (ref.read(databaseProvider).delete(ref.read(databaseProvider).contacts)..where((t) => t.id.equals(c.id))).go();
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _color(c.type).withValues(alpha: 0.2),
                    child: Icon(_icon(c.type), color: _color(c.type)),
                  ),
                  title: Text(c.name),
                  subtitle: Text('${_typeLabel(c.type)} · ${c.phone}${c.address != null ? '\n${c.address}' : ''}'),
                  isThreeLine: c.address != null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _color(String t) {
    switch (t) {
      case 'hospital': return Colors.red;
      case 'grooming': return Colors.blue;
      case 'boarding': return Colors.green;
      case 'emergency': return Colors.deepOrange;
      default: return Colors.grey;
    }
  }
  IconData _icon(String t) {
    switch (t) {
      case 'hospital': return Icons.local_hospital;
      case 'grooming': return Icons.content_cut;
      case 'boarding': return Icons.home;
      case 'emergency': return Icons.emergency;
      default: return Icons.phone;
    }
  }
  String _typeLabel(String t) {
    switch (t) {
      case 'hospital': return '医院';
      case 'grooming': return '美容';
      case 'boarding': return '寄养';
      case 'emergency': return '急救';
      default: return '其他';
    }
  }
}

class _ContactSheet extends ConsumerStatefulWidget {
  const _ContactSheet();
  @override
  ConsumerState<_ContactSheet> createState() => _S();
}

class _S extends ConsumerState<_ContactSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  String _type = 'hospital';
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addrCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('名称和电话必填')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(databaseProvider).into(ref.read(databaseProvider).contacts).insert(
        ContactsCompanion(
          name: drift.Value(_nameCtrl.text.trim()),
          phone: drift.Value(_phoneCtrl.text.trim()),
          address: drift.Value(_addrCtrl.text.trim().isEmpty ? null : _addrCtrl.text.trim()),
          type: drift.Value(_type),
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('失败: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('新增联系人', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                for (final t in ['hospital', 'grooming', 'boarding', 'emergency'])
                  ChoiceChip(
                    label: Text({'hospital': '医院', 'grooming': '美容', 'boarding': '寄养', 'emergency': '急救'}[t]!),
                    selected: _type == t,
                    onSelected: (_) => setState(() => _type = t),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: '名称 *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: '电话 *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _addrCtrl, decoration: const InputDecoration(labelText: '地址 (可选)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '保存')),
          ],
        ),
      ),
    );
  }
}
