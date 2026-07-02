import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../../auth/repositories/auth_repository.dart' show ApiException;
import '../models/counter_models.dart';

/// State for the sale-area counter's off-camera concerns: syncing finalized
/// sessions to the backend and showing today's aggregated tally. The live
/// counting (camera + engine) lives in the counter screen; this provider owns
/// persistence + sync so a session is never lost when the backend is down.
class CounterState {
  final List<CounterSummaryItem> summary; // today's server-aggregated tally
  final bool summaryLoading;
  final int pendingCount; // locally-queued sessions not yet synced
  final bool backendReachable; // false ⇒ counter endpoints not deployed / offline
  final String? error;

  const CounterState({
    this.summary = const [],
    this.summaryLoading = false,
    this.pendingCount = 0,
    this.backendReachable = true,
    this.error,
  });

  int get summaryTotal => summary.fold(0, (a, e) => a + e.qty);

  CounterState copyWith({
    List<CounterSummaryItem>? summary,
    bool? summaryLoading,
    int? pendingCount,
    bool? backendReachable,
    String? error,
    bool clearError = false,
  }) => CounterState(
    summary: summary ?? this.summary,
    summaryLoading: summaryLoading ?? this.summaryLoading,
    pendingCount: pendingCount ?? this.pendingCount,
    backendReachable: backendReachable ?? this.backendReachable,
    error: clearError ? null : (error ?? this.error),
  );
}

class CounterNotifier extends Notifier<CounterState> {
  ApiClient get _client => ref.read(apiClientProvider);

  static const _pendingKey = 'counter_pending_sessions_v1';

  @override
  CounterState build() {
    ref.watch(storeScopeProvider); // reload on store switch
    Future.microtask(() async {
      await _refreshPendingCount();
      await loadSummary();
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
        .map((s) => CounterSession.fromStorageJson(
            jsonDecode(s) as Map<String, dynamic>))
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
    all.removeWhere((s) => s.clientUid == session.clientUid); // de-dupe on retry
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
    state = state.copyWith(
      pendingCount: all.where((s) => !s.synced).length,
    );
  }
}

final counterProvider = NotifierProvider<CounterNotifier, CounterState>(
  CounterNotifier.new,
);
