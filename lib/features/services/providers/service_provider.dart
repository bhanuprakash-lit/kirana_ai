import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../models/service_models.dart';

/// Service catalogue for the store.
final servicesProvider = FutureProvider<List<ServiceItem>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final data = await ref.read(apiClientProvider).get('/kirana/services');
  final list = (data is Map ? data['services'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => ServiceItem.fromJson(e.cast<String, dynamic>()))
      .toList();
});

/// Appointments for a given day (yyyy-mm-dd).
final appointmentsProvider = FutureProvider.family<List<Appointment>, String>((
  ref,
  day,
) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final data = await ref
      .read(apiClientProvider)
      .get('/kirana/appointments?day=$day');
  final list =
      (data is Map ? data['appointments'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => Appointment.fromJson(e.cast<String, dynamic>()))
      .toList();
});

/// All memberships for the store (V3 — memberships tab in the services
/// screen). The checkout deep-link keeps its own per-customer fetch.
final membershipsProvider = FutureProvider<List<Membership>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final data = await ref.read(apiClientProvider).get('/kirana/memberships');
  final list =
      (data is Map ? data['memberships'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => Membership.fromJson(e.cast<String, dynamic>()))
      .toList();
});

class ServiceActions {
  ServiceActions(this.ref);
  final Ref ref;
  ApiClient get _c => ref.read(apiClientProvider);

  Future<void> createService(Map<String, dynamic> body) async {
    await _c.post('/kirana/services', body);
    ref.invalidate(servicesProvider);
  }

  Future<void> toggleService(int serviceId, bool isActive) async {
    await _c.patch('/kirana/services/$serviceId', {'is_active': isActive});
    ref.invalidate(servicesProvider);
  }

  Future<void> createAppointment(Map<String, dynamic> body, String day) async {
    await _c.post('/kirana/appointments', body);
    ref.invalidate(appointmentsProvider(day));
  }

  Future<void> setStatus(int appointmentId, String status, String day) async {
    await _c.patch('/kirana/appointments/$appointmentId', {'status': status});
    ref.invalidate(appointmentsProvider(day));
  }

  /// Sell a prepaid session bundle to a customer (V3).
  Future<void> createMembership({
    required int customerId,
    required String name,
    required int totalSessions, // 0 = unlimited
    required double price,
    String? validUntil, // yyyy-mm-dd
  }) async {
    await _c.post('/kirana/memberships', {
      'customer_id': customerId,
      'name': name,
      'total_sessions': totalSessions,
      'price': price,
      'valid_until': ?validUntil,
    });
    ref.invalidate(membershipsProvider);
  }

  /// Consume one session (backend deactivates when the bundle is exhausted).
  Future<void> useMembershipSession(int membershipId) async {
    await _c.post('/kirana/memberships/$membershipId/use', {});
    ref.invalidate(membershipsProvider);
  }
}

final serviceActionsProvider = Provider<ServiceActions>(ServiceActions.new);
