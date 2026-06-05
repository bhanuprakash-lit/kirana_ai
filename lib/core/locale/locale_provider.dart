import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locales the app ships with.
///
/// English, Telugu, Hindi, Marathi, Tamil, Kannada and Malayalam are translated
/// today. Bengali (`bn`) and Odia (`or`) will be appended here as their ARB
/// files land — for those the theme still needs the matching Noto font case
/// added (see `brand_theme.dart`); ta/kn/ml are already mapped. Adding a locale
/// is just: drop an `app_xx.arb` file and add the `Locale` below.
const List<Locale> kSupportedLocales = [
  Locale('en'),
  Locale('te'),
  Locale('hi'),
  Locale('mr'),
  Locale('ta'),
  Locale('kn'),
  Locale('ml'),
];

const String _kLocaleKey = 'app_locale';

/// Holds the user's chosen UI locale, persisted in [SharedPreferences].
///
/// Defaults to English on first launch; the persisted choice is loaded
/// asynchronously and pushed into state once available.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _load();
    return const Locale('en');
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLocaleKey);
    if (code != null && code.isNotEmpty) {
      final match = kSupportedLocales
          .where((l) => l.languageCode == code)
          .firstOrNull;
      if (match != null) state = match;
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
