import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'core/config/firebase_backend_config.dart';
import 'core/theme/brand_theme.dart';
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

class KiranaApp extends ConsumerWidget {
  const KiranaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
