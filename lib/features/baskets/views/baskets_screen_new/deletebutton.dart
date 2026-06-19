part of '../baskets_screen_new.dart';

class _DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  const _DeleteButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onDelete,
      icon: const Icon(
        Icons.delete_outline_rounded,
        color: BrandColors.error,
        size: 20,
      ),
      style: IconButton.styleFrom(
        backgroundColor: BrandColors.error.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

