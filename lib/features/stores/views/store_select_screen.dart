import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/brand_theme.dart';
import '../providers/stores_provider.dart';

/// Shown right after login: if the owner has one store we go straight in; if
/// several, they pick which store to open. (They can switch any time later.)
class StoreSelectScreen extends ConsumerWidget {
  const StoreSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stores = ref.watch(myStoresProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      body: SafeArea(
        child: stores.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) {
            // On any failure, don't trap the user — fall through to home.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/home');
            });
            return const Center(child: CircularProgressIndicator());
          },
          data: (list) {
            // 0 or 1 store → no choice to make; proceed.
            if (list.length <= 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go('/home');
              });
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Choose a store',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: BrandColors.ink)),
                  const SizedBox(height: 4),
                  const Text('Pick which store to open. You can switch any time.',
                      style: TextStyle(color: BrandColors.muted)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final s = list[i];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            try {
                              await ref.read(storeActionsProvider).switchStore(s.storeId);
                            } catch (_) {}
                            if (context.mounted) context.go('/home');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: BrandColors.border),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: BrandColors.primary.withValues(alpha: 0.12),
                                  child: Text(
                                    s.storeName.isNotEmpty ? s.storeName[0].toUpperCase() : '?',
                                    style: const TextStyle(color: BrandColors.primary, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s.storeName,
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                      Text(
                                        s.verticalCode[0].toUpperCase() + s.verticalCode.substring(1) +
                                            (s.city != null && s.city!.isNotEmpty ? ' · ${s.city}' : ''),
                                        style: const TextStyle(color: BrandColors.muted, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: BrandColors.muted),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
