// 宠物友好 - 极简单色版 (黑白灰)
// 抛弃绿色渐变 + emoji

import 'package:flutter/material.dart';
import '../encyclopedia/data_loader.dart';
import '../encyclopedia/dog_play_spots_page.dart';
import '../../core/ui/design_tokens.dart';

class DogPlayCard extends StatefulWidget {
  const DogPlayCard({super.key});
  @override
  State<DogPlayCard> createState() => _DogPlayCardState();
}

class _DogPlayCardState extends State<DogPlayCard> {
  final _pageCtrl = PageController(viewportFraction: 0.85);

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DogPlaySpotsPage())),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline, width: 0.5),
          ),
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Map<String, dynamic>>(
            future: DataLoader.dogPlay(),
            builder: (ctx, snap) {
              if (!snap.hasData) {
                return SizedBox(
                  height: 80,
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: cs.onSurface),
                    ),
                  ),
                );
              }
              final data = snap.data!;
              final total = data['total_spots'] ?? 0;
              final cities = data['total_cities'] ?? 0;
              final spots = ((data['spots'] as List?) ?? []).take(6).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题区
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: cs.onSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.park_rounded, color: cs.surface, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '宠物友好',
                              style: AppTypography.titleMedium.copyWith(color: cs.onSurface),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$cities 城市 · $total 个推荐',
                              style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: cs.onSurfaceVariant, size: 18),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 横滑卡片
                  SizedBox(
                    height: 110,
                    child: PageView.builder(
                      controller: _pageCtrl,
                      itemCount: spots.length,
                      itemBuilder: (_, i) {
                        final s = spots[i] as Map;
                        final name = s['name'] ?? '';
                        final cat = s['category'] ?? '';
                        final city = s['city'] ?? '';
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: cs.outline, width: 0.5),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: cs.surfaceContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    cat.toString(),
                                    style: AppTypography.caption.copyWith(
                                      color: cs.onSurface,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      name.toString(),
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: cs.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      city.toString(),
                                      style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
