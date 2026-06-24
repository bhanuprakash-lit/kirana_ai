import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A monotonically increasing token bumped every time the active store changes
/// (see `StoreActions.switchStore` / `addStore`).
///
/// This is the **canonical** way to make a provider store-scoped: any provider
/// that fetches data tied to the active store must call
/// `ref.watch(storeScopeProvider);` at the top of its build/fetch so it
/// automatically refetches when the owner switches stores. Forgetting this is
/// what caused per-store data to "bleed" (the previous store's job cards,
/// baskets, services, appointments, etc. lingering until a write forced a
/// refresh).
///
/// Bumping the token once invalidates every dependent at once — no need to
/// import and list each provider at the switch site.
class StoreScopeNotifier extends Notifier<int> {
  @override
  int build() => 0;

  /// Call when the active store changes so every watcher refetches.
  void bump() => state++;
}

final storeScopeProvider = NotifierProvider<StoreScopeNotifier, int>(
  StoreScopeNotifier.new,
);
