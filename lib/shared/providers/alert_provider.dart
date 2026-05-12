import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alert_model.dart';
import '../../features/pos_inventory/providers/inventory_provider.dart';
import '../../features/finance/providers/finance_provider.dart';
import '../../features/pos_inventory/providers/procurement_provider.dart';

class AlertNotifier extends Notifier<List<BusinessAlert>> {
  @override
  List<BusinessAlert> build() {
    // Watch other providers to trigger alert regeneration
    final inventory = ref.watch(inventoryProvider).value;
    final finance = ref.watch(financeProvider).value;
    final procurement = ref.watch(procurementProvider).value;

    final alerts = <BusinessAlert>[];

    // 1. Low Stock Alerts
    if (inventory != null) {
      for (final item in inventory.items) {
        if (item.isOutOfStock) {
          alerts.add(BusinessAlert(
            id: 'oos_${item.productId}',
            title: 'Out of Stock',
            message: '${item.name} is completely out of stock.',
            type: AlertType.lowStock,
            priority: AlertPriority.high,
            timestamp: DateTime.now(),
          ));
        } else if (item.isLowStock) {
          alerts.add(BusinessAlert(
            id: 'low_${item.productId}',
            title: 'Low Stock',
            message: '${item.name} is running low (${item.stockLabel}).',
            type: AlertType.lowStock,
            priority: AlertPriority.medium,
            timestamp: DateTime.now(),
          ));
        }

        // 2. Expiry Alerts
        if (item.expiryDate != null) {
          final expiry = DateTime.tryParse(item.expiryDate!);
          if (expiry != null) {
            final days = expiry.difference(DateTime.now()).inDays;
            if (days <= 7) {
              alerts.add(BusinessAlert(
                id: 'exp_${item.productId}',
                title: 'Expiring Soon',
                message: '${item.name} expires in $days days.',
                type: AlertType.expiry,
                priority: days <= 3 ? AlertPriority.high : AlertPriority.medium,
                timestamp: DateTime.now(),
              ));
            }
          }
        }
      }
    }

    // 3. Udhaar Alerts
    if (finance != null) {
      for (final item in finance.udhaarList) {
        if (!item.isRecovered && item.daysPending > 30) {
          alerts.add(BusinessAlert(
            id: 'udhaar_${item.khataId}',
            title: 'Long Overdue Udhaar',
            message: '${item.customerName} has pending ₹${item.balance.toStringAsFixed(0)} for ${item.daysPending} days.',
            type: AlertType.udhaar,
            priority: item.daysPending > 60 ? AlertPriority.high : AlertPriority.medium,
            timestamp: DateTime.now(),
          ));
        }
      }
    }

    // 4. Distributor Payment Alerts
    if (procurement != null) {
      for (final p in procurement.purchases) {
        if (p.paymentStatus != 'paid' && p.dueDate != null) {
          final days = p.dueDate!.difference(DateTime.now()).inDays;
          if (days <= 2) {
            alerts.add(BusinessAlert(
              id: 'pay_${p.purchaseId}',
              title: days < 0 ? 'Overdue Payment' : 'Upcoming Payment',
              message: '₹${p.totalAmount.toStringAsFixed(0)} to ${p.supplierName} ${days < 0 ? "is overdue" : "due in $days days"}.',
              type: AlertType.performance,
              priority: days < 0 ? AlertPriority.high : AlertPriority.medium,
              timestamp: DateTime.now(),
            ));
          }
        }
      }
    }

    // Sort by priority and then timestamp
    alerts.sort((a, b) {
      final prio = a.priority.index.compareTo(b.priority.index);
      if (prio != 0) return prio;
      return b.timestamp.compareTo(a.timestamp);
    });

    return alerts;
  }
}

final alertProvider = NotifierProvider<AlertNotifier, List<BusinessAlert>>(AlertNotifier.new);
