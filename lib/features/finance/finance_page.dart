// ============================================================
//  记账 + 月度图表
// ============================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../db/database.dart';
import 'finance_repository.dart';

final _monthProvider = StateProvider<DateTime>((_) => DateTime.now());
final _expensesProvider = StreamProvider.family.autoDispose<List<Expense>, DateTime>((ref, month) {
  return ref.watch(financeRepoProvider).watchMonth(month);
});

const _categories = ['food', 'medical', 'grooming', 'toy', 'training', 'other'];
const _catLabels = {'food': '食物', 'medical': '医疗', 'grooming': '美容', 'toy': '玩具', 'training': '训练', 'other': '其他'};
const _catColors = {'food': Colors.orange, 'medical': Colors.red, 'grooming': Colors.purple, 'toy': Colors.blue, 'training': Colors.green, 'other': Colors.grey};

class FinancePage extends ConsumerWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(_monthProvider);
    final expensesAsync = ref.watch(_expensesProvider(month));
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 记账'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => ref.read(_monthProvider.notifier).state = DateTime(month.year, month.month - 1, 1),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final next = DateTime(month.year, month.month + 1, 1);
              if (next.isBefore(DateTime.now().add(const Duration(days: 32)))) {
                ref.read(_monthProvider.notifier).state = next;
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(DateFormat('yyyy 年 M 月').format(month), style: const TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, showDragHandle: true, builder: (_) => const _ExpenseSheet());
        },
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
        data: (list) {
          if (list.isEmpty) {
            return Column(
              children: [
                Expanded(child: Center(child: Text('${DateFormat('M 月').format(month)} 暂无支出\n点击右下角记录', textAlign: TextAlign.center))),
              ],
            );
          }
          final total = list.fold<double>(0, (s, e) => s + e.amount);
          final byCategory = <String, double>{};
          for (final e in list) {
            byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
          }
          return ListView(
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('本月支出', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('¥ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
              if (byCategory.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('分类占比', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(height: 180, child: PieChart(PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          for (final c in byCategory.entries)
                            PieChartSectionData(
                              color: _catColors[c.key] ?? Colors.grey,
                              value: c.value,
                              title: _catLabels[c.key] ?? c.key,
                              radius: 60,
                              titleStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ))),
                    ]),
                  ),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Padding(padding: EdgeInsets.all(8), child: Text('明细', style: TextStyle(fontWeight: FontWeight.bold))),
                    for (final e in list)
                      Dismissible(
                        key: ValueKey(e.id),
                        direction: DismissDirection.endToStart,
                        background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                        onDismissed: (_) async {
                          await ref.read(financeRepoProvider).delete(e.id);
                        },
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(backgroundColor: (_catColors[e.category] ?? Colors.grey).withValues(alpha: 0.2), child: Icon(Icons.payments, color: _catColors[e.category] ?? Colors.grey, size: 18)),
                          title: Text(e.description ?? _catLabels[e.category] ?? e.category),
                          subtitle: Text(DateFormat('MM-dd').format(e.spentAt)),
                          trailing: Text('-¥ ${e.amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExpenseSheet extends ConsumerStatefulWidget {
  const _ExpenseSheet();
  @override
  ConsumerState<_ExpenseSheet> createState() => _S();
}

class _S extends ConsumerState<_ExpenseSheet> {
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'food';
  DateTime _spentAt = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入有效金额')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(financeRepoProvider).add(
        spentAt: _spentAt,
        amount: amount,
        category: _category,
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
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
          Text('记一笔', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          const Text('类别'),
          const SizedBox(height: 4),
          Wrap(spacing: 8, children: [
            for (final c in _categories)
              ChoiceChip(
                label: Text(_catLabels[c]!),
                selected: _category == c,
                onSelected: (_) => setState(() => _category = c),
              ),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: '金额 (元) *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: '说明', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('日期'),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(_spentAt)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _spentAt, firstDate: DateTime(2000), lastDate: DateTime.now());
              if (d != null) setState(() => _spentAt = d);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? '保存中...' : '保存')),
        ]),
      ),
    );
  }
}
