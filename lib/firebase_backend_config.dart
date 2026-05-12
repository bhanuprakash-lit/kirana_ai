// import 'dart:async';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';

// import 'firebase_options.dart';
// import 'app_config.dart';

// class FirebaseBackendConfig {
//   static StreamSubscription<RemoteConfigUpdate>? _subscription;

//   static Future<void> initialize() async {
//     try {
//       await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       );
//     } on UnsupportedError catch (error) {
//       debugPrint('Firebase config skipped: $error');
//       return;
//     } catch (error) {
//       debugPrint('Firebase initialization failed: $error');
//       return;
//     }

//     final remoteConfig = FirebaseRemoteConfig.instance;
//     try {
//       await remoteConfig.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(seconds: 10),
//           minimumFetchInterval: Duration.zero,
//         ),
//       );
//       await remoteConfig.setDefaults({
//         'kirana_api_base_url': AppConfig.baseUrl,
//       });
//       await remoteConfig.fetchAndActivate();
//       _apply(remoteConfig);

//       await _subscription?.cancel();
//       _subscription = remoteConfig.onConfigUpdated.listen((_) async {
//         await remoteConfig.activate();
//         _apply(remoteConfig);
//       });
//     } catch (error) {
//       debugPrint('Firebase Remote Config unavailable: $error');
//     }
//   }

//   static void _apply(FirebaseRemoteConfig remoteConfig) {
//     AppConfig.updateFromRemote(
//       _firstString(remoteConfig, const [
//         'api_base_url',
//         'backend_api_base_url',
//         'kirana_api_base_url',
//       ]),
//     );
//   }

//   static String? _firstString(
//     FirebaseRemoteConfig remoteConfig,
//     List<String> keys,
//   ) {
//     for (final key in keys) {
//       final value = remoteConfig.getString(key).trim();
//       if (value.isNotEmpty) return value;
//     }
//     return null;
//   }
// }
