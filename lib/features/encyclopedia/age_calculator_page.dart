// 狗狗年龄换算 (按体型)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data_loader.dart';
import '../../core/providers.dart';
import '../../db/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgeCalculatorPage extends ConsumerStatefulWidget {
  const AgeCalculatorPage({super.key});
  @override
  ConsumerState<AgeCalculatorPage> createState() => _S();
}

class _S extends ConsumerState<AgeCalculatorPage> {
  DateTime _birthday = DateTime.now().subtract(const Duration(days: 365 * 3));
  String _size = 'medium';

  int _humanAge() {
    // 按体型换算
    // 小型: 1=15, 2=24, 之后+4
    // 中型: 1=15, 2=24, 之后+5
    // 大型: 1=12, 2=22, 之后+7
    // 巨型: 1=10, 2=18, 之后+9
    final dogYears = DateTime.now().difference(_birthday).inDays / 365.25;
    if (dogYears < 1) return (dogYears * 15).round();
    if (dogYears < 2) {
      return (15 + (dogYears - 1) * 9).round();
    }
    final base = _size == 'small' ? 24 : _size == 'medium' ? 24 : _size == 'large' ? 22 : 18;
    final perYear = _size == 'small' ? 4 : _size == 'medium' ? 5 : _size == 'large' ? 7 : 9;
    return (base + (dogYears - 2) * perYear).round();
  }

  String _lifeStage(int humanAge) {
    if (humanAge < 13) return '🧒 幼年';
    if (humanAge < 25) return '🧑 青少年';
    if (humanAge < 50) return '🧔 壮年';
    if (humanAge < 65) return '👨 中年';
    return '👴 老年';
  }

  @override
  Widget build(BuildContext context) {
    final human = _humanAge();
    return Scaffold(
      appBar: AppBar(title: const Text('🎂 狗狗年龄换算')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: Colors.pink.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('为什么不是 ×7?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('犬类老化速度因体型差异巨大. 大型犬寿命短, 老化更快. 这个换算器按品种大小分四档, 比 ×7 准确得多.', style: TextStyle(height: 1.5)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('📅 生日', style: TextStyle(fontWeight: FontWeight.bold)),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(DateFormat('yyyy-MM-dd').format(_birthday)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: _birthday, firstDate: DateTime(1990), lastDate: DateTime.now());
                    if (d != null) setState(() => _birthday = d);
                  },
                ),
                const Divider(),
                const Text('🐕 体型', style: TextStyle(fontWeight: FontWeight.bold)),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'small', label: Text('小型')),
                    ButtonSegment(value: 'medium', label: Text('中型')),
                    ButtonSegment(value: 'large', label: Text('大型')),
                    ButtonSegment(value: 'giant', label: Text('巨型')),
                  ],
                  selected: {_size},
                  onSelectionChanged: (s) => setState(() => _size = s.first),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Text('${DateTime.now().difference(_birthday).inDays ~/ 365} 岁', style: const TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(height: 8),
                Text('相当于人类 $human 岁', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                const SizedBox(height: 4),
                Text(_lifeStage(human), style: const TextStyle(fontSize: 16)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          // 用宠物档案快速填
          Consumer(builder: (ctx, ref, _) {
            final petsAsync = ref.watch(petsStreamProvider);
            return petsAsync.maybeWhen(
              data: (pets) {
                if (pets.isEmpty) return const SizedBox.shrink();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('从宠物档案填入:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(spacing: 6, children: [
                        for (final p in pets.where((e) => e.birthday != null))
                          ActionChip(
                            label: Text('${p.name} (${_sizeFromWeight(p)})'),
                            onPressed: () => setState(() {
                              _birthday = p.birthday!;
                              _size = _sizeFromWeight(p);
                            }),
                          ),
                      ]),
                    ]),
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          }),
        ],
      ),
    );
  }

  String _sizeFromWeight(Pet p) {
    final w = p.adultWeightKg ?? 10;
    if (w < 10) return 'small';
    if (w < 25) return 'medium';
    if (w < 40) return 'large';
    return 'giant';
  }
}
