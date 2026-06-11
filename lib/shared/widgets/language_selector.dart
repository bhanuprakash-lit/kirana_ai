import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/locale/locale_provider.dart';
import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';

/// Opens a bottom sheet listing every supported language by its native name
/// and switches the app locale on selection. Each language is labelled in its
/// own script (via [lookupAppLocalizations]) so users recognise their language
/// regardless of the current UI locale.
Future<void> showLanguagePicker(BuildContext context, WidgetRef ref) {
  final current = ref.read(localeProvider);
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: BrandColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.languageChooseTitle,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.languageChooseSubtitle,
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  itemCount: kSupportedLocales.length,
                  itemBuilder: (context, index) {
                    final locale = kSupportedLocales[index];
                    return _LanguageTile(
                      locale: locale,
                      selected: locale.languageCode == current.languageCode,
                      onTap: () {
                        ref.read(localeProvider.notifier).setLocale(locale);
                        Navigator.of(sheetContext).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _LanguageTile extends StatelessWidget {
  final Locale locale;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.locale,
    required this.selected,
    required this.onTap,
  });

  String _getLanguageCharacter(String code) {
    switch (code) {
      case 'en':
        return 'A';
      case 'hi':
        return 'अ';
      case 'kn':
        return 'ಅ';
      case 'ml':
        return 'അ';
      case 'mr':
        return 'अ';
      case 'ta':
        return 'அ';
      case 'te':
        return 'అ';
      default:
        return 'A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final nativeName = lookupAppLocalizations(locale).languageName;
    final char = _getLanguageCharacter(locale.languageCode);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected
            ? BrandColors.primary.withValues(alpha: 0.08)
            : BrandColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected
              ? BrandColors.primary
              : BrandColors.border.withValues(alpha: 0.5),
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: BrandColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -20,
                  child: Text(
                    char,
                    style: TextStyle(
                      fontSize: 84,
                      fontWeight: FontWeight.w900,
                      color: selected
                          ? BrandColors.primary.withValues(alpha: 0.12)
                          : BrandColors.ink.withValues(alpha: 0.04),
                      height: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? BrandColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: selected
                                  ? null
                                  : Border.all(color: BrandColors.border),
                            ),
                            child: Text(
                              locale.languageCode.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: selected
                                    ? Colors.white
                                    : BrandColors.muted,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (selected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: BrandColors.primary,
                              size: 20,
                            ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        nativeName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: selected
                                  ? BrandColors.primary
                                  : BrandColors.ink,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact pill that shows the current language and opens the picker on tap.
/// Designed to sit on the dark gradient of the welcome slide.
class LanguageChip extends ConsumerWidget {
  const LanguageChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final nativeName = lookupAppLocalizations(locale).languageName;
    return Material(
      color: Colors.white.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => showLanguagePicker(context, ref),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                nativeName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
