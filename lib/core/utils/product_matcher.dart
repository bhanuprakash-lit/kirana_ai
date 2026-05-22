import '../../features/pos_inventory/models/pos_product.dart';

/// Four-stage fuzzy matcher used across Voice, Handwriting, and Invoice sheets.
/// Stage 1 — exact name match (lowercase)
/// Stage 2 — substring match either direction
/// Stage 3 — any significant word (≥4 chars) present in product name
/// Stage 4 — romanized regional word inside parentheses, e.g. "senagapappu"
PosProduct? matchProductByName(String itemName, List<PosProduct> products) {
  final base = itemName.split('(').first.trim().toLowerCase();
  if (base.isEmpty) return null;

  // Stage 1: exact
  for (final p in products) {
    if (p.name.toLowerCase() == base) return p;
  }
  // Stage 2: full substring either direction
  for (final p in products) {
    final pn = p.name.toLowerCase();
    if (pn.contains(base) || (base.contains(pn) && pn.length > 3)) return p;
  }
  // Stage 3: any significant word (≥4 chars) of the extracted name matches
  final words = base.split(RegExp(r'\s+')).where((w) => w.length >= 4).toList();
  for (final word in words) {
    for (final p in products) {
      if (p.name.toLowerCase().contains(word)) return p;
    }
  }
  // Stage 4: romanized regional word inside parentheses
  final parenMatch = RegExp(r'\(([a-zA-Z\s]+)\)').firstMatch(itemName);
  if (parenMatch != null) {
    final regional = parenMatch.group(1)!.trim().toLowerCase();
    if (regional.length > 3) {
      for (final p in products) {
        if (p.name.toLowerCase().contains(regional)) return p;
      }
    }
  }
  return null;
}
