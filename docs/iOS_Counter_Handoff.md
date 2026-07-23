# iOS Counter — handoff to a Mac

**Written 2026-07-23 from a Windows machine.** Everything described here was built
and tested on Windows/Linux. **No part of the iOS path has ever run on Apple
hardware**, because this repo cannot be built for iOS from Windows. That is the
entire reason this document exists.

If you are a Claude session on a Mac: read this end to end before changing
anything. The work is done; what remains is *verification on a device* and
fixing whatever that verification turns up. Resist the urge to re-architect —
the failure modes are enumerated in §6 with what each one actually implies.

---

## 1. What this feature is

The sale-area counter runs on-device object detection (`ultralytics_yolo`) over
the camera feed and tallies items crossing a line. The model used to be a 38 MB
`.tflite` bundled as a Flutter asset.

**PAI-15 removed it from the app binary.** The model is now downloaded once, by
an authenticated user, from a private Azure blob container, checksum-verified,
and cached in app-private storage. Anyone who unzips the IPA/APK gets nothing.

The plugin uses a **different runtime per platform**, so there are two models:

| | Android | iOS |
|---|---|---|
| Runtime | TensorFlow Lite | Core ML |
| Artifact | `counter_model.tflite` | `counter_model.mlpackage` (a **directory**) |
| Blob prefix | `counter/` | `counter-ios/` |
| Transport | raw file | **zipped**, extracted on device |
| Size | 38,624,531 B | 17,857,516 B zipped (18.5 MB unpacked) |

Both are exported from the same `kirana_v7` weights at 640px, so behaviour and
the line-crossing thresholds should carry over. The iOS one is smaller only
because it was exported `half=True` (fp16), which is normal for Core ML — the
ANE runs fp16 regardless.

---

## 2. What was done on the Windows side

### The Core ML export — **already done, no Mac needed for it**

This surprises people, so it's worth stating plainly: producing the
`.mlpackage` does **not** require macOS. `coremltools` publishes macOS and Linux
wheels but none for Windows, and ultralytics turns that into a hard gate:

```python
# ultralytics/engine/exporter.py:848
assert not WINDOWS, "CoreML export is not supported on Windows, please run on macOS or Linux."
```

Linux satisfies it. There was no WSL distro on the Windows box, so the export
ran in Docker Desktop's Linux engine (`python:3.11-slim` + CPU torch +
`ultralytics==8.4.57` + `coremltools>=9.0`, `numpy<=2.3.5` — numpy 2.4 breaks
coremltools export):

```bash
yolo export model=vision-ai/ml/train/runs/kirana_v7/weights/best.pt \
            format=coreml nms=True imgsz=640 half=True
```

- `nms=True` because this model is **yolo11s**. A YOLO26 model would need
  `nms=False end2end=True` (the plugin README documents the end-to-end output
  contract). Do not "fix" this to match the README without checking the base
  model in `runs/kirana_v7/args.yaml`.
- `imgsz=640` matches the Android export deliberately (trained at 960, exported
  at 640 so the counter stays real-time on a mid-range phone).

The `.mlpackage` was then zipped **with the package directory as the archive
root** and published to blob.

### Published to Azure blob (container `vision-models`, account `stlohiyaml`)

```
counter-ios/manifest.json
    {"version":"2026.07.1",
     "sha256":"059ed0aa163e5b2fe8db3f336505f411353fff6afc4c562350d02a5b3224bc37",
     "size":17857516, "ext":".mlpackage.zip", "format":"coreml"}
counter-ios/2026.07.1.mlpackage.zip
counter-ios/2026.07.1.labels          (442 classes, same set as Android)
```

Verified against live storage from the backend's own code: full-stream sha256
matches the manifest; an 8 MB prefix plus the ranged remainder reassembles to
the same hash (resume works); the reassembled bytes decode as a valid zip
containing exactly `Manifest.json`, `Data/com.apple.CoreML/model.mlmodel`,
`Data/com.apple.CoreML/weights/weight.bin`.

The container is **private** (`public_access: None`); an anonymous GET is
refused. Downloads go through the authenticated backend endpoints only.

### Backend changes (`kirana-master-backend`, branch `fix/pai-sweep`)

The storage layer hardcoded `.tflite` everywhere. It now carries a format
dimension:

- `vision/model_storage.py` — `artifact_ext(manifest)` (defaults to `.tflite`
  so **pre-existing Android manifests with no `ext` key keep resolving** —
  verified), plus `ext=` on `stream_model` / `download_model`.
- `vision/routes.py` — `KNOWN_MODELS = ("counter", "counter-ios")` replaces
  three hardcoded `("counter",)` whitelists; the manifest response now returns
  `format`; the download streams with the manifest's `ext`.
- `scripts/upload_vision_model.py` — infers ext + format from the weights file.
  Note `.mlpackage.zip` is **two** suffixes; `os.path.splitext` would keep only
  `.zip` and publish a blob name the app never asks for. That's special-cased.

Range/resume (`206`, `Content-Range`, `Accept-Ranges`) and the
`vision_model_fetch` attribution logging were already there and are unchanged.

### App changes (`kirana_ai`, branch `fix/pai-sweep`)

- `lib/features/vision/counter/counter_model.dart` — platform split:
  `remoteModel` (`counter` vs `counter-ios`), `installedName`
  (`counter_model.tflite` vs `counter_model.mlpackage`), `downloadIsArchive`.
  `hasBundledAsset` is now **`false`** (see cutover below) and was always false
  for iOS anyway — the bundled asset was a `.tflite`.
- `lib/features/vision/counter/model_provisioner.dart` — iOS now goes through
  the **same** state machine as Android (checking → downloading → ready), with
  the same auto-retry, resume and sha256 verification. The only divergence is
  the final install step.
- `installModelArchive()` — top-level (so it's testable without a platform
  channel). Extracts into a `.unpack` staging directory, then swaps, so a kill
  mid-extract can't leave a half-populated `.mlpackage` that the next launch
  mistakes for a good model. Rejects entries that escape the destination.
  Collapses the archive's root directory.
- `pubspec.yaml` — `archive: ^4.0.9` promoted from transitive to direct. Pure
  Dart, no native code, **no Podfile impact**.

### The asset cutover — already applied

`assets/models/` is **removed from pubspec** and `hasBundledAsset` is `false`.

**There is no fallback on either platform any more.** A download that exhausts
its retries surfaces as a real failure with a retry button. Previously a failed
download silently fell back to the bundled `.tflite`.

If device verification goes badly and you want the Android safety net back
while you debug, it's a two-line revert: restore `- assets/models/` under
`flutter: assets:` in `pubspec.yaml` and set `_bundledAndroidAsset = true` in
`counter_model.dart`. That does **not** help iOS — there has never been an iOS
fallback, because the bundled asset is a format Core ML cannot load.

### Tests

`flutter analyze` clean, 117/117 tests pass, including 8 new ones in
`test/features/vision/model_archive_test.dart` covering extraction, the root
collapse, replacing an existing install, the traversal guard, and the
corrupt-archive case.

One real bug was caught there and fixed: **`ZipDecoder` returns an empty archive
on corrupt input rather than throwing**, so the install would have replaced a
working model with an empty directory. There's now an `extracted == 0` guard.

Backend: 31 vision unit tests pass; all touched files compile. The full backend
suite could not run on the Windows box (its conda env crashes importing
pandas/numpy BLAS — pre-existing, unrelated).

---

## 3. Before you touch a Mac

**Two blockers, both outside this repo:**

1. **The work is uncommitted.** Both repos sit dirty on branch `fix/pai-sweep`.
   Commit and push from the Windows machine (or copy the trees) — otherwise the
   Mac has none of this.

2. **The backend must be deployed.** The app talks to UAT
   (`ca-lohiya-outlet-uat...azurecontainerapps.io`, per
   `lib/core/config/app_config.dart`, overridable by Firebase Remote Config
   `backend_url_dev`). Until the `KNOWN_MODELS` change is live there, a request
   for `counter-ios` returns **404 "Unknown model"** and the app will show its
   setup screen failing forever. This is the single most likely reason for a
   "nothing works" report.

   Deploy note carried from earlier work: a boot crash silently keeps serving
   the **old** image while the health check still passes. Verify the new
   revision is actually active, don't trust a green deploy.

---

## 4. What the Mac is actually for

Three things, none of which Windows or Linux can do:

1. **Build and sign the IPA.** Xcode only. The project targets iOS 15.6
   (`Podfile` + `IPHONEOS_DEPLOYMENT_TARGET`), raised for Firebase 12.16.
2. **Run Core ML.** `coremltools` can *convert* on Linux but can only *predict*
   on macOS. The conversion is therefore **numerically unvalidated** — see §6.1.
3. **Compile the model.** Core ML compiles `.mlpackage` → `.mlmodelc` on first
   load via `MLModel.compileModel(at:)`, inside the plugin
   (`YOLOPlugin.swift:174`). Nothing to do, but it explains the first-load pause.

`Info.plist` already has `NSCameraUsageDescription`, so camera permission is not
a blocker.

---

## 5. Verification steps, in order

Run on a **physical iPhone**. The simulator has no usable camera and will not
exercise the Neural Engine.

```bash
flutter pub get
cd ios && pod install && cd ..
flutter run --release -d <device-id>      # release: debug-mode CoreML is slow
```

Then, in the app:

1. **Log in**, and make sure the account has a store context. The model
   endpoints are Bearer-authed; the download is attributed to the user in
   `vision_model_fetch`.
2. **Open the Counter.** Expected: the "Setting up your counter" screen with the
   shelf-stocking loader, a percentage, and `x of 17.9 MB`. It should **not**
   ask permission to download — that's deliberate (the owner's call: the users
   are shopkeepers who won't self-serve a "38 MB model?" dialog; opening the
   Counter *is* the consent).
3. **Let it finish.** On success it walks straight into the camera without a
   second tap.
4. **Kill the app mid-download and reopen.** It must resume, not restart from
   zero. Watch the byte count pick up where it left off.
5. **Point the camera at real stock.** This is the step that matters — see §6.1.
   Bounding boxes should appear with plausible labels.
6. **Force-quit and reopen.** Second launch must go straight to the camera with
   no download (the cached `.mlpackage` is found on disk).

Useful signals in the Xcode console: the plugin logs
`YOLOView: Model file not found: <path>. Camera will run without inference.`
when the path doesn't resolve.

---

## 6. Failure modes, and what each one means

### 6.1 Camera opens, boxes are wrong / absent / nonsensical

**The most likely real failure, and the one I could not test.** The conversion
was done on Linux where prediction is impossible, and `nms=True` makes
ultralytics splice an NMS pipeline onto the model's output heads. If that
pipeline is wrong, the model loads fine and produces garbage.

Diagnose by running the model directly on the Mac, outside the app:

```bash
pip install ultralytics 'coremltools>=9.0' 'numpy<=2.3.5'
yolo predict task=detect model=counter_model.mlpackage imgsz=640 source=<a photo>
```

If that is also wrong, the artifact is bad, not the app. Re-export **natively on
the Mac** (same command as §2) and compare. If the native export is correct and
the Linux one isn't, that's a real coremltools platform difference — republish
from the Mac (§7) and note it in `docs/VISION_INTEGRATION.md`.

If `yolo predict` is correct but the app is wrong, the problem is in the app's
pre/post-processing or the model handoff, not the export.

### 6.2 "Camera will run without inference" / label reads "No Model"

The path handed to `YOLOView` didn't resolve. `YOLOView.swift:324-331` accepts
an absolute on-disk path ending in `.mlpackage`/`.mlmodelc`/`.mlmodel` and
checks it exists **as a directory or file**; anything else is looked up by name
in the app bundle. Check what the provisioner emitted as `state.path` and
whether that directory exists with `Manifest.json` directly inside it (not
nested one level deeper — the root collapse in `installModelArchive` is what
prevents that, and it is unit-tested, but verify on device).

### 6.3 Setup screen fails repeatedly

Almost certainly the backend, not the app. Check in order:
- Is the `KNOWN_MODELS` change deployed? (§3.2) → 404 otherwise.
- `GET /kirana/vision/model/counter-ios/manifest` with a valid Bearer token —
  should return `version`, `sha256`, `size`, `format: "coreml"`.
- Is `AZURE_STORAGE_CONNECTION_STRING` set in the deployed env? → 503 otherwise.

### 6.4 Setup finishes but the model won't load

Possible checksum-passing-but-corrupt extraction. Check that the on-device
`.mlpackage` has all three files and that `weight.bin` is ~18 MB. A truncated
`weight.bin` would mean the extract is at fault.

### 6.5 Detection works but is too slow

Expected knobs, in order of preference: confirm you're testing a `--release`
build; then `CounterModel.defaultConfidence` (currently 0.4); then re-export at
`imgsz=480`. Don't reach for int8 — Core ML on the ANE is already fp16 and int8
would need real calibration data.

---

## 7. Re-exporting and republishing

If you produce a better artifact on the Mac, publish it as a **new version**
rather than overwriting `2026.07.1`, so a device with the old one cached isn't
left checksum-mismatching against a changed blob:

```bash
cd kirana-master-backend
export AZURE_STORAGE_CONNECTION_STRING='<from .env line 42>'
python scripts/upload_vision_model.py \
    --model counter-ios --version 2026.07.2 \
    --weights /path/to/counter_model.mlpackage.zip \
    --labels  /path/to/counter_labels.txt
```

The zip must have the `.mlpackage` directory as its **archive root** — that's
what `installModelArchive` expects (it tolerates a flat archive too, but the
root form is what's published today). The script writes `manifest.json` **last**,
so a client can never see a manifest pointing at a half-uploaded blob.

⚠️ **Known gap, by design:** a published new version does **not** reach existing
installs. `_check()` treats any usable cached model as good enough, even a
version behind, so nobody is ever held behind a fresh download just to open the
Counter. Shipping a model update needs a deliberate mechanism (background
refresh, or a prompt at a moment the user isn't mid-sale) that doesn't exist
yet. For testing, delete and reinstall the app.

---

## 8. Things not to change without reading why

- **`nms=True`** — correct for yolo11s. The plugin README's `nms=False
  end2end=True` applies to YOLO26 only.
- **No total-duration timeout on the download**, only a 45 s *idle* timeout. A
  38 MB transfer on a shop's connection legitimately takes minutes; the old
  fixed 60 s made it categorically impossible below ~5 Mbps.
- **The cached model is not encrypted at rest.** Core ML and TFLite both load
  from a path, so decryption would write plaintext to disk anyway. It would be
  theatre paid for in startup time.
- **The setup screen doesn't ask permission.** Owner decision, §5.2.
- **Don't add the `.mlpackage` to the Runner target.** That would put it back in
  the IPA and undo PAI-15. The provisioner *does* check for a bundled Core ML
  model first (`YOLO.checkModelExists`) and would prefer it — that check exists
  so a future bundled model doesn't get downloaded on top of itself, not as an
  invitation to bundle one.

**PAI-15 caveat worth recording:** even with this, an iOS `.mlpackage` inside an
IPA would be extractable — App Store FairPlay encrypts the executable, not
resource files. Downloading it is what closes that, which is now done. But if
anyone ever bundles it "temporarily", the ticket silently reopens.

---

## 9. Checklist

- [ ] Both repos committed, pushed, pulled on the Mac
- [ ] Backend `KNOWN_MODELS` change deployed; new revision confirmed active
- [ ] `flutter pub get` + `pod install`
- [ ] Release build runs on a physical iPhone
- [ ] Setup screen appears, progresses, completes
- [ ] Resume verified (kill mid-download, reopen)
- [ ] Camera opens and **detections are correct** ← the real gate
- [ ] Second launch skips the download
- [ ] IPA size confirms the model is not bundled
- [ ] Android regression check — the cutover removed its fallback too
- [ ] `docs/VISION_INTEGRATION.md` updated with what device testing found
