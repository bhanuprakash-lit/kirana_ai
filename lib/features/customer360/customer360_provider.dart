import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';

/// Module M8 — Customer 360+ : profiles (prescription / style / size) + wishlist.

class CustomerProfile {
  final String? prescription;
  final String? prescriptionDate; // yyyy-mm-dd (optical) — feeds rx-renewal KPI
  final int? prescriptionValidMonths;
  final String? styleProfile;
  final String? sizeProfile;
  const CustomerProfile({
    this.prescription,
    this.prescriptionDate,
    this.prescriptionValidMonths,
    this.styleProfile,
    this.sizeProfile,
  });
  factory CustomerProfile.fromJson(Map<String, dynamic> j) => CustomerProfile(
        prescription: j['prescription'] as String?,
        prescriptionDate: j['prescription_date']?.toString(),
        prescriptionValidMonths: (j['prescription_valid_months'] as num?)?.toInt(),
        styleProfile: j['style_profile'] as String?,
        sizeProfile: j['size_profile'] as String?,
      );
  bool get isEmpty =>
      (prescription ?? '').isEmpty &&
      (prescriptionDate ?? '').isEmpty &&
      (styleProfile ?? '').isEmpty &&
      (sizeProfile ?? '').isEmpty;
}

final customerProfileProvider =
    FutureProvider.family<CustomerProfile, int>((ref, cid) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/customers/$cid/profile');
  return CustomerProfile.fromJson((d as Map).cast<String, dynamic>());
});

final wishlistProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((ref, cid) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/customers/$cid/wishlist');
  final l = (d is Map ? d['wishlist'] : null) as List<dynamic>? ?? [];
  return l.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
});

class Customer360Actions {
  Customer360Actions(this.ref);
  final Ref ref;
  ApiClient get _c => ref.read(apiClientProvider);

  Future<void> saveProfile(int cid, Map<String, dynamic> body) async {
    await _c.patch('/kirana/customers/$cid/profile', body);
    ref.invalidate(customerProfileProvider(cid));
  }

  Future<void> addWish(int cid, String note) async {
    await _c.post('/kirana/customers/$cid/wishlist', {'note': note});
    ref.invalidate(wishlistProvider(cid));
  }

  /// Wishlist a real product from the store's catalogue (preferred over free text).
  Future<void> addWishProduct(int cid, int productId, {String? note}) async {
    await _c.post('/kirana/customers/$cid/wishlist',
        {'product_id': productId, 'note': ?note});
    ref.invalidate(wishlistProvider(cid));
  }

  Future<void> removeWish(int cid, int itemId) async {
    await _c.delete('/kirana/wishlist/$itemId');
    ref.invalidate(wishlistProvider(cid));
  }
}

final customer360ActionsProvider =
    Provider<Customer360Actions>(Customer360Actions.new);
