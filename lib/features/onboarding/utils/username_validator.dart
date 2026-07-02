/// Single source of truth for username rules, shared by the live field indicator
/// and the submit-time validation so they can never disagree.
///
/// Rules: 3–30 characters, letters (a–z, A–Z), digits (0–9) and underscore only.
library;

enum UsernameStatus { empty, tooShort, tooLong, invalidChars, valid }

class UsernameRules {
  static const int minLength = 3;
  static const int maxLength = 30;

  /// Allowed set: ASCII letters, digits, underscore. No spaces/symbols/unicode.
  static final RegExp _allowed = RegExp(r'^[a-zA-Z0-9_]+$');

  /// Classify a raw (untrimmed) username. Trims surrounding whitespace first.
  static UsernameStatus evaluate(String raw) {
    final u = raw.trim();
    if (u.isEmpty) return UsernameStatus.empty;
    if (u.length < minLength) return UsernameStatus.tooShort;
    if (u.length > maxLength) return UsernameStatus.tooLong;
    if (!_allowed.hasMatch(u)) return UsernameStatus.invalidChars;
    return UsernameStatus.valid;
  }

  static bool isValid(String raw) => evaluate(raw) == UsernameStatus.valid;
}
