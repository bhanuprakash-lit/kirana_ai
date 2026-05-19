class GeminiItem {
  final String name;
  final String quantity;

  const GeminiItem({required this.name, required this.quantity});

  factory GeminiItem.fromMap(Map<String, dynamic> m) => GeminiItem(
        name: m['name'] as String? ?? '',
        quantity: m['quantity'] as String? ?? '1',
      );

  /// Strips regional parenthetical: "Rice (బియ్యం)" → "rice"
  String get baseName => name.split('(').first.trim().toLowerCase();

  /// Parses the numeric portion: "5kg" → 5.0, "500g" → 500.0
  double get parsedQty {
    final m = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(quantity);
    return double.tryParse(m?.group(1) ?? '') ?? 1.0;
  }
}
