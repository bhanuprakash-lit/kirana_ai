import 'package:flutter/material.dart';

import '../../../../core/theme/brand_theme.dart';

// ── Shared gate/usage widgets for Voice, Handwriting, Invoice sheets ──────────

class AiGateBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const AiGateBanner({
    super.key,
    this.icon = Icons.lock_rounded,
    this.color = BrandColors.orange,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: color,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
            child: Text(actionLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class AiUsageBadge extends StatelessWidget {
  final int remaining;
  final int total;
  final String label;

  const AiUsageBadge({super.key, required this.remaining, required this.total, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = remaining > 1 ? BrandColors.success : remaining == 1 ? Colors.orange : BrandColors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bolt_rounded, size: 14, color: color),
        const SizedBox(width: 4),
        Text('$remaining/$total $label',
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
