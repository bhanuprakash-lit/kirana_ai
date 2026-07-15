import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/vertical/vertical_config_provider.dart';
import '../../../../core/vertical/vertical_copy.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../core/tutorial/tutorial_controller.dart';
import '../../../../core/tutorial/tutorial_keys.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/pos_provider.dart';
import '../../providers/variant_provider.dart';
import '../../models/product_variant.dart';
import 'add_category_sheet.dart';
import 'barcode_scanner_overlay.dart';

part 'add_product_sheet_new/catalogproduct.dart';
part 'add_product_sheet_new/stage.dart';
part 'add_product_sheet_new/addproductscreen.dart';
part 'add_product_sheet_new/variantdata.dart';
part 'add_product_sheet_new/catalogresulttile.dart';
part 'add_product_sheet_new/linkedchip.dart';
part 'add_product_sheet_new/categorypickersheet.dart';
part 'add_product_sheet_new/sectionheader.dart';
part 'add_product_sheet_new/togglerow.dart';

Future<void> showAddProductSheet(
  BuildContext context,
  WidgetRef ref, {
  String? initialBarcode,
}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) =>
          _AddProductScreen(ref: ref, initialBarcode: initialBarcode),
    ),
  );
}

/// Public entry point so other sheets can reuse the category picker.
Future<Map<String, dynamic>?> showCategoryPicker(
  BuildContext context,
  List<Map<String, dynamic>> categories,
) => showModalBottomSheet<Map<String, dynamic>>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) => _CategoryPickerSheet(categories: categories),
);

String _toTitleCase(String s) => s
    .split(RegExp(r'\s+'))
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1))
    .join(' ');
