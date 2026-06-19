part of '../udhaar_tab_new.dart';

class _EmptyUdhaar extends StatelessWidget {
  const _EmptyUdhaar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              size: 64,
              color: BrandColors.muted.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 16),

            Text(
              l10n.finNoPendingUdhaars,
              style: const TextStyle(
                color: BrandColors.muted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

