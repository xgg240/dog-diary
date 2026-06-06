// ============================================================
//  药品交互检查字典（v4 Stage 2）
// ------------------------------------------------------------
//  常见犬类药品冲突，简化版不覆盖所有
//  实际处方遵医嘱，本工具仅作提醒
// ============================================================

class DrugInteraction {
  final String drug1;
  final String drug2;
  final String severity; // major / moderate / minor
  final String description;
  const DrugInteraction({
    required this.drug1,
    required this.drug2,
    required this.severity,
    required this.description,
  });
}

class DrugInteractionChecker {
  /// 简化的冲突字典（包含常用犬药的关键交互）
  /// drug1/drug2 小写匹配
  static const _interactions = <DrugInteraction>[
    DrugInteraction(
      drug1: 'nsaid', drug2: 'corticosteroid',
      severity: 'major',
      description: 'NSAID 与类固醇联用 → 胃肠道溃疡风险大增，建议间隔或替代',
    ),
    DrugInteraction(
      drug1: 'nsaid', drug2: 'nsaid',
      severity: 'major',
      description: '两种 NSAID 同时使用 → 肾毒性叠加 + 出血风险',
    ),
    DrugInteraction(
      drug1: 'corticosteroid', drug2: 'nsaid',
      severity: 'major',
      description: '类固醇 + NSAID → 胃出血/溃疡风险',
    ),
    DrugInteraction(
      drug1: 'tramadol', drug2: 'ssri',
      severity: 'major',
      description: '曲马多 + SSRI（氟西汀等）→ 5-羟色胺综合征风险',
    ),
    DrugInteraction(
      drug1: 'metronidazole', drug2: 'phenobarbital',
      severity: 'moderate',
      description: '甲硝唑 + 苯巴比妥 → 甲硝唑代谢加快，疗效降低',
    ),
    DrugInteraction(
      drug1: 'furosemide', drug2: 'ace',
      severity: 'moderate',
      description: '呋塞米 + ACE 抑制剂 → 低血压/肾损伤',
    ),
    DrugInteraction(
      drug1: 'gabapentin', drug2: 'opioid',
      severity: 'moderate',
      description: '加巴喷丁 + 阿片类 → 中枢抑制叠加，嗜睡加剧',
    ),
  ];

  /// 关键词识别：用药名 → 药物类别
  static String? _classify(String medName) {
    final n = medName.toLowerCase();
    if (RegExp(r'(nsaid|美洛昔康|carprofen|meloxicam|ibuprofen|阿司匹林|aspirin|naproxen|etodolac|firocoxib)').hasMatch(n)) {
      return 'nsaid';
    }
    if (RegExp(r'(强的松|泼尼松|prednisone|地塞米松|dexamethasone|泼尼松龙|prednisolone|甲强龙|corticosteroid|类固醇)').hasMatch(n)) {
      return 'corticosteroid';
    }
    if (RegExp(r'(曲马多|tramadol)').hasMatch(n)) {
      return 'tramadol';
    }
    if (RegExp(r'(氟西汀|fluoxetine|舍曲林|sertraline|帕罗西汀|paroxetine|ssri)').hasMatch(n)) {
      return 'ssri';
    }
    if (RegExp(r'(甲硝唑|metronidazole)').hasMatch(n)) {
      return 'metronidazole';
    }
    if (RegExp(r'(苯巴比妥|phenobarbital)').hasMatch(n)) {
      return 'phenobarbital';
    }
    if (RegExp(r'(呋塞米|furosemide)').hasMatch(n)) {
      return 'furosemide';
    }
    if (RegExp(r'(贝那普利|benazepril|enalapril|ace 抑制剂|acei)').hasMatch(n)) {
      return 'ace';
    }
    if (RegExp(r'(加巴喷丁|gabapentin)').hasMatch(n)) {
      return 'gabapentin';
    }
    if (RegExp(r'(吗啡|morphine|布托啡诺|butorphanol|羟考酮|oxycodone|阿片)').hasMatch(n)) {
      return 'opioid';
    }
    return null;
  }

  /// 检查两个药名之间是否有冲突
  /// 返回 null 表示无冲突，否则返回冲突详情
  static DrugInteraction? check(String med1, String med2) {
    final c1 = _classify(med1);
    final c2 = _classify(med2);
    if (c1 == null || c2 == null) return null;
    if (c1 == c2) {
      // 同类药
      if (c1 == 'nsaid') {
        return _interactions.firstWhere((i) => i.drug1 == 'nsaid' && i.drug2 == 'nsaid');
      }
      return null;
    }
    for (final i in _interactions) {
      if ((i.drug1 == c1 && i.drug2 == c2) || (i.drug1 == c2 && i.drug2 == c1)) {
        return i;
      }
    }
    return null;
  }

  /// 检查新药与已有活跃药物的冲突
  /// existingActiveMeds: 当前活跃用药名列表
  /// newMed: 即将添加的药物
  /// 返回所有冲突
  static List<DrugInteraction> checkAgainstActive(
    List<String> existingActiveMeds,
    String newMed,
  ) {
    final conflicts = <DrugInteraction>[];
    for (final m in existingActiveMeds) {
      final c = check(m, newMed);
      if (c != null) conflicts.add(c);
    }
    return conflicts;
  }

  /// 检查某只狗当前所有活跃用药的内部冲突
  /// 启动用药页 / 添加药后调用
  static List<DrugInteraction> checkAll(List<String> activeMeds) {
    final seen = <String>{};
    final out = <DrugInteraction>[];
    for (var i = 0; i < activeMeds.length; i++) {
      for (var j = i + 1; j < activeMeds.length; j++) {
        final c = check(activeMeds[i], activeMeds[j]);
        if (c != null) {
          final key = '${c.drug1}|${c.drug2}';
          if (seen.add(key)) out.add(c);
        }
      }
    }
    return out;
  }
}
