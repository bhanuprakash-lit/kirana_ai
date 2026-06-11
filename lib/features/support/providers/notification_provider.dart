import 'dart:convert';

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

@pragma('vm:entry-point')
void _onNotificationTapBackground(NotificationResponse response) {
  // Action-button taps on a notification shown while the app is terminated land
  // here in a separate isolate. We can't touch the main-isolate navigation from
  // here, so the app simply opens; deep-linking applies to foreground/resumed
  // taps. Kept registered so the plugin doesn't warn.
}

// ── Notification channels ─────────────────────────────────────────────────────
// Splitting into categories lets users mute one kind (e.g. tips) without
// silencing payments or stock alerts. Channel IDs MUST match what the backend
// sets in AndroidNotification.channel_id (via the `channel` data field).

const String kDefaultChannelId = 'kirana_ai_high';

class _Channel {
  final String id;
  final String name;
  final String description;
  final Importance importance;
  const _Channel(this.id, this.name, this.description, this.importance);
}

const List<_Channel> _channels = <_Channel>[
  _Channel(
    'kirana_payments',
    'Payments & Udhaar',
    'Customer dues and supplier payment reminders',
    Importance.high,
  ),
  _Channel(
    'kirana_stock',
    'Stock Alerts',
    'Low-stock and expiry warnings',
    Importance.high,
  ),
  _Channel(
    'kirana_sales',
    'Sales & Billing',
    'Cart and billing reminders',
    Importance.high,
  ),
  _Channel(
    'kirana_summary',
    'Daily Summary',
    'Daily and weekly business summaries',
    Importance.defaultImportance, // informational — no heads-up intrusion
  ),
  _Channel(
    'kirana_growth',
    'Tips & Offers',
    'Growth tips and feature suggestions',
    Importance.low,
  ),
  _Channel(
    'kirana_account',
    'Account & Subscription',
    'Subscription and account updates',
    Importance.high,
  ),
  // Legacy / fallback channel — also the manifest default_notification_channel_id.
  _Channel(
    kDefaultChannelId,
    'Kirana AI Alerts',
    'Important alerts from Kirana AI',
    Importance.high,
  ),
];

final Map<String, _Channel> _channelById = {for (final c in _channels) c.id: c};

// ── Local notifications setup ─────────────────────────────────────────────────

final _localNotifications = FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iOS = DarwinInitializationSettings(
    requestAlertPermission: false, // already requested via FirebaseMessaging
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  await _localNotifications.initialize(
    const InitializationSettings(android: android, iOS: iOS),
    onDidReceiveNotificationResponse: _onNotificationTap,
    onDidReceiveBackgroundNotificationResponse: _onNotificationTapBackground,
  );

  // Create every Android notification channel up front.
  final androidImpl = _localNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  if (androidImpl != null) {
    for (final c in _channels) {
      await androidImpl.createNotificationChannel(
        AndroidNotificationChannel(
          c.id,
          c.name,
          description: c.description,
          importance: c.importance,
          playSound: true,
        ),
      );
    }
  }
}

// ── Pending navigation (deep-link from a tapped notification) ─────────────────
// Stores the full nav intent (route + tab + subtab) rather than a bare route,
// so tab/subtab targeting from the backend actually takes effect.

Map<String, String>? _pendingNav;
void Function()? _onPendingNav;

/// Dashboard registers a callback so taps that arrive while it's already alive
/// (foreground tap, or resume from background) navigate immediately.
void registerPendingNavListener(void Function() cb) => _onPendingNav = cb;
void clearPendingNavListener() => _onPendingNav = null;

/// Returns and clears the pending navigation intent, if any.
Map<String, String>? consumePendingNavigation() {
  final nav = _pendingNav;
  _pendingNav = null;
  return nav;
}

/// Sets a pending navigation intent from outside the FCM flow (e.g. a home-screen
/// widget tap) and pings the listener so it's applied immediately when the app
/// is already running.
void setPendingNavigation(Map<String, String> nav) {
  _pendingNav = nav;
  _onPendingNav?.call();
}

Map<String, String> _navFromData(Map<String, dynamic> data) {
  final out = <String, String>{};
  for (final key in const ['route', 'tab', 'subtab', 'action']) {
    final v = data[key];
    if (v != null && '$v'.isNotEmpty) out[key] = '$v';
  }
  return out;
}

void _onNotificationTap(NotificationResponse response) {
  final payload = response.payload;
  if (payload == null || payload.isEmpty) return;
  try {
    final decoded = jsonDecode(payload) as Map;
    _pendingNav = decoded.map((k, v) => MapEntry('$k', '$v'));
  } catch (_) {
    // Legacy plain-string payloads were a bare route.
    _pendingNav = {'route': payload};
  }
  _onPendingNav?.call();
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

    // Note: Permission is no longer requested here. Call requestPermission() when appropriate.

    // Check if permission is already granted (e.g. from previous runs)
    final settings = await _fcm.getNotificationSettings();
    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!granted)
      return; // Don't setup foreground styling/local notifs if not allowed

    await _setupForegroundHandling();
  }

  Future<bool> requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (granted) {
      await _setupForegroundHandling();
    }
    return granted;
  }

  Future<void> _setupForegroundHandling() async {
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

    final data = message.data;
    final channelId = data['channel'] ?? kDefaultChannelId;
    final channel = _channelById[channelId] ?? _channelById[kDefaultChannelId]!;
    final nav = _navFromData(data);
    final cta = data['cta'];

    _localNotifications.show(
      message.hashCode,
      n.title ?? 'Kirana AI',
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          // Expandable long text so summaries/reports aren't truncated.
          styleInformation: BigTextStyleInformation(
            n.body ?? '',
            contentTitle: n.title,
          ),
          actions: (cta != null && cta.isNotEmpty)
              ? <AndroidNotificationAction>[
                  AndroidNotificationAction(
                    'cta',
                    cta,
                    showsUserInterface: true,
                  ),
                ]
              : null,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      // Tapping the local notification deep-links via the full nav intent.
      payload: nav.isEmpty ? null : jsonEncode(nav),
    );

    _handleAction(data['action'], route: data['route']);
    _markOpened(data['log_id']);
  }

  // ── Tap handler (background resume or terminated launch) ──────────────────

  void _handleMessageTap(RemoteMessage message) {
    final data = message.data;
    _pendingNav = _navFromData(data);
    _markOpened(data['log_id']);
    _handleAction(data['action'], route: data['route']);
    _onPendingNav?.call();
  }

  // ── Mark a notification as opened (best-effort) ────────────────────────────

  void _markOpened(String? logId) {
    if (logId == null || logId == 'pending') return;
    final id = int.tryParse(logId);
    if (id == null) return;
    Future.microtask(() async {
      try {
        final client = _ref.read(apiClientProvider);
        await client.post('/kirana/intelligence/notification-opened', {
          'log_id': id,
        });
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
