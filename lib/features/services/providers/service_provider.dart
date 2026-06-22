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
final appointmentsProvider =
    FutureProvider.family<List<Appointment>, String>((ref, day) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final data =
      await ref.read(apiClientProvider).get('/kirana/appointments?day=$day');
  final list =
      (data is Map ? data['appointments'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => Appointment.fromJson(e.cast<String, dynamic>()))
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
}

final serviceActionsProvider = Provider<ServiceActions>(ServiceActions.new);
