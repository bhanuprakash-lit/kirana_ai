import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

/// First-run language picker, shown once before onboarding.
///
/// Each language is rendered in its own native name + script font, so users
/// recognise their language regardless of the (still-English) app locale. The
/// title, subtitle and the Continue button preview the *selected* language live
/// — the global locale is only committed when the user taps Continue, which
/// then routes into the welcome step of onboarding.
class LanguageSelectScreen extends ConsumerStatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  ConsumerState<LanguageSelectScreen> createState() =>
      _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends ConsumerState<LanguageSelectScreen> {
  late String _selected = ref.read(localeProvider).languageCode;

  // A warm accent per card so the grid feels alive. Cycles if more languages
  // are added than colours.
  static const _accents = [
    Color(0xFFF59E0B), // amber
    Color(0xFF34D399), // emerald
    Color(0xFF60A5FA), // blue
    Color(0xFFF472B6), // pink
    Color(0xFFA78BFA), // violet
    Color(0xFF22D3EE), // cyan
    Color(0xFFFB7185), // rose
    Color(0xFF4ADE80), // green
    Color(0xFFFBBF24), // gold
  ];

  /// Resolve the right bundled Noto script font for a language code so Indic
  /// glyphs render instead of tofu. Uses the shared mapping in `brand_theme.dart`.
  TextStyle _scriptStyle(String code, TextStyle base) =>
      base.copyWith(fontFamily: fontFamilyForLocale(Locale(code)));

  void _continue() {
    ref.read(localeProvider.notifier).setLocale(Locale(_selected));
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    // Strings are pulled for the *selected* language for a live preview, with no
    // BuildContext needed (the global locale hasn't changed yet).
    final l10n = lookupAppLocalizations(Locale(_selected));
    final media = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A5F), Color(0xFF243B6B), Color(0xFF312E81)],
          ),
        ),
        child: Stack(
          children: [
            // Oversized translucent globe motif in the corner.
            Positioned(
              top: -40,
              right: -40,
              child: Icon(
                Icons.language_rounded,
                size: 220,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.translate_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        )
                        .animate()
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(),
                    const SizedBox(height: 24),
                    Text(
                          l10n.languageChooseTitle,
                          style: _scriptStyle(
                            _selected,
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 120.ms)
                        .slideX(begin: -0.12, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      l10n.languageChooseSubtitle,
                      style: _scriptStyle(
                        _selected,
                        TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 28),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 1.15,
                            ),
                        itemCount: kSupportedLocales.length,
                        itemBuilder: (context, i) {
                          final locale = kSupportedLocales[i];
                          final code = locale.languageCode;
                          return _LanguageCard(
                                code: code,
                                nativeName: lookupAppLocalizations(
                                  locale,
                                ).languageName,
                                accent: _accents[i % _accents.length],
                                selected: code == _selected,
                                scriptStyle: _scriptStyle,
                                onTap: () => setState(() => _selected = code),
                              )
                              .animate()
                              .fadeIn(delay: (260 + i * 70).ms)
                              .slideY(
                                begin: 0.15,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: BrandColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _continue,
                        child: Text(
                          l10n.commonContinue,
                          style: _scriptStyle(
                            _selected,
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ).copyWith(color: BrandColors.primary),
                        ),
                      ),
                    ),
                    SizedBox(height: media.padding.bottom > 0 ? 0 : 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String code;
  final String nativeName;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle Function(String, TextStyle) scriptStyle;

  const _LanguageCard({
    required this.code,
    required this.nativeName,
    required this.accent,
    required this.selected,
    required this.onTap,
    required this.scriptStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Big watermark glyph = first grapheme of the native name, in its script.
    final glyph = nativeName.characters.isEmpty
        ? '?'
        : nativeName.characters.first;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? accent : Colors.white.withValues(alpha: 0.18),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Decorative oversized script glyph, tinted by the accent.
            Positioned(
              right: -6,
              bottom: -18,
              child: Text(
                glyph,
                style: scriptStyle(
                  code,
                  TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.w800,
                    color: (selected ? accent : Colors.white).withValues(
                      alpha: selected ? 0.12 : 0.10,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: selected
                          ? accent
                          : Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      selected ? Icons.check_rounded : Icons.circle_outlined,
                      size: 16,
                      color: selected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    nativeName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: scriptStyle(
                      code,
                      TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: selected ? BrandColors.ink : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
