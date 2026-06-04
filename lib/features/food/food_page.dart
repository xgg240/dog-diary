// ============================================================
//  狗粮库存 + 喂食记录
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../db/database.dart';
import 'food_repository.dart';

final _invProvider = StreamProvider<List<FoodInventory>>((ref) {
  return ref.watch(foodRepoProvider).watchInventory();
});
final _feedProvider = StreamProvider<List<FeedingRecord>>((ref) {
  return ref.watch(foodRepoProvider).watchFeedings();
});
final _lowProvider = StreamProvider<List<FoodInventory>>((ref) {
  return ref.watch(foodRepoProvider).watchLowStock();
});

class FoodPage extends ConsumerWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (ctx) {
          // ctx 在 DefaultTabController 子树内, 可以正确拿到 controller
          return Scaffold(
            appBar: AppBar(
              title: const Text('🍖 饮食'),
              bottom: const TabBar(tabs: [
                Tab(icon: Icon(Icons.inventory), text: '库存'),
                Tab(icon: Icon(Icons.restaurant_menu), text: '喂食'),
              ]),
            ),
            floatingActionButton: AnimatedBuilder(
              animation: DefaultTabController.of(ctx),
              builder: (innerCtx, _) {
                final tab = DefaultTabController.of(innerCtx).index;
                return FloatingActionButton.extended(
                  onPressed: () {
                    if (tab == 0) {
                      showModalBottomSheet(context: innerCtx, isScrollControlled: true, useSafeArea: true, showDragHandle: true, builder: (_) => const _InvSheet());
                    } else {
                      showModalBottomSheet(context: innerCtx, isScrollControlled: true, useSafeArea: true, showDragHandle: true, builder: (_) => const _FeedSheet());
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: Text(tab == 0 ? '入库' : '喂食'),
                );
              },
            ),
            body: TabBarView(children: [
              _InventoryTab(),
              _FeedingsTab(),
            ]),
          );
        },
      ),
    );
  }
}

class _InventoryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invAsync = ref.watch(_invProvider);
    final lowAsync = ref.watch(_lowProvider);
    return invAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('错误: $e')),
      data: (list) {
        return ListView(
          children: [
            lowAsync.maybeWhen(
              data: (low) {
                if (low.isEmpty) return const SizedBox.shrink();
                return Card(
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(child: Text('${low.length} 种狗粮库存不足 1kg', style: const TextStyle(fontWeight: FontWeight.bold))),
                    ]),
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            if (list.isEmpty) const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('暂无库存\n点击右下角入库'))),
            for (final group in _groupByCategory(list).entries) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text('${_categoryIcon(group.key)} ${_categoryLabel(group.key)} (${group.value.length})',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _categoryColor(group.key))),
              ),
              for (final f in group.value)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: (f.remainingKg <= _lowThreshold(f.category) ? Colors.red : Colors.green).withValues(alpha: 0.2), child: Icon(_categoryIcon(f.category), color: f.remainingKg <= _lowThreshold(f.category) ? Colors.red : _categoryColor(f.category))),
                    title: Text('${f.brand} · ${f.productName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${f.remainingKg.toStringAsFixed(2)} / ${f.totalKg.toStringAsFixed(2)} kg${f.expireDate != null ? ' · 过期 ${DateFormat('yyyy-MM-dd').format(f.expireDate!)}' : ''}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await ref.read(foodRepoProvider).deleteInventory(f.id);
                      },
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  Map<String, List<FoodInventory>> _groupByCategory(List<FoodInventory> list) {
    final map = <String, List<FoodInventory>>{};
    const order = ['kibble', 'can', 'snack', 'supplement', 'medicine'];
    for (final cat in order) {
      final items = list.where((f) => f.category == cat).toList();
      if (items.isNotEmpty) map[cat] = items;
    }
    return map;
  }
}

String _categoryLabel(String c) {
  switch (c) {
    case 'kibble': return '干粮';
    case 'can': return '罐头';
    case 'snack': return '零食';
    case 'supplement': return '保健品';
    case 'medicine': return '药品';
    default: return c;
  }
}

IconData _categoryIcon(String c) {
  switch (c) {
    case 'kibble': return Icons.bakery_dining;
    case 'can': return Icons.set_meal;
    case 'snack': return Icons.cookie;
    case 'supplement': return Icons.medical_services;
    case 'medicine': return Icons.medication;
    default: return Icons.kitchen;
  }
}

Color _categoryColor(String c) {
  switch (c) {
    case 'kibble': return Colors.brown;
    case 'can': return Colors.deepOrange;
    case 'snack': return Colors.amber;
    case 'supplement': return Colors.teal;
    case 'medicine': return Colors.red;
    default: return Colors.grey;
  }
}

double _lowThreshold(String category) {
  // 药品/保健品<0.3kg 紧急，干粮/罐头<1.0kg 警告，零食<0.5kg
  switch (category) {
    case 'medicine':
    case 'supplement':
      return 0.3;
    case 'snack':
      return 0.5;
    case 'kibble':
    case 'can':
    default:
      return 1.0;
  }
}

class _FeedingsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(_feedProvider);
    return feedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('错误: $e')),
      data: (list) {
        if (list.isEmpty) return const Center(child: Text('暂无喂食记录\n点击右下角喂食'));
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final f = list[i];
            return Dismissible(
              key: ValueKey(f.id),
              direction: DismissDirection.endToStart,
              background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
              confirmDismiss: (_) async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('删除喂食?'),
                    content: const Text('删除会回滚对应库存的扣减。'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
                      FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('删除')),
                    ],
                  ),
                );
                return ok ?? false;
              },
              onDismissed: (_) async {
                await ref.read(foodRepoProvider).deleteFeeding(f.id);
              },
              child: ListTile(
                leading: const Icon(Icons.restaurant, color: Colors.orange),
                title: Text('${f.amountKg.toStringAsFixed(2)} kg · ${f.mealType}'),
                subtitle: Text(DateFormat('MM-dd HH:mm').format(f.fedAt)),
              ),
            );
          },
        );
      },
    );
  }
}

class _InvSheet extends ConsumerStatefulWidget {
  const _InvSheet();
  @override
  ConsumerState<_InvSheet> createState() => _InvS();
}

class _InvS extends ConsumerState<_InvSheet> {
  final _brandCtrl = TextEditingController();
  final _prodCtrl = TextEditingController();
  final _flavorCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _category = 'kibble';
  DateTime _purchaseDate = DateTime.now();
  DateTime? _expireDate;
  bool _saving = false;

  @override
  void dispose() {
    _brandCtrl.dispose();
    _prodCtrl.dispose();
    _flavorCtrl.dispose();
    _totalCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final total = double.tryParse(_totalCtrl.text.trim());
    if (_brandCtrl.text.trim().isEmpty || _prodCtrl.text.trim().isEmpty || total == null || total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('品牌/产品/总量 必填')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(foodRepoProvider).addInventory(
        category: _category,
        brand: _brandCtrl.text.trim(),
        productName: _prodCtrl.text.trim(),
        flavor: _flavorCtrl.text.trim().isEmpty ? null : _flavorCtrl.text.trim(),
        totalKg: total,
        remainingKg: total,
        pricePerKg: double.tryParse(_priceCtrl.text.trim()),
        purchaseDate: _purchaseDate,
        expireDate: _expireDate,
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
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('入库', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: '分类 *', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'kibble', child: Text('🥣 干粮')),
              DropdownMenuItem(value: 'can', child: Text('🥫 罐头')),
              DropdownMenuItem(value: 'snack', child: Text('🦴 零食')),
              DropdownMenuItem(value: 'supplement', child: Text('💊 保健品')),
              DropdownMenuItem(value: 'medicine', child: Text('💉 药品')),
            ],
            onChanged: (v) => setState(() => _category = v ?? 'kibble'),
          ),
          const SizedBox(height: 12),
          TextField(controller: _brandCtrl, decoration: const InputDecoration(labelText: '品牌 *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _prodCtrl, decoration: const InputDecoration(labelText: '产品名 *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _flavorCtrl, decoration: const InputDecoration(labelText: '口味', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _totalCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: '总重 (kg) *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _priceCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: '单价 (元/kg)', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('购买日期'),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(_purchaseDate)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _purchaseDate, firstDate: DateTime(2000), lastDate: DateTime.now());
              if (d != null) setState(() => _purchaseDate = d);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('过期日期'),
            subtitle: Text(_expireDate == null ? '不设置' : DateFormat('yyyy-MM-dd').format(_expireDate!)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (_expireDate != null) IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _expireDate = null)),
              const Icon(Icons.chevron_right),
            ]),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _expireDate ?? DateTime.now().add(const Duration(days: 365)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365 * 3)));
              if (d != null) setState(() => _expireDate = d);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '入库')),
        ]),
      ),
    );
  }
}

class _FeedSheet extends ConsumerStatefulWidget {
  const _FeedSheet();
  @override
  ConsumerState<_FeedSheet> createState() => _FeedS();
}

class _FeedS extends ConsumerState<_FeedSheet> {
  final _amountCtrl = TextEditingController();
  int? _petId;
  int? _foodId;
  String _mealType = 'meal';
  DateTime _fedAt = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_petId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先创建宠物')));
      return;
    }
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入有效克数')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(foodRepoProvider).addFeeding(
        petId: _petId!,
        foodId: _foodId,
        fedAt: _fedAt,
        amountKg: amount,
        mealType: _mealType,
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
    final invAsync = ref.watch(_invProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('喂食记录', style: Theme.of(context).textTheme.titleLarge),
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
          invAsync.maybeWhen(
            data: (list) {
              return DropdownButtonFormField<int?>(
                initialValue: _foodId,
                decoration: const InputDecoration(labelText: '狗粮 (可选, 选后会扣库存)', border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem(value: null, child: Text('不关联')),
                  for (final f in list)
                    DropdownMenuItem(
                      value: f.id,
                      child: Text('${f.brand} · ${f.productName} (${f.remainingKg.toStringAsFixed(1)}kg)'),
                    ),
                ],
                onChanged: (v) => setState(() => _foodId = v),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          TextField(controller: _amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: '喂食量 (kg) *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const Text('类型'),
          const SizedBox(height: 4),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'meal', label: Text('正餐')),
              ButtonSegment(value: 'snack', label: Text('零食')),
            ],
            selected: {_mealType},
            onSelectionChanged: (s) => setState(() => _mealType = s.first),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('喂食时间'),
            subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(_fedAt)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _fedAt, firstDate: DateTime(2000), lastDate: DateTime.now());
              if (d != null) {
                if (!context.mounted) return;
                final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_fedAt));
                if (t != null) setState(() => _fedAt = DateTime(d.year, d.month, d.day, t.hour, t.minute));
              }
            },
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '记录')),
        ]),
      ),
    );
  }
}
