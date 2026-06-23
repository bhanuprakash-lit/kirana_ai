import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../models/product_variant.dart';

/// F2 — the variant axes the caller's vertical exposes (refetched per store).
final attributeDefsProvider = FutureProvider<List<AttributeDef>>((ref) async {
  ref.watch(storeScopeProvider); // vertical-specific axes — refetch on switch
  final data = await ref.read(apiClientProvider).get('/kirana/attribute-defs');
  final list = (data is Map ? data['attributes'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => AttributeDef.fromJson(e.cast<String, dynamic>()))
      .toList();
});

/// Active variants for one product (the implicit one is always first).
final productVariantsProvider =
    FutureProvider.family<List<ProductVariant>, int>((ref, productId) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final data = await ref
      .read(apiClientProvider)
      .get('/kirana/products/$productId/variants');
  final list = (data is Map ? data['variants'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => ProductVariant.fromJson(e.cast<String, dynamic>()))
      .toList();
});

/// Create/update/deactivate variants, refreshing the product's list after each.
class VariantActions {
  VariantActions(this.ref);
  final Ref ref;

  ApiClient get _client => ref.read(apiClientProvider);

  Future<void> create(
    int productId, {
    required Map<String, String> attributes,
    String? sku,
    String? barcode,
    double? price,
    double? mrp,
    double? cost,
    double? stock,
  }) async {
    await _client.post('/kirana/products/$productId/variants', {
      'attributes': attributes,
      if (sku != null && sku.isNotEmpty) 'sku': sku,
      if (barcode != null && barcode.isNotEmpty) 'barcode': barcode,
      'price': ?price,
      'mrp': ?mrp,
      'cost': ?cost,
      'stock': ?stock,
    });
    ref.invalidate(productVariantsProvider(productId));
  }

  Future<void> update(
    int productId,
    int variantId, {
    Map<String, String>? attributes,
    double? price,
    double? mrp,
    double? cost,
    double? stock,
    bool? isActive,
  }) async {
    await _client.patch('/kirana/variants/$variantId', {
      'attributes': ?attributes,
      'price': ?price,
      'mrp': ?mrp,
      'cost': ?cost,
      'stock': ?stock,
      'is_active': ?isActive,
    });
    ref.invalidate(productVariantsProvider(productId));
  }

  Future<void> deactivate(int productId, int variantId) async {
    await _client.delete('/kirana/variants/$variantId');
    ref.invalidate(productVariantsProvider(productId));
  }
}

final variantActionsProvider = Provider<VariantActions>(VariantActions.new);
