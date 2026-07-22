import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/brand_theme.dart';
import '../../features/dashboard/views/alert_navigation.dart';
import '../../l10n/generated/app_localizations.dart';
import '../models/alert_model.dart';
import '../providers/alert_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: Text(l10n.shrBusinessAlerts)),
      body: alerts.isEmpty
          ? _emptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return _AlertTile(
                  alert: alert,
                  // PAI-14 — an alert has to lead somewhere. Close the inbox
                  // first (it sits on top of the dashboard we're about to
                  // retarget), holding the router since `context` is gone
                  // once we pop.
                  onTap: () {
                    final router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    openBusinessAlert(router, ref, alert);
                  },
                );
              },
            ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 64,
            color: BrandColors.muted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.shrAllCaughtUp,
            style: const TextStyle(
              color: BrandColors.muted,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.shrNoUrgentAlerts,
            style: const TextStyle(color: BrandColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final BusinessAlert alert;
  final VoidCallback onTap;
  const _AlertTile({required this.alert, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BrandColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: alert.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(alert.icon, color: alert.color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        alert.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _formatTime(alert.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: BrandColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.message,
                    style: const TextStyle(
                      fontSize: 13,
                      color: BrandColors.ink,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
