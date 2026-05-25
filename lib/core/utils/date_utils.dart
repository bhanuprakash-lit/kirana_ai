import 'package:intl/intl.dart';

/// Parses an ISO datetime string and returns local time (IST on Indian devices).
/// Timezone-naive strings (no Z / +HH:MM) are treated as UTC, which is the
/// correct assumption since the backend runs in UTC.
DateTime parseAsUtc(String? s) {
  if (s == null || s.isEmpty) return DateTime.now();
  final t = s.trim();
  // Date-only (YYYY-MM-DD) → treat as UTC midnight.
  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(t)) {
    return DateTime.parse('${t}T00:00:00Z').toLocal();
  }
  final hasOffset = t.endsWith('Z') || RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(t);
  try {
    return DateTime.parse(hasOffset ? t : '${t}Z').toLocal();
  } on FormatException {
    return DateTime.parse(t).toLocal();
  }
}

/// Format a DateTime for date-only display in IST.
String formatDateIst(DateTime? dt, {String pattern = 'dd MMM yyyy'}) {
  if (dt == null) return '—';
  return DateFormat(pattern).format(dt.toLocal());
}

/// Format a DateTime with time for IST display.
String formatDateTimeIst(DateTime? dt) {
  if (dt == null) return '—';
  return DateFormat('dd MMM yyyy, hh:mm a').format(dt.toLocal());
}

/// Format a DateTime showing time only.
String formatTimeIst(DateTime? dt) {
  if (dt == null) return '—';
  return DateFormat('hh:mm a').format(dt.toLocal());
}
