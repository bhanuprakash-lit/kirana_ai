import Flutter
import UIKit
import FirebaseAuth

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // MARK: - Firebase Phone Auth bridging
  //
  // Info.plist sets FirebaseAppDelegateProxyEnabled = NO, so Firebase does NOT
  // auto-swizzle the app delegate. Phone Auth then needs these callbacks
  // forwarded manually, otherwise verifyPhoneNumber can't complete:
  //   • APNs token   → silent-push verification (the no-captcha happy path)
  //   • notification → Firebase consumes its silent verification push
  //   • open URL     → the reCAPTCHA web fallback redirects back via the
  //                    REVERSED_CLIENT_ID URL scheme (which must ALSO be
  //                    registered in Info.plist — see docs/IOS_APP_STORE_REVIEW.md).

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // .unknown lets Firebase auto-detect sandbox vs production APNs environment.
    Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    super.application(
      application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler(.noData)
      return
    }
    super.application(
      application, didReceiveRemoteNotification: userInfo,
      fetchCompletionHandler: completionHandler)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    if Auth.auth().canHandle(url) {
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
