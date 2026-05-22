import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import '../services/usage_limits_service.dart';

class UsageLimitsState {
  final int voiceUsed;
  final int voiceCredits;
  final int handwriteUsed;
  final int handwriteCredits;
  final int invoiceUsed;
  final int invoiceCredits;

  const UsageLimitsState({
    required this.voiceUsed,
    required this.voiceCredits,
    required this.handwriteUsed,
    required this.handwriteCredits,
    required this.invoiceUsed,
    required this.invoiceCredits,
  });

  // ── Computed helpers ───────────────────────────────────────────────────────

  int get voiceLimit => kDailyLimits[kFeatureVoice]!;
  int get handwriteLimit => kDailyLimits[kFeatureHandwrite]!;
  int get invoiceLimit => kDailyLimits[kFeatureInvoice]!;

  int get voiceRemaining {
    final free = (voiceLimit - voiceUsed).clamp(0, voiceLimit);
    return free > 0 ? free : voiceCredits;
  }

  int get handwriteRemaining {
    final free = (handwriteLimit - handwriteUsed).clamp(0, handwriteLimit);
    return free > 0 ? free : handwriteCredits;
  }

  int get invoiceRemaining {
    final free = (invoiceLimit - invoiceUsed).clamp(0, invoiceLimit);
    return free > 0 ? free : invoiceCredits;
  }

  bool get canUseVoice => voiceRemaining > 0;
  bool get canUseHandwrite => handwriteRemaining > 0;
  bool get canUseInvoice => invoiceRemaining > 0;

  int remainingFor(String feature) {
    switch (feature) {
      case kFeatureVoice:
        return voiceRemaining;
      case kFeatureHandwrite:
        return handwriteRemaining;
      case kFeatureInvoice:
        return invoiceRemaining;
      default:
        return 0;
    }
  }

  factory UsageLimitsState.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> feat(String key) =>
        (json[key] as Map<String, dynamic>?) ?? {};
    final v = feat(kFeatureVoice);
    final h = feat(kFeatureHandwrite);
    final i = feat(kFeatureInvoice);
    return UsageLimitsState(
      voiceUsed: (v['used'] as num?)?.toInt() ?? 0,
      voiceCredits: (v['credits'] as num?)?.toInt() ?? 0,
      handwriteUsed: (h['used'] as num?)?.toInt() ?? 0,
      handwriteCredits: (h['credits'] as num?)?.toInt() ?? 0,
      invoiceUsed: (i['used'] as num?)?.toInt() ?? 0,
      invoiceCredits: (i['credits'] as num?)?.toInt() ?? 0,
    );
  }

  /// Patch a single feature's counts using the inline `ai_status` the server
  /// returns alongside every AI response — avoids a second network call.
  UsageLimitsState withFeatureUpdate(String feature, Map<String, dynamic> s) {
    final used = (s['used'] as num?)?.toInt() ?? 0;
    final credits = (s['credits'] as num?)?.toInt() ?? 0;
    return UsageLimitsState(
      voiceUsed: feature == kFeatureVoice ? used : voiceUsed,
      voiceCredits: feature == kFeatureVoice ? credits : voiceCredits,
      handwriteUsed: feature == kFeatureHandwrite ? used : handwriteUsed,
      handwriteCredits: feature == kFeatureHandwrite
          ? credits
          : handwriteCredits,
      invoiceUsed: feature == kFeatureInvoice ? used : invoiceUsed,
      invoiceCredits: feature == kFeatureInvoice ? credits : invoiceCredits,
    );
  }

  static const zero = UsageLimitsState(
    voiceUsed: 0,
    voiceCredits: 0,
    handwriteUsed: 0,
    handwriteCredits: 0,
    invoiceUsed: 0,
    invoiceCredits: 0,
  );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class UsageLimitsNotifier extends AsyncNotifier<UsageLimitsState> {
  @override
  Future<UsageLimitsState> build() => _fetch();

  Future<UsageLimitsState> _fetch() async {
    try {
      final data = await ref.read(apiClientProvider).get('/kirana/ai/status');
      return UsageLimitsState.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      // Offline or auth not ready — return permissive defaults so UI doesn't break
      return UsageLimitsState.zero;
    }
  }

  Future<void> refresh() async {
    state = AsyncData(await _fetch());
  }

  /// Instantly update counts from the inline ai_status returned by each AI endpoint.
  void applyInlineUpdate(String feature, Map<String, dynamic> aiStatus) {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.withFeatureUpdate(feature, aiStatus));
    }
  }

  Future<void> addCredits(String feature, int count) async {
    final data = await ref.read(apiClientProvider).post(
      '/kirana/ai/credits/add',
      {'feature': feature, 'count': count},
    );
    state = AsyncData(UsageLimitsState.fromJson(data as Map<String, dynamic>));
  }
}

final usageLimitsProvider =
    AsyncNotifierProvider<UsageLimitsNotifier, UsageLimitsState>(
      UsageLimitsNotifier.new,
    );
