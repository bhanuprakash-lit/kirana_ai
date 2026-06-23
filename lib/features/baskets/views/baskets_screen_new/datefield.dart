part of '../baskets_screen_new.dart';

class _DateField extends StatelessWidget {
  final IconData icon;
  final String caption;
  final String? value;
  final String placeholder;
  final VoidCallback? onTap;
  const _DateField({
    required this.icon,
    required this.caption,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSet = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: const TextStyle(
            fontSize: 11,
            color: BrandColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BrandColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: BrandColors.muted),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    value ?? placeholder,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSet ? BrandColors.ink : BrandColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

