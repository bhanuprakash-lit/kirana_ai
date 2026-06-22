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
  StoreTypeOption('kirana', 'Kirana / grocery', 'grocery'),
  StoreTypeOption('supermarket', 'Supermarket', 'grocery'),
  StoreTypeOption('mini_supermarket', 'Mini supermarket', 'grocery'),
  StoreTypeOption('provision', 'Provision store', 'grocery'),
  StoreTypeOption('fruits_vegetables', 'Fruits & vegetables', 'grocery'),
  StoreTypeOption('bakery', 'Bakery', 'grocery'),
  StoreTypeOption('apparel', 'Apparel / clothing', 'apparel'),
  StoreTypeOption('boutique', 'Boutique', 'apparel'),
  StoreTypeOption('mono_brand', 'Mono-brand outlet', 'apparel'),
  StoreTypeOption('footwear', 'Footwear', 'footwear'),
  StoreTypeOption('electronics', 'Mobile & electronics', 'electronics'),
  StoreTypeOption('optical', 'Optical', 'optical'),
  StoreTypeOption('salon', 'Salon', 'services'),
  StoreTypeOption('sports_fitness', 'Sports & fitness', 'services'),
  StoreTypeOption('fancy_gift', 'Fancy / gift', 'general'),
  StoreTypeOption('stationery', 'Stationery', 'general'),
  StoreTypeOption('general', 'General store', 'general'),
];
