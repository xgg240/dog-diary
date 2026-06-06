// 美容/护理
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class GroomingPage extends StatelessWidget {
  const GroomingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('🛁 美容/护理')),
      body: FutureBuilder(
        future: DataLoader.grooming(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _bath(context, d['bath']),
              const SizedBox(height: 12),
              _nail(context, d['nail_care']),
              const SizedBox(height: 12),
              _ear(context, d['ear_care']),
              const SizedBox(height: 12),
              _dental(context, d['dental_care']),
              const SizedBox(height: 12),
              _anal(context, d['anal_gland']),
              const SizedBox(height: 12),
              _tear(context, d['tear_stain']),
              const SizedBox(height: 12),
              _coat(context, d['coat_care']),
              const SizedBox(height: 12),
              _paw(context, d['paw_care']),
              const SizedBox(height: 12),
              _weight(context, d['weight_management']),
            ],
          );
        },
      ),
    );
  }

  Widget _card(BuildContext context, String title, Widget child, {Color? color, IconData? icon}) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (icon != null) Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
            if (icon != null) const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 8),
          child,
        ]),
      ),
    );
  }

  Widget _bath(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return _card(context, '🛁 洗澡', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('📅 频率:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final e in (d['frequency_by_breed']['items'] as List).cast<Map>())
        Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• ${e['type']}: ${e['freq']}')),
      const SizedBox(height: 8),
      const Text('步骤:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['step_by_step'] as List).cast<String>()) Text(s, style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 4),
      Text('🚫 绝对禁忌:', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
      for (final s in (d['absolutes'] as List).cast<String>()) Text(s, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
    ]), color: Theme.of(context).colorScheme.primaryContainer, icon: Icons.bathtub);
  }

  Widget _nail(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return _card(context, '💅 指甲', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('📅 频率: ${d['frequency']}'),
      const SizedBox(height: 8),
      const Text('🔬 解剖:', style: TextStyle(fontWeight: FontWeight.bold)),
      Text(d['anatomy']),
      const SizedBox(height: 8),
      const Text('✂️ 步骤:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['steps'] as List).cast<String>()) Text(s, style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 8),
      const Text('🔄 替代方案:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['alternatives'] as List).cast<String>()) Text('• $s', style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 4),
      Text('⚠️ ${d['warning']}', style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold)),
    ]), color: Theme.of(context).colorScheme.tertiaryContainer, icon: Icons.content_cut);
  }

  Widget _ear(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    final nva = d['normal_vs_abnormal'];
    return _card(context, '👂 耳朵', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('📅 频率: ${d['frequency']}'),
      const SizedBox(height: 8),
      Text('✅ 正常:', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
      for (final s in (nva['normal'] as List).cast<String>()) Text('• $s', style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 4),
      Text('🚨 异常:', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
      for (final s in (nva['abnormal'] as List).cast<String>()) Text('• $s', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
      const SizedBox(height: 8),
      const Text('步骤:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['steps'] as List).cast<String>()) Text(s, style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 4),
      Text('⚠️ ${d['warning']}', style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold)),
    ]), color: Theme.of(context).colorScheme.errorContainer, icon: Icons.hearing);
  }

  Widget _dental(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return _card(context, '🦷 牙齿', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('📅 频率: ${d['frequency']}'),
      const SizedBox(height: 4),
      Text('💡 ${d['importance']}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontStyle: FontStyle.italic)),
      const SizedBox(height: 8),
      const Text('步骤:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['steps'] as List).cast<String>()) Text(s, style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 8),
      const Text('🦴 辅助:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['supplements'] as List).cast<String>()) Text('• $s', style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer, borderRadius: BorderRadius.circular(4)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['professional_cleaning']['title'], style: const TextStyle(fontWeight: FontWeight.bold, )),
          Text('📅 ${d['professional_cleaning']['frequency']}'),
          Text('💰 ${d['professional_cleaning']['cost_cny']}'),
          Text('⚠️ ${d['professional_cleaning']['warning']}', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
        ]),
      ),
    ]), color: Theme.of(context).colorScheme.primaryContainer, icon: Icons.medical_services);
  }

  Widget _anal(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return _card(context, '💩 肛门腺', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('📅 频率: ${d['frequency']}'),
      const SizedBox(height: 4),
      Text('📖 ${d['function']}', style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 8),
      Text('🚨 问题信号:', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
      for (final s in (d['signs_problem'] as List).cast<String>()) Text(s, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer, borderRadius: BorderRadius.circular(4)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['how_to_express']['warning'], style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          for (final s in (d['how_to_express']['steps'] as List).cast<String>()) Text(s, style: const TextStyle(fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 8),
      const Text('💊 治疗:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['treatment']['items'] as List).cast<String>()) Text('• $s', style: const TextStyle(fontSize: 13)),
    ]), color: Theme.of(context).colorScheme.tertiaryContainer, icon: Icons.warning);
  }

  Widget _tear(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return _card(context, '💧 泪痕', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('🔍 常见原因:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['common_causes'] as List).cast<String>()) Text('• $s', style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 8),
      const Text('💡 解决方案:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['solutions'] as List).cast<String>()) Text(s, style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 4),
      Text('⚠️ ${d['warning']}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
    ]), color: Theme.of(context).colorScheme.primaryContainer, icon: Icons.water_drop);
  }

  Widget _coat(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return _card(context, '🪮 毛发', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('🧰 工具:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final t in (d['tools'] as List).cast<Map>())
        Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• ${t['name']}: ${t['use']}', style: const TextStyle(fontSize: 13))),
      const SizedBox(height: 8),
      Text('🍂 掉毛管理:', style: const TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['shedding']['tips'] as List).cast<String>()) Text('• $s', style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 4),
      Text('⚠️ ${d['shedding']['warning']}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
    ]), color: Theme.of(context).colorScheme.errorContainer, icon: Icons.brush);
  }

  Widget _paw(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return _card(context, '🐾 爪子', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _kv('❄️ 冬天', d['winter']),
      _kv('☀️ 夏天', d['summer']),
      _kv('🩹 干裂', d['crack_care']),
      _kv('💅 指甲', d['nail_trim']),
      _kv('🦶 悬爪', d['dewclaw']),
    ]), color: Theme.of(context).colorScheme.tertiaryContainer, icon: Icons.pets);
  }

  Widget _weight(BuildContext context, d) {
    if (d == null) return const SizedBox.shrink();
    return _card(context, '⚖️ 体重管理', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('✅ ${d['ideal_weight_check']}'),
      const SizedBox(height: 4),
      Text('⚠️ 肥胖风险:', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
      for (final s in (d['obesity_risks'] as List).cast<String>()) Text(s, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
      const SizedBox(height: 8),
      const Text('📉 减肥方案:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (final s in (d['weight_loss_plan'] as List).cast<String>()) Text(s, style: const TextStyle(fontSize: 13)),
    ]), color: Theme.of(context).colorScheme.errorContainer, icon: Icons.monitor_weight);
  }

  Widget _kv(String k, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('$k: $v', style: const TextStyle(fontSize: 13)));
}
