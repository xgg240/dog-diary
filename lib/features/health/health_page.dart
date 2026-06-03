// ============================================================
//  健康事件 + 用药管理
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../db/database.dart';
import 'health_repository.dart';

final _eventsProvider = StreamProvider<List<HealthEvent>>((ref) {
  return ref.watch(healthRepoProvider).watchEvents();
});
final _upcomingProvider = StreamProvider<List<HealthEvent>>((ref) {
  return ref.watch(healthRepoProvider).watchUpcomingDue();
});
final _overdueProvider = StreamProvider<List<HealthEvent>>((ref) {
  return ref.watch(healthRepoProvider).watchOverdue();
});
final _medsProvider = StreamProvider<List<Medication>>((ref) {
  return ref.watch(healthRepoProvider).watchMedications(activeOnly: true);
});

class HealthPage extends ConsumerWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdueAsync = ref.watch(_overdueProvider);
    final upcomingAsync = ref.watch(_upcomingProvider);
    final eventsAsync = ref.watch(_eventsProvider);
    final medsAsync = ref.watch(_medsProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('❤️ 健康'),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.event_note), text: '事件'),
            Tab(icon: Icon(Icons.medication), text: '用药'),
            Tab(icon: Icon(Icons.alarm), text: '提醒'),
          ]),
        ),
        floatingActionButton: Builder(builder: (ctx) {
          final tab = DefaultTabController.of(ctx).index;
          return FloatingActionButton.extended(
            onPressed: () {
              if (tab == 0) {
                _openEventSheet(context, ref);
              } else if (tab == 1) {
                _openMedSheet(context, ref);
              }
            },
            icon: const Icon(Icons.add),
            label: Text(tab == 0 ? '事件' : tab == 1 ? '用药' : ''),
          );
        }),
        body: TabBarView(children: [
          _EventsTab(eventsAsync: eventsAsync),
          _MedsTab(medsAsync: medsAsync),
          _AlertsTab(overdueAsync: overdueAsync, upcomingAsync: upcomingAsync),
        ]),
      ),
    );
  }

  void _openEventSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const _EventSheet(),
    );
  }
  void _openMedSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const _MedSheet(),
    );
  }
}

class _EventsTab extends ConsumerWidget {
  final AsyncValue<List<HealthEvent>> eventsAsync;
  const _EventsTab({required this.eventsAsync});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('错误: $e')),
      data: (list) {
        if (list.isEmpty) return const Center(child: Text('暂无健康事件\n点击右下角添加'));
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final e = list[i];
            return Dismissible(
              key: ValueKey(e.id),
              direction: DismissDirection.endToStart,
              background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
              onDismissed: (_) async {
                await ref.read(healthRepoProvider).deleteEvent(e.id);
              },
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: _typeColor(e.type).withValues(alpha: 0.2), child: Icon(_typeIcon(e.type), color: _typeColor(e.type))),
                  title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${_typeLabel(e.type)} · ${DateFormat('yyyy-MM-dd').format(e.eventDate)}${e.vetName != null ? ' · ${e.vetName}' : ''}'),
                  trailing: e.nextDueDate != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('下次', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text(DateFormat('MM-dd').format(e.nextDueDate!)),
                          ],
                        )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
  Color _typeColor(String t) {
    switch (t) {
      case 'checkup': return Colors.blue;
      case 'vaccine': return Colors.green;
      case 'deworm': return Colors.orange;
      case 'flea': return Colors.purple;
      case 'surgery': return Colors.red;
      default: return Colors.grey;
    }
  }
  IconData _typeIcon(String t) {
    switch (t) {
      case 'checkup': return Icons.medical_services;
      case 'vaccine': return Icons.vaccines;
      case 'deworm': return Icons.bug_report;
      case 'flea': return Icons.pest_control;
      case 'surgery': return Icons.local_hospital;
      default: return Icons.event_note;
    }
  }
  String _typeLabel(String t) {
    switch (t) {
      case 'checkup': return '体检';
      case 'vaccine': return '疫苗';
      case 'deworm': return '驱虫';
      case 'flea': return '跳蚤';
      case 'surgery': return '手术';
      default: return '其他';
    }
  }
}

class _MedsTab extends ConsumerWidget {
  final AsyncValue<List<Medication>> medsAsync;
  const _MedsTab({required this.medsAsync});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return medsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('错误: $e')),
      data: (list) {
        if (list.isEmpty) return const Center(child: Text('暂无用药\n点击右下角添加'));
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final m = list[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.teal.withValues(alpha: 0.2), child: const Icon(Icons.medication, color: Colors.teal)),
                title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${m.dosage ?? '-'} · ${m.frequency ?? '-'} · ${DateFormat('yyyy-MM-dd').format(m.startDate)} 起'),
                trailing: Switch(
                  value: m.active,
                  onChanged: (_) async {
                    await ref.read(healthRepoProvider).toggleMedication(m);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AlertsTab extends StatelessWidget {
  final AsyncValue<List<HealthEvent>> overdueAsync;
  final AsyncValue<List<HealthEvent>> upcomingAsync;
  const _AlertsTab({required this.overdueAsync, required this.upcomingAsync});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        overdueAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, st) => ListTile(title: Text('错误: $e')),
          data: (list) {
            if (list.isEmpty) return const SizedBox.shrink();
            return Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.warning, color: Colors.red), SizedBox(width: 8), Text('已逾期', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))]),
                    const SizedBox(height: 8),
                    for (final e in list)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(e.title),
                        subtitle: Text('${_label(e.type)} · 逾期 ${DateFormat('MM-dd').format(e.nextDueDate!)}'),
                        trailing: const Icon(Icons.arrow_forward, size: 16),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        upcomingAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, st) => ListTile(title: Text('错误: $e')),
          data: (list) {
            if (list.isEmpty) return const Card(child: ListTile(title: Text('30 天内无提醒')));
            return Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.alarm, color: Colors.orange), SizedBox(width: 8), Text('即将到期 (30 天内)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))]),
                    const SizedBox(height: 8),
                    for (final e in list)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(e.title),
                        subtitle: Text('${_label(e.type)} · ${DateFormat('MM-dd').format(e.nextDueDate!)}'),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _label(String t) {
    switch (t) {
      case 'checkup': return '体检';
      case 'vaccine': return '疫苗';
      case 'deworm': return '驱虫';
      case 'flea': return '跳蚤';
      case 'surgery': return '手术';
      default: return '其他';
    }
  }
}

class _EventSheet extends ConsumerStatefulWidget {
  const _EventSheet();
  @override
  ConsumerState<_EventSheet> createState() => _EventS();
}

class _EventS extends ConsumerState<_EventSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _vetCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  int? _petId;
  String _type = 'checkup';
  DateTime _eventDate = DateTime.now();
  DateTime? _nextDue;
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _vetCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_petId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先创建宠物')));
      return;
    }
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入标题')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(healthRepoProvider).addEvent(
        petId: _petId!,
        type: _type,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        eventDate: _eventDate,
        nextDueDate: _nextDue,
        vetName: _vetCtrl.text.trim().isEmpty ? null : _vetCtrl.text.trim(),
        cost: double.tryParse(_costCtrl.text.trim()),
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
    final petsAsync = ref.watch(petsStreamProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('新增健康事件', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          petsAsync.maybeWhen(
            data: (pets) {
              if (pets.isEmpty) return const Text('请先创建宠物');
              _petId ??= pets.first.id;
              return DropdownButtonFormField<int>(
                initialValue: _petId,
                decoration: const InputDecoration(labelText: '宠物', border: OutlineInputBorder()),
                items: [for (final p in pets) DropdownMenuItem(value: p.id, child: Text(p.name))],
                onChanged: (v) => setState(() => _petId = v),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          const Text('类型'),
          const SizedBox(height: 4),
          Wrap(spacing: 8, children: [
            for (final t in ['checkup', 'vaccine', 'deworm', 'flea', 'surgery', 'other'])
              ChoiceChip(
                label: Text({'checkup': '体检', 'vaccine': '疫苗', 'deworm': '驱虫', 'flea': '跳蚤', 'surgery': '手术', 'other': '其他'}[t]!),
                selected: _type == t,
                onSelected: (_) => setState(() => _type = t),
              ),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: '标题 *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: '描述', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('事件日期'),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(_eventDate)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _eventDate, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 365)));
              if (d != null) setState(() => _eventDate = d);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('下次提醒'),
            subtitle: Text(_nextDue == null ? '不提醒' : DateFormat('yyyy-MM-dd').format(_nextDue!)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (_nextDue != null) IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _nextDue = null)),
              const Icon(Icons.chevron_right),
            ]),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _nextDue ?? DateTime.now().add(const Duration(days: 365)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365 * 3)));
              if (d != null) setState(() => _nextDue = d);
            },
          ),
          TextField(controller: _vetCtrl, decoration: const InputDecoration(labelText: '医生/医院', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _costCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: '费用 (元)', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '保存')),
        ]),
      ),
    );
  }
}

class _MedSheet extends ConsumerStatefulWidget {
  const _MedSheet();
  @override
  ConsumerState<_MedSheet> createState() => _MedS();
}

class _MedS extends ConsumerState<_MedSheet> {
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  int? _petId;
  String _freq = 'daily';
  DateTime _startDate = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_petId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先创建宠物')));
      return;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入药名')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(healthRepoProvider).addMedication(
        petId: _petId!,
        name: _nameCtrl.text.trim(),
        dosage: _dosageCtrl.text.trim().isEmpty ? null : _dosageCtrl.text.trim(),
        frequency: _freq,
        startDate: _startDate,
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
    final petsAsync = ref.watch(petsStreamProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('新增用药', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          petsAsync.maybeWhen(
            data: (pets) {
              if (pets.isEmpty) return const Text('请先创建宠物');
              _petId ??= pets.first.id;
              return DropdownButtonFormField<int>(
                initialValue: _petId,
                decoration: const InputDecoration(labelText: '宠物', border: OutlineInputBorder()),
                items: [for (final p in pets) DropdownMenuItem(value: p.id, child: Text(p.name))],
                onChanged: (v) => setState(() => _petId = v),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: '药名 *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _dosageCtrl, decoration: const InputDecoration(labelText: '剂量 (如 1片/次)', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const Text('频率'),
          const SizedBox(height: 4),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'daily', label: Text('每日')),
              ButtonSegment(value: 'weekly', label: Text('每周')),
              ButtonSegment(value: 'monthly', label: Text('每月')),
            ],
            selected: {_freq},
            onSelectionChanged: (s) => setState(() => _freq = s.first),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('开始日期'),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(_startDate)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _startDate, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 365)));
              if (d != null) setState(() => _startDate = d);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '保存')),
        ]),
      ),
    );
  }
}
