// ============================================================
//  顶栏宠物切换器 widget（v3 Stage 1）
// ------------------------------------------------------------
//  PopupMenuButton 列出所有宠物，点选切换 currentPetIdProvider
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pet_switcher_provider.dart';
import 'providers.dart';

class PetSwitcher extends ConsumerWidget {
  const PetSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsStreamProvider);
    final currentPet = ref.watch(currentPetProvider);
    final allPets = petsAsync.value ?? [];

    if (allPets.isEmpty) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<int>(
      tooltip: '切换宠物',
      onSelected: (id) {
        ref.read(currentPetIdProvider.notifier).state = id;
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<int>(
            value: -1,
            child: Row(
              children: [
                Icon(Icons.all_inclusive, size: 18),
                SizedBox(width: 8),
                Text('全部宠物'),
              ],
            ),
          ),
          const PopupMenuDivider(),
          ...allPets.map((p) => PopupMenuItem<int>(
                value: p.id,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        p.name.isNotEmpty ? p.name[0] : '?',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(p.name),
                  ],
                ),
              )),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                currentPet?.name.isNotEmpty == true ? currentPet!.name[0] : '全',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              currentPet?.name ?? '全部',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}
