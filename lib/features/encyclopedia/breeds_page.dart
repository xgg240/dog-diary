// 品种百科
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class BreedsPage extends StatefulWidget {
  const BreedsPage({super.key});
  static Future<List<dynamic>> allBreeds() => DataLoader.breeds();
  @override
  State<BreedsPage> createState() => _S();
}

class _S extends State<BreedsPage> {
  String? _sizeFilter;
  String _query = '';


  Color _sizeColor(BuildContext context, String? s) {
    switch (s) {
      case 'toy':
        return Theme.of(context).colorScheme.tertiary;
      case 'small':
        return Theme.of(context).colorScheme.error;
      case 'medium':
        return Theme.of(context).colorScheme.tertiary;
      case 'large':
        return Theme.of(context).colorScheme.primary;
      case 'giant':
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  String _sizeIcon(String? s) {
    switch (s) {
      case 'toy':
        return '🧸';
      case 'small':
        return '🐕';
      case 'medium':
        return '🐶';
      case 'large':
        return '🦮';
      case 'giant':
        return '🐕‍🦺';
      default:
        return '🐾';
    }
  }

  String _sizeLabel(String? s) {
    switch (s) {
      case 'toy':
        return '玩赏犬';
      case 'small':
        return '小型';
      case 'medium':
        return '中型';
      case 'large':
        return '大型';
      case 'giant':
        return '巨型';
      default:
        return s ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('🐶 品种百科')),
      body: FutureBuilder(
        future: DataLoader.breeds(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final all = snap.data!;
          var list = all.where((b) {
            if (_sizeFilter != null && b['size'] != _sizeFilter) return false;
            if (_query.isNotEmpty && !(b['name_zh'] as String).toLowerCase().contains(_query.toLowerCase()) && !((b['name_en'] as String?) ?? '').toLowerCase().contains(_query.toLowerCase())) return false;
            return true;
          }).toList();
          // 按 size 分组
          final groups = <String, List<dynamic>>{};
          for (final b in list) {
            final s = (b['size'] as String?) ?? 'other';
            groups.putIfAbsent(s, () => []).add(b);
          }
          if (list.isEmpty) {
            return Center(child: Text('没有匹配结果', style: TextStyle(color: cs.onSurfaceVariant)));
          }
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: '搜索: 金毛/泰迪/柯基...',
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixText: '${list.length}/${all.length}',
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(children: [
                for (final s in [(null, '全部', null), ('toy', '🧸 玩赏犬', null), ('small', '🐕 小型', null), ('medium', '🐶 中型', null), ('large', '🦮 大型', null), ('giant', '🐕🦺 巨型', null)])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(s.$2),
                      selected: _sizeFilter == s.$1,
                      onSelected: (_) => setState(() => _sizeFilter = s.$1),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  for (final entry in groups.entries) _BreedGroup(size: entry.key, breeds: entry.value),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _BreedGroup extends StatelessWidget {
  final String size;
  final List<dynamic> breeds;
  const _BreedGroup({required this.size, required this.breeds});

  Color _sizeColor(BuildContext context, String? s) {
    switch (s) {
      case 'toy': return Theme.of(context).colorScheme.tertiary;
      case 'small': return Theme.of(context).colorScheme.error;
      case 'medium': return Theme.of(context).colorScheme.tertiary;
      case 'large': return Theme.of(context).colorScheme.primary;
      case 'giant': return Theme.of(context).colorScheme.tertiary;
      default: return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  String _sizeIcon(String? s) {
    switch (s) {
      case 'toy': return '🧸';
      case 'small': return '🐕';
      case 'medium': return '🐶';
      case 'large': return '🦮';
      case 'giant': return '🐕🦺';
      default: return '🐾';
    }
  }

  String _sizeLabel(String? s) {
    switch (s) {
      case 'toy': return '玩赏犬';
      case 'small': return '小型';
      case 'medium': return '中型';
      case 'large': return '大型';
      case 'giant': return '巨型';
      default: return '其他';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
            title: Row(children: [
              Text(_sizeIcon(size), style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(child: Text(_sizeLabel(size), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: cs.onSurface))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: _sizeColor(context, size), borderRadius: BorderRadius.circular(10)),
                child: Text('${breeds.length}', style: TextStyle(color: cs.surface, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
            children: [for (final b in breeds) _breedCard(context, b)],
          ),
        ),
      ),
    );
  }

  Widget _breedCard(BuildContext context, dynamic b) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BreedDetailPage(breed: b))),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: _sizeColor(context, b['size']).withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Center(child: Text(_sizeIcon(b['size']), style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b['name_zh'] ?? '', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: cs.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${b['name_en']} · 寿命 ${b['lifespan_years']}年', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant.withValues(alpha: 0.5), size: 18),
            ]),
          ),
        ),
      ),
    );
  }
}

class BreedDetailPage extends StatelessWidget {
  Color _sizeColor(BuildContext context, String? s) {
    switch (s) {
      case 'toy':
        return Theme.of(context).colorScheme.tertiary;
      case 'small':
        return Theme.of(context).colorScheme.error;
      case 'medium':
        return Theme.of(context).colorScheme.tertiary;
      case 'large':
        return Theme.of(context).colorScheme.primary;
      case 'giant':
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  final Map<String, dynamic> breed;
  const BreedDetailPage({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(breed['name_zh'])),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: _sizeColor(context, breed['size']).withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(_sizeIcon(breed['size']), style: const TextStyle(fontSize: 48)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(breed['name_zh'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(breed['name_en'], style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(height: 4),
                      Text('📍 起源: ${breed['origin']}'),
                    ]),
                  ),
                ]),
                const SizedBox(height: 12),
                Text(breed['personality'], style: const TextStyle(fontSize: 14, height: 1.5)),
              ]),
            ),
          ),
          _statsCard(),
          _healthCard(context),
          _careCard(),
        ],
      ),
    );
  }

  Widget _statsCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📊 基本数据', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _row('体型', _sizeLabel(breed['size'])),
            _row('体重', '${breed['weight_kg'][0]}-${breed['weight_kg'][1]} kg'),
            _row('体高', '${breed['height_cm'][0]}-${breed['height_cm'][1]} cm'),
            _row('寿命', '${breed['lifespan_years'][0]}-${breed['lifespan_years'][1]} 年'),
            _row('运动需求', '${breed['exercise_min']} 分钟/天'),
            _row('美容频率', _groomingLabel(breed['grooming'])),
            _row('掉毛', _sheddingLabel(breed['shedding'])),
            _row('吠叫', _barkLabel(breed['bark_tendency'])),
            _row('能量', _energyLabel(breed['energy'])),
            _row('可训练性', _trainLabel(breed['trainability'])),
          ]),
        ),
      );

  Widget _healthCard(BuildContext context) {
    final list = breed['common_health'] as List<dynamic>;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🏥 常见健康问题', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 4, children: [
            for (final h in list) Chip(label: Text(h, style: const TextStyle(fontSize: 11)), backgroundColor: Theme.of(context).colorScheme.errorContainer),
          ]),
        ]),
      ),
    );
  }

  Widget _careCard() {
    final apt = breed['apartment_friendly'] as bool;
    final kid = breed['kid_friendly'] as bool;
    final beg = breed['beginner_friendly'] as bool;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('👨‍👩‍👧 适合度', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _row('公寓饲养', apt ? '✅ 适合' : '❌ 不适合'),
          _row('儿童家庭', kid ? '✅ 友好' : '⚠️ 谨慎'),
          _row('新手主人', beg ? '✅ 推荐' : '⚠️ 需经验'),
        ]),
      ),
    );
  }

  Widget _row(String k, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
        SizedBox(width: 80, child: Text(k, style: TextStyle(color: Colors.grey.shade700))),
        Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w500))),
      ]));

  String _sizeLabel(String s) => switch (s) { 'toy' => '玩具犬', 'small' => '小型犬', 'medium' => '中型犬', 'large' => '大型犬', 'giant' => '巨型犬', _ => s };
  String _sizeIcon(String s) => switch (s) { 'toy' => '🐹', 'small' => '🐶', 'medium' => '🐕', 'large' => '🦮', 'giant' => '🐎', _ => '🐶' };
  String _groomingLabel(String s) => switch (s) { 'daily' => '每天', 'weekly' => '每周', 'monthly' => '每月', _ => s };
  String _sheddingLabel(String s) => switch (s) { 'low' => '少', 'medium' => '中等', 'high' => '多', 'very_high' => '非常多', _ => s };
  String _barkLabel(String s) => switch (s) { 'low' => '安静', 'medium' => '一般', 'high' => '爱叫', 'very_high' => '非常爱叫', _ => s };
  String _energyLabel(String s) => switch (s) { 'low' => '低', 'medium' => '中', 'high' => '高', 'very_high' => '极高', _ => s };
  String _trainLabel(String s) => switch (s) { 'low' => '难训', 'medium' => '一般', 'high' => '好训', 'very_high' => '极好训', _ => s };
}
