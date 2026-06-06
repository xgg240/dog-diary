// 通用内容页 v2 - 数据驱动的列表 / 详情 / 搜索
// 用 ModernPageHeader, ModernSectionHeader, ModernCard, ModernSearchBar, ModernChipRow

import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'modern_widgets.dart';

abstract class ContentItem {
  String get title;
  String? get subtitle;
  String? get description;
  String? get tag;
  String? get severity;
  IconData? get icon;
  String? get category;
  Map<String, String> get details;
}

class ListContentPage<T extends ContentItem> extends StatefulWidget {
  const ListContentPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.items,
    this.searchHint = '搜索',
    this.searchFields = const [ContentSearchField.title, ContentSearchField.subtitle, ContentSearchField.description, ContentSearchField.tag],
    this.itemBuilder,
    this.onItemTap,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final List<T> items;
  final String searchHint;
  final List<ContentSearchField> searchFields;
  final Widget Function(BuildContext, T)? itemBuilder;
  final void Function(T)? onItemTap;

  @override
  State<ListContentPage<T>> createState() => _ListContentPageState<T>();
}

enum ContentSearchField { title, subtitle, description, tag, details }

class _ListContentPageState<T extends ContentItem> extends State<ListContentPage<T>> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _filter = '全部';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filters = <String>{'全部'}.followedBy(
      widget.items.map((e) => e.category).whereType<String>().toSet(),
    ).toList();

    final filtered = widget.items.where((item) {
      if (_filter != '全部' && item.category != _filter) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      bool match = false;
      for (final f in widget.searchFields) {
        switch (f) {
          case ContentSearchField.title:
            match = match || item.title.toLowerCase().contains(q);
            break;
          case ContentSearchField.subtitle:
            match = match || (item.subtitle?.toLowerCase().contains(q) ?? false);
            break;
          case ContentSearchField.description:
            match = match || (item.description?.toLowerCase().contains(q) ?? false);
            break;
          case ContentSearchField.tag:
            match = match || (item.tag?.toLowerCase().contains(q) ?? false);
            break;
          case ContentSearchField.details:
            for (final v in item.details.values) {
              if (v.toLowerCase().contains(q)) {
                match = true;
                break;
              }
            }
            break;
        }
      }
      return match;
    }).toList();

    return Scaffold(
      appBar: ModernPageHeader(
        title: widget.title,
        subtitle: widget.subtitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ContentSearchDelegate(
                  items: widget.items.cast<ContentItem>(),
                  searchFields: widget.searchFields,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: ModernSearchBar(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim()),
              onClear: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
              hasText: _query.isNotEmpty,
              hintText: widget.searchHint,
            ),
          ),
          if (filters.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ModernChipRow(
                items: filters,
                selected: _filter,
                onSelect: (c) => setState(() => _filter = c),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} 条',
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_filter != '全部') ...[
                  Text(
                    ' · $_filter',
                    style: TextStyle(
                      color: cs.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (_query.isNotEmpty) ...[
                  Text(
                    ' · 搜 "$_query"',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const ModernEmptyState(
                    icon: Icons.search_off_rounded,
                    title: '没有匹配的内容',
                    subtitle: '试试其他关键词或切换分类',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      if (widget.itemBuilder != null) {
                        return widget.itemBuilder!(context, item);
                      }
                      return _DefaultContentCard(
                        item: item,
                        onTap: widget.onItemTap == null
                            ? null
                            : () => widget.onItemTap!(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DefaultContentCard extends StatelessWidget {
  const _DefaultContentCard({required this.item, this.onTap});
  final ContentItem item;
  final VoidCallback? onTap;

  Color _severityColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (item.severity) {
      case 'safe':
        return AppColors.success;
      case 'caution':
        return AppColors.warning;
      case 'danger':
      case 'fatal':
        return cs.error;
      default:
        return cs.primary;
    }
  }

  String _severityLabel() {
    switch (item.severity) {
      case 'safe':
        return '安全';
      case 'caution':
        return '注意';
      case 'danger':
        return '危险';
      case 'fatal':
        return '致命';
      case 'info':
        return '信息';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sevColor = _severityColor(context);
    final sevLabel = _severityLabel();
    return ModernCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.icon != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: sevColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, size: 20, color: sevColor),
            ),
          if (item.icon != null) const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (sevLabel.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: sevColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          sevLabel,
                          style: TextStyle(
                            color: sevColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle!,
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (item.description != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.description!,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentSearchDelegate<T extends ContentItem> extends SearchDelegate<T?> {
  _ContentSearchDelegate({required this.items, required this.searchFields});
  final List<ContentItem> items;
  final List<ContentSearchField> searchFields;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => close(context, null)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final q = query.toLowerCase();
    if (q.isEmpty) return const SizedBox.shrink();
    final results = items.where((item) {
      for (final f in searchFields) {
        switch (f) {
          case ContentSearchField.title:
            if (item.title.toLowerCase().contains(q)) return true;
            break;
          case ContentSearchField.subtitle:
            if ((item.subtitle ?? '').toLowerCase().contains(q)) return true;
            break;
          case ContentSearchField.description:
            if ((item.description ?? '').toLowerCase().contains(q)) return true;
            break;
          case ContentSearchField.tag:
            if ((item.tag ?? '').toLowerCase().contains(q)) return true;
            break;
          case ContentSearchField.details:
            for (final v in item.details.values) {
              if (v.toLowerCase().contains(q)) return true;
            }
            break;
        }
      }
      return false;
    }).toList();
    if (results.isEmpty) {
      return const ModernEmptyState(
        icon: Icons.search_off_rounded,
        title: '无匹配',
        subtitle: '试试其他关键词',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _DefaultContentCard(item: results[i]),
    );
  }
}
