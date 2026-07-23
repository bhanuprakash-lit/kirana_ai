# iOS Home-Screen Widgets — Mac/Xcode Setup

> **STATUS: DONE (2026-07-22).** The `KiranaWidgetExtensionExtension` target now
> exists in `Runner.xcodeproj`, the SwiftUI source lives at
> `ios/KiranaWidgetExtension/KiranaWidget.swift`, the App Group is wired on both
> targets, and a signed release build embeds `Runner.app/PlugIns/
> KiranaWidgetExtensionExtension.appex`. The section below is kept for reference /
> for re-creating the target from scratch. See **"Gotchas"** at the bottom for the
> two things that bit us (build-phase cycle + version match).

The Dart wiring and the SwiftUI source (`ios/KiranaWidgetExtension/KiranaWidget.swift`)
are already committed. The steps below create the Widget Extension target, the shared
App Group, and the deep-link wiring — these must be done **in Xcode on a Mac**.

Three widgets are defined: **KiranaMediumWidget** (4-stat glance, data-driven),
**KiranaNewSaleWidget** (small — opens scanner), **KiranaVisionWidget** (small —
"coming soon" toast).

> **Already wired in source** (nothing to write): deep-link URLs carry the
> `homeWidget` marker; `kiranaai` URL scheme registered in `Info.plist`; App
> Group added to `ios/Runner/Runner.entitlements`; the widget extension's
> `ios/KiranaWidget/Info.plist` and `ios/KiranaWidget/KiranaWidgetExtension.entitlements`
> are provided. **Remaining = Xcode GUI only:** create the Widget Extension
> target, add both files to it, add the App Group capability to both targets
> (registers it in your Apple Developer portal), and build. Steps 1–2 below.

## Prerequisites
- macOS + Xcode.
- An Apple Developer account (the App Group capability needs it).
- `cd ios && pod install` after pulling (the `home_widget` pod must be installed).

## 1. Create the Widget Extension target
1. Open `ios/Runner.xcworkspace` in Xcode.
2. **File → New → Target… → Widget Extension**. Name it **`KiranaWidget`**.
   - Uncheck **Include Configuration App Intent** and **Include Live Activity**
     (we use a plain `StaticConfiguration`).
   - Team = your team. Activate the scheme when prompted.
3. Xcode generates a placeholder `KiranaWidget.swift` + assets in a new group.
   **Delete the placeholder `.swift`** and instead add our committed file
   `ios/KiranaWidget/KiranaWidget.swift` to the project, with **Target Membership =
   KiranaWidgetExtension only** (not Runner). (Keep the Xcode-generated
   `Info.plist` and `Assets.xcassets` for the extension.)
4. Set the extension's **Minimum Deployments** to match Runner (iOS 14+ is fine;
   the code guards iOS-17 APIs).

## 2. Shared App Group (data bridge)
The app writes widget data into `group.com.lohiya.kiranaAi`; the widget reads it.
Add the **same** App Group to **both** targets:
1. Select the **Runner** target → **Signing & Capabilities → + Capability → App Groups**
   → add `group.com.lohiya.kiranaAi`.
2. Select the **KiranaWidgetExtension** target → add the **same** App Group.
3. With "Automatically manage signing" on, Xcode registers the group in the portal.
   This creates `Runner.entitlements` and `KiranaWidgetExtension.entitlements`,
   each listing the group.

> The id must exactly match `_appGroupId` in
> `lib/core/services/home_widget_service.dart` (`group.com.lohiya.kiranaAi`).

## 3. Deep links (widget tap → app screen) — ✅ DONE in source
Widget taps open `kiranaai://w?homeWidget=1&...` URLs, parsed by
`HomeWidgetService._handleUri` (→ `setPendingNavigation` → dashboard). This is
already wired in the committed source — no Swift to write:

- **`homeWidget` marker** — every deep link in `KiranaWidget.swift` is built via
  `deepLink(...)`, which prepends `homeWidget=1`. The `home_widget` plugin's
  `isWidgetUrl()` only treats a URL as a widget tap when it carries a `homeWidget`
  query item; without the marker `HomeWidget.widgetClicked` never fires.
- **URL delivery** — `SceneDelegate` is a plain `FlutterSceneDelegate` subclass
  and needs no manual forwarding. On this Flutter version `FlutterSceneDelegate`
  implements `scene(_:openURLContexts:)` / `scene(_:willConnectTo:)` and bridges
  those to legacy `application(_:open:)` plugins (via
  `sceneFallbackOpenURLContexts:`), which is exactly where `home_widget` 0.7
  listens. (The older hand-written scene-forwarding snippet is obsolete — do not
  re-add it, it would double-handle the tap.)
- **URL scheme** — `kiranaai` is registered under `CFBundleURLTypes` in
  `ios/Runner/Info.plist` so iOS routes the scheme to the app.

> Cold-launch nuance: warm taps (app already running) navigate reliably. If a
> tap that cold-launches the app ever fails to route, that's the one spot to
> revisit `HomeWidget.initiallyLaunchedFromHomeWidget()` timing.

## 4. Build & run
1. `cd ios && pod install`
2. Select the **Runner** scheme → run on a simulator/device once (so the app writes
   a first snapshot into the App Group; open the app while logged in).
3. Long-press the home screen → **+** → **Kirana AI** → add the medium and the two
   small widgets.
4. Tap each: medium cells deep-link (per-cell taps need **iOS 17+**; on older iOS
   the whole medium widget opens the overview), New Sale opens the scanner, Vision
   AI shows the "coming soon" toast.

## Notes
- The medium widget refreshes when the app foregrounds/backgrounds (the app calls
  `updateWidget(iOSName: "KiranaMediumWidget")`) plus a 30-min safety timeline.
  WidgetKit throttles refreshes — "fresh after app use or push" is the realistic
  promise, same as Android.
- Small widgets are static (no data) — pure action launchers, English labels.
- Icons use SF Symbols (`qrcode.viewfinder`, `sparkles`); no asset import needed.
- Snapshot keys are shared with Android — see
  `lib/core/services/home_widget_service.dart` and the `KiranaSnapshot.load()`
  reader in the Swift file. Keep them in sync.

## Gotchas (hit during the 2026-07-22 setup)

### 1. "Cycle inside Runner; building could produce unreliable results"
Adding the extension made Xcode append an **Embed Foundation Extensions** phase as
the *last* build phase. Flutter's **Thin Binary** phase treats the whole
`Runner.app` as its input, so it depended on the `.appex` that was copied in *after*
it → dependency cycle, every build failed.

**Fix:** in the Runner target's `buildPhases`, the **Embed Foundation Extensions**
phase must run **before Thin Binary** (it now sits right after *Embed Frameworks*).
If you ever re-add the target and hit the cycle again, reorder that phase up in
**Runner → Build Phases** (drag "Embed Foundation Extensions" above "Thin Binary").

### 2. Extension version must match the app (or App Store upload is rejected)
Apple rejects uploads (`ITMS-90473 CFBundleVersion Mismatch`) when an embedded
extension's version differs from the host app. Xcode created the extension at
`1.0 (1)` while the app is `1.1.0 (8)`.

**Fix:** the `KiranaWidgetExtensionExtension` target uses `GENERATE_INFOPLIST_FILE`,
so its version comes from build settings. They are set to match the app:
`MARKETING_VERSION = 1.1.0`, `CURRENT_PROJECT_VERSION = 8`.

> ⚠️ **These are literal values, NOT wired to Flutter's `$(FLUTTER_BUILD_*)`** (the
> extension target has no Flutter xcconfig in scope). **When you bump the app
> version in `pubspec.yaml`, also update `MARKETING_VERSION` and
> `CURRENT_PROJECT_VERSION` on the KiranaWidgetExtensionExtension target** (General
> tab → Version/Build, or the 3 config blocks in `project.pbxproj`) to the same
> values. A forgotten bump fails validation at upload with a clear ITMS-90473 error.

### 3. ⚠️ Archive with `flutter build ipa`, NOT Xcode's Product → Archive
The generated SPM manifest
`ios/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Package.swift`
declares an iOS platform floor via `.iOS("…")`. Its default is the Flutter
framework minimum (**13.0**); it is raised to the project's
`IPHONEOS_DEPLOYMENT_TARGET` (**15.6**) **only** by
`SwiftPackageManager.updateMinimumDeployment`, which runs **exclusively in the
`flutter build ios/ipa` code path** (`flutter_tools/lib/src/ios/mac.dart`).

**Xcode's Product → Archive does NOT run that bump.** Its run-script phase calls
`flutter assemble`, which regenerates `Package.swift` at the default **13.0** →
Firebase (needs iOS 15) fails to resolve → the archive errors. This recurs on
*every* Xcode archive, no matter how many times you regenerate from the CLI.

**Fix / workflow:** build releases with **`flutter build ipa --release`**. It
applies the 15.6 bump, embeds + signs the widget appex, and emits both
`build/ios/archive/Runner.xcarchive` (open in Xcode → Window → Organizer →
Distribute App) and `build/ios/ipa/*.ipa` (drag into the Transporter app). Do
not use the Archive menu for this project.
