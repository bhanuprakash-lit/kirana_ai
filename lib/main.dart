import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'core/config/firebase_backend_config.dart';
import 'core/services/api_client.dart';
import 'core/theme/brand_theme.dart';
import 'features/pos_inventory/providers/printer_provider.dart';
import 'features/subscription/providers/iap_provider.dart';
import 'features/support/providers/notification_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init (Remote Config, Crashlytics, Performance)
  await FirebaseBackendConfig.initialize();

  // Route all Flutter framework errors to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Catch async errors that escape the Flutter zone
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Enable Firebase Performance monitoring
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  // Register FCM background handler before runApp (Flutter requirement)
  await initLocalNotifications();

  runApp(const ProviderScope(child: KiranaApp()));
}

class KiranaApp extends ConsumerStatefulWidget {
  const KiranaApp({super.key});

  @override
  ConsumerState<KiranaApp> createState() => _KiranaAppState();
}

class _KiranaAppState extends ConsumerState<KiranaApp>
    with WidgetsBindingObserver {
  DateTime? _foregroundStart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // App launched = first foreground event
    _foregroundStart = DateTime.now();
    _trackEvent('foreground');
    // Request Bluetooth permissions early so the printer is ready before
    // the user reaches the POS screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(printerProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _foregroundStart = DateTime.now();
      _trackEvent('foreground');
      // Re-check Bluetooth state (user may have toggled it in system settings)
      ref.read(printerProvider.notifier).onAppResumed();
    } else if (state == AppLifecycleState.paused) {
      final durationSec = _foregroundStart != null
          ? DateTime.now().difference(_foregroundStart!).inSeconds
          : null;
      _foregroundStart = null;
      _trackEvent('background', durationSec: durationSec);
    }
  }

  Future<void> _trackEvent(String event, {int? durationSec}) async {
    try {
      final body = <String, dynamic>{'event': event};
      if (durationSec != null) body['duration_sec'] = durationSec;
      await ref
          .read(apiClientProvider)
          .post('/kirana/tracking/app-event', body);
    } catch (_) {
      // Silently ignore — user may not be logged in yet
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(iapProvider); // Initialize IAP stream at app startup
    // Initialize FCM listeners once; safe to call multiple times (idempotent via Provider)
    ref.watch(notificationServiceProvider).init();
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Kirana AI',
      theme: buildBrandTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
