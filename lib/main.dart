import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'core/config/firebase_backend_config.dart';
import 'core/locale/locale_provider.dart';
import 'core/services/api_client.dart';
import 'core/services/home_widget_service.dart';
import 'core/theme/brand_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'features/pos_inventory/providers/printer_provider.dart';
import 'features/subscription/providers/iap_provider.dart';
import 'features/support/providers/notification_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait up
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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
    // Home-screen widget: register tap routing + refresh from last-known data.
    HomeWidgetService.init();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => HomeWidgetService.update(ref),
    );
    // Permissions are now handled contextually or via a dedicated onboarding flow
    // to enhance the user's first-time experience.
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
      HomeWidgetService.update(ref);
    } else if (state == AppLifecycleState.paused) {
      final durationSec = _foregroundStart != null
          ? DateTime.now().difference(_foregroundStart!).inSeconds
          : null;
      _foregroundStart = null;
      _trackEvent('background', durationSec: durationSec);
      // Leaving the app — push a complete, freshly-fetched snapshot to the widget.
      HomeWidgetService.update(ref, fetch: true);
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
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'Kirana AI',
      theme: buildBrandTheme(locale),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Clamp very large system font / display-size settings so the dense
        // business layouts (dashboard cards, headers) don't overflow. Moderate
        // accessibility scaling up to 1.3× is still honoured.
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(maxScaleFactor: 1.3),
          ),
          child: child!,
        );
      },
    );
  }
}
