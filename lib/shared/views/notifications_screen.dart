import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/brand_theme.dart';
import '../models/alert_model.dart';
import '../providers/alert_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Business Alerts'),
      ),
      body: alerts.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return _AlertTile(alert: alert);
              },
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 64, color: BrandColors.muted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('All caught up!', style: TextStyle(color: BrandColors.muted, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('No urgent alerts at the moment.', style: TextStyle(color: BrandColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final BusinessAlert alert;
  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(
                      _formatTime(alert.timestamp),
                      style: const TextStyle(fontSize: 11, color: BrandColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(alert.message, style: const TextStyle(fontSize: 13, color: BrandColors.ink, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
