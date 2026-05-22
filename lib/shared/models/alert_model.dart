import 'package:flutter/material.dart';

enum AlertPriority { high, medium, low }

enum AlertType { lowStock, expiry, udhaar, performance, subscription }

class BusinessAlert {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final AlertPriority priority;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  const BusinessAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    this.data,
  });

  IconData get icon {
    switch (type) {
      case AlertType.lowStock:
        return Icons.inventory_2_rounded;
      case AlertType.expiry:
        return Icons.event_busy_rounded;
      case AlertType.udhaar:
        return Icons.account_balance_wallet_rounded;
      case AlertType.performance:
        return Icons.trending_down_rounded;
      case AlertType.subscription:
        return Icons.workspace_premium_rounded;
    }
  }

  Color get color {
    switch (priority) {
      case AlertPriority.high:
        return Colors.red;
      case AlertPriority.medium:
        return Colors.orange;
      case AlertPriority.low:
        return Colors.blue;
    }
  }
}
