import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/vertical/nav_preset.dart';
import '../../../shared/models/alert_model.dart';
import 'dashboard_screen.dart';

/// The single mapping from a [BusinessAlert] to the screen that answers it.
///
/// Both the home alert strip and the notifications inbox route through here.
/// They used to disagree — the inbox had no navigation at all, so tapping a
/// Business Alert there did nothing (PAI-14) — and keeping one copy is what
/// stops them drifting again.
///
/// Takes a [GoRouter] rather than a `BuildContext` so a caller can pop its own
/// screen first and still navigate afterwards, without touching a context that
/// is no longer mounted.
void openBusinessAlert(GoRouter router, WidgetRef ref, BusinessAlert alert) {
  switch (alert.type) {
    case AlertType.udhaar:
      switchToNavTab(ref, NavTabId.khata);
      ref.read(financeSubTabProvider.notifier).setSubTab(1); // customer udhaar
    case AlertType.performance:
      switchToNavTab(ref, NavTabId.khata);
      ref.read(financeSubTabProvider.notifier).setSubTab(2); // supplier udhaar
    case AlertType.lowStock:
    case AlertType.expiry:
      switchToNavTab(ref, NavTabId.billing);
      ref.read(dashboardSubTabProvider.notifier).setSubTab(1); // inventory
    case AlertType.subscription:
      router.push('/profile/subscription');
  }
}
