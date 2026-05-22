import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_user.dart';
import 'auth_provider.dart';

final userProvider = AsyncNotifierProvider<UserNotifier, AppUser?>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    try {
      return await ref.read(authRepositoryProvider).getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).getCurrentUser(),
    );
  }
}
