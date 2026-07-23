import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/vision/counter/counter_model.dart';
import 'package:kirana_ai/features/vision/counter/model_provisioner.dart';

/// Build a zip laid out like the published CoreML release: the `.mlpackage`
/// directory is the archive root.
List<int> _mlpackageZip({String root = 'counter_model.mlpackage'}) {
  final a = Archive()
    ..addFile(ArchiveFile.bytes('$root/Manifest.json', '{"x":1}'.codeUnits))
    ..addFile(
      ArchiveFile.bytes(
        '$root/Data/com.apple.CoreML/model.mlmodel',
        List<int>.filled(64, 7),
      ),
    )
    ..addFile(
      ArchiveFile.bytes(
        '$root/Data/com.apple.CoreML/weights/weight.bin',
        List<int>.filled(128, 9),
      ),
    );
  return ZipEncoder().encode(a);
}

void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('model_archive_test');
  });
  tearDown(() async {
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  Future<File> writeZip(List<int> bytes) async {
    final f = File('${tmp.path}/counter_model.mlpackage.part');
    await f.writeAsBytes(bytes, flush: true);
    return f;
  }

  group('installModelArchive', () {
    test('unpacks the package so the model sits at the destination', () async {
      final zip = await writeZip(_mlpackageZip());
      final dest = '${tmp.path}/counter_model.mlpackage';

      await installModelArchive(
        zip,
        dest,
        innerName: 'counter_model.mlpackage',
      );

      // The .mlpackage root in the archive must be collapsed, not nested:
      // CoreML expects Manifest.json directly inside the package.
      expect(await Directory(dest).exists(), isTrue);
      expect(await File('$dest/Manifest.json').exists(), isTrue);
      expect(
        await File('$dest/Data/com.apple.CoreML/weights/weight.bin').length(),
        128,
      );
      expect(
        await Directory('$dest/counter_model.mlpackage').exists(),
        isFalse,
        reason: 'the archive root must not survive as a nested directory',
      );
    });

    test('removes the zip and the staging directory when done', () async {
      final zip = await writeZip(_mlpackageZip());
      final dest = '${tmp.path}/counter_model.mlpackage';

      await installModelArchive(
        zip,
        dest,
        innerName: 'counter_model.mlpackage',
      );

      expect(await zip.exists(), isFalse, reason: '17 MB should not linger');
      expect(await Directory('$dest.unpack').exists(), isFalse);
    });

    test('replaces an existing install rather than merging into it', () async {
      final dest = '${tmp.path}/counter_model.mlpackage';
      await Directory(dest).create(recursive: true);
      await File('$dest/stale.bin').writeAsString('old version');

      await installModelArchive(
        await writeZip(_mlpackageZip()),
        dest,
        innerName: 'counter_model.mlpackage',
      );

      // A leftover file from the previous version would make the package
      // inconsistent with its own Manifest.json.
      expect(await File('$dest/stale.bin').exists(), isFalse);
      expect(await File('$dest/Manifest.json').exists(), isTrue);
    });

    test('tolerates a flat archive with no wrapping directory', () async {
      final a = Archive()
        ..addFile(ArchiveFile.bytes('Manifest.json', '{}'.codeUnits));
      final zip = await writeZip(ZipEncoder().encode(a));
      final dest = '${tmp.path}/counter_model.mlpackage';

      await installModelArchive(
        zip,
        dest,
        innerName: 'counter_model.mlpackage',
      );

      expect(await File('$dest/Manifest.json').exists(), isTrue);
    });

    test('refuses an entry that escapes the destination', () async {
      final a = Archive()
        ..addFile(ArchiveFile.bytes('../../evil.txt', 'pwned'.codeUnits));
      final zip = await writeZip(ZipEncoder().encode(a));
      final dest = '${tmp.path}/counter_model.mlpackage';

      await expectLater(
        installModelArchive(zip, dest, innerName: 'counter_model.mlpackage'),
        throwsA(isA<FileSystemException>()),
      );
      expect(await File('${tmp.path}/../../evil.txt').exists(), isFalse);
    });

    test('leaves a previous install intact when the archive is junk', () async {
      final dest = '${tmp.path}/counter_model.mlpackage';
      await Directory(dest).create(recursive: true);
      await File('$dest/Manifest.json').writeAsString('working model');

      final zip = await writeZip(List<int>.filled(200, 3)); // not a zip

      await expectLater(
        installModelArchive(zip, dest, innerName: 'counter_model.mlpackage'),
        throwsA(anything),
      );
      // The old model must survive a failed install — the counter keeps working.
      expect(await File('$dest/Manifest.json').readAsString(), 'working model');
    });
  });

  group('CounterModel platform split', () {
    tearDown(() => debugDefaultTargetPlatformOverride = null);

    test('iOS fetches the CoreML prefix and extracts it', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(CounterModel.remoteModel, 'counter-ios');
      expect(CounterModel.installedName, 'counter_model.mlpackage');
      expect(CounterModel.downloadIsArchive, isTrue);
      // assets/models/ holds a .tflite, which the CoreML runtime cannot load —
      // there has never been an iOS fallback, so it must not claim one.
      expect(CounterModel.hasBundledAsset, isFalse);
    });

    test('Android fetches the TFLite prefix as a plain file', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(CounterModel.remoteModel, 'counter');
      expect(CounterModel.installedName, 'counter_model.tflite');
      expect(CounterModel.downloadIsArchive, isFalse);
    });
  });
}
