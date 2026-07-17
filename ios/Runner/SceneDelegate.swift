import Flutter
import UIKit

/// Scene delegate for the app. Deliberately empty: `FlutterSceneDelegate`
/// already implements `scene(_:openURLContexts:)` / `scene(_:willConnectTo:)`
/// and bridges those scene URL events to plugins that register the legacy way
/// via `application(_:open:)` (Flutter's `sceneFallbackOpenURLContexts:` /
/// `application:openURL:options:isFallbackForScene:` path). The `home_widget`
/// plugin (0.7) listens on exactly that legacy entry point, so home-screen
/// widget taps (`kiranaai://w?homeWidget=1&…`) reach it automatically — no
/// manual forwarding required. See docs/IOS_WIDGET_SETUP.md.
class SceneDelegate: FlutterSceneDelegate {

}
