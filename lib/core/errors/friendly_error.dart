import '../../l10n/generated/app_localizations.dart';

/// Turns operator-facing upstream errors into something a shopkeeper can act on.
///
/// A store owner tapping "Remind" should never read
/// `WhatsApp API 401: Authentication Error` — that is our expired Meta access
/// token, not anything they can fix, and it reads as if their data is broken.
/// Returns `null` when the error isn't one we recognise, so callers keep their
/// own (more specific) message instead of losing detail.
String? friendlyErrorOrNull(AppLocalizations l10n, Object error) {
  final raw = error.toString().toLowerCase();
  if (raw.contains('whatsapp') &&
      (raw.contains('401') ||
          raw.contains('403') ||
          raw.contains('authentication error') ||
          raw.contains('access token'))) {
    return l10n.errWhatsAppUnavailable;
  }
  return null;
}
