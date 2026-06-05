import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import 'inventory_provider.dart';
import 'pos_provider.dart';

/// A near-expiry stock batch surfaced for loss prevention.
class NearExpiryBatch {
  final int batchId;
  final int productId;
  final String productName;
  final String? unit;
  final String? batchNo;
  final String expiryDate; // YYYY-MM-DD
  final int daysLeft;
  final int qtyInStock;
  final double markdownPct;
  final int wastedUnits;
  final double price;
  final double costPrice;
  final double suggestedMarkdownPct;
  final double valueAtRisk;
  final double markedDownPrice;

  const NearExpiryBatch({
    required this.batchId,
    required this.productId,
    required this.productName,
    this.unit,
    this.batchNo,
    required this.expiryDate,
    required this.daysLeft,
    required this.qtyInStock,
    required this.markdownPct,
    required this.wastedUnits,
    required this.price,
    required this.costPrice,
    required this.suggestedMarkdownPct,
    required this.valueAtRisk,
    required this.markedDownPrice,
  });

  bool get isExpired => daysLeft < 0;
  bool get hasMarkdown => markdownPct > 0;

  factory NearExpiryBatch.fromJson(Map<String, dynamic> j) => NearExpiryBatch(
    batchId: (j['batch_id'] as num).toInt(),
    productId: (j['product_id'] as num).toInt(),
    productName: j['product_name'] as String? ?? 'Item',
    unit: j['unit'] as String?,
    batchNo: j['batch_no'] as String?,
    expiryDate: j['expiry_date'] as String? ?? '',
    daysLeft: (j['days_left'] as num?)?.toInt() ?? 0,
    qtyInStock: (j['qty_in_stock'] as num?)?.toInt() ?? 0,
    markdownPct: (j['markdown_pct'] as num?)?.toDouble() ?? 0,
    wastedUnits: (j['wasted_units'] as num?)?.toInt() ?? 0,
    price: (j['price'] as num?)?.toDouble() ?? 0,
    costPrice: (j['cost_price'] as num?)?.toDouble() ?? 0,
    suggestedMarkdownPct:
        (j['suggested_markdown_pct'] as num?)?.toDouble() ?? 0,
    valueAtRisk: (j['value_at_risk'] as num?)?.toDouble() ?? 0,
    markedDownPrice: (j['marked_down_price'] as num?)?.toDouble() ?? 0,
  );
}

class NearExpiryNotifier extends AsyncNotifier<List<NearExpiryBatch>> {
  int _days = 7;
  int get days => _days;

  @override
  Future<List<NearExpiryBatch>> build() => _fetch();

  Future<List<NearExpiryBatch>> _fetch() async {
    final client = ref.read(apiClientProvider);
    final res = await client.get('/kirana/inventory/near-expiry?days=$_days');
    final list = (res['batches'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    return list.map(NearExpiryBatch.fromJson).toList();
  }

  Future<void> setWindow(int days) async {
    _days = days;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  /// Apply a clearance markdown so the near-expiry stock actually sells.
  Future<bool> applyMarkdown(int batchId, double pct) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.post('/kirana/inventory/batch/$batchId/markdown', {
        'markdown_pct': pct,
      });
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Write off spoiled units — also reduces store inventory.
  Future<bool> recordWaste(int batchId, int units) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.post('/kirana/inventory/batch/$batchId/waste', {
        'units': units,
      });
      // Stock changed — keep inventory + POS in sync.
      ref.invalidate(inventoryProvider);
      ref.read(posProvider.notifier).reloadProducts();
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final nearExpiryProvider =
    AsyncNotifierProvider<NearExpiryNotifier, List<NearExpiryBatch>>(
      NearExpiryNotifier.new,
    );

/// Count of near-expiry batches for badges/banners (0 while loading/error).
final nearExpiryCountProvider = Provider<int>((ref) {
  return ref
      .watch(nearExpiryProvider)
      .maybeWhen(data: (b) => b.length, orElse: () => 0);
});
