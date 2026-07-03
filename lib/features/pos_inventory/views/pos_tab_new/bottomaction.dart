part of '../pos_tab_new.dart';

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final bool locked;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: filled
              ? null
              : Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
            ),
            if (locked) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.lock_rounded,
                size: 12,
                color: filled ? Colors.white70 : color.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
