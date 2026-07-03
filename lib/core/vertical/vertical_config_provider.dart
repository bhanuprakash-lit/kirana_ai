import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import 'vertical_config.dart';

/// Fetches the store's vertical config once and caches it for the session.
/// On any error it falls back to [VerticalConfig.grocery], so a failed call can
/// never break the UI — grocery behaviour is the safe default.
final verticalConfigProvider = FutureProvider<VerticalConfig>((ref) async {
  try {
    final data = await ref
        .read(apiClientProvider)
        .get('/kirana/vertical-config');
    if (data is Map<String, dynamic>) {
      return VerticalConfig.fromJson(data);
    }
    if (data is Map) {
      return VerticalConfig.fromJson(data.cast<String, dynamic>());
    }
    return VerticalConfig.grocery;
  } catch (_) {
    return VerticalConfig.grocery;
  }
});

/// Synchronous read for build methods: the loaded config, or grocery defaults
/// while loading / on error. Lets widgets gate UI without awaiting.
VerticalConfig verticalConfigOf(WidgetRef ref) {
  return ref.watch(verticalConfigProvider).asData?.value ??
      VerticalConfig.grocery;
}
