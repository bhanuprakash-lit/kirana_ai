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
              for (final locale in kSupportedLocales)
                _LanguageTile(
                  locale: locale,
                  selected: locale.languageCode == current.languageCode,
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale(locale);
                    Navigator.of(sheetContext).pop();
                  },
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

  @override
  Widget build(BuildContext context) {
    // Resolve the language's own native name from its ARB ("English", "తెలుగు"…).
    final nativeName = lookupAppLocalizations(locale).languageName;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? BrandColors.primary.withValues(alpha: 0.06)
              : BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? BrandColors.primary : BrandColors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                nativeName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: selected ? BrandColors.primary : BrandColors.ink,
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
