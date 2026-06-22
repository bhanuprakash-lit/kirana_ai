/// One store the logged-in owner can switch into (multi-store).
class UserStore {
  final int storeId;
  final String storeName;
  final String storeType;
  final String verticalCode;
  final String? city;
  final bool isActive;

  const UserStore({
    required this.storeId,
    required this.storeName,
    required this.storeType,
    required this.verticalCode,
    this.city,
    this.isActive = false,
  });

  factory UserStore.fromJson(Map<String, dynamic> j) => UserStore(
        storeId: (j['store_id'] as num).toInt(),
        storeName: (j['store_name'] ?? 'My Store').toString(),
        storeType: (j['store_type'] ?? 'kirana').toString(),
        verticalCode: (j['vertical_code'] ?? 'grocery').toString(),
        city: j['city'] as String?,
        isActive: j['is_active'] == true,
      );
}
