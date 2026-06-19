import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kirana_ai/features/pos_inventory/views/widgets/add_product_sheet.dart';
import 'package:kirana_ai/features/pos_inventory/views/widgets/add_product_sheet_new.dart';
import '../../../core/locale/locale_provider.dart';
import '../../auth/repositories/auth_repository.dart' show ApiException;
import '../../../core/providers/usage_limits_provider.dart';
import '../../../core/services/usage_limits_service.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../models/pos_product.dart';
import '../providers/pos_provider.dart';
import '../providers/inventory_provider.dart';
import '../../../../core/services/contact_service.dart';
import 'widgets/continuous_scanner_sheet.dart';
import 'widgets/order_dialog.dart';
import 'widgets/basket_savings_banner.dart';
import '../../baskets/models/basket_model.dart';
import '../../baskets/providers/basket_provider.dart';
import '../../subscription/models/subscription_model.dart';
import '../../subscription/providers/subscription_provider.dart';
import 'widgets/voice_order_sheet.dart';
import 'widgets/handwriting_order_sheet.dart';
import '../../campaigns/models/campaign_model.dart' as campaign_card_lib;
import '../../campaigns/providers/campaign_provider.dart';
import '../../campaigns/views/widgets/campaign_card.dart';

part 'pos_tab_new/postab.dart';
part 'pos_tab_new/smartassortmenthints.dart';
part 'pos_tab_new/searchresults.dart';
part 'pos_tab_new/customerpriceeditaction.dart';
part 'pos_tab_new/setcustomerpricesheet.dart';
part 'pos_tab_new/carttile.dart';
part 'pos_tab_new/qtycontrol.dart';
part 'pos_tab_new/qtybtn.dart';
part 'pos_tab_new/emptycartwithcampaigns.dart';
part 'pos_tab_new/posbasketcard.dart';
part 'pos_tab_new/basketdetailsheet.dart';
part 'pos_tab_new/posbottombar.dart';
part 'pos_tab_new/bottomaction.dart';
part 'pos_tab_new/emptycarthint.dart';
part 'pos_tab_new/customerpricebanner.dart';
part 'pos_tab_new/orderfooter.dart';

Widget _posIconBox(double size) => Container(
  width: size,
  height: size,
  color: BrandColors.surfaceTint,
  child: Icon(
    Icons.inventory_2_rounded,
    size: size * 0.45,
    color: BrandColors.muted,
  ),
);

/// Sheet to set or clear the selected customer's personal price for a product.
Future<void> _showSetCustomerPriceSheet(
  BuildContext context,
  WidgetRef ref,
  PosProduct product,
  double? currentOverride,
) async {
  final state = ref.read(posProvider);
  final name = state.selectedCustomerName?.trim().isNotEmpty == true
      ? state.selectedCustomerName!.trim()
      : 'this customer';
  final cp = state.customerPriceFor(product.productId);
  final hasPin = cp?.isPinned ?? false;
  final initial = currentOverride ?? cp?.price ?? product.price;
  final notifier = ref.read(posProvider.notifier);
  final messenger = ScaffoldMessenger.maybeOf(context);

  // The sheet is a StatefulWidget so its TextEditingController is disposed in
  // the normal element-unmount order when the route pops, and we pop
  // synchronously. The earlier inline builder + function-scoped controller +
  // post-pop `endOfFrame`/delayed mutation tore down out of order and tripped
  // the framework's `_dependents.isEmpty` MediaQuery assertion on save.
  final action = await showModalBottomSheet<_CustomerPriceEditAction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SetCustomerPriceSheet(
      product: product,
      customerName: name,
      hasPin: hasPin,
      initial: initial,
    ),
  );

  if (action == null) return;
  final ok = await notifier.setCustomerPrice(product.productId, action.price);
  if (!ok && (messenger?.mounted ?? false)) {
    messenger!.showSnackBar(
      const SnackBar(content: Text('Could not save price. Try again.')),
    );
  }
}

/// Bottom sheet that edits a customer's personal price for one product. Owns
/// and disposes its controller, and pops synchronously with the chosen
/// [_CustomerPriceEditAction] — the caller persists it after the sheet closes.

/// Bottom thumb-zone action bar: the screen's primary inputs (Scan / Voice /
/// Handwrite) anchored low so the screen is usable one-handed.

/// Non-blocking prompt offering the selected customer's personal prices.
