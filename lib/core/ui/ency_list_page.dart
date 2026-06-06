// 百科子页通用模板 v7 - 跟 HumanMedsPage 风格完全一致
// 搜索框 + 类目 Chip 行 + 状态 Chip 行 + ListView(leading icon, title, subtitle, trailing badge) + 详情 BottomSheet
// 黑白蓝配色, 现代极简

import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'modern_widgets.dart';

/// 条目
class EncyItem {
  EncyItem({
    required this.title,
    this.subtitle,
    this.description,
    this.severity,
    this.category,
    this.icon = Icons.article_rounded,
    this.details = const {},
  });
  final String title;
  final String? subtitle;
  final String? description;
  final String? severity;        // 紧急程度, 如 '禁用/慎用/安全'
  final String? category;        // 类目, 用于类目筛选
  final IconData icon;
  final Map<String, String> details;  // 详情 sheet 内容

  String? get _severityColorKey => severity;
}

/// 状态色 - 禁用/慎用/安全 等语义色
class SeverityPalette {
  const SeverityPalette({
    this.danger = '禁用',
    this.warning = '慎用',
    this.safe = '安全',
  });
  final String danger;
  final String warning;
  final String safe;

  bool isDanger(String? s) => s == danger;
  bool isWarning(String? s) => s == warning;
  bool isSafe(String? s) => s == safe;
}

/// 通用百科子页
class EncyListPage extends StatefulWidget {
  const EncyListPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.items,
    this.searchHint = '搜索',
    this.palette = const SeverityPalette(),
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final List<EncyItem> items;
  final String searchHint;
  final SeverityPalette palette;

  @override
  State<EncyListPage> createState() => _EncyListPageState();
}

class _EncyListPageState extends State<EncyListPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _catFilter = '全部';
  String _statusFilter = '全部';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cats = <String>{'全部'}.followedBy(widget.items.map((e) => e.category).whereType<String>()).toList();
    final hasCategory = cats.length > 1;
    final severities = <String>{'全部', widget.palette.danger, widget.palette.warning, widget.palette.safe, '兽医处方'}
        .where((s) => widget.items.any((e) => e.severity == s)).toSet().toList()
      ..insert(0, '全部');
    final hasStatus = severities.length > 1;

    final filtered = widget.items.where((e) {
      if (_catFilter != '全部' && e.category != _catFilter) return false;
      if (_statusFilter != '全部' && e.severity != _statusFilter) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          (e.subtitle?.toLowerCase().contains(q) ?? false) ||
          (e.description?.toLowerCase().contains(q) ?? false);
    }).toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: ModernPageHeader(
        title: widget.title,
        subtitle: widget.subtitle,
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: cs.outline, width: 0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search_rounded, color: cs.onSurfaceVariant, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _query = v.trim()),
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.close_rounded, color: cs.onSurfaceVariant, size: 18),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 状态筛选 (紧急程度)
          if (hasStatus) _ChipRow(
            options: severities,
            current: _statusFilter,
            onPick: (s) => setState(() => _statusFilter = s),
            getColor: (s) {
              if (widget.palette.isDanger(s)) return cs.error;
              if (widget.palette.isWarning(s)) return cs.tertiary;
              if (widget.palette.isSafe(s)) return cs.tertiary;
              return cs.primary;
            },
          ),

          // 类目筛选
          if (hasCategory) _ChipRow(
            options: cats,
            current: _catFilter,
            onPick: (s) => setState(() => _catFilter = s),
            getColor: (_) => cs.primary,
          ),

          // 列表
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_rounded, color: cs.onSurfaceVariant, size: 48),
                        const SizedBox(height: 12),
                        Text('无结果', style: AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: cs.outlineVariant,
                      indent: 60,
                    ),
                    itemBuilder: (_, i) => _ItemRow(
                      item: filtered[i],
                      palette: widget.palette,
                      onTap: () => _openDetail(filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _openDetail(EncyItem e) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DetailSheet(item: e, icon: widget.icon),
    );
  }
}

// ============================================================
//  Chip 横排 (可横滑)
// ============================================================
class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.options,
    required this.current,
    required this.onPick,
    required this.getColor,
  });

  final List<String> options;
  final String current;
  final ValueChanged<String> onPick;
  final Color Function(String) getColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final opt = options[i];
          final selected = opt == current;
          final color = getColor(opt);
          return GestureDetector(
            onTap: () => onPick(opt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? color : cs.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: selected ? color : cs.outline,
                  width: 0.5,
                ),
              ),
              child: Text(
                opt,
                style: AppTypography.bodySmall.copyWith(
                  color: selected ? cs.onPrimary : cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
//  List row
// ============================================================
class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.palette, required this.onTap});
  final EncyItem item;
  final SeverityPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: cs.onSurface, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (item.severity != null) _SeverityBadge(label: item.severity!, palette: palette),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, size: 18, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.label, required this.palette});
  final String label;
  final SeverityPalette palette;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color bg, fg;
    if (palette.isDanger(label)) {
      bg = cs.errorContainer; fg = cs.onErrorContainer;
    } else if (palette.isWarning(label)) {
      bg = cs.tertiaryContainer; fg = cs.onTertiaryContainer;
    } else if (palette.isSafe(label)) {
      bg = cs.tertiaryContainer; fg = cs.onTertiaryContainer;
    } else {
      bg = cs.primaryContainer; fg = cs.onPrimaryContainer;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================
//  详情 BottomSheet
// ============================================================
class _DetailSheet extends StatelessWidget {
  const _DetailSheet({required this.item, required this.icon});
  final EncyItem item;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (sctx, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: cs.onSurface, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: AppTypography.titleLarge.copyWith(color: cs.onSurface)),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(item.subtitle!, style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (item.severity != null) ...[
              _MetaRow(label: '紧急程度', value: item.severity!),
              const SizedBox(height: 8),
            ],
            if (item.category != null) ...[
              _MetaRow(label: '类目', value: item.category!),
              const SizedBox(height: 8),
            ],
            if (item.description != null && item.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('说明', style: AppTypography.titleSmall.copyWith(color: cs.onSurface)),
              const SizedBox(height: 8),
              Text(item.description!, style: AppTypography.bodyMedium.copyWith(color: cs.onSurface, height: 1.6)),
            ],
            if (item.details.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('详细', style: AppTypography.titleSmall.copyWith(color: cs.onSurface)),
              const SizedBox(height: 8),
              for (final entry in item.details.entries) ...[
                _MetaRow(label: entry.key, value: entry.value),
                const SizedBox(height: 6),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
        ),
        Expanded(
          child: Text(value, style: AppTypography.bodyMedium.copyWith(color: cs.onSurface)),
        ),
      ],
    );
  }
}
