import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/core/tutorial/tutorial_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(ProviderContainer, TutorialController)> boot({
    Map<String, Object> prefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final c = container.read(tutorialProvider.notifier);
    // _load runs in a microtask on build.
    container.read(tutorialProvider);
    await Future<void>.delayed(Duration.zero);
    return (container, c);
  }

  group('TutorialController', () {
    test('loads persisted state', () async {
      final (container, _) = await boot(
        prefs: {
          'tut_enabled_v1': false,
          'tut_seen_v1': ['welcome'],
          'tut_checklist_v1': ['sale'],
          'tut_checklist_dismissed_v1': true,
        },
      );
      final s = container.read(tutorialProvider);
      expect(s.loaded, isTrue);
      expect(s.enabled, isFalse);
      expect(s.seen, contains('welcome'));
      expect(s.checklist, contains('sale'));
      expect(s.checklistDismissed, isTrue);
    });

    test('shouldShow gates on loaded/enabled/seen/flow/overlay', () async {
      final (_, c) = await boot();
      expect(c.shouldShow(Tut.welcome), isTrue);

      c.markSeen(Tut.welcome);
      expect(c.shouldShow(Tut.welcome), isFalse);

      // Flow-bound segments need their flow running.
      expect(c.shouldShow(Tut.fsSearch, flow: Tut.flowFirstSale), isFalse);
      c.startFlow(Tut.flowFirstSale);
      expect(c.shouldShow(Tut.fsSearch, flow: Tut.flowFirstSale), isTrue);

      // An active overlay does NOT gate shouldShow — segments queue behind
      // it in the overlay layer instead of dying (sheet-race fix).
      c.setOverlayActive(true);
      expect(c.shouldShow(Tut.fsSearch, flow: Tut.flowFirstSale), isTrue);
      c.setOverlayActive(false);

      // Master switch wins over everything.
      c.setEnabled(false);
      expect(c.shouldShow(Tut.fsSearch, flow: Tut.flowFirstSale), isFalse);
    });

    test('startFlow re-arms previously seen segments', () async {
      final (_, c) = await boot(
        prefs: {
          'tut_seen_v1': ['fs_search', 'fs_payment'],
        },
      );
      c.startFlow(Tut.flowFirstSale);
      expect(c.shouldShow(Tut.fsSearch, flow: Tut.flowFirstSale), isTrue);
      expect(c.shouldShow(Tut.fsPayment, flow: Tut.flowFirstSale), isTrue);
    });

    test('skipFlow silences the whole flow and ends it', () async {
      final (container, c) = await boot();
      c.startFlow(Tut.flowFirstSale);
      c.skipFlow(Tut.fsSearch);
      final s = container.read(tutorialProvider);
      expect(s.activeFlow, isNull);
      expect(s.seen, containsAll(Tut.firstSaleSegments));
    });

    test('onSaleCompleted marks sale (+udhaar) and completes the flow', () async {
      final (container, c) = await boot();
      c.startFlow(Tut.flowFirstSale);
      c.onSaleCompleted('udhaar');
      final s = container.read(tutorialProvider);
      expect(s.checklist, containsAll([Tut.ckSale, Tut.ckUdhaar]));
      expect(s.activeFlow, isNull);
    });

    test('cash sale does not mark the udhaar step', () async {
      final (container, c) = await boot();
      c.onSaleCompleted('cash');
      final s = container.read(tutorialProvider);
      expect(s.checklist, contains(Tut.ckSale));
      expect(s.checklist, isNot(contains(Tut.ckUdhaar)));
    });

    test('onProductAdded marks product and completes add-product flow', () async {
      final (container, c) = await boot();
      c.startFlow(Tut.flowAddProduct);
      c.onProductAdded();
      final s = container.read(tutorialProvider);
      expect(s.checklist, contains(Tut.ckProduct));
      expect(s.activeFlow, isNull);
    });

    test('checklistComplete only when all five steps are done', () async {
      final (container, c) = await boot();
      for (final step in Tut.checklistSteps) {
        expect(container.read(tutorialProvider).checklistComplete, isFalse);
        c.markChecklist(step);
      }
      expect(container.read(tutorialProvider).checklistComplete, isTrue);
    });

    test('replaySegment re-arms a seen segment', () async {
      final (_, c) = await boot(
        prefs: {
          'tut_seen_v1': ['welcome'],
        },
      );
      expect(c.shouldShow(Tut.welcome), isFalse);
      c.replaySegment(Tut.welcome);
      expect(c.shouldShow(Tut.welcome), isTrue);
    });
  });
}
