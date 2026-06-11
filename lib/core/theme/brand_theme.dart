import 'package:flutter/material.dart';

class BrandColors {
  static const Color primary = Color(0xFF243B6B);
  static const Color accent = Color(0xFFF59E0B);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);

  /// Purple — used for handwriting/AI features
  static const Color purple = Color(0xFF7C3AED);

  /// Orange — used for upgrade/pro banners
  static const Color orange = Color(0xFFE87722);

  static const Color background = Color(0xFFFFFDF8);
  static const Color surface = Colors.white;
  static const Color surfaceTint = Color(0xFFF6F4EE);

  static const Color ink = Color(0xFF1F2937);
  static const Color muted = Color(0xFF6B7280);

  static const Color border = Color(0xFFE5E7EB);
  static const Color error = Color(0xFFDC2626);
}

/// Picks the bundled font family that actually has glyphs for the active
/// script. GoogleSans (the brand face) covers Latin only, so for Indic locales
/// we swap in the matching Noto Sans family — otherwise translated text renders
/// as empty boxes (tofu). All families are bundled as assets (see pubspec), so
/// nothing is fetched over the network at runtime.
String fontFamilyForLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'te':
      return 'NotoSansTelugu';
    case 'hi':
    case 'mr':
      return 'NotoSansDevanagari';
    case 'ta':
      return 'NotoSansTamil';
    case 'kn':
      return 'NotoSansKannada';
    case 'ml':
      return 'NotoSansMalayalam';
    default:
      return 'GoogleSans';
  }
}

ThemeData buildBrandTheme(Locale locale) {
  final family = fontFamilyForLocale(locale);
  // Apply the bundled family to Material's default text theme, then layer the
  // brand weight/colour overrides on top (mirrors the old GoogleFonts setup).
  final baseTextTheme = ThemeData(
    useMaterial3: true,
  ).textTheme.apply(fontFamily: family);

  return ThemeData(
    useMaterial3: true,
    fontFamily: family,
    scaffoldBackgroundColor: BrandColors.background,

    colorScheme: const ColorScheme.light(
      primary: BrandColors.primary,
      secondary: BrandColors.accent,
      tertiary: BrandColors.success,
      surface: BrandColors.surface,
      error: BrandColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: BrandColors.ink,
      onError: Colors.white,
      outline: BrandColors.border,
    ),

    textTheme: baseTextTheme.copyWith(
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        color: BrandColors.ink,
        fontWeight: FontWeight.w800,
        height: 1.08,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        color: BrandColors.ink,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        color: BrandColors.ink,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        color: BrandColors.ink,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        color: BrandColors.ink,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: BrandColors.ink,
        height: 1.5,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: BrandColors.muted,
        height: 1.5,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: BrandColors.background,
      foregroundColor: BrandColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.black.withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: BrandColors.border),
      ),
    ),

    dividerColor: BrandColors.border,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: BrandColors.surfaceTint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: BrandColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: BrandColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: BrandColors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: BrandColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: BrandColors.error, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: baseTextTheme.bodyMedium?.copyWith(color: BrandColors.muted),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BrandColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: BrandColors.border,
        disabledForegroundColor: BrandColors.muted,
        minimumSize: const Size.fromHeight(56),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: baseTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: BrandColors.ink,
        minimumSize: const Size.fromHeight(56),
        side: const BorderSide(color: BrandColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: baseTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: BrandColors.surfaceTint,
      selectedColor: BrandColors.accent.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: const BorderSide(color: BrandColors.border),
      ),
      labelStyle: baseTextTheme.labelMedium?.copyWith(
        color: BrandColors.ink,
        fontWeight: FontWeight.w600,
      ),
      side: const BorderSide(color: BrandColors.border),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: BrandColors.accent.withValues(alpha: 0.16),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? BrandColors.primary
              : BrandColors.muted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => baseTextTheme.labelMedium?.copyWith(
          color: states.contains(WidgetState.selected)
              ? BrandColors.primary
              : BrandColors.muted,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: BrandColors.accent,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: BrandColors.ink,
      contentTextStyle: baseTextTheme.bodyMedium?.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
