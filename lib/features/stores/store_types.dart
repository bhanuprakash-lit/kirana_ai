/// Store types the owner can pick when adding a store, and the coarse vertical
/// each maps to (mirrors onboarding's _mapVertical). Pharmacy is intentionally
/// excluded — it has its own dedicated app.
class StoreTypeOption {
  final String code;
  final String label;
  final String vertical;

  const StoreTypeOption(this.code, this.label, this.vertical);
}

/// PAI-2 — "General Store", "Provision Store" and "Fruits & Vegetables" were
/// dropped from the picker: the first duplicated "Kirana / General Stores" and
/// the other two are the same grocery behaviour under different names, which
/// only made the list harder to choose from. **The codes stay resolvable**
/// (see [verticalForStoreType]) because 21 live stores still carry them.
///
/// "Others" is kept deliberately — without it a trade that isn't listed has
/// nowhere to land.
const List<StoreTypeOption> kStoreTypeOptions = [
  StoreTypeOption('kirana', 'Kirana / General Stores', 'grocery'),
  StoreTypeOption('supermarket', 'Supermarket', 'grocery'),
  StoreTypeOption('mini_supermarket', 'Mini Supermarket', 'grocery'),
  StoreTypeOption('bakery', 'Bakery & Sweet Shop', 'bakery'),
  StoreTypeOption('apparel', 'Apparel & Clothing', 'apparel'),
  StoreTypeOption('boutique', 'Boutique', 'boutique'),
  StoreTypeOption('footwear', 'Footwear Shop', 'footwear'),
  StoreTypeOption('sports_fitness', 'Sports & Fitness', 'sports_fitness'),
  StoreTypeOption('cosmetics', 'Cosmetics & Beauty', 'cosmetics'),
  // Mono-brand can be any trade, so its vertical comes from a follow-up
  // question at signup rather than this table — see [kMonoBrandTrades].
  StoreTypeOption('mono_brand', 'Mono Brand Store', 'apparel'),
  StoreTypeOption('electronics', 'Mobile & Electronics', 'electronics'),
  StoreTypeOption('optical', 'Optical Store', 'optical'),
  StoreTypeOption('salon', 'Salon & Parlour', 'services'),
  StoreTypeOption('stationery', 'Stationery & Books', 'general'),
  StoreTypeOption('fancy_gift', 'Fancy & Gift Store', 'general'),
  StoreTypeOption('others', 'Others', 'general'),
];

/// Store types no longer offered at signup but still held by live stores.
/// Kept so existing rows resolve to the right vertical and their labels render.
const Map<String, String> kRetiredStoreTypes = {
  'general': 'grocery',
  'provision': 'grocery',
  'fruits_vegetables': 'grocery',
  'other': 'grocery',
};

/// What a mono-brand store actually sells. Asked as a follow-up when the owner
/// picks "Mono Brand Store", because a single-brand outlet can be clothing,
/// phones or cosmetics — one fixed vertical is wrong in every direction.
const List<StoreTypeOption> kMonoBrandTrades = [
  StoreTypeOption('mono_brand', 'Clothing', 'apparel'),
  StoreTypeOption('mono_brand', 'Footwear', 'footwear'),
  StoreTypeOption('mono_brand', 'Mobile & electronics', 'electronics'),
  StoreTypeOption('mono_brand', 'Cosmetics & beauty', 'cosmetics'),
  StoreTypeOption('mono_brand', 'Something else', 'general'),
];

/// Resolve a store_type to its vertical, including retired codes.
String verticalForStoreType(String code) {
  for (final o in kStoreTypeOptions) {
    if (o.code == code) return o.vertical;
  }
  return kRetiredStoreTypes[code] ?? 'grocery';
}
