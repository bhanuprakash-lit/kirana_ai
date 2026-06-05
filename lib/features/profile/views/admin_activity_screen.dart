import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';

final _adminActivityProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final client = ref.read(apiClientProvider);
      final res =
          await client.get('/kirana/admin/user-activity')
              as Map<String, dynamic>;
      return (res['users'] as List).cast<Map<String, dynamic>>();
    });

class AdminActivityScreen extends ConsumerWidget {
  const AdminActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(_adminActivityProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.psetUserActivity,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(_adminActivityProvider),
          ),
        ],
      ),
      body: asyncData.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: ListShimmer(itemCount: 6),
        ),
        error: (e, _) => Center(child: Text(l10n.psetErrorWith(e.toString()))),
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Text(
                l10n.psetNoUsersFound,
                style: const TextStyle(color: BrandColors.muted),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (_, i) => _UserActivityCard(data: users[i]),
          );
        },
      ),
    );
  }
}

class _UserActivityCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _UserActivityCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fullName =
        data['full_name'] as String? ?? data['username'] as String? ?? '—';
    final storeName = data['store_name'] as String? ?? l10n.psetNoStore;
    final lastSeen = data['last_seen'] as String?;
    // total_sessions kept for future use
    // ignore: unused_local_variable
    final totalSessions = data['total_sessions'] as int? ?? 0;
    final opensToday = data['opens_today'] as int? ?? 0;
    final salesToday = data['sales_today'] as int? ?? 0;
    final foregroundSec = data['foreground_sec_today'] as int? ?? 0;

    final lastSeenDt = lastSeen != null
        ? DateTime.tryParse(lastSeen)?.toLocal()
        : null;
    final lastSeenLabel = lastSeenDt != null
        ? _formatRelative(lastSeenDt, l10n)
        : l10n.psetNever;
    final openedToday = opensToday > 0;
    final madeSalesToday = salesToday > 0;

    String fmtDuration(int sec) {
      if (sec == 0) return '0s';
      if (sec < 60) return '${sec}s';
      if (sec < 3600) return '${sec ~/ 60}m ${sec % 60}s';
      return '${sec ~/ 3600}h ${(sec % 3600) ~/ 60}m';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: openedToday
                    ? BrandColors.primary.withValues(alpha: 0.1)
                    : BrandColors.surfaceTint,
                child: Text(
                  fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: openedToday
                        ? BrandColors.primary
                        : BrandColors.muted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      storeName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              // Status chips
              if (openedToday)
                _Chip(label: l10n.psetActiveToday, color: BrandColors.primary),
              if (!openedToday && lastSeenDt != null)
                _Chip(label: l10n.psetInactive, color: BrandColors.muted),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatBox(
                icon: Icons.access_time_rounded,
                label: l10n.psetLastSeen,
                value: lastSeenLabel,
                highlight: openedToday,
              ),
              const SizedBox(width: 8),
              _StatBox(
                icon: Icons.phone_android_rounded,
                label: l10n.psetOpensToday,
                value: '$opensToday',
                highlight: opensToday > 0,
              ),
              const SizedBox(width: 8),
              _StatBox(
                icon: Icons.timer_rounded,
                label: l10n.psetTimeInApp,
                value: fmtDuration(foregroundSec),
                highlight: foregroundSec > 0,
              ),
              const SizedBox(width: 8),
              _StatBox(
                icon: Icons.shopping_cart_rounded,
                label: l10n.psetSalesToday,
                value: '$salesToday',
                highlight: madeSalesToday,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRelative(DateTime dt, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return l10n.psetJustNow;
    if (diff.inMinutes < 60) return l10n.psetMinsAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.psetHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.psetDaysAgo(diff.inDays);
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: highlight
              ? BrandColors.primary.withValues(alpha: 0.06)
              : BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16,
              color: highlight ? BrandColors.primary : BrandColors.muted,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: highlight ? BrandColors.primary : BrandColors.ink,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: BrandColors.muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
