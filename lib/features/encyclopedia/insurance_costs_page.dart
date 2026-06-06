// 医保/费用估算
import 'package:flutter/material.dart';
import 'data_loader.dart';
import '../../core/ui/design_tokens.dart';
class InsuranceCostsPage extends StatelessWidget {
  const InsuranceCostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('💰 医保/费用估算')),
      body: FutureBuilder(
        future: DataLoader.insurance(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _costTable(context, d['annual_cost_estimate']),
              const SizedBox(height: 8),
              _surgeryTable(context, d['annual_cost_estimate']['common_surgery_cost_cny']),
              const SizedBox(height: 8),
              _insuranceGuide(context, d['insurance_guide']),
              const SizedBox(height: 8),
              _providers(context, d['insurance_guide']['providers_zh']),
              const SizedBox(height: 8),
              _keyTerms(context, d['insurance_guide']['key_terms']),
              const SizedBox(height: 8),
              _claimProcess(context, d['insurance_guide']['claim_process']),
              const SizedBox(height: 8),
              _commonRejection(context, d['insurance_guide']['common_rejection']),
              const SizedBox(height: 8),
              _breedExclusions(context, d['insurance_guide']['breed_exclusions']),
              const SizedBox(height: 8),
              _emergencyFund(context, d['insurance_guide']['emergency_fund_recommendation']),
              const SizedBox(height: 8),
              _buyingTips(context, d['insurance_guide']['buying_tips']),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  Widget _costTable(BuildContext context, Map<String, dynamic> d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final e in (d['by_size'] as Map).entries) Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                title: Text(_sizeLabelZh(e.key), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('年常规: ¥${((e.value['annual_routine_cny'] as List?)?.join(' - ') ?? '')}\n'
                    '• 疫苗: ¥${e.value['breakdown']['疫苗']}\n'
                    '• 驱虫: ¥${e.value['breakdown']['驱虫']}\n'
                    '• 体检: ¥${e.value['breakdown']['体检']}\n'
                    '• 日粮: ¥${e.value['breakdown']['日粮(干粮)']}\n'
                    '• 美容: ¥${e.value['breakdown']['美容']}\n'
                    '• 应急: ¥${e.value['breakdown']['意外应急']}'),
                isThreeLine: true,
              ),
            ),
          ]),
        ),
      );

  Widget _surgeryTable(BuildContext context, Map<String, dynamic> d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('🛠 常见手术费用', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final e in d.entries) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
              Expanded(child: Text(e.key)),
              Text('¥${((e.value as List?)?.join(' - ') ?? '')}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
            ])),
          ]),
        ),
      );

  Widget _insuranceGuide(BuildContext context, Map<String, dynamic> d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final p in (d['providers_zh'] as List<dynamic>)) ListTile(
              dense: true,
              title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('月费: ¥${((p['monthly_cny'] as List?)?.join('-') ?? '')} · ${p['coverage']}'),
            ),
            const SizedBox(height: 8),
            const Text('💡 注意事项:', style: TextStyle(fontWeight: FontWeight.bold)),
            for (final t in ((d['buying_tips']?['items'] as List<dynamic>?) ?? const <dynamic>[])) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('• $t')),
            const SizedBox(height: 8),
            Card(color: Theme.of(context).colorScheme.errorContainer, child: Padding(padding: const EdgeInsets.all(8), child: Text(d['buying_tips']?['title']?.toString() ?? ''))),
          ]),
        ),
      );

  String _sizeLabelZh(String s) => switch (s) { 'small' => '🐶 小型犬', 'medium' => '🐕 中型犬', 'large' => '🦮 大型犬', _ => s };
}

  Widget _providers(BuildContext context, List items) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('🏢 国内主流宠物医保', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
          const SizedBox(height: 10),
          for (final p in items) Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('• ${p['name']}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: cs.onSurface)),
              const SizedBox(height: 2),
              Text('月费: ¥${((p['monthly_cny'] as List?)?.join('-') ?? '')} | 保障: ${p['coverage']}', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12, height: 1.4)),
              Text('等待期: ${p['waiting_period']} | 免赔: ${p['deductible']} | 报销: ${p['reimbursement_ratio']}', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12, height: 1.4)),
              Text('适合: ${p['best_for']}', style: TextStyle(color: cs.primary, fontSize: 12, height: 1.4)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _keyTerms(BuildContext context, Map data) {
    final cs = Theme.of(context).colorScheme;
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
      const SizedBox(height: 8),
      for (final i in (data['items'] as List).cast<String>()) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: TextStyle(height: 1.4, color: cs.onSurface))),
    ])));
  }

  Widget _claimProcess(BuildContext context, Map data) {
    final cs = Theme.of(context).colorScheme;
    return Card(color: cs.tertiaryContainer.withValues(alpha: 0.4), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onTertiaryContainer)),
      const SizedBox(height: 8),
      for (final i in (data['items'] as List).cast<String>()) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: TextStyle(height: 1.4, color: cs.onSurface))),
    ])));
  }

  Widget _commonRejection(BuildContext context, Map data) {
    final cs = Theme.of(context).colorScheme;
    return Card(color: cs.errorContainer.withValues(alpha: 0.4), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onErrorContainer)),
      const SizedBox(height: 8),
      for (final i in (data['items'] as List).cast<String>()) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: TextStyle(height: 1.4, color: cs.onSurface))),
    ])));
  }

  Widget _breedExclusions(BuildContext context, Map data) {
    final cs = Theme.of(context).colorScheme;
    return Card(color: cs.secondaryContainer.withValues(alpha: 0.4), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSecondaryContainer)),
      const SizedBox(height: 8),
      for (final i in (data['items'] as List).cast<String>()) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: TextStyle(height: 1.4, color: cs.onSurface))),
    ])));
  }

  Widget _emergencyFund(BuildContext context, Map data) {
    final cs = Theme.of(context).colorScheme;
    return Card(color: cs.primaryContainer.withValues(alpha: 0.4), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onPrimaryContainer)),
      const SizedBox(height: 8),
      for (final i in (data['items'] as List).cast<String>()) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: TextStyle(height: 1.4, color: cs.onSurface))),
    ])));
  }

  Widget _buyingTips(BuildContext context, Map data) {
    final cs = Theme.of(context).colorScheme;
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
      const SizedBox(height: 8),
      for (final i in (data['items'] as List).cast<String>()) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(i, style: TextStyle(height: 1.4, color: cs.onSurface))),
    ])));
  }
