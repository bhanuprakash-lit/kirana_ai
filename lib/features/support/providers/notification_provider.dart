import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../subscription/providers/subscription_provider.dart';

// ── Background handler — must be top-level (no class, no context) ─────────────

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Background messages on Android are shown automatically by FCM.
  // We only need this registered; heavy work should not happen here.
  debugPrint('FCM background message: ${message.messageId}');
}

// ── Local notifications setup ─────────────────────────────────────────────────

final _localNotifications = FlutterLocalNotificationsPlugin();

const _androidChannel = AndroidNotificationChannel(
  'kirana_ai_high',          // must match what FCM uses or what you send
  'Kirana AI Alerts',
  description: 'Important alerts from Kirana AI',
  importance: Importance.high,
  playSound: true,
);

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iOS    = DarwinInitializationSettings(
    requestAlertPermission: false, // already requested via FirebaseMessaging
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  await _localNotifications.initialize(
    const InitializationSettings(android: android, iOS: iOS),
    onDidReceiveNotificationResponse: _onNotificationTap,
  );

  // Create the Android notification channel
  await _localNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_androidChannel);
}

void _onNotificationTap(NotificationResponse response) {
  // payload carries the FCM 'action' value; handled by NotificationService
  debugPrint('Notification tapped: ${response.payload}');
  _pendingAction = response.payload;
}

// Pending deep-link action set when the user taps a notification.
String? _pendingAction;

String? consumePendingAction() {
  final action = _pendingAction;
  _pendingAction = null;
  return action;
}

// ── NotificationService ───────────────────────────────────────────────────────

class NotificationService {
  final Ref _ref;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool _initialized = false;

  NotificationService(this._ref);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    // Register background handler first (required before any other FCM call)
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Request permissions
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!granted) return;

    // Keep notifications visible while app is in foreground on Android
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await initLocalNotifications();
    await uploadToken();

    _fcm.onTokenRefresh.listen(_uploadTokenToServer);

    // ── Foreground messages ────────────────────────────────────────────────
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // ── User taps notification while app is in background (resumes) ────────
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // ── App opened from a terminated state via notification ────────────────
    final initial = await _fcm.getInitialMessage();
    if (initial != null) _handleMessageTap(initial);
  }

  // ── Foreground: show a local notification manually ─────────────────────────

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('FCM foreground: ${message.notification?.title}');

    final n = message.notification;
    if (n == null) return;

    final data   = message.data;
    final route  = data['route'] as String?;
    final action = data['action'] as String?;
    final logId  = data['log_id'] as String?;

    // Use route as payload so tapping the local notification deep-links correctly
    final payload = route ?? action;

    _localNotifications.show(
      message.hashCode,
      n.title ?? 'Kirana AI',
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );

    _handleAction(action, route: route);
    _markOpened(logId);
  }

  // ── Tap handler (background resume or terminated launch) ──────────────────

  void _handleMessageTap(RemoteMessage message) {
    final data = message.data;
    // New intelligence notifications use 'route'; legacy ones use 'action'
    final route  = data['route'] as String?;
    final action = data['action'] as String?;
    final logId  = data['log_id'] as String?;

    _pendingAction = route ?? action;
    _markOpened(logId);
    _handleAction(action, route: route);
  }

  // ── Mark a notification as opened (best-effort) ────────────────────────────

  void _markOpened(String? logId) {
    if (logId == null || logId == 'pending') return;
    final id = int.tryParse(logId);
    if (id == null) return;
    Future.microtask(() async {
      try {
        final client = _ref.read(apiClientProvider);
        await client.post('/kirana/intelligence/notification-opened', {'log_id': id});
      } catch (_) {}
    });
  }

  // ── Act on the data payload ───────────────────────────────────────────────

  void _handleAction(String? action, {String? route}) {
    if (action == 'open_subscription' || route == '/profile/subscription') {
      _ref.read(subscriptionProvider.notifier).refresh();
    } else if (action == 'subscription_cancelled') {
      // Refresh subscription — tier drops to 'none', dashboard will gate automatically
      _ref.read(subscriptionProvider.notifier).refresh();
    }
  }

  // ── Token management ───────────────────────────────────────────────────────

  Future<void> uploadToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) await _uploadTokenToServer(token);
    } catch (e) {
      debugPrint('FCM token upload error: $e');
    }
  }

  Future<void> _uploadTokenToServer(String token) async {
    try {
      // ApiClient reads auth_token from secure storage directly — no need to
      // wait for userProvider, which lags behind on first registration.
      final client = _ref.read(apiClientProvider);
      await client.post('/kirana/auth/fcm-token', {'fcm_token': token});
      debugPrint('FCM token uploaded');
    } catch (e) {
      debugPrint('FCM token server upload failed: $e');
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});
