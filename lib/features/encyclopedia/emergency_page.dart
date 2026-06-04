// 急症快速入口 - 选择 + 详情
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data_loader.dart';

// ============================================================
//  急症选择页 (从 SOS FAB 点开)
// ============================================================
class EmergencyListPage extends StatelessWidget {
  const EmergencyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        title: const Text('🚨 急症快查'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: DataLoader.emergencies(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          // critical 的排前面
          list.sort((a, b) {
            if (a['severity'] == 'critical' && b['severity'] != 'critical') return -1;
            if (a['severity'] != 'critical' && b['severity'] == 'critical') return 1;
            return 0;
          });
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                color: Colors.red.shade100,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(children: [
                    Icon(Icons.warning_amber, color: Colors.red, size: 32),
                    SizedBox(width: 8),
                    Expanded(child: Text('以下急症处理步骤仅供临时急救, 黄金时间内必须送医!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                  ]),
                ),
              ),
              const SizedBox(height: 8),
              for (final e in list) _card(context, e),
            ],
          );
        },
      ),
    );
  }

  Widget _card(BuildContext ctx, Map<String, dynamic> e) {
    final critical = e['severity'] == 'critical';
    return Card(
      color: critical ? Colors.red.shade50 : Colors.amber.shade50,
      elevation: critical ? 4 : 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: critical ? Colors.red : Colors.orange,
          radius: 24,
          child: Text(e['icon'], style: const TextStyle(fontSize: 20)),
        ),
        title: Text(e['name_zh'], style: TextStyle(fontWeight: FontWeight.bold, color: critical ? Colors.red.shade900 : null)),
        subtitle: Text('⏱️ 黄金时间: ${e['golden_time']}', style: const TextStyle(fontSize: 12)),
        trailing: Icon(Icons.chevron_right, color: critical ? Colors.red : null),
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => EmergencyDetailPage(emergency: e))),
      ),
    );
  }
}

// ============================================================
//  急症详情页 - 大字 + 步骤可勾选
// ============================================================
class EmergencyDetailPage extends StatefulWidget {
  final Map<String, dynamic> emergency;
  const EmergencyDetailPage({super.key, required this.emergency});
  @override
  State<EmergencyDetailPage> createState() => _S();
}

class _S extends State<EmergencyDetailPage> {
  final Set<int> _done = {};

  @override
  Widget build(BuildContext context) {
    final e = widget.emergency;
    final critical = e['severity'] == 'critical';
    return Scaffold(
      backgroundColor: critical ? Colors.red.shade50 : Colors.amber.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: critical ? Colors.red.shade700 : Colors.orange.shade700,
            foregroundColor: Colors.white,
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${e['icon']} ${e['name_zh']}'),
              background: Container(
                color: critical ? Colors.red.shade700 : Colors.orange.shade700,
                padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 16),
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('⏱️ 黄金时间: ${e['golden_time']}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('⚠️ ${e['when_to_vet']}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),

              // 警示症状
              _section('🔍 警示症状', [e['warning_signs']], Colors.red),

              // 可能原因
              if (e['common_toxins'] != null)
                _section('☠️ 常见毒物', (e['common_toxins'] as List).cast<String>(), Colors.purple)
              else if (e['common_causes'] != null)
                _section('⚠️ 常见原因', (e['common_causes'] as List).cast<String>(), Colors.orange)
              else if (e['common_situations'] != null)
                _section('🚗 常见场景', (e['common_situations'] as List).cast<String>(), Colors.indigo)
              else if (e['common_objects'] != null)
                _section('🧦 常见物品', (e['common_objects'] as List).cast<String>(), Colors.brown)
              else if (e['common_dogs'] != null)
                _section('🐕 高发犬种', (e['common_dogs'] as List).cast<String>(), Colors.indigo),

              // 居家急救 (可勾选)
              _checkList('🏠 居家急救 (按顺序做)', (e['home_care'] as List).cast<String>(), Colors.green),

              // 绝对禁忌
              _section('🚫 绝对禁忌', (e['absolute_donts'] as List).cast<String>(), Colors.red),

              // 送医时机
              _section('🚑 何时送医', [e['when_to_vet']], Colors.red),

              // 电话脚本
              if (e['vet_call_script'] != null)
                Card(
                  color: Colors.blue.shade50,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Row(children: [
                        Icon(Icons.phone, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('📞 打电话时的脚本', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                      ]),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.blue.shade200)),
                        child: SelectableText(e['vet_call_script'], style: const TextStyle(height: 1.5)),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: e['vet_call_script']));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('电话脚本已复制, 打电话时可粘贴给医生')));
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('复制脚本'),
                      ),
                    ]),
                  ),
                ),

              // 拨打按钮
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () {
                        showDialog(context: context, builder: (_) => AlertDialog(
                          title: const Text('📞 拨打 120 急救'),
                          content: const Text('120 是人类急救电话, 宠物医院电话请提前存. \n\n如需紧急找最近 24h 宠物医院: \n1. 高德/百度地图搜"宠物医院 24小时" \n2. 美团/大众点评搜附近宠物医院 \n3. 拨打 96319 宠物 120 转接 (部分地区有)'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('知道了')),
                          ],
                        ));
                      },
                      icon: const Icon(Icons.phone, size: 28),
                      label: const Text('联系医院', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<String> items, Color color) {
    return Card(
      color: color.withValues(alpha: 0.08),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          for (final i in items) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• $i', style: const TextStyle(height: 1.5))),
        ]),
      ),
    );
  }

  Widget _checkList(String title, List<String> items, Color color) {
    return Card(
      color: Colors.green.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 8),
          for (var i = 0; i < items.length; i++) _checkItem(i, items[i]),
        ]),
      ),
    );
  }

  Widget _checkItem(int idx, String text) {
    final done = _done.contains(idx);
    return InkWell(
      onTap: () => setState(() => done ? _done.remove(idx) : _done.add(idx)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: done ? Colors.green : Colors.white,
              border: Border.all(color: done ? Colors.green : Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: done ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(decoration: done ? TextDecoration.lineThrough : null, color: done ? Colors.grey : null, height: 1.5))),
        ]),
      ),
    );
  }
}
