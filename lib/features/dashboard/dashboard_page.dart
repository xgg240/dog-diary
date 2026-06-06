// ============================================================
//  仪表盘 - 接入宠物/健康预警/低库存/本月消费
// ============================================================

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/reminder_service.dart';
import '../contacts/contacts_page.dart';
import 'weight_chart_card.dart';
import 'dog_play_card.dart';
import '../../db/database.dart';
import 'blacklist_alert.dart';
import '../nearby/nearby_page.dart';
import '../nearby/nearby_online.dart';
import '../../core/location_service.dart';
import '../../core/pet_switcher_provider.dart';
import '../../core/ui/design_tokens.dart';
import '../../core/ui/modern_widgets.dart';

final _overdueProvider = StreamProvider<List<dynamic>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).healthEvents)
        ..where((t) => t.nextDueDate.isSmallerThanValue(DateTime.now()))
        ..orderBy([(t) => drift.OrderingTerm.asc(t.nextDueDate)]))
      .watch();
});
final _upcomingProvider = StreamProvider<List<dynamic>>((ref) {
  final in30 = DateTime.now().add(const Duration(days: 30));
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).healthEvents)
        ..where((t) => t.nextDueDate.isBetweenValues(DateTime.now(), in30))
        ..orderBy([(t) => drift.OrderingTerm.asc(t.nextDueDate)]))
      .watch();
});
final _lowStockProvider = StreamProvider<List<dynamic>>((ref) {
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).foodItems)
        ..where((t) => t.remainingKg.isSmallerOrEqualValue(1.0)))
      .watch();
});
final _monthExpenseProvider = StreamProvider<double>((ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 1);
  return (ref.watch(databaseProvider).select(ref.watch(databaseProvider).expenses)
        ..where((t) => t.spentAt.isBetweenValues(start, end)))
      .watch()
      .map((list) => list.fold<double>(0, (s, e) => s + e.amount));
});

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsStreamProvider);
    final overdueAsync = ref.watch(_overdueProvider);
    final upcomingAsync = ref.watch(_upcomingProvider);
    final lowAsync = ref.watch(_lowStockProvider);
    final monthExpAsync = ref.watch(_monthExpenseProvider);
    final pets = petsAsync.value ?? const <Pet>[];
    final currentPetId = ref.watch(currentPetIdProvider);
    return Scaffold(
      appBar: const ModernPageHeader(
        title: '我的养狗日记',
        centerTitle: true,
      ),
      body: petsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => ModernEmptyState(
          icon: Icons.error_outline_rounded,
          title: '加载错误',
          subtitle: '$e',
          isError: true,
          action: FilledButton(onPressed: () => ref.invalidate(petsStreamProvider), child: const Text('重试')),
        ),
        data: (pets) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            // ===== 宠物概览 =====
            if (pets.isNotEmpty) ...[
              _PetsOverviewCard(pets: pets),
              const SizedBox(height: 24),
            ],

            // ===== 健康监控 =====
            ModernCard(
              padding: EdgeInsets.zero,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: _InlineStat(
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.danger,
                      label: '已逾期',
                      value: overdueAsync.when(
                        loading: () => '-',
                        error: (_, __) => '!',
                        data: (l) => '${l.length}',
                      ),
                      onTap: () => Navigator.pushNamed(context, '/health'),
                    )),
                    VerticalDivider(width: 0.5, thickness: 0.5, color: Theme.of(context).colorScheme.outlineVariant),
                    Expanded(child: _InlineStat(
                      icon: Icons.schedule_rounded,
                      color: AppColors.warning,
                      label: '30 天内',
                      value: upcomingAsync.when(
                        loading: () => '-',
                        error: (_, __) => '!',
                        data: (l) => '${l.length}',
                      ),
                      onTap: () => Navigator.pushNamed(context, '/health'),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ===== 库存与财务 =====
            ModernCard(
              padding: EdgeInsets.zero,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: _InlineStat(
                      icon: Icons.kitchen_rounded,
                      color: AppColors.textSecondary,
                      label: '低库存',
                      value: lowAsync.when(
                        loading: () => '-',
                        error: (_, __) => '!',
                        data: (l) => '${l.length}',
                      ),
                      onTap: () => Navigator.pushNamed(context, '/food'),
                    )),
                    VerticalDivider(width: 0.5, thickness: 0.5, color: Theme.of(context).colorScheme.outlineVariant),
                    Expanded(child: _InlineStat(
                      icon: Icons.account_balance_wallet_rounded,
                      color: AppColors.blue,
                      label: '本月',
                      value: monthExpAsync.when(
                        loading: () => '-',
                        error: (_, __) => '!',
                        data: (v) => '¥${v.toStringAsFixed(0)}',
                      ),
                      onTap: () => Navigator.pushNamed(context, '/finance'),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ===== 体重曲线 =====
            WeightChartCard(),
            const SizedBox(height: 24),

            // ===== 周边服务 =====
            ModernCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ModernListTile(
                    icon: Icons.local_hospital_outlined,
                    color: AppColors.danger,
                    title: '附近医院',
                    subtitle: '查找最近的 24h 宠物医院',
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyPage())),
                  ),
                  const Divider(height: 0.5, thickness: 0.5, indent: 64),
                  const DogPlayCard(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===== 黑名单警告 =====
            BlacklistAlertCard(),
            const SizedBox(height: 24),

            // ===== 快捷入口 =====
            const SizedBox(height: 4),
            ModernCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Expanded(child: _QuickAction(icon: Icons.phone_outlined, label: '紧急', color: AppColors.danger, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsPage())))),
                  Expanded(child: _QuickAction(icon: Icons.directions_walk_rounded, label: '遛狗', color: AppColors.success, onTap: () => Navigator.pushNamed(context, '/walks'))),
                  Expanded(child: _QuickAction(icon: Icons.school_outlined, label: '训练', color: AppColors.blue, onTap: () => Navigator.pushNamed(context, '/training'))),
                  Expanded(child: _QuickAction(icon: Icons.menu_book_outlined, label: '百科', color: AppColors.textSecondary, onTap: () => Navigator.pushNamed(context, '/encyclopedia'))),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                '今日已同步',
                style: AppTypography.caption.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//  内联统计 (新版 - 紧凑版)
// ============================================================

class _InlineStat extends StatelessWidget {
  const _InlineStat({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final card = Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              color: cs.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: card,
    );
  }
}

// ============================================================
//  快捷入口 (新版 - icon, 不再用 emoji)
// ============================================================

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class _PetsOverviewCard extends ConsumerWidget {
  final List<Pet> pets;
  const _PetsOverviewCard({required this.pets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: cs.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.pets, color: cs.onPrimaryContainer, size: 18),
            const SizedBox(width: 6),
            Text('我的宠物们 · 共 ${pets.length} 只',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: cs.onPrimaryContainer)),
            const Spacer(),
            Text('点查看详情 >', style: TextStyle(fontSize: 11, color: cs.onPrimaryContainer.withValues(alpha: 0.7))),
          ]),
          const SizedBox(height: 12),
          // 每只狗一行
          for (int i = 0; i < pets.length; i++) ...[
            if (i > 0) Divider(height: 14, color: cs.onPrimaryContainer.withValues(alpha: 0.15)),
            _PetRow(pet: pets[i]),
          ],
        ]),
      ),
    );
  }
}

class _PetRow extends ConsumerWidget {
  final Pet pet;
  const _PetRow({required this.pet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final weightAsync = ref.watch(_latestWeightProvider(pet.id));
    final ageStr = _ageStr(pet);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/pets'),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          // 头像圆 (首字)
          CircleAvatar(
            radius: 20,
            backgroundColor: cs.primary,
            child: Text(
              pet.name.isNotEmpty ? pet.name[0] : '?',
              style: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          // 名字 + 年龄
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(pet.name.isEmpty ? '未命名' : pet.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cs.onPrimaryContainer)),
              const SizedBox(height: 2),
              Text(ageStr, style: TextStyle(fontSize: 11, color: cs.onPrimaryContainer.withValues(alpha: 0.75))),
            ]),
          ),
          // 体重
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(weightAsync.when(
              data: (w) => w != null ? '${w.toStringAsFixed(1)} kg' : '—',
              loading: () => '...',
              error: (_, __) => '—',
            ), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cs.onPrimaryContainer)),
            const SizedBox(height: 2),
            Text('体重', style: TextStyle(fontSize: 10, color: cs.onPrimaryContainer.withValues(alpha: 0.7))),
          ]),
        ]),
      ),
    );
  }

  String _ageStr(Pet pet) {
    if (pet.birthday == null) return pet.breed ?? '品种未知';
    final now = DateTime.now();
    final diff = now.difference(pet.birthday!);
    final years = diff.inDays ~/ 365;
    final months = (diff.inDays % 365) ~/ 30;
    if (years >= 1) return '$years 岁${months > 0 ? " $months 月" : ""}';
    if (months >= 1) return '$months 月';
    return '${diff.inDays} 天';
  }
}

// ============================================================
//  最新体重 provider (per pet)
// ============================================================
final _latestWeightProvider = StreamProvider.autoDispose.family<double?, int>((ref, petId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.weightRecords)
        ..where((t) => t.petId.equals(petId))
        ..orderBy([(t) => drift.OrderingTerm.desc(t.measuredAt)])
        ..limit(1))
      .watch()
      .map((list) => list.isEmpty ? null : list.first.weightKg);
});

// ============================================================
//  附近医院卡片 - 实时查最近 3 个医院+距离
// ============================================================
class _NearbyHospitalsCard extends StatefulWidget {
  final VoidCallback onTap;
  const _NearbyHospitalsCard({required this.onTap});
  @override
  State<_NearbyHospitalsCard> createState() => _NearbyHospitalsCardState();
}

class _NearbyHospitalsCardState extends State<_NearbyHospitalsCard> {
  List<NearbyPoi> _items = [];
  bool _loading = true;
  String? _err;

  @override
  void initState() {
    super.initState();
    // 不写死城市! GPS 拿到 → 自动设 override; IP 拿到 → 自动设 override;
    // 用户在 nearby 点选 → 手动设 override
    _load();
  }

  Future<void> _load() async {
    try {
      final result = await Future(() async {
        // 用 LocationService 全局 override city (会优先生效)
        final pos = await LocationService.getMyLocation();
        if (pos == null) return <NearbyPoi>[];
        return await NearbyService.search(lat: pos.lat, lng: pos.lng, category: 'hospital', radiusM: 8000);
      }).timeout(const Duration(seconds: 10), onTimeout: () => <NearbyPoi>[]);
      if (!mounted) return;
      setState(() { _items = result.take(3).toList(); _loading = false; _err = result.isEmpty ? '附近暂无' : null; });
    } catch (_) {
      if (!mounted) return;
      setState(() { _loading = false; _err = '查询失败'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: const Color(0xFF1B5E20),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 14)),
              const SizedBox(width: 6),
              Expanded(child: const Text('附近医院', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const Icon(Icons.chevron_right, color: Colors.white70, size: 14),
            ]),
            const SizedBox(height: 6),
            if (_loading)
              const SizedBox(height: 18, child: Center(child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white))))
            else if (_err != null)
              Text(_err!, style: const TextStyle(color: Colors.white70, fontSize: 10))
            else if (_items.isEmpty)
              const Text('附近暂无医院', style: TextStyle(color: Colors.white70, fontSize: 10))
            else
              ..._items.take(3).map((p) => Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text('${p.name} ${(p.distance ?? 0).toStringAsFixed(1)}km', style: const TextStyle(color: Colors.white, fontSize: 9, height: 1.2), maxLines: 1, overflow: TextOverflow.ellipsis),
              )),
          ]),
        ),
      ),
    );
  }
}
