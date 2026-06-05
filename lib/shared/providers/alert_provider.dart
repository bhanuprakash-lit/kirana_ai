import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alert_model.dart';
import '../../core/locale/locale_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../features/pos_inventory/providers/inventory_provider.dart';
import '../../features/finance/providers/finance_provider.dart';
import '../../features/pos_inventory/providers/procurement_provider.dart';

// Holds dynamically injected alerts (e.g., subscription warnings).
// AlertNotifier watches this so any change triggers a full rebuild.
class _PinnedAlertsNotifier extends Notifier<List<BusinessAlert>> {
  @override
  List<BusinessAlert> build() => const [];

  void add(BusinessAlert alert) {
    state = <BusinessAlert>[alert, ...state.where((a) => a.id != alert.id)];
  }

  void remove(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}

final _pinnedAlertsProvider =
    NotifierProvider<_PinnedAlertsNotifier, List<BusinessAlert>>(
      _PinnedAlertsNotifier.new,
    );

class AlertNotifier extends Notifier<List<BusinessAlert>> {
  @override
  List<BusinessAlert> build() {
    final l10n = lookupAppLocalizations(ref.watch(localeProvider));
    final pinned = ref.watch(_pinnedAlertsProvider);
    final inventory = ref.watch(inventoryProvider).asData?.value;
    final finance = ref.watch(financeProvider).asData?.value;
    final procurement = ref.watch(procurementProvider).asData?.value;

    final computed = <BusinessAlert>[];

    // Low Stock Alerts
    if (inventory != null) {
      for (final item in inventory.items) {
        if (item.isOutOfStock) {
          computed.add(
            BusinessAlert(
              id: 'oos_${item.productId}',
              title: l10n.shrAlertOutOfStock,
              message: l10n.shrMsgOutOfStock(item.name),
              type: AlertType.lowStock,
              priority: AlertPriority.high,
              timestamp: DateTime.now(),
            ),
          );
        } else if (item.isLowStock) {
          computed.add(
            BusinessAlert(
              id: 'low_${item.productId}',
              title: l10n.shrAlertLowStock,
              message: l10n.shrMsgLowStock(item.name, item.stockLabel),
              type: AlertType.lowStock,
              priority: AlertPriority.medium,
              timestamp: DateTime.now(),
            ),
          );
        }

        if (item.expiryDate != null) {
          final expiry = DateTime.tryParse(item.expiryDate!);
          if (expiry != null) {
            final days = expiry.difference(DateTime.now()).inDays;
            if (days <= 7) {
              computed.add(
                BusinessAlert(
                  id: 'exp_${item.productId}',
                  title: l10n.shrAlertExpiringSoon,
                  message: l10n.shrMsgExpiringSoon(item.name, days),
                  type: AlertType.expiry,
                  priority: days <= 3
                      ? AlertPriority.high
                      : AlertPriority.medium,
                  timestamp: DateTime.now(),
                ),
              );
            }
          }
        }
      }
    }

    // Udhaar Alerts
    if (finance != null) {
      for (final item in finance.udhaarList) {
        if (!item.isRecovered && item.daysPending > 30) {
          computed.add(
            BusinessAlert(
              id: 'udhaar_${item.khataId}',
              title: l10n.shrAlertOverdueUdhaar,
              message: l10n.shrMsgOverdueUdhaar(
                item.customerName,
                item.balance.toStringAsFixed(0),
                item.daysPending,
              ),
              type: AlertType.udhaar,
              priority: item.daysPending > 60
                  ? AlertPriority.high
                  : AlertPriority.medium,
              timestamp: DateTime.now(),
            ),
          );
        }
      }
    }

    // Distributor Payment Alerts
    if (procurement != null) {
      for (final p in procurement.purchases) {
        if (p.paymentStatus != 'paid' && p.dueDate != null) {
          final days = p.dueDate!.difference(DateTime.now()).inDays;
          if (days <= 2) {
            computed.add(
              BusinessAlert(
                id: 'pay_${p.purchaseId}',
                title: days < 0
                    ? l10n.shrAlertOverduePayment
                    : l10n.shrAlertUpcomingPayment,
                message: days < 0
                    ? l10n.shrMsgPaymentOverdue(
                        p.totalAmount.toStringAsFixed(0),
                        p.supplierName,
                      )
                    : l10n.shrMsgPaymentDue(
                        p.totalAmount.toStringAsFixed(0),
                        p.supplierName,
                        days,
                      ),
                type: AlertType.performance,
                priority: days < 0 ? AlertPriority.high : AlertPriority.medium,
                timestamp: DateTime.now(),
              ),
            );
          }
        }
      }
    }

    // Pinned alerts (subscription, etc.) always appear first
    final all = <BusinessAlert>[...pinned, ...computed];
    all.sort((a, b) {
      final prio = a.priority.index.compareTo(b.priority.index);
      if (prio != 0) return prio;
      return b.timestamp.compareTo(a.timestamp);
    });
    return all;
  }

  void addCustomAlert(BusinessAlert alert) {
    ref.read(_pinnedAlertsProvider.notifier).add(alert);
  }

  void removeCustomAlert(String id) {
    ref.read(_pinnedAlertsProvider.notifier).remove(id);
  }
}

final alertProvider = NotifierProvider<AlertNotifier, List<BusinessAlert>>(
  AlertNotifier.new,
);
