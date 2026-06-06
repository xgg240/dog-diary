// ============================================================
//  健康事件 + 用药管理
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../db/database.dart';
import 'health_repository.dart';
import 'drug_interaction_banner.dart';

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
      child: Builder(
        builder: (ctx) {
          // ctx 在 DefaultTabController 子树内, 可以正确拿到 controller
          return Scaffold(
            appBar: AppBar(
              title: const Text('❤️ 健康'),
              bottom: const TabBar(tabs: [
                Tab(icon: Icon(Icons.event_note), text: '事件'),
                Tab(icon: Icon(Icons.medication), text: '用药'),
                Tab(icon: Icon(Icons.alarm), text: '提醒'),
              ]),
            ),
            floatingActionButton: AnimatedBuilder(
              animation: DefaultTabController.of(ctx),
              builder: (innerCtx, _) {
                final tab = DefaultTabController.of(innerCtx).index;
                return FloatingActionButton.extended(
                  onPressed: () {
                    if (tab == 0) {
                      _openEventSheet(innerCtx, ref);
                    } else if (tab == 1) {
                      _openMedSheet(innerCtx, ref);
                    } else if (tab == 2) {
                      _openAlertSheet(innerCtx, ref);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: Text(tab == 0 ? '事件' : tab == 1 ? '用药' : '提醒'),
                );
              },
            ),
            body: TabBarView(children: [
              Column(children: [
                const DrugInteractionBanner(),
                Expanded(child: _EventsTab(eventsAsync: eventsAsync)),
              ]),
              _MedsTab(medsAsync: medsAsync),
              _AlertsTab(overdueAsync: overdueAsync, upcomingAsync: upcomingAsync),
            ]),
          );
        },
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
  void _openAlertSheet(BuildContext context, WidgetRef ref) {
    // 提醒专用的 sheet: 强制要求 nextDueDate
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const _ReminderSheet(),
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
        final petsAsync = ref.watch(petsStreamProvider);
        final petNameMap = petsAsync.maybeWhen(
          data: (pets) => {for (final p in pets) p.id: p.name},
          orElse: () => <int, String>{},
        );
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final e = list[i];
            final petName = petNameMap[e.petId] ?? '未知宠物';
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
                  title: Text('$petName · ${e.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                  e.type == 'medication'
                      ? '${_typeLabel(e.type)} · ${e.dosage ?? '-'} · ${DateFormat('yyyy-MM-dd').format(e.eventDate)}'
                      : '${_typeLabel(e.type)} · ${DateFormat('yyyy-MM-dd').format(e.eventDate)}${e.vetName != null ? ' · ${e.vetName}' : ''}',
                ),
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
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      showDragHandle: true,
                      builder: (_) => _EventSheet(existing: e),
                    );
                  },
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
      case 'medication': return Colors.teal;
      case 'reminder': return const Color(0xFFE76F51);
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
      case 'medication': return Icons.medication;
      case 'reminder': return Icons.notifications_active;
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
      case 'medication': return '用药';
      case 'reminder': return '提醒';
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
        final petsAsync = ref.watch(petsStreamProvider);
        final petNameMap = petsAsync.maybeWhen(
          data: (pets) => {for (final p in pets) p.id: p.name},
          orElse: () => <int, String>{},
        );
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final m = list[i];
            final petName = petNameMap[m.petId] ?? '未知宠物';
            return Card(
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.teal.withValues(alpha: 0.2), child: const Icon(Icons.medication, color: Colors.teal)),
                title: Text('$petName · ${m.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${m.dosage ?? '-'} · ${_freqLabel(m.frequency)} · ${DateFormat('yyyy-MM-dd').format(m.startDate)} 起'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  Switch(
                    value: m.active,
                    onChanged: (_) async {
                      await ref.read(healthRepoProvider).toggleMedication(m);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                    tooltip: '编辑',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        showDragHandle: true,
                        builder: (_) => _MedSheet(existing: m),
                      );
                    },
                  ),
                ]),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    builder: (_) => _MedSheet(existing: m),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  String _freqLabel(String? f) {
    switch (f) {
      case 'daily': return '每日';
      case 'weekly': return '每周';
      case 'monthly': return '每月';
      default: return f ?? '-';
    }
  }
}

class _AlertsTab extends ConsumerWidget {
  final AsyncValue<List<HealthEvent>> overdueAsync;
  final AsyncValue<List<HealthEvent>> upcomingAsync;
  const _AlertsTab({required this.overdueAsync, required this.upcomingAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsStreamProvider);
    final petNameMap = petsAsync.maybeWhen(
      data: (pets) => {for (final p in pets) p.id: p.name},
      orElse: () => <int, String>{},
    );
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
                        title: Text('${petNameMap[e.petId] ?? '未知'} · ${e.title}'),
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
                        title: Text('${petNameMap[e.petId] ?? '未知'} · ${e.title}'),
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
      case 'medication': return '用药';
      default: return '其他';
    }
  }
}

class _EventSheet extends ConsumerStatefulWidget {
  final dynamic existing;
  const _EventSheet({this.existing});
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
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _petId = e.petId;
      _type = e.type ?? 'checkup';
      _titleCtrl.text = e.title ?? '';
      _descCtrl.text = e.description ?? '';
      _vetCtrl.text = e.vetName ?? '';
      _costCtrl.text = e.cost?.toString() ?? '';
      _eventDate = e.eventDate ?? DateTime.now();
      _nextDue = e.nextDueDate;
    }
  }

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
      final repo = ref.read(healthRepoProvider);
      if (widget.existing != null) {
        await repo.updateEvent(
          widget.existing.id,
          petId: _petId!,
          type: _type,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          eventDate: _eventDate,
          nextDueDate: _nextDue,
          vetName: _vetCtrl.text.trim().isEmpty ? null : _vetCtrl.text.trim(),
          cost: double.tryParse(_costCtrl.text.trim()),
        );
      } else {
        await repo.addEvent(
          petId: _petId!,
          type: _type,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          eventDate: _eventDate,
          nextDueDate: _nextDue,
          vetName: _vetCtrl.text.trim().isEmpty ? null : _vetCtrl.text.trim(),
          cost: double.tryParse(_costCtrl.text.trim()),
        );
      }
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
          Text(widget.existing != null ? '编辑健康事件' : '新增健康事件', style: Theme.of(context).textTheme.titleLarge),
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
  final dynamic existing;
  const _MedSheet({this.existing});
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
  void initState() {
    super.initState();
    final m = widget.existing;
    if (m != null) {
      _petId = m.petId;
      _nameCtrl.text = m.name ?? '';
      _dosageCtrl.text = m.dosage ?? '';
      _freq = m.frequency ?? 'daily';
      _startDate = m.startDate ?? DateTime.now();
    }
  }

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
      final repo = ref.read(healthRepoProvider);
      if (widget.existing != null) {
        await repo.updateMedication(
          widget.existing.id,
          petId: _petId!,
          name: _nameCtrl.text.trim(),
          dosage: _dosageCtrl.text.trim().isEmpty ? null : _dosageCtrl.text.trim(),
          frequency: _freq,
          startDate: _startDate,
        );
      } else {
        await repo.addMedication(
          petId: _petId!,
          name: _nameCtrl.text.trim(),
          dosage: _dosageCtrl.text.trim().isEmpty ? null : _dosageCtrl.text.trim(),
          frequency: _freq,
          startDate: _startDate,
        );
      }
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
          Text(widget.existing != null ? '编辑用药' : '新增用药', style: Theme.of(context).textTheme.titleLarge),
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

// ============================================================
//  提醒专用 Sheet (区别于事件: 强制要求 nextDueDate)
// ============================================================
class _ReminderSheet extends ConsumerStatefulWidget {
  const _ReminderSheet();
  @override
  ConsumerState<_ReminderSheet> createState() => _RS();
}

class _RS extends ConsumerState<_ReminderSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  int? _petId;
  String _remindType = 'health_check'; // 提醒分类
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _dueTime = const TimeOfDay(hour: 9, minute: 0);
  bool _saving = false;

  static const Map<String, String> _typeLabel = {
    'health_check': '体检',
    'vaccine': '疫苗',
    'deworm': '驱虫',
    'flea': '体外驱虫',
    'grooming': '美容',
    'medication_refill': '补药',
    'food_replenish': '补粮',
    'other': '其他',
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d != null) setState(() => _dueDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _dueTime);
    if (t != null) setState(() => _dueTime = t);
  }

  Future<void> _save() async {
    if (_petId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先创建宠物')));
      return;
    }
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入提醒事项')));
      return;
    }
    setState(() => _saving = true);
    try {
      // 提醒 = type='reminder' + eventDate=今天 + nextDueDate=所选日期
      final remindAt = DateTime(_dueDate.year, _dueDate.month, _dueDate.day, _dueTime.hour, _dueTime.minute);
      await ref.read(healthRepoProvider).addEvent(
        petId: _petId!,
        type: 'reminder',  // 明确标记为提醒
        title: '[${_typeLabel[_remindType]}] ${_titleCtrl.text.trim()}',
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        eventDate: DateTime.now(),
        nextDueDate: remindAt,
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
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            const Icon(Icons.alarm, color: Color(0xFFE76F51)),
            const SizedBox(width: 8),
            Text('新建提醒', style: Theme.of(context).textTheme.titleLarge),
          ]),
          const SizedBox(height: 20),
          petsAsync.maybeWhen(
            data: (pets) {
              if (pets.isEmpty) return const Text('请先创建宠物');
              _petId ??= pets.first.id;
              return DropdownButtonFormField<int>(
                initialValue: _petId,
                decoration: const InputDecoration(labelText: '宠物', prefixIcon: Icon(Icons.pets)),
                items: [for (final p in pets) DropdownMenuItem(value: p.id, child: Text(p.name))],
                onChanged: (v) => setState(() => _petId = v),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 14),
          Text('提醒分类', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(spacing: 8, runSpacing: 6, children: [
            for (final e in _typeLabel.entries)
              ChoiceChip(
                label: Text(e.value),
                selected: _remindType == e.key,
                onSelected: (_) => setState(() => _remindType = e.key),
              ),
          ]),
          const SizedBox(height: 14),
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: '提醒事项 *',
              hintText: '如: 年度体检 / 第三针疫苗',
              prefixIcon: Icon(Icons.edit_note),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _descCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: '备注',
              prefixIcon: Icon(Icons.notes),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            margin: EdgeInsets.zero,
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today, color: Color(0xFFE76F51)),
                  title: const Text('提醒日期'),
                  subtitle: Text('${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickDate,
                ),
                const Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time, color: Color(0xFFE76F51)),
                  title: const Text('提醒时间'),
                  subtitle: Text('${_dueTime.hour.toString().padLeft(2, '0')}:${_dueTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickTime,
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.notifications_active),
            label: Text(_saving ? '保存中...' : '设置提醒'),
          ),
        ]),
      ),
    );
  }
}
