// import 'dart:async';

// import 'package:flutter/foundation.dart';

// /// Single master backend on port 9000 — Kirana AI, POS and KPI all share
// /// the same host. Firebase Remote Config can override the URL at runtime.
// class AppConfig {
//   static final _changes = StreamController<int>.broadcast();
//   static int _revision = 0;
//   static String? _remoteUrl;

//   static Stream<int> get changes => _changes.stream;

//   static String get baseUrl {
//     final remote = _sanitize(_remoteUrl);
//     if (remote != null) return remote;
//     if (kIsWeb) return 'http://127.0.0.1:9000';
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'http://10.0.2.2:9000';
//     }
//     return 'http://127.0.0.1:9000';
//   }

//   static String get apiBaseUrl => baseUrl;
//   static String get posApiBaseUrl => baseUrl;

//   /// Called by Firebase Remote Config when a new URL is fetched.
//   static void updateFromRemote(String? url) {
//     final next = _sanitize(url);
//     if (_remoteUrl == next) return;
//     _remoteUrl = next;
//     _changes.add(++_revision);
//   }

//   static String? _sanitize(String? value) {
//     final trimmed = value?.trim();
//     if (trimmed == null || trimmed.isEmpty) return null;
//     final without = trimmed.replaceFirst(RegExp(r'/+$'), '');
//     final uri = Uri.tryParse(without);
//     if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;
//     return without;
//   }
// }
