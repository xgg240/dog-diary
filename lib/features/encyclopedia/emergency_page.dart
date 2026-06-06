// 急症快速入口 - 选择 + 详情
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
// ============================================================
//  急症选择页 (从 SOS FAB 点开)
// ============================================================
class EmergencyListPage extends StatelessWidget {
  const EmergencyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.error,
        foregroundColor: cs.onError,
        title: const Text('急症快查'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
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
              Container(
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.error.withValues(alpha: 0.3), width: 0.5),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Icon(Icons.emergency_rounded, color: cs.error, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '以下急症处理步骤仅供临时急救, 黄金时间内必须送医!',
                      style: TextStyle(color: cs.onErrorContainer, fontWeight: FontWeight.w600, fontSize: 13.5, height: 1.4),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 12),
              for (final e in list) _card(context, e),
            ],
          );
        },
      ),
    );
  }

  Widget _card(BuildContext ctx, Map<String, dynamic> e) {
    final critical = e['severity'] == 'critical';
    final cs = Theme.of(ctx).colorScheme;
    final accent = critical ? cs.error : cs.tertiary;
    final onAccent = critical ? cs.onErrorContainer : cs.onTertiaryContainer;
    final accentContainer = critical ? cs.errorContainer : cs.tertiaryContainer;
    return Card(
      // critical 跟 normal 用语义色块, 跟 surface 背景区分
      color: accentContainer.withValues(alpha: 0.45),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accent.withValues(alpha: 0.25), width: 0.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: accent,
          foregroundColor: cs.onError,
          radius: 22,
          child: Text(e['icon'], style: const TextStyle(fontSize: 20)),
        ),
        title: Text(e['name_zh'], style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: onAccent, letterSpacing: 0.1)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: cs.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: accent.withValues(alpha: 0.3), width: 0.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('⏱️', style: TextStyle(fontSize: 12, height: 1.0)),
              const SizedBox(width: 4),
              Text(
                '黄金时间 ${e['golden_time']}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                  color: onAccent,
                ),
              ),
            ]),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: critical ? Theme.of(ctx).colorScheme.error : null),
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
    final cs = Theme.of(context).colorScheme;
    final e = widget.emergency;
    final critical = e['severity'] == 'critical';
    final bgColor = critical ? cs.error : cs.tertiary;
    final onBg = critical ? cs.onError : cs.onTertiary;
    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: bgColor,
            foregroundColor: onBg,
            expandedHeight: 220,
            pinned: true,
            collapsedHeight: kToolbarHeight,
            toolbarHeight: kToolbarHeight,
            // 标题留出位置, 不与 background 重叠
            title: Text('${e['icon']} ${e['name_zh']}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: onBg)),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: const EdgeInsets.only(left: 16, right: 56, bottom: 14),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: critical
                        ? [cs.error, cs.error.withValues(alpha: 0.85)]
                        : [cs.tertiary, cs.tertiary.withValues(alpha: 0.85)],
                  ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                  left: 16,
                  right: 16,
                  bottom: 56,
                ),
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Icon(Icons.timer_outlined, color: onBg, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '黄金时间: ${e['golden_time']}',
                          style: TextStyle(color: onBg, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Text(
                      '⚠️ ${e['when_to_vet']}',
                      style: TextStyle(color: onBg.withValues(alpha: 0.92), fontSize: 13, height: 1.3, fontWeight: FontWeight.w400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),

              // 警示症状
              _section(context, '🔍 警示症状', [e['warning_signs']], Theme.of(context).colorScheme.error),

              // 可能原因
              if (e['common_toxins'] != null)
                _section(context, '☠️ 常见毒物', (e['common_toxins'] as List).cast<String>(), Theme.of(context).colorScheme.tertiary)
              else if (e['common_causes'] != null)
                _section(context, '⚠️ 常见原因', (e['common_causes'] as List).cast<String>(), Theme.of(context).colorScheme.error)
              else if (e['common_situations'] != null)
                _section(context, '🚗 常见场景', (e['common_situations'] as List).cast<String>(), Theme.of(context).colorScheme.primary)
              else if (e['common_objects'] != null)
                _section(context, '🧦 常见物品', (e['common_objects'] as List).cast<String>(), Theme.of(context).colorScheme.tertiary)
              else if (e['common_dogs'] != null)
                _section(context, '🐕 高发犬种', (e['common_dogs'] as List).cast<String>(), Theme.of(context).colorScheme.primary),

              // 居家急救 (可勾选)
              _checkList(context, '🏠 居家急救 (按顺序做)', (e['home_care'] as List).cast<String>(), Theme.of(context).colorScheme.tertiary),

              // 绝对禁忌
              _section(context, '🚫 绝对禁忌', (e['absolute_donts'] as List).cast<String>(), Theme.of(context).colorScheme.error),

              // 送医时机
              _section(context, '🚑 何时送医', [e['when_to_vet']], Theme.of(context).colorScheme.error),

              // 电话脚本
              if (e['vet_call_script'] != null)
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.4),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2), width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.phone_in_talk_rounded, color: Theme.of(context).colorScheme.tertiary),
                        const SizedBox(width: 8),
                        Text('打电话时的脚本', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                      ]),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                        ),
                        child: SelectableText(e['vet_call_script'], style: TextStyle(height: 1.5, color: Theme.of(context).colorScheme.onSurface, fontSize: 13.5)),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: e['vet_call_script']));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('电话脚本已复制, 打电话时可粘贴给医生')));
                          },
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          label: const Text('复制脚本'),
                        ),
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
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
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

  Widget _section(BuildContext context, String title, List<String> items, Color color) {
    return Card(
      color: color.withValues(alpha: 0.08),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 3, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.1))),
          ]),
          const SizedBox(height: 10),
          for (final i in items) Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text('• $i', style: TextStyle(height: 1.55, color: Theme.of(context).colorScheme.onSurface, fontSize: 13.5)),
          ),
        ]),
      ),
    );
  }

  Widget _checkList(BuildContext context, String title, List<String> items, Color color) {
    return Card(
      color: color.withValues(alpha: 0.08),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 3, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.1))),
          ]),
          const SizedBox(height: 10),
          for (var i = 0; i < items.length; i++) _checkItem(context, i, items[i], color),
        ]),
      ),
    );
  }

  Widget _checkItem(BuildContext context, int idx, String text, Color color) {
    final cs = Theme.of(context).colorScheme;
    final done = _done.contains(idx);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => done ? _done.remove(idx) : _done.add(idx)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              color: done ? color : Colors.transparent,
              border: Border.all(color: done ? color : cs.outline, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: done ? Icon(Icons.check_rounded, size: 16, color: cs.onPrimary) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                decoration: done ? TextDecoration.lineThrough : null,
                color: done ? cs.onSurfaceVariant : cs.onSurface,
                height: 1.55,
                fontSize: 13.5,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
