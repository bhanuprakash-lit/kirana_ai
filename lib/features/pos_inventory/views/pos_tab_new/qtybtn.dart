part of '../pos_tab_new.dart';

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: BrandColors.border),
        ),
        child: Icon(icon, size: 16, color: BrandColors.ink),
      ),
    );
  }
}

