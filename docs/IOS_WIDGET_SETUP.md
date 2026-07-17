# iOS Home-Screen Widgets — Mac/Xcode Setup

The Dart wiring and the SwiftUI source (`ios/KiranaWidget/KiranaWidget.swift`) are
already committed. The steps below create the Widget Extension target, the shared
App Group, and the deep-link wiring — these must be done **in Xcode on a Mac**
(they can't be done from the Windows dev box).

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
