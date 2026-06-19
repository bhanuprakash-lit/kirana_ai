import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/action_widgets.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../../pos_inventory/models/pos_product.dart';
import '../../pos_inventory/providers/pos_provider.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';
import '../models/basket_model.dart';
import '../models/basket_tier_config.dart';
import '../providers/basket_provider.dart';
import 'basket_tier_config_screen.dart';


part 'baskets_screen_new/basketsscreen.dart';
part 'baskets_screen_new/basketcard.dart';
part 'baskets_screen_new/priceblock.dart';
part 'baskets_screen_new/tierbadge.dart';
part 'baskets_screen_new/pill.dart';
part 'baskets_screen_new/deletebutton.dart';
part 'baskets_screen_new/selecteditem.dart';
part 'baskets_screen_new/basketsheet.dart';
part 'baskets_screen_new/tierpreview.dart';
part 'baskets_screen_new/datefield.dart';
part 'baskets_screen_new/basketsprogate.dart';
part 'baskets_screen_new/productpickersheet.dart';



/// Localized tier name (Bronze/Silver/Gold/Platinum kept as proper nouns).
String tierLabel(AppLocalizations l10n, String? tier) {
  switch (tier) {
    case 'bronze':
      return l10n.mktTierBronze;
    case 'silver':
      return l10n.mktTierSilver;
    case 'gold':
      return l10n.mktTierGold;
    case 'platinum':
      return l10n.mktTierPlatinum;
    default:
      return '';
  }
}

String _msg(Object e) {
  final s = e.toString();
  return s.startsWith('Exception: ') ? s.substring(11) : s;
}

/// Live, read-only preview of the tier + auto-discount for the current items.
