enum PendingStatus { syncing, failed }

class PendingInventoryItem {
  final int tempId; // negative epoch ms — guaranteed not to clash with real IDs
  final String name;
  final String? brand;
  final String? categoryName;
  final double price;
  final double stockQuantity;
  final PendingStatus status;
  final String? error;
  final Map<String, dynamic> params; // original addProduct args, used for retry

  const PendingInventoryItem({
    required this.tempId,
    required this.name,
    this.brand,
    this.categoryName,
    required this.price,
    required this.stockQuantity,
    required this.status,
    this.error,
    required this.params,
  });

  PendingInventoryItem copyWith({
    PendingStatus? status,
    String? error,
    bool clearError = false,
  }) => PendingInventoryItem(
    tempId: tempId,
    name: name,
    brand: brand,
    categoryName: categoryName,
    price: price,
    stockQuantity: stockQuantity,
    status: status ?? this.status,
    error: clearError ? null : (error ?? this.error),
    params: params,
  );
}
