import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../../profile/models/customer_model.dart';
import '../../../profile/providers/customer_provider.dart';
import '../../models/finance_models.dart';
import '../../providers/finance_provider.dart';
import '../../providers/smart_udhaar_provider.dart';
import '../smart_reminders_screen.dart';

part 'udhaar_tab_new/udhaartab.dart';
part 'udhaar_tab_new/addudhaarsheet.dart';
part 'udhaar_tab_new/customerpickersheet.dart';
part 'udhaar_tab_new/udhaarstatscard.dart';
part 'udhaar_tab_new/ministat.dart';
part 'udhaar_tab_new/smartremindersbanner.dart';
part 'udhaar_tab_new/customerudhaar.dart';
part 'udhaar_tab_new/customerudhaarcard.dart';
part 'udhaar_tab_new/expandedbody.dart';
part 'udhaar_tab_new/summarycell.dart';
part 'udhaar_tab_new/debtrow.dart';
part 'udhaar_tab_new/settledsection.dart';
part 'udhaar_tab_new/recovercustomersheet.dart';
part 'udhaar_tab_new/emptyudhaar.dart';
part 'udhaar_tab_new/udhaarhistorysheet.dart';

/// All of one customer's khata rows, with the aggregates the grouped card needs.

List<_CustomerUdhaar> _groupByCustomer(List<UdhaarItem> items) {
  final byCustomer = <int, List<UdhaarItem>>{};
  for (final it in items) {
    byCustomer.putIfAbsent(it.customerId, () => []).add(it);
  }
  return byCustomer.entries.map((e) {
    final first = e.value.first;
    return _CustomerUdhaar(
      customerId: e.key,
      customerName: first.customerName,
      phone: first.phone,
      entries: e.value,
    );
  }).toList();
}

String _formatUdhaarDate(DateTime date) {
  final d = date.toLocal();
  return "${d.day}/${d.month}/${d.year}";
}

/// Urgency colour for a customer based on how long their oldest debt is overdue.
Color _urgencyColor(int oldestDays) {
  if (oldestDays >= 30) return BrandColors.error;
  if (oldestDays >= 14) return const Color(0xFFD97706);
  return BrandColors.primary;
}
