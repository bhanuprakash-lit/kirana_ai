// Merges per-cluster translation fragments into the main ARB files.
//
// Each fragment is lib/l10n/frag/<name>.json with shape:
//   { "en": { "key": "..", "@key": {..} }, "te": { "key": ".." }, "hi": {..} }
//
// Run from project root:  dart run tool/l10n_merge.dart
// Existing keys are preserved; fragment keys are appended. Collisions are
// reported (and the existing value is kept) so prefix mistakes surface loudly.
import 'dart:convert';
import 'dart:io';

void main() {
  final fragDir = Directory('lib/l10n/frag');
  if (!fragDir.existsSync()) {
    stderr.writeln('No lib/l10n/frag directory — nothing to merge.');
    exit(0);
  }
  final fragFiles = fragDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList();
  if (fragFiles.isEmpty) {
    stderr.writeln('No fragment .json files found.');
    exit(0);
  }

  const locales = ['en', 'te', 'hi'];
  for (final locale in locales) {
    final arbFile = File('lib/l10n/app_$locale.arb');
    final arb = jsonDecode(arbFile.readAsStringSync()) as Map<String, dynamic>;
    var added = 0;
    final collisions = <String>[];

    for (final frag in fragFiles..sort((a, b) => a.path.compareTo(b.path))) {
      final data = jsonDecode(frag.readAsStringSync()) as Map<String, dynamic>;
      final section = (data[locale] as Map<String, dynamic>?) ?? {};
      section.forEach((key, value) {
        if (arb.containsKey(key)) {
          if (!key.startsWith('@')) collisions.add(key);
          return; // keep existing
        }
        arb[key] = value;
        if (!key.startsWith('@')) added++;
      });
    }

    const encoder = JsonEncoder.withIndent('  ');
    arbFile.writeAsStringSync('${encoder.convert(arb)}\n');
    stdout.writeln(
      'app_$locale.arb: +$added keys'
      '${collisions.isEmpty ? '' : '  COLLISIONS(kept existing): ${collisions.toSet().join(', ')}'}',
    );
  }
  stdout.writeln('Done. Now run: flutter gen-l10n');
}
