import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';
import '../models/customer_model.dart';

class CustomerState {
  final List<Customer> customers;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedSegment;

  CustomerState({
    this.customers = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedSegment,
  });

  CustomerState copyWith({
    List<Customer>? customers,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedSegment,
    bool clearSegment = false,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSegment: clearSegment
          ? null
          : (selectedSegment ?? this.selectedSegment),
    );
  }
}

class CustomerNotifier extends Notifier<CustomerState> {
  @override
  CustomerState build() {
    Future.microtask(() => fetchCustomers());
    return CustomerState();
  }

  Future<void> fetchCustomers() async {
    state = state.copyWith(isLoading: true, error: null);
    final client = ref.read(apiClientProvider);

    try {
      final prefs = await SharedPreferences.getInstance();
      final storeId = prefs.getInt('store_id') ?? 1;

      final res = await client.get('/kirana/customers?store_id=$storeId');
      final rows = (res['customers'] as List).cast<Map<String, dynamic>>();
      final customers = rows.map((json) => Customer.fromJson(json)).toList();

      state = state.copyWith(customers: customers, isLoading: false);
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

  void setSegment(String? segment) {
    state = state.copyWith(
      selectedSegment: segment,
      clearSegment: segment == null,
    );
  }

  List<Customer> get filteredCustomers {
    var list = state.customers;

    if (state.selectedSegment != null) {
      list = list
          .where((c) => c.segments.contains(state.selectedSegment))
          .toList();
    }

    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      list = list.where((c) {
        return c.name.toLowerCase().contains(q) || c.phone.contains(q);
      }).toList();
    }

    return list;
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

  /// Create a customer and return the new record (for picker flows that need
  /// to select the customer they just added). Null on failure.
  Future<Customer?> createAndReturn(Map<String, dynamic> data) async {
    final client = ref.read(apiClientProvider);
    try {
      final res = await client.postOltp('customer', data);
      final id = (res['row']?['customer_id'] as num).toInt();
      await fetchCustomers();
      return state.customers.firstWhere(
        (c) => c.customerId == id,
        orElse: () => Customer(
          customerId: id,
          name: (data['name'] as String?) ?? '',
          phone: (data['phone'] as String?) ?? '',
        ),
      );
    } catch (e) {
      state = state.copyWith(error: 'Create failed: $e');
      return null;
    }
  }

  Future<bool> updateCustomer(int customerId, Map<String, dynamic> data) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.patchOltp(
        'customer',
        data,
        filters: {'customer_id': '$customerId'},
      );
      await fetchCustomers();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Update failed: $e');
      return false;
    }
  }

  Future<String?> deleteCustomer(int customerId) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.deleteOltp(
        'customer',
        filters: {'customer_id': '$customerId'},
      );
      await fetchCustomers();
      return null; // success
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(error: msg);
      return msg; // caller shows the error
    }
  }
}

final customerProvider = NotifierProvider<CustomerNotifier, CustomerState>(
  CustomerNotifier.new,
);

final customerOrdersProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, int>((ref, customerId) async {
      final client = ref.read(apiClientProvider);
      final res = await client.posGetList(
        '/pos/orders?customer_id=$customerId&limit=50',
      );
      return (res ?? []).cast<Map<String, dynamic>>();
    });

final customerKhataProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>?, int>((ref, customerId) async {
      final client = ref.read(apiClientProvider);
      try {
        final res = await client.getOltp(
          'khata',
          filters: {'customer_id': '$customerId'},
        );
        final rows = (res['rows'] as List).cast<Map<String, dynamic>>();
        return rows.isNotEmpty ? rows.first : null;
      } catch (_) {
        return null;
      }
    });
