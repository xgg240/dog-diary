// ============================================================
//  宠物编辑/新建表单
// ============================================================

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../db/database.dart';
import 'pet_repository.dart';

class PetEditSheet extends ConsumerStatefulWidget {
  final Pet? existing;
  const PetEditSheet({super.key, this.existing});

  @override
  ConsumerState<PetEditSheet> createState() => _S();
}

class _S extends ConsumerState<PetEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _breedCtrl;
  late TextEditingController _notesCtrl;
  late DateTime? _birthday;
  late String _gender;
  late bool _neutered;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _breedCtrl = TextEditingController(text: widget.existing?.breed ?? '');
    _notesCtrl = TextEditingController(text: widget.existing?.notes ?? '');
    _birthday = widget.existing?.birthday;
    _gender = widget.existing?.gender ?? 'male';
    _neutered = widget.existing?.neutered ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(petRepoProvider);
      if (widget.existing != null) {
        await repo.update(widget.existing!.copyWith(
          name: _nameCtrl.text.trim(),
          breed: Value(_breedCtrl.text.trim().isEmpty ? null : _breedCtrl.text.trim()),
          birthday: Value(_birthday),
          gender: _gender,
          neutered: _neutered,
          notes: Value(_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
        ));
      } else {
        await repo.create(
          name: _nameCtrl.text.trim(),
          breed: _breedCtrl.text.trim().isEmpty ? null : _breedCtrl.text.trim(),
          birthday: _birthday,
          gender: _gender,
          neutered: _neutered,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('保存失败: $e')));
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.existing != null ? '编辑宠物' : '新增宠物',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: '名字 *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? '请输入名字' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _breedCtrl,
                decoration: const InputDecoration(
                  labelText: '品种',
                  hintText: '如: 柴犬/金毛/泰迪',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('生日'),
                subtitle: Text(_birthday == null ? '未设置' : DateFormat('yyyy-MM-dd').format(_birthday!)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _birthday ?? DateTime(2020, 1, 1),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _birthday = picked);
                },
              ),
              Row(
                children: [
                  const Text('性别:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'male', label: Text('♂ 公')),
                        ButtonSegment(value: 'female', label: Text('♀ 母')),
                      ],
                      selected: {_gender},
                      onSelectionChanged: (s) => setState(() => _gender = s.first),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('已绝育'),
                value: _neutered,
                onChanged: (v) => setState(() => _neutered = v),
              ),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(
                  labelText: '备注',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? '保存中...' : '保存'),
              ),
              if (widget.existing != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('确认删除'),
                        content: Text('确定删除 "${widget.existing!.name}" 吗?\n所有关联数据也会删除。'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
                          FilledButton.tonal(
                            style: FilledButton.styleFrom(foregroundColor: Colors.red),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('删除'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await ref.read(petRepoProvider).delete(widget.existing!.id);
                      if (!mounted) return;
                      if (context.mounted) {
                        Navigator.pop(context); // 关 sheet
                        Navigator.pop(context); // 回详情
                      }
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('删除此宠物', style: TextStyle(color: Colors.red)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
