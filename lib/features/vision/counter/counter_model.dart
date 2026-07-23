import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Where the on-device counter model lives, per platform. The `ultralytics_yolo`
/// plugin uses a **different runtime on each platform**, so the model format
/// differs too:
///   • Android → TensorFlow Lite (`.tflite`).
///   • iOS     → CoreML — the iOS plugin is CoreML-only and CANNOT load a
///     `.tflite`. A `.mlpackage` is a *directory*, so it is published zipped and
///     extracted on the device.
///
/// **Both are downloaded, neither is bundled** (PAI-15). They come from separate
/// blob prefixes — `counter` and `counter-ios` — because they are different
/// files with different checksums, exported from the same `kirana_v7` weights at
/// the same 640px input size so the two platforms behave alike.
///
/// The iOS export runs on Linux (a container is enough — coremltools has no
/// Windows wheels, hence `assert not WINDOWS` in the ultralytics exporter):
///     yolo export model=best.pt format=coreml nms=True imgsz=640 half=True
/// `nms=True` because this is yolo11s; YOLO26 would want `nms=False end2end=True`.
class CounterModel {
  static const String tfliteAsset = 'assets/models/counter_model.tflite';
  static const String labelsAsset = 'assets/models/counter_labels.txt';

  /// iOS CoreML resource name (no extension). Only used for the *bundled*
  /// lookup path; a downloaded model is handed to the plugin as an absolute
  /// `.mlpackage` path instead, which `YOLOView` accepts directly.
  static const String iosCoreMlName = 'counter_model';

  /// Blob prefix to fetch from, for the platform we're running on.
  static String get remoteModel =>
      defaultTargetPlatform == TargetPlatform.iOS ? 'counter-ios' : 'counter';

  /// Name the model is cached under once installed. On iOS this is a directory
  /// (the extracted `.mlpackage`), everywhere else a single file.
  static String get installedName => defaultTargetPlatform == TargetPlatform.iOS
      ? 'counter_model.mlpackage'
      : 'counter_model.tflite';

  /// Whether the downloaded artifact is a zip that must be extracted. True only
  /// on iOS — CoreML packages are directories, TFLite models are plain files.
  static bool get downloadIsArchive =>
      defaultTargetPlatform == TargetPlatform.iOS;

  /// The model path/name handed to [YOLOView], resolved for the current platform.
  ///
  /// PAI-15 — prefer `counterModelProvider`, which returns the downloaded copy.
  /// This static path is the bundled-asset fallback used while the Android model
  /// is still shipped in the build.
  static String get path =>
      defaultTargetPlatform == TargetPlatform.iOS ? iosCoreMlName : tfliteAsset;

  /// Whether a usable model is still bundled with the app.
  ///
  /// Now `false`: `assets/models/` was dropped from pubspec once both platforms
  /// had a published manifest, which is the change that actually removes the
  /// weights from the build. There is no fallback left — a download that fails
  /// all its retries surfaces as a real failure with a retry button, so the
  /// fetch path has to work.
  ///
  /// It was never `true` for iOS in any case: the bundled asset is a `.tflite`,
  /// which the CoreML runtime cannot load.
  static bool get hasBundledAsset =>
      defaultTargetPlatform != TargetPlatform.iOS && _bundledAndroidAsset;

  static const bool _bundledAndroidAsset = false;

  /// Default detection confidence for the live feed. A touch higher than the
  /// plugin default (0.25) to cut counter noise; tunable in the UI later.
  static const double defaultConfidence = 0.4;
}

// The old `counterModelAvailableProvider` lived here. It was a boolean
// "is the model bundled?" gate, which stopped being the right question once
// the Android model started being downloaded rather than shipped: availability
// is now one outcome of a state machine that also covers fetching, resuming and
// failing. `counterModelProvider` in model_provisioner.dart owns all of it,
// including the iOS bundle check this used to perform. Two gates disagreeing
// about whether the counter can run is exactly the bug that removing this
// avoids.
