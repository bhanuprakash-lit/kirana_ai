import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_client.dart';
import '../store/store_scope.dart';
import 'vertical_config.dart';

/// Fetches the active store's vertical config and caches the last-good copy
/// per store in SharedPreferences.
///
/// Watches [storeScopeProvider], so switching stores refetches automatically
/// (the canonical store-scoped pattern) — no reliance on the switch site
/// remembering to invalidate this provider.
///
/// Failure order matters: a failed fetch falls back to the LAST-GOOD config
/// for this store, not to grocery. Falling back to grocery silently swapped a
/// salon/electronics store to grocery UI (wrong tabs, wrong fields) whenever
/// one request failed on a flaky network. Grocery remains the fallback only
/// when this store has never loaded a config before.
final verticalConfigProvider = FutureProvider<VerticalConfig>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes

  final prefs = await SharedPreferences.getInstance();
  final storeId = prefs.getInt('store_id') ?? 0;
  final cacheKey = 'vertical_config_$storeId';

  try {
    final data = await ref.read(apiClientProvider).get('/kirana/vertical-config');
    if (data is Map) {
      final map = data.cast<String, dynamic>();
      final config = VerticalConfig.fromJson(map);
      await prefs.setString(cacheKey, jsonEncode(map));
      return config;
    }
  } catch (_) {
    // fall through to the cached copy
  }

  final cached = prefs.getString(cacheKey);
  if (cached != null) {
    try {
      return VerticalConfig.fromJson(
        (jsonDecode(cached) as Map).cast<String, dynamic>(),
      );
    } catch (_) {
      // corrupt cache — fall through to grocery
    }
  }
  return VerticalConfig.grocery;
});

/// Synchronous read for build methods: the loaded config, or grocery defaults
/// while loading / on error. Lets widgets gate UI without awaiting.
VerticalConfig verticalConfigOf(WidgetRef ref) {
  return ref.watch(verticalConfigProvider).asData?.value ??
      VerticalConfig.grocery;
}
