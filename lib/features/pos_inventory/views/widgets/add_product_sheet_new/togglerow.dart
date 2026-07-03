part of '../add_product_sheet_new.dart';

class _ToggleRow extends StatelessWidget {
  final String label, sublabel;
  final bool value, enabled;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.sublabel,
    required this.value,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: BrandColors.surfaceTint,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: BrandColors.border),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeTrackColor: BrandColors.primary,
        ),
      ],
    ),
  );
}
