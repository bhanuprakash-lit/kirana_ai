/// Store types the owner can pick when adding a store, and the coarse vertical
/// each maps to (mirrors onboarding's _mapVertical). Pharmacy is intentionally
/// excluded — it has its own dedicated app.
class StoreTypeOption {
  final String code;
  final String label;
  final String vertical;

  const StoreTypeOption(this.code, this.label, this.vertical);
}

const List<StoreTypeOption> kStoreTypeOptions = [
  StoreTypeOption('kirana', 'Kirana / General Stores', 'grocery'),
  StoreTypeOption('general', 'General Store', 'general'),
  StoreTypeOption('provision', 'Provision Store', 'grocery'),
  StoreTypeOption('fruits_vegetables', 'Fruits & Vegetables', 'grocery'),
  StoreTypeOption('stationery', 'Stationery & Books', 'general'),
  StoreTypeOption('supermarket', 'Supermarket', 'grocery'),
  StoreTypeOption('mini_supermarket', 'Mini Supermarket', 'grocery'),
  StoreTypeOption('mono_brand', 'Mono Brand Store', 'apparel'),
  StoreTypeOption('boutique', 'Boutique', 'apparel'),
  StoreTypeOption('salon', 'Salon & Parlour', 'services'),
  StoreTypeOption('fancy_gift', 'Fancy & Gift Store', 'general'),
  // V0.6 — sports shops sell shoes/apparel/equipment: size variants matter
  // more than appointments, so this maps to apparel (kept in sync with
  // onboarding's _mapVertical).
  StoreTypeOption('sports_fitness', 'Sports & Fitness', 'apparel'),
  StoreTypeOption('footwear', 'Footwear Shop', 'footwear'),
  StoreTypeOption('optical', 'Optical Store', 'optical'),
  StoreTypeOption('bakery', 'Bakery & Sweet Shop', 'grocery'),
  StoreTypeOption('apparel', 'Apparel & Clothing', 'apparel'),
  StoreTypeOption('electronics', 'Mobile & Electronics', 'electronics'),
  StoreTypeOption('others', 'Others', 'general'),
];
