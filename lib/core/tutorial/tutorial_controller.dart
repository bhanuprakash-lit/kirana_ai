import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_client.dart';

/// Ids for tours, guided flows and getting-started checklist steps.
///
/// A FLOW is a multi-screen guided task ("make your first bill") made of
/// SEGMENTS — one spotlight tour per screen/sheet, chained by the owner's own
/// actions: tapping the highlighted button opens the next screen, whose build
/// asks the controller whether its segment should fire.
class Tut {
  Tut._();

  // Flows
  static const flowFirstSale = 'first_sale';
  static const flowAddProduct = 'add_product';

  // Segments (welcome is a flow of one)
  static const welcome = 'welcome';
  static const fsSearch = 'fs_search';
  static const fsCustomer = 'fs_customer';
  static const fsCharge = 'fs_charge';
  static const fsPayment = 'fs_payment';
  static const apFab = 'ap_fab';
  static const apSearch = 'ap_search';
  static const apForm = 'ap_form';
  static const ckReportTour = 'ck_report';

  // First-visit orientation tours (layer 3) — fire once when a screen is
  // first opened, replayable from that screen's ? button or the Learn screen.
  static const khataIntro = 'khata_intro';
  static const racksIntro = 'racks_intro';
  static const visionIntro = 'vision_intro';

  static const firstSaleSegments = [fsSearch, fsCustomer, fsCharge, fsPayment];
  static const addProductSegments = [apFab, apSearch, apForm];

  // Getting-started checklist steps
  static const ckProduct = 'product';
  static const ckSale = 'sale';
  static const ckUdhaar = 'udhaar';
  static const ckReport = 'report';
  static const ckLanguage = 'language';
  static const checklistSteps = [
    ckProduct,
    ckSale,
    ckUdhaar,
    ckReport,
    ckLanguage,
  ];
}

class TutorialState {
  final bool loaded;
  final bool enabled; // "Show tips" master switch (Learn screen)
  final Set<String> seen; // segment ids already shown
  final Set<String> checklist; // completed getting-started steps
  final bool checklistDismissed;
  final String? activeFlow; // guided flow in progress, or null
  final bool overlayActive; // a coach-mark overlay is on screen right now

  const TutorialState({
    this.loaded = false,
    this.enabled = true,
    this.seen = const {},
    this.checklist = const {},
    this.checklistDismissed = false,
    this.activeFlow,
    this.overlayActive = false,
  });

  bool get checklistComplete =>
      Tut.checklistSteps.every(checklist.contains);

  TutorialState copyWith({
    bool? loaded,
    bool? enabled,
    Set<String>? seen,
    Set<String>? checklist,
    bool? checklistDismissed,
    String? activeFlow,
    bool clearActiveFlow = false,
    bool? overlayActive,
  }) => TutorialState(
    loaded: loaded ?? this.loaded,
    enabled: enabled ?? this.enabled,
    seen: seen ?? this.seen,
    checklist: checklist ?? this.checklist,
    checklistDismissed: checklistDismissed ?? this.checklistDismissed,
    activeFlow: clearActiveFlow ? null : (activeFlow ?? this.activeFlow),
    overlayActive: overlayActive ?? this.overlayActive,
  );
}

/// Owns everything about guided tours except the overlay rendering: what's
/// been seen (persisted), which guided flow is running, the getting-started
/// checklist, the master on/off switch, and lightweight usage telemetry.
class TutorialController extends Notifier<TutorialState> {
  static const _enabledKey = 'tut_enabled_v1';
  static const _seenKey = 'tut_seen_v1';
  static const _checklistKey = 'tut_checklist_v1';
  static const _dismissedKey = 'tut_checklist_dismissed_v1';

  @override
  TutorialState build() {
    Future.microtask(_load);
    return const TutorialState();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) return;
    state = state.copyWith(
      loaded: true,
      enabled: prefs.getBool(_enabledKey) ?? true,
      seen: (prefs.getStringList(_seenKey) ?? const []).toSet(),
      checklist: (prefs.getStringList(_checklistKey) ?? const []).toSet(),
      checklistDismissed: prefs.getBool(_dismissedKey) ?? false,
    );
  }

  Future<void> _persist() async {
    // Snapshot before the async gap — the provider may be disposed while the
    // write is in flight, and `state` must not be touched after that.
    final s = state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, s.enabled);
    await prefs.setStringList(_seenKey, s.seen.toList());
    await prefs.setStringList(_checklistKey, s.checklist.toList());
    await prefs.setBool(_dismissedKey, s.checklistDismissed);
  }

  // ── Segment gating ─────────────────────────────────────────────────────────

  /// May segment [id] fire? [flow] non-null means the segment belongs to a
  /// guided flow and only fires while that flow is running.
  ///
  /// Deliberately does NOT consider [TutorialState.overlayActive]: a segment
  /// requested while the previous spotlight is still playing its closing
  /// animation must QUEUE, not die — the overlay layer waits for clearance
  /// and re-checks this gate right before showing. (This was the "nothing
  /// happens until I reopen the sheet" bug: the sheet's one-shot trigger ran
  /// while the tapped step's overlay was dismissing and gave up forever.)
  bool shouldShow(String id, {String? flow}) {
    final s = state;
    if (!s.loaded || !s.enabled) return false;
    if (s.seen.contains(id)) return false;
    if (flow != null && s.activeFlow != flow) return false;
    return true;
  }

  bool flowActive(String flow) => state.activeFlow == flow;

  void setOverlayActive(bool active) =>
      state = state.copyWith(overlayActive: active);

  void markSeen(String id) {
    if (state.seen.contains(id)) return;
    state = state.copyWith(seen: {...state.seen, id});
    _persist();
  }

  // ── Guided flows ───────────────────────────────────────────────────────────

  /// Short flow code for telemetry (app_activity.event is VARCHAR(20)).
  static String _code(String flow) => switch (flow) {
    Tut.flowFirstSale => 'fs',
    Tut.flowAddProduct => 'ap',
    _ => flow,
  };

  /// Start (or restart) a guided flow: its segments are un-seen so they fire
  /// again as the owner reaches each screen.
  void startFlow(String flow) {
    final segments = switch (flow) {
      Tut.flowFirstSale => Tut.firstSaleSegments,
      Tut.flowAddProduct => Tut.addProductSegments,
      _ => const <String>[],
    };
    state = state.copyWith(
      activeFlow: flow,
      seen: {...state.seen}..removeAll(segments),
    );
    _persist();
    logEvent('tut:${_code(flow)}:start');
  }

  void endFlow({bool completed = false}) {
    final flow = state.activeFlow;
    if (flow == null) return;
    state = state.copyWith(clearActiveFlow: true);
    logEvent('tut:${_code(flow)}:${completed ? 'done' : 'skip'}');
  }

  /// The owner tapped Skip on an overlay: stop nagging for this whole flow.
  void skipFlow(String segmentId) {
    markSeen(segmentId);
    final flow = state.activeFlow;
    if (flow != null) {
      final segments = switch (flow) {
        Tut.flowFirstSale => Tut.firstSaleSegments,
        Tut.flowAddProduct => Tut.addProductSegments,
        _ => const <String>[],
      };
      state = state.copyWith(seen: {...state.seen, ...segments});
      _persist();
      endFlow();
    }
  }

  // ── Checklist ──────────────────────────────────────────────────────────────

  void markChecklist(String step) {
    if (state.checklist.contains(step)) return;
    state = state.copyWith(checklist: {...state.checklist, step});
    _persist();
    logEvent('tut:ck:$step');
  }

  void dismissChecklist() {
    state = state.copyWith(checklistDismissed: true);
    _persist();
    logEvent('tut:ck:hide');
  }

  // ── Hooks from real actions ────────────────────────────────────────────────

  /// An order was placed (any path, guided or not).
  void onSaleCompleted(String? paymentMethod) {
    markChecklist(Tut.ckSale);
    if (paymentMethod == 'udhaar') markChecklist(Tut.ckUdhaar);
    if (state.activeFlow == Tut.flowFirstSale) endFlow(completed: true);
  }

  /// A product was saved to inventory (any path).
  void onProductAdded() {
    markChecklist(Tut.ckProduct);
    if (state.activeFlow == Tut.flowAddProduct) endFlow(completed: true);
  }

  // ── Settings / replay ──────────────────────────────────────────────────────

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _persist();
    logEvent(enabled ? 'tut:on' : 'tut:off');
  }

  /// Re-arm one segment (Learn screen replay, e.g. the welcome tour).
  void replaySegment(String id) {
    state = state.copyWith(seen: {...state.seen}..remove(id));
    _persist();
  }

  // ── Telemetry ──────────────────────────────────────────────────────────────

  /// Fire-and-forget usage event. NOTE: app_activity.event is VARCHAR(20) —
  /// keep names short ('tut:first_sale:done' is 19).
  void logEvent(String name) {
    assert(name.length <= 20, 'app_activity.event is VARCHAR(20): $name');
    // Grab the client before going async — the provider may dispose meanwhile.
    final client = ref.read(apiClientProvider);
    Future(() async {
      try {
        await client.post('/kirana/tracking/app-event', {'event': name});
      } catch (_) {
        // Telemetry must never surface to the owner.
      }
    });
  }
}

final tutorialProvider = NotifierProvider<TutorialController, TutorialState>(
  TutorialController.new,
);
