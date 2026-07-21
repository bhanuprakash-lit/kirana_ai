import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'tutorial_controller.dart';

/// What's-new announcements: when a release ships something the owner should
/// notice, add an entry here — it shows ONCE as a simple card on the Home tab
/// (seen-state rides the tutorial controller, id-prefixed `wn_`).
///
/// Keep entries rare and short; this is for features that change how the owner
/// works, not a changelog. Remove entries older than a couple of releases.
class WhatsNewEntry {
  /// Stable id, e.g. 'racks_2026_07'. Changing it re-shows the card.
  final String id;
  final IconData icon;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) body;

  const WhatsNewEntry({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
  });
}

/// Currently nothing to announce — the seam exists so shipping the next
/// feature is: add an entry + two ARB keys, done.
const List<WhatsNewEntry> whatsNewEntries = [];

/// Show the oldest unseen announcement, if any. Called from the Home tab after
/// first frame; no-ops for owners who have seen everything (the common case)
/// and never stacks on top of an active tour.
void maybeShowWhatsNew(BuildContext context, WidgetRef ref) {
  final controller = ref.read(tutorialProvider.notifier);
  final state = ref.read(tutorialProvider);
  if (!state.loaded || !state.enabled || state.overlayActive) return;

  final entry = whatsNewEntries
      .where((e) => controller.shouldShow('wn_${e.id}'))
      .firstOrNull;
  if (entry == null) return;

  controller.markSeen('wn_${entry.id}');
  final l10n = AppLocalizations.of(context);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: Icon(entry.icon, color: BrandColors.primary, size: 36),
      title: Text(entry.title(l10n), textAlign: TextAlign.center),
      content: Text(
        entry.body(l10n),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, height: 1.4),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.tutDone),
          ),
        ),
      ],
    ),
  );
}
