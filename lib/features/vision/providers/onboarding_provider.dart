import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../auth/repositories/auth_repository.dart' show ApiException;
import '../models/vision_models.dart';

/// Bulk stock-in ("snap your shelves") flow state machine.
enum OnboardingStatus { idle, uploading, processing, ready, committing, done, failed }

/// One detected product on the review screen — its quantity is editable and, for
/// an unrecognised detection, the owner can map it to a real catalog product.
class OnboardingReviewItem {
  final int itemId;
  final String label; // best human label from detection
  final bool detectedUnknown; // model couldn't match it to the catalog
  int? productId; // resolved: matched, or owner-picked
  int quantity; // opening stock (defaults to detected count)

  OnboardingReviewItem({
    required this.itemId,
    required this.label,
    required this.detectedUnknown,
    required this.productId,
    required this.quantity,
  });

  /// Needs the owner to map it before it can be committed.
  bool get needsMapping => productId == null;
}

class OnboardingState {
  final OnboardingStatus status;
  final int? sessionId;
  final List<OnboardingReviewItem> items;
  final int committedProducts;
  final int committedQuantity;
  final String? error;

  const OnboardingState({
    this.status = OnboardingStatus.idle,
    this.sessionId,
    this.items = const [],
    this.committedProducts = 0,
    this.committedQuantity = 0,
    this.error,
  });

  /// Items ready to commit (mapped + positive quantity).
  List<OnboardingReviewItem> get committable =>
      items.where((i) => i.productId != null && i.quantity > 0).toList();

  int get mappedCount => items.where((i) => !i.needsMapping).length;
  int get unmappedCount => items.where((i) => i.needsMapping).length;

  OnboardingState copyWith({
    OnboardingStatus? status,
    int? sessionId,
    List<OnboardingReviewItem>? items,
    int? committedProducts,
    int? committedQuantity,
    String? error,
    bool clearError = false,
  }) => OnboardingState(
    status: status ?? this.status,
    sessionId: sessionId ?? this.sessionId,
    items: items ?? this.items,
    committedProducts: committedProducts ?? this.committedProducts,
    committedQuantity: committedQuantity ?? this.committedQuantity,
    error: clearError ? null : (error ?? this.error),
  );
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  ApiClient get _client => ref.read(apiClientProvider);

  static const _pollEvery = Duration(seconds: 3);
  static const _pollMax = 40; // ~2 min ceiling (shelf detection can be slow)

  @override
  OnboardingState build() => const OnboardingState();

  /// Upload captured shelf photos, then wait for detection to finish.
  Future<void> analyze(List<String> filePaths) async {
    state = state.copyWith(status: OnboardingStatus.uploading, clearError: true, items: []);
    try {
      final res = await _client.postMultipart(
        '/kirana/vision/onboarding/analyze',
        filePaths: filePaths,
      ) as Map<String, dynamic>;
      final sessionId = (res['session_id'] as num).toInt();
      state = state.copyWith(status: OnboardingStatus.processing, sessionId: sessionId);
      await _pollUntilDone(sessionId);
    } catch (e) {
      state = state.copyWith(status: OnboardingStatus.failed, error: _msg(e));
    }
  }

  /// Resume a session opened from an FCM deep-link (owner backgrounded the app
  /// during processing). Loads its items if detection already finished, else waits.
  Future<void> resumeSession(int sessionId) async {
    state = state.copyWith(
        status: OnboardingStatus.processing, sessionId: sessionId, items: [], clearError: true);
    await _pollUntilDone(sessionId);
  }

  Future<void> _pollUntilDone(int sessionId) async {
    for (var i = 0; i < _pollMax; i++) {
      await Future.delayed(_pollEvery);
      try {
        final res =
            await _client.get('/kirana/vision/sessions') as List<dynamic>;
        final match = res
            .map((j) => VisionSession.fromJson(j as Map<String, dynamic>))
            .where((s) => s.sessionId == sessionId);
        if (match.isNotEmpty && !match.first.isPending) {
          if (match.first.isFailed) {
            state = state.copyWith(status: OnboardingStatus.failed);
          } else {
            await _loadItems(sessionId);
          }
          return;
        }
      } catch (_) {
        // transient; keep polling
      }
    }
    state = state.copyWith(status: OnboardingStatus.failed, error: 'Timed out reading your photos');
  }

  Future<void> _loadItems(int sessionId) async {
    final res =
        await _client.get('/kirana/vision/session/$sessionId/items') as List<dynamic>;
    final items = res
        .map((j) => VisionItem.fromJson(j as Map<String, dynamic>))
        .map((v) => OnboardingReviewItem(
              itemId: v.itemId,
              label: v.label,
              detectedUnknown: v.isUnknown,
              productId: v.correctedProductId ?? v.productId,
              quantity: v.count,
            ))
        .toList();
    state = state.copyWith(status: OnboardingStatus.ready, items: items);
  }

  // ── Review edits ─────────────────────────────────────────────────────────────

  void setQuantity(int itemId, int quantity) {
    state = state.copyWith(items: [
      for (final i in state.items)
        if (i.itemId == itemId)
          (i..quantity = quantity < 0 ? 0 : quantity)
        else
          i,
    ]);
  }

  /// Map an unrecognised detection to a catalog product (owner picked it).
  void mapProduct(int itemId, int productId, String label) {
    state = state.copyWith(items: [
      for (final i in state.items)
        if (i.itemId == itemId) (i..productId = productId) else i,
    ]);
  }

  void removeItem(int itemId) {
    state = state.copyWith(
        items: state.items.where((i) => i.itemId != itemId).toList());
  }

  // ── Commit ───────────────────────────────────────────────────────────────────

  /// Write reviewed quantities to inventory. Returns true on success.
  Future<bool> commit() async {
    final sessionId = state.sessionId;
    if (sessionId == null) return false;
    final payload = state.committable;
    if (payload.isEmpty) {
      state = state.copyWith(error: 'Add a quantity to at least one product first.');
      return false;
    }
    state = state.copyWith(status: OnboardingStatus.committing, clearError: true);
    try {
      final res = await _client.post('/kirana/vision/onboarding/commit/$sessionId', {
        'items': [
          for (final i in payload) {'product_id': i.productId, 'quantity': i.quantity},
        ],
      }) as Map<String, dynamic>;
      state = state.copyWith(
        status: OnboardingStatus.done,
        committedProducts: (res['products_added'] as num?)?.toInt() ?? payload.length,
        committedQuantity: (res['total_quantity'] as num?)?.toInt() ?? 0,
      );
      return true;
    } catch (e) {
      state = state.copyWith(status: OnboardingStatus.ready, error: _msg(e));
      return false;
    }
  }

  void reset() => state = const OnboardingState();

  String _msg(Object e) => e is ApiException ? e.message : e.toString();
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(OnboardingNotifier.new);
