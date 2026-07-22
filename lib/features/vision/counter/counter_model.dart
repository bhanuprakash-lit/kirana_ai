import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

/// Where the on-device counter model lives, per platform. The `ultralytics_yolo`
/// plugin uses a **different runtime on each platform**, so the model format
/// differs too:
///   • Android → TensorFlow Lite (`.tflite`), bundled as a Flutter asset.
///   • iOS     → CoreML — the iOS plugin is CoreML-only and CANNOT load a
///     `.tflite`. The model ships as `counter_model.mlpackage` added to the
///     Runner target (Target Membership = Runner) so the plugin resolves it from
///     the app bundle by name. Export it from the trained YOLO weights with:
///        yolo export model=counter.pt format=coreml nms=True
///     (see docs/VISION_INTEGRATION.md — "iOS CoreML export pending").
class CounterModel {
  static const String tfliteAsset = 'assets/models/counter_model.tflite';
  static const String labelsAsset = 'assets/models/counter_labels.txt';

  /// iOS CoreML resource name (no extension) — the plugin looks for
  /// `counter_model.mlpackage` / `counter_model.mlmodelc` in the app bundle.
  static const String iosCoreMlName = 'counter_model';

  /// The model path/name handed to [YOLOView], resolved for the current platform.
  ///
  /// PAI-15 — prefer `counterModelPathProvider`, which returns the downloaded
  /// copy. This static path is the bundled-asset fallback used while the model
  /// is still shipped in the build.
  static String get path =>
      defaultTargetPlatform == TargetPlatform.iOS ? iosCoreMlName : tfliteAsset;

  /// Whether the `.tflite` is still bundled with the app.
  ///
  /// Flip to `false` in the same change that drops `assets/models/` from
  /// pubspec — the provisioner then stops offering the asset as a fallback and
  /// relies entirely on the authenticated download. Keep it `true` until
  /// `scripts/upload_vision_model.py` has published a manifest, so an install
  /// is never left with no model at all.
  static const bool hasBundledAsset = true;

  /// Default detection confidence for the live feed. A touch higher than the
  /// plugin default (0.25) to cut counter noise; tunable in the UI later.
  static const double defaultConfidence = 0.4;
}

/// Whether the on-device model binary is actually bundled for THIS platform.
/// Until the model is present the counter shows a "not installed" state instead
/// of a black (or crashing) camera — the rest of the app is unaffected.
///
/// Android checks the bundled `.tflite` asset directly. iOS asks the plugin's
/// native resolver whether the CoreML model exists in the app bundle — checking
/// the `.tflite` on iOS would give a false positive (the asset is bundled but
/// the CoreML runtime can't load it), opening a YOLOView that fails to start.
final counterModelAvailableProvider = FutureProvider<bool>((ref) async {
  try {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final result = await YOLO.checkModelExists(CounterModel.iosCoreMlName);
      return result['exists'] == true;
    }
    final data = await rootBundle.load(CounterModel.tfliteAsset);
    return data.lengthInBytes > 0;
  } catch (_) {
    return false;
  }
});
