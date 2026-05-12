import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/customer_model.dart';

class CustomerState {
  final List<Customer> customers;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  CustomerState({
    this.customers = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  CustomerState copyWith({
    List<Customer>? customers,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CustomerNotifier extends Notifier<CustomerState> {
  @override
  CustomerState build() {
    // Initial fetch
    Future.microtask(() => fetchCustomers());
    return CustomerState();
  }

  Future<void> fetchCustomers() async {
    state = state.copyWith(isLoading: true, error: null);
    final client = ref.read(apiClientProvider);

    try {
      // 1. Fetch customers from OLTP
      final res = await client.getOltp('customer', filters: {'limit': '500'});
      final rows = (res['rows'] as List).cast<Map<String, dynamic>>();
      
      // 2. Map to model
      final customers = rows.map((json) => Customer.fromJson(json)).toList();

      state = state.copyWith(
        customers: customers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch customers: $e',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  List<Customer> get filteredCustomers {
    if (state.searchQuery.isEmpty) return state.customers;
    final q = state.searchQuery.toLowerCase();
    return state.customers.where((c) {
      return c.name.toLowerCase().contains(q) || c.phone.contains(q);
    }).toList();
  }

  Future<bool> createCustomer(Map<String, dynamic> data) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.postOltp('customer', data);
      await fetchCustomers();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Create failed: $e');
      return false;
    }
  }

  Future<bool> updateCustomer(int customerId, Map<String, dynamic> data) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.patchOltp('customer', data, filters: {'customer_id': '$customerId'});
      await fetchCustomers();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Update failed: $e');
      return false;
    }
  }

  Future<void> deleteCustomer(int customerId) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.deleteOltp('customer', filters: {'customer_id': '$customerId'});
      await fetchCustomers();
    } catch (e) {
      state = state.copyWith(error: 'Delete failed: $e');
    }
  }
}

final customerProvider = NotifierProvider<CustomerNotifier, CustomerState>(CustomerNotifier.new);

// Detail provider for a single customer
final customerOrdersProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>((ref, customerId) async {
  final client = ref.read(apiClientProvider);
  final res = await client.posGetList('/pos/orders?customer_id=$customerId&limit=50');
  return (res ?? []).cast<Map<String, dynamic>>();
});

final customerKhataProvider = FutureProvider.autoDispose.family<Map<String, dynamic>?, int>((ref, customerId) async {
  final client = ref.read(apiClientProvider);
  try {
    final res = await client.getOltp('khata', filters: {'customer_id': '$customerId'});
    final rows = (res['rows'] as List).cast<Map<String, dynamic>>();
    return rows.isNotEmpty ? rows.first : null;
  } catch (_) {
    return null;
  }
});
