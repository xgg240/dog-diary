// ============================================================
//  宠物列表
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import 'pet_detail_page.dart';
import 'pet_edit_sheet.dart';

import '../../core/ui/modern_widgets.dart';
class PetsPage extends ConsumerWidget {
  const PetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsStreamProvider);
    return Scaffold(
      appBar: ModernPageHeader(title: '我的宠物'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (_) => const PetEditSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('新增宠物'),
      ),
      body: petsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
        data: (pets) {
          if (pets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pets, size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('还没有宠物', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('点击右下角 + 添加第一只宠物', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (_, i) {
              final p = pets[i];
              final age = p.birthday != null
                  ? (DateTime.now().difference(p.birthday!).inDays / 365.25).toStringAsFixed(1)
                  : null;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(p.name.isNotEmpty ? p.name[0] : '🐕',
                        style: const TextStyle(fontSize: 24)),
                  ),
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text([
                    p.breed ?? '未填品种',
                    if (age != null) '$age 岁',
                    p.gender == 'male' ? '♂' : '♀',
                    if (p.neutered) '已绝育',
                  ].join(' · ')),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: '编辑',
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          showDragHandle: true,
                          builder: (_) => PetEditSheet(existing: p),
                        );
                      },
                    ),
                    const Icon(Icons.chevron_right),
                  ]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PetDetailPage(petId: p.id)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
