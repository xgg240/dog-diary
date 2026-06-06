// ============================================================
//  狗粮库存 + 喂食记录（v3 - 库存进度条 + 喂食大卡 + 状态徽章）
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
final _expiringProvider = StreamProvider<List<FoodInventory>>((ref) {
  return ref.watch(foodRepoProvider).watchInventory().map((list) {
    final now = DateTime.now();
    final cutoff = now.add(const Duration(days: 14));
    return list.where((f) =>
      f.expireDate != null && f.expireDate!.isBefore(cutoff) && f.remainingKg > 0
    ).toList();
  });
});

class FoodPage extends ConsumerWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('🍖 饮食'),
              bottom: const TabBar(tabs: [
                Tab(icon: Icon(Icons.inventory_2_rounded), text: '库存'),
                Tab(icon: Icon(Icons.restaurant_menu_rounded), text: '喂食'),
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
            body: const TabBarView(children: [
              _InventoryTab(),
              _FeedingsTab(),
            ]),
          );
        },
      ),
    );
  }
}

// =================================================================
//  库存 Tab
// =================================================================
class _InventoryTab extends ConsumerWidget {
  const _InventoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invAsync = ref.watch(_invProvider);
    final lowAsync = ref.watch(_lowProvider);
    final expAsync = ref.watch(_expiringProvider);
    return invAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('加载失败: $e')),
      data: (list) {
        if (list.isEmpty) {
          return const _EmptyState(
            icon: Icons.inventory_2_outlined,
            title: '暂无库存',
            hint: '点右下角「入库」添加狗粮/罐头/零食/保健品/药品',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(_invProvider),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
            children: [
              // 摘要条
              _InventorySummary(inv: list, low: lowAsync.value ?? const [], exp: expAsync.value ?? const []),
              const SizedBox(height: 8),
              // 分组
              for (final group in _groupByCategory(list).entries) ...[
                _CategoryHeader(cat: group.key, count: group.value.length),
                for (final f in group.value) _InventoryTile(item: f),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _InventorySummary extends StatelessWidget {
  final List<FoodInventory> inv;
  final List<FoodInventory> low;
  final List<FoodInventory> exp;
  const _InventorySummary({required this.inv, required this.low, required this.exp});

  @override
  Widget build(BuildContext context) {
    final totalKg = inv.fold<double>(0, (s, f) => s + f.remainingKg);
    final cats = inv.map((f) => f.category).toSet().length;
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Expanded(child: _SumCol(label: '总重', value: '${totalKg.toStringAsFixed(1)}', unit: 'kg')),
          Container(width: 1, height: 36, color: Colors.black12),
          Expanded(child: _SumCol(label: '种类', value: '$cats', unit: '类')),
          Container(width: 1, height: 36, color: Colors.black12),
          Expanded(child: _SumCol(
            label: '低库存',
            value: '${low.length}',
            unit: '种',
            alert: low.isNotEmpty,
          )),
          Container(width: 1, height: 36, color: Colors.black12),
          Expanded(child: _SumCol(
            label: '临期',
            value: '${exp.length}',
            unit: '种',
            alert: exp.isNotEmpty,
          )),
        ]),
      ),
    );
  }
}

class _SumCol extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool alert;
  const _SumCol({required this.label, required this.value, required this.unit, this.alert = false});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 11, color: cs.onSecondaryContainer.withValues(alpha: 0.7))),
      const SizedBox(height: 2),
      RichText(text: TextSpan(children: [
        TextSpan(text: value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: alert ? cs.error : cs.onSecondaryContainer)),
        TextSpan(text: ' $unit', style: TextStyle(fontSize: 10, color: cs.onSecondaryContainer.withValues(alpha: 0.7))),
      ])),
    ]);
  }
}

class _CategoryHeader extends StatelessWidget {
  final String cat;
  final int count;
  const _CategoryHeader({required this.cat, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
      child: Row(children: [
        Icon(_categoryIcon(cat), size: 16, color: _categoryColor(cat)),
        const SizedBox(width: 6),
        Text('${_categoryLabel(cat)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _categoryColor(cat))),
        const SizedBox(width: 6),
        Text('· $count', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ]),
    );
  }
}

class _InventoryTile extends ConsumerWidget {
  final FoodInventory item;
  const _InventoryTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threshold = _lowThreshold(item.category);
    final remaining = item.remainingKg;
    final total = item.totalKg;
    final ratio = total <= 0 ? 0.0 : (remaining / total).clamp(0.0, 1.0);
    final isLow = remaining <= threshold;
    final expDays = item.expireDate == null ? null : item.expireDate!.difference(DateTime.now()).inDays;
    final isExpired = expDays != null && expDays < 0;
    final isExpiring = expDays != null && expDays >= 0 && expDays <= 14;
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      elevation: 0,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, showDragHandle: true, builder: (_) => _InvSheet(existing: item));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: isLow ? cs.errorContainer : _categoryColor(item.category).withValues(alpha: 0.18),
                child: Icon(_categoryIcon(item.category), color: isLow ? cs.onErrorContainer : _categoryColor(item.category), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(
                    item.brand,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                  )),
                  if (isLow) _Badge(text: '低库存', color: cs.error, bg: cs.errorContainer, icon: Icons.warning_amber_rounded),
                  if (isExpired) _Badge(text: '已过期', color: cs.error, bg: cs.errorContainer, icon: Icons.dangerous_rounded),
                  if (!isExpired && isExpiring) _Badge(text: '${expDays}天到期', color: Colors.orange.shade900, bg: Colors.orange.shade100, icon: Icons.schedule),
                ]),
                const SizedBox(height: 2),
                Text(item.productName + (item.flavor != null && item.flavor!.isNotEmpty ? ' · ${item.flavor}' : ''),
                    style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.75)), overflow: TextOverflow.ellipsis),
              ])),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 20, color: cs.onSurface.withValues(alpha: 0.6)),
                onSelected: (v) async {
                  if (v == 'edit') {
                    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, showDragHandle: true, builder: (_) => _InvSheet(existing: item));
                  } else if (v == 'delete') {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('删除库存?'),
                        content: Text('确认删除「${item.brand} · ${item.productName}」?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
                          FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('删除')),
                        ],
                      ),
                    );
                    if (ok == true) await ref.read(foodRepoProvider).deleteInventory(item.id);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('编辑')])),
                  PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('删除', style: TextStyle(color: Colors.red))])),
                ],
              ),
            ]),
            const SizedBox(height: 10),
            // 剩余 vs 总量 + 进度条
            Row(children: [
              Text('${remaining.toStringAsFixed(1)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isLow ? cs.error : cs.onSurface)),
              Text(' / ${total.toStringAsFixed(1)} kg', style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.55))),
              const Spacer(),
              Text('${(ratio * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isLow ? cs.error : _categoryColor(item.category))),
            ]),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: cs.outlineVariant.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation(isLow ? cs.error : _categoryColor(item.category)),
              ),
            ),
            if (isExpired) Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('⚠️ 已过期 ${-expDays!} 天，建议丢弃',
                  style: TextStyle(fontSize: 11, color: cs.error, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color bg;
  final IconData icon;
  const _Badge({required this.text, required this.color, required this.bg, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 2),
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
      ]),
    );
  }
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
    case 'snack': return Colors.amber.shade800;
    case 'supplement': return Colors.teal;
    case 'medicine': return Colors.red;
    default: return Colors.grey;
  }
}

double _lowThreshold(String category) {
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

// =================================================================
//  喂食 Tab
// =================================================================
class _FeedingsTab extends ConsumerWidget {
  const _FeedingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(_feedProvider);
    final invAsync = ref.watch(_invProvider);
    final petsAsync = ref.watch(petsStreamProvider);
    final petNameMap = petsAsync.maybeWhen(
      data: (pets) => {for (final p in pets) p.id: p.name},
      orElse: () => <int, String>{},
    );
    final foodMap = invAsync.maybeWhen(
      data: (list) => {for (final f in list) f.id: f},
      orElse: () => <int, FoodInventory>{},
    );
    return feedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('加载失败: $e')),
      data: (list) {
        if (list.isEmpty) {
          return const _EmptyState(
            icon: Icons.restaurant_menu_rounded,
            title: '暂无喂食记录',
            hint: '点右下角「喂食」记录狗子今天吃了啥',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(_feedProvider),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final f = list[i];
              final petName = petNameMap[f.petId] ?? '未知宠物';
              final food = f.foodId != null ? foodMap[f.foodId!] : null;
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
                child: _FeedingTile(rec: f, petName: petName, food: food),
              );
            },
          ),
        );
      },
    );
  }
}

class _FeedingTile extends ConsumerWidget {
  final FeedingRecord rec;
  final String petName;
  final FoodInventory? food;
  const _FeedingTile({required this.rec, required this.petName, required this.food});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isSnack = rec.mealType == 'snack';
    final time = DateFormat('HH:mm').format(rec.fedAt);
    final date = DateFormat('MM-dd').format(rec.fedAt);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      elevation: 0,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, showDragHandle: true, builder: (_) => _FeedSheet(existing: rec));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            // 左侧时间大块
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: isSnack ? Colors.amber.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(time.split(':')[0], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, height: 1.0)),
                  Text(time.split(':')[1], style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.0)),
                  Text(date, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, height: 1.2)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 中间: 食物 + 宠物
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(isSnack ? Icons.cookie : Icons.restaurant, size: 14, color: isSnack ? Colors.amber.shade800 : Colors.deepOrange),
                const SizedBox(width: 4),
                Expanded(child: Text(
                  food == null ? (isSnack ? '零食' : '正餐') : '${food!.brand} · ${food!.productName}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                )),
              ]),
              const SizedBox(height: 2),
              Row(children: [
                Icon(Icons.pets, size: 12, color: cs.onSurface.withValues(alpha: 0.6)),
                const SizedBox(width: 4),
                Text(petName, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.7))),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSnack ? Colors.amber.shade200 : Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(isSnack ? '零食' : '正餐', style: TextStyle(fontSize: 10, color: isSnack ? Colors.amber.shade900 : Colors.orange.shade900, fontWeight: FontWeight.w700)),
                ),
              ]),
            ])),
            // 右侧: 大数字
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(rec.amountKg.toStringAsFixed(1),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isSnack ? Colors.amber.shade800 : Colors.deepOrange)),
              Text('公斤', style: TextStyle(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.6))),
            ]),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 20, color: cs.onSurface.withValues(alpha: 0.6)),
              onSelected: (v) async {
                if (v == 'edit') {
                  showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, showDragHandle: true, builder: (_) => _FeedSheet(existing: rec));
                } else if (v == 'delete') {
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
                  if (ok == true) await ref.read(foodRepoProvider).deleteFeeding(rec.id);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('编辑')])),
                PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('删除', style: TextStyle(color: Colors.red))])),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

// =================================================================
//  Empty state
// =================================================================
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String hint;
  const _EmptyState({required this.icon, required this.title, required this.hint});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Text(hint, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ]),
      ),
    );
  }
}

// =================================================================
//  入库 sheet (保留原 _InvSheet 实现，下面省略字段重排，保持兼容)
// =================================================================
class _InvSheet extends ConsumerStatefulWidget {
  final dynamic existing;
  const _InvSheet({this.existing});
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
  bool _blacklisted = false;
  final _allergyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _category = e.category ?? 'kibble';
      _brandCtrl.text = e.brand ?? '';
      _prodCtrl.text = e.productName ?? '';
      _flavorCtrl.text = e.flavor ?? '';
      _totalCtrl.text = e.totalKg?.toString() ?? '';
      _priceCtrl.text = e.pricePerKg?.toString() ?? '';
      _purchaseDate = e.purchaseDate ?? DateTime.now();
      _expireDate = e.expireDate;
      _blacklisted = e.blacklisted ?? false;
      _allergyCtrl.text = e.allergyReason ?? '';
    }
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _prodCtrl.dispose();
    _flavorCtrl.dispose();
    _totalCtrl.dispose();
    _priceCtrl.dispose();
    _allergyCtrl.dispose();
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
      final repo = ref.read(foodRepoProvider);
      if (widget.existing != null) {
        await repo.updateInventory(
          widget.existing.id,
          category: _category,
          brand: _brandCtrl.text.trim(),
          productName: _prodCtrl.text.trim(),
          flavor: _flavorCtrl.text.trim().isEmpty ? null : _flavorCtrl.text.trim(),
          totalKg: total,
          pricePerKg: double.tryParse(_priceCtrl.text.trim()),
          purchaseDate: _purchaseDate,
          expireDate: _expireDate,
          blacklisted: _blacklisted,
          allergyReason: _allergyCtrl.text.trim().isEmpty ? null : _allergyCtrl.text.trim(),
        );
      } else {
        await repo.addInventory(
          category: _category,
          brand: _brandCtrl.text.trim(),
          productName: _prodCtrl.text.trim(),
          flavor: _flavorCtrl.text.trim().isEmpty ? null : _flavorCtrl.text.trim(),
          totalKg: total,
          remainingKg: total,
          pricePerKg: double.tryParse(_priceCtrl.text.trim()),
          purchaseDate: _purchaseDate,
          expireDate: _expireDate,
          blacklisted: _blacklisted,
          allergyReason: _allergyCtrl.text.trim().isEmpty ? null : _allergyCtrl.text.trim(),
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
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(widget.existing == null ? '➕ 入库' : '✏️ 编辑库存',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Wrap(spacing: 6, children: [
            for (final c in const ['kibble', 'can', 'snack', 'supplement', 'medicine'])
              ChoiceChip(
                label: Text('${_categoryIcon(c == _category ? c : c)} ${_categoryLabel(c)}'),
                selected: _category == c,
                onSelected: (_) => setState(() => _category = c),
              ),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _brandCtrl, decoration: const InputDecoration(labelText: '品牌 *', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: _prodCtrl, decoration: const InputDecoration(labelText: '产品名 *', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: _flavorCtrl, decoration: const InputDecoration(labelText: '口味（可选）', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: _totalCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '总重 kg *', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '单价 元/kg', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text('购入 ${DateFormat('yyyy-MM-dd').format(_purchaseDate)}'),
              onPressed: () async {
                final d = await showDatePicker(context: context, initialDate: _purchaseDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
                if (d != null) setState(() => _purchaseDate = d);
              },
            )),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.event, size: 16),
              label: Text(_expireDate == null ? '到期' : DateFormat('yyyy-MM-dd').format(_expireDate!)),
              onPressed: () async {
                final d = await showDatePicker(context: context, initialDate: _expireDate ?? DateTime.now().add(const Duration(days: 365)), firstDate: DateTime(2000), lastDate: DateTime(2100));
                if (d != null) setState(() => _expireDate = d);
              },
            )),
          ]),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('标记为过敏/黑名单'),
            value: _blacklisted,
            onChanged: (v) => setState(() => _blacklisted = v),
          ),
          if (_blacklisted) TextField(controller: _allergyCtrl, decoration: const InputDecoration(labelText: '过敏原因/不适症状', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '保存')),
        ]),
      ),
    );
  }
}

// =================================================================
//  喂食 sheet
// =================================================================
class _FeedSheet extends ConsumerStatefulWidget {
  final dynamic existing;
  const _FeedSheet({this.existing});
  @override
  ConsumerState<_FeedSheet> createState() => _FeedS();
}

class _FeedS extends ConsumerState<_FeedSheet> {
  int? _petId;
  int? _foodId;
  String _mealType = 'meal';
  DateTime _fedAt = DateTime.now();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _petId = e.petId;
      _foodId = e.foodId;
      _mealType = e.mealType ?? 'meal';
      _fedAt = e.fedAt ?? DateTime.now();
      _amountCtrl.text = e.amountKg?.toString() ?? '';
      _notesCtrl.text = e.notes ?? '';
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (_petId == null || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请选宠物 + 喂食量')));
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(foodRepoProvider);
      if (widget.existing != null) {
        await repo.updateFeeding(
          widget.existing.id,
          petId: _petId!,
          foodId: _foodId,
          fedAt: _fedAt,
          amountKg: amount,
          mealType: _mealType,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
      } else {
        await repo.addFeeding(
          petId: _petId!,
          foodId: _foodId,
          fedAt: _fedAt,
          amountKg: amount,
          mealType: _mealType,
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
    final petsAsync = ref.watch(petsStreamProvider);
    final invAsync = ref.watch(_invProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(widget.existing == null ? '➕ 喂食' : '✏️ 编辑喂食',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          petsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('加载宠物失败: $e'),
            data: (pets) => DropdownButtonFormField<int>(
              initialValue: _petId,
              decoration: const InputDecoration(labelText: '宠物 *', border: OutlineInputBorder()),
              items: [for (final p in pets) DropdownMenuItem(value: p.id, child: Text(p.name))],
              onChanged: (v) => setState(() => _petId = v),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 6, children: [
            ChoiceChip(label: const Text('正餐'), selected: _mealType == 'meal', onSelected: (_) => setState(() => _mealType = 'meal')),
            ChoiceChip(label: const Text('零食'), selected: _mealType == 'snack', onSelected: (_) => setState(() => _mealType = 'snack')),
          ]),
          const SizedBox(height: 8),
          invAsync.maybeWhen(
            data: (list) => DropdownButtonFormField<int?>(
              initialValue: _foodId,
              decoration: const InputDecoration(labelText: '食物（可选，会扣减库存）', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('不关联')),
                for (final f in list) DropdownMenuItem<int?>(value: f.id, child: Text('${f.brand} · ${f.productName} (剩 ${f.remainingKg.toStringAsFixed(1)} kg)')),
              ],
              onChanged: (v) => setState(() => _foodId = v),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 8),
          TextField(controller: _amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: '喂食量 kg *', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.schedule, size: 16),
            label: Text('时间 ${DateFormat('yyyy-MM-dd HH:mm').format(_fedAt)}'),
            onPressed: () async {
              final d = await showDatePicker(context: context, initialDate: _fedAt, firstDate: DateTime(2000), lastDate: DateTime(2100));
              if (d == null) return;
              final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_fedAt));
              if (t == null) return;
              setState(() => _fedAt = DateTime(d.year, d.month, d.day, t.hour, t.minute));
            },
          ),
          const SizedBox(height: 8),
          TextField(controller: _notesCtrl, maxLines: 2, decoration: const InputDecoration(labelText: '备注', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '保存')),
        ]),
      ),
    );
  }
}
