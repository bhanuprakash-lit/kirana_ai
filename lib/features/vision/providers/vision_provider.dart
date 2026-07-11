import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../../auth/repositories/auth_repository.dart' show ApiException;
import '../models/vision_models.dart';

/// State for the Vision shelf-inventory feature (one store, today).
///
/// busyMorning/busyEvening are true only while the photos are UPLOADING — the
/// owner is held just for that. Analysis runs server-side; its progress shows on
/// the session card as a "processing" status (pending → done/failed), refreshed
/// by a detached poll + the completion push, so the owner can leave the screen.
class VisionState {
  final List<VisionSession> sessions;
  final bool busyMorning;
  final bool busyEvening;
  final Map<int, List<VisionItem>> items; // by sessionId
  final List<SalesDeltaItem>? sales; // null = not loaded; [] = loaded-but-empty
  final bool salesLoading;
  final List<VisionSession> history; // recent scans across days, newest first
  final bool historyLoading;
  final String? error;

  const VisionState({
    this.sessions = const [],
    this.busyMorning = false,
    this.busyEvening = false,
    this.items = const {},
    this.sales,
    this.salesLoading = false,
    this.history = const [],
    this.historyLoading = false,
    this.error,
  });

  /// Latest session of a type (sessions arrive ordered by created_at asc).
  VisionSession? _latest(String type) {
    VisionSession? found;
    for (final s in sessions) {
      if (s.sessionType == type) found = s;
    }
    return found;
  }

  VisionSession? get morning => _latest('morning');
  VisionSession? get evening => _latest('evening');

  /// Sales delta is meaningful only once both a morning and an evening scan
  /// have completed.
  bool get canViewSales =>
      (morning?.isDone ?? false) && (evening?.isDone ?? false);

  VisionState copyWith({
    List<VisionSession>? sessions,
    bool? busyMorning,
    bool? busyEvening,
    Map<int, List<VisionItem>>? items,
    List<SalesDeltaItem>? sales,
    bool? salesLoading,
    List<VisionSession>? history,
    bool? historyLoading,
    String? error,
    bool clearError = false,
  }) {
    return VisionState(
      sessions: sessions ?? this.sessions,
      busyMorning: busyMorning ?? this.busyMorning,
      busyEvening: busyEvening ?? this.busyEvening,
      items: items ?? this.items,
      sales: sales ?? this.sales,
      salesLoading: salesLoading ?? this.salesLoading,
      history: history ?? this.history,
      historyLoading: historyLoading ?? this.historyLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class VisionNotifier extends Notifier<VisionState> {
  ApiClient get _client => ref.read(apiClientProvider);

  static const _pollEvery = Duration(seconds: 3);
  // ~3min ceiling: a full 10-photo batch (Gemini + YOLO per image) can take well
  // over a minute. If we still time out, the session stays visible as "processing"
  // (the card polls/refreshes) rather than silently vanishing.
  static const _pollMax = 60;

  @override
  VisionState build() {
    ref.watch(storeScopeProvider); // reset + reload sessions on store switch
    Future.microtask(loadToday);
    return const VisionState();
  }

  // ── Sessions ────────────────────────────────────────────────────────────────

  Future<void> loadToday() async {
    try {
      final res = await _client.get('/kirana/vision/sessions') as List<dynamic>;
      final sessions = res
          .map((j) => VisionSession.fromJson(j as Map<String, dynamic>))
          .toList();
      state = state.copyWith(sessions: sessions, clearError: true);
    } catch (e) {
      state = state.copyWith(error: _msg(e));
    }
  }

  /// Upload a set of captured shelf photos (3–10). Blocks ONLY for the upload;
  /// the analysis continues server-side and this returns as soon as the backend
  /// accepts the batch (202), so the owner is free to leave the screen. A
  /// detached poll (plus the completion push notification) updates the session
  /// card from "processing" to done/failed. Returns true when accepted.
  Future<bool> capture(String type, List<String> filePaths) async {
    final isMorning = type == 'morning';
    state = state.copyWith(
      busyMorning: isMorning ? true : null,
      busyEvening: isMorning ? null : true,
      clearError: true,
    );
    try {
      final res =
          await _client.postMultipart(
                '/kirana/vision/shelf/analyze?session_type=$type',
                filePaths: filePaths,
              )
              as Map<String, dynamic>;
      final sessionId = (res['session_id'] as num).toInt();
      await loadToday();
      unawaited(_pollUntilDone(sessionId)); // keep refreshing in the background
      return true;
    } catch (e) {
      state = state.copyWith(error: _msg(e));
      return false;
    } finally {
      state = state.copyWith(
        busyMorning: isMorning ? false : null,
        busyEvening: isMorning ? null : false,
      );
    }
  }

  /// Polls the session list until the given session reaches done/failed.
  /// Analysis also fires an FCM push on completion (for backgrounded apps); this
  /// in-app poll keeps the foreground UX responsive without depending on it.
  Future<void> _pollUntilDone(int sessionId) async {
    for (var i = 0; i < _pollMax; i++) {
      await Future.delayed(_pollEvery);
      await loadToday();
      final s = state.sessions.where((x) => x.sessionId == sessionId);
      if (s.isNotEmpty && !s.first.isPending) {
        if (s.first.isDone) {
          await loadItems(sessionId);
          if (state.canViewSales) await loadSales();
        }
        return;
      }
    }
  }

  // ── Scan history ──────────────────────────────────────────────────────────────

  /// Past scans across the last [days] days (newest first) — what was uploaded,
  /// when, and with what result. Failures keep the old list; history is a view,
  /// never a blocker.
  Future<void> loadHistory({int days = 14}) async {
    state = state.copyWith(historyLoading: true);
    try {
      final res =
          await _client.get('/kirana/vision/sessions?days=$days')
              as List<dynamic>;
      final sessions = res
          .map((j) => VisionSession.fromJson(j as Map<String, dynamic>))
          .toList();
      state = state.copyWith(history: sessions, historyLoading: false);
    } catch (_) {
      state = state.copyWith(historyLoading: false);
    }
  }

  // ── Items & corrections ───────────────────────────────────────────────────────

  Future<void> loadItems(int sessionId) async {
    try {
      final res =
          await _client.get('/kirana/vision/session/$sessionId/items')
              as List<dynamic>;
      final items = res
          .map((j) => VisionItem.fromJson(j as Map<String, dynamic>))
          .toList();
      state = state.copyWith(items: {...state.items, sessionId: items});
    } catch (e) {
      state = state.copyWith(error: _msg(e));
    }
  }

  /// Owner correction → becomes training data. [productId] null clears it.
  Future<void> correctItem(int sessionId, int itemId, int? productId) async {
    try {
      await _client.post('/kirana/vision/correct/$itemId', {
        'corrected_product_id': productId,
      });
      await loadItems(sessionId);
      if (state.canViewSales) await loadSales();
    } catch (e) {
      state = state.copyWith(error: _msg(e));
    }
  }

  // ── Sales delta ────────────────────────────────────────────────────────────

  Future<void> loadSales() async {
    state = state.copyWith(salesLoading: true, clearError: true);
    try {
      final res =
          await _client.get('/kirana/vision/sales') as Map<String, dynamic>;
      final items = (res['items'] as List<dynamic>? ?? [])
          .map((j) => SalesDeltaItem.fromJson(j as Map<String, dynamic>))
          .toList();
      state = state.copyWith(sales: items, salesLoading: false);
    } on ApiException catch (e) {
      // 404 = no completed morning+evening pair yet → empty, not an error.
      state = state.copyWith(
        sales: e.statusCode == 404 ? const [] : state.sales,
        salesLoading: false,
        error: e.statusCode == 404 ? null : e.message,
      );
    } catch (e) {
      state = state.copyWith(salesLoading: false, error: _msg(e));
    }
  }

  String _msg(Object e) => e is ApiException ? e.message : e.toString();
}

final visionProvider = NotifierProvider<VisionNotifier, VisionState>(
  VisionNotifier.new,
);

/// Which Vision sub-tab is active (0=Shelf, 1=Results, 2=Counter). Lets a
/// notification deep-link ("open_vision", tab=results) jump straight to Results.
class VisionSubTabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void set(int i) => state = i;
}

final visionSubTabProvider = NotifierProvider<VisionSubTabNotifier, int>(
  VisionSubTabNotifier.new,
);
