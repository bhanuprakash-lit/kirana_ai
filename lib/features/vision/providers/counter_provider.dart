import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../../auth/repositories/auth_repository.dart' show ApiException;
import '../counter/counter_model.dart';
import '../models/counter_models.dart';

/// State for the sale-area counter's off-camera concerns: syncing finalized
/// sessions to the backend, today's aggregated tally, the scan history, and the
/// class→product/price map that lets the LIVE tally show money. The live
/// counting (camera + engine) lives in the counter screen; this provider owns
/// persistence + sync so a session is never lost when the backend is down.
class CounterState {
  final List<CounterSummaryItem> summary; // today's server-aggregated tally
  final bool summaryLoading;
  final double summaryValue; // ₹ value of today's tally (server-priced)
  final List<CounterHistorySession> history; // recent sessions, newest first
  final bool historyLoading;
  final Map<String, CounterClassPrice> prices; // model class → product + price
  final int pendingCount; // locally-queued sessions not yet synced
  final bool
  backendReachable; // false ⇒ counter endpoints not deployed / offline
  final String? error;

  const CounterState({
    this.summary = const [],
    this.summaryLoading = false,
    this.summaryValue = 0,
    this.history = const [],
    this.historyLoading = false,
    this.prices = const {},
    this.pendingCount = 0,
    this.backendReachable = true,
    this.error,
  });

  int get summaryTotal => summary.fold(0, (a, e) => a + e.qty);

  CounterState copyWith({
    List<CounterSummaryItem>? summary,
    bool? summaryLoading,
    double? summaryValue,
    List<CounterHistorySession>? history,
    bool? historyLoading,
    Map<String, CounterClassPrice>? prices,
    int? pendingCount,
    bool? backendReachable,
    String? error,
    bool clearError = false,
  }) => CounterState(
    summary: summary ?? this.summary,
    summaryLoading: summaryLoading ?? this.summaryLoading,
    summaryValue: summaryValue ?? this.summaryValue,
    history: history ?? this.history,
    historyLoading: historyLoading ?? this.historyLoading,
    prices: prices ?? this.prices,
    pendingCount: pendingCount ?? this.pendingCount,
    backendReachable: backendReachable ?? this.backendReachable,
    error: clearError ? null : (error ?? this.error),
  );
}

class CounterNotifier extends Notifier<CounterState> {
  ApiClient get _client => ref.read(apiClientProvider);

  static const _pendingKey = 'counter_pending_sessions_v1';
  static const _pricesKey = 'counter_class_prices_v1';

  @override
  CounterState build() {
    ref.watch(storeScopeProvider); // reload on store switch
    Future.microtask(() async {
      await _refreshPendingCount();
      await loadPrices();
      await loadSummary();
      await loadHistory();
      await retryPending();
    });
    return const CounterState();
  }

  // ── Summary ────────────────────────────────────────────────────────────────

  Future<void> loadSummary() async {
    state = state.copyWith(summaryLoading: true, clearError: true);
    try {
      final res =
          await _client.get('/kirana/vision/counter/summary')
              as Map<String, dynamic>;
      final items = (res['items'] as List<dynamic>? ?? [])
          .map((j) => CounterSummaryItem.fromJson(j as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
        summary: items,
        summaryValue: (res['total_value'] as num?)?.toDouble() ?? 0,
        summaryLoading: false,
        backendReachable: true,
      );
    } on ApiException catch (e) {
      // 404/501 ⇒ counter endpoints not deployed yet. Not a user-facing error;
      // the counter still works on-device and queues locally.
      final notDeployed = e.statusCode == 404 || e.statusCode == 501;
      state = state.copyWith(
        summaryLoading: false,
        backendReachable: !notDeployed,
        error: notDeployed ? null : e.message,
      );
    } catch (_) {
      state = state.copyWith(summaryLoading: false, backendReachable: false);
    }
  }

  // ── Scan history ────────────────────────────────────────────────────────────

  Future<void> loadHistory({int days = 14}) async {
    state = state.copyWith(historyLoading: true);
    try {
      final res =
          await _client.get('/kirana/vision/counter/sessions?days=$days')
              as Map<String, dynamic>;
      final sessions = (res['sessions'] as List<dynamic>? ?? [])
          .map(
            (j) => CounterHistorySession.fromJson(j as Map<String, dynamic>),
          )
          .toList();
      state = state.copyWith(history: sessions, historyLoading: false);
    } catch (_) {
      // History is a nice-to-have view; a failure never blocks counting.
      state = state.copyWith(historyLoading: false);
    }
  }

  // ── Class → product/price map (live tally pricing) ──────────────────────────

  /// Resolve the on-device model's class labels to catalog products + prices.
  /// Server round-trip once per launch; cached locally so the live tally is
  /// priced even offline (with yesterday's prices, which is fine for a glance).
  Future<void> loadPrices() async {
    // Serve the cache first so the camera never waits on the network.
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_pricesKey);
    if (cached != null && state.prices.isEmpty) {
      try {
        final list = (jsonDecode(cached) as List<dynamic>)
            .map((j) => CounterClassPrice.fromJson(j as Map<String, dynamic>))
            .toList();
        state = state.copyWith(
          prices: {for (final p in list) p.className: p},
        );
      } catch (_) {/* stale cache format — refreshed below */}
    }

    final labels = await ref.read(counterLabelsProvider.future);
    if (labels.isEmpty) return;
    try {
      final res =
          await _client.post('/kirana/vision/counter/resolve', {
                'class_names': labels,
              })
              as Map<String, dynamic>;
      final list = (res['items'] as List<dynamic>? ?? [])
          .map((j) => CounterClassPrice.fromJson(j as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
        prices: {for (final p in list) p.className: p},
        backendReachable: true,
      );
      await prefs.setString(
        _pricesKey,
        jsonEncode([for (final p in list) p.toJson()]),
      );
    } catch (_) {
      // Offline / not deployed: the cached (possibly empty) map stays in use.
    }
  }

  /// Price for one on-device class, if known.
  double? priceFor(String className) => state.prices[className]?.price;

  // ── Sync queue ───────────────────────────────────────────────────────────────

  /// Persist a finalized session locally, then attempt to sync it. Always
  /// succeeds locally; sync failure just leaves it queued for [retryPending].
  Future<void> finalizeAndSync(CounterSession session) async {
    await _enqueue(session);
    await _trySync(session);
    await loadSummary();
  }

  /// Retry every locally-queued (unsynced) session. Called on load and can be
  /// wired to a connectivity/app-resume trigger.
  Future<void> retryPending() async {
    final pending = (await _loadPending()).where((s) => !s.synced).toList();
    for (final s in pending) {
      await _trySync(s);
    }
    if (pending.isNotEmpty) await loadSummary();
  }

  Future<void> _trySync(CounterSession session) async {
    try {
      await _client.post('/kirana/vision/counter/sync', session.toSyncJson());
      await _markSynced(session.clientUid);
      state = state.copyWith(backendReachable: true);
    } on ApiException catch (e) {
      final notDeployed = e.statusCode == 404 || e.statusCode == 501;
      state = state.copyWith(backendReachable: !notDeployed);
      // Keep it queued; a later retry (or deploy) will pick it up.
    } catch (_) {
      state = state.copyWith(backendReachable: false);
    }
  }

  // ── Local persistence (shared_preferences) ────────────────────────────────────

  Future<List<CounterSession>> _loadPending() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_pendingKey) ?? const [];
    return raw
        .map(
          (s) => CounterSession.fromStorageJson(
            jsonDecode(s) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> _savePending(List<CounterSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _pendingKey,
      sessions.map((s) => jsonEncode(s.toStorageJson())).toList(),
    );
    await _refreshPendingCount(sessions);
  }

  Future<void> _enqueue(CounterSession session) async {
    final all = await _loadPending();
    all.removeWhere(
      (s) => s.clientUid == session.clientUid,
    ); // de-dupe on retry
    all.add(session);
    await _savePending(all);
  }

  Future<void> _markSynced(String clientUid) async {
    final all = await _loadPending();
    // Drop synced sessions older than today to keep the queue small; keep today's
    // marked synced so an accidental double-finalize stays idempotent.
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final next = <CounterSession>[];
    for (final s in all) {
      if (s.clientUid == clientUid) {
        if (s.sessionDate == today) next.add(s.copyWith(synced: true));
        continue;
      }
      if (!(s.synced && s.sessionDate != today)) next.add(s);
    }
    await _savePending(next);
  }

  Future<void> _refreshPendingCount([List<CounterSession>? known]) async {
    final all = known ?? await _loadPending();
    state = state.copyWith(pendingCount: all.where((s) => !s.synced).length);
  }
}

final counterProvider = NotifierProvider<CounterNotifier, CounterState>(
  CounterNotifier.new,
);
