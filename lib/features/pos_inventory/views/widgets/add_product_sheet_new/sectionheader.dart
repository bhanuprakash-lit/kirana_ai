part of '../add_product_sheet_new.dart';

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Text(
    title.toUpperCase(),
    style: const TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 11,
      color: BrandColors.muted,
      letterSpacing: 1.2,
    ),
  );
}
