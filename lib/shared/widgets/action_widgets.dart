import 'package:flutter/material.dart';
import '../../core/theme/brand_theme.dart';

class LoadingButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;

  const LoadingButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? BrandColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: (color ?? BrandColors.primary).withValues(
          alpha: 0.6,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}

class ActionStatusOverlay extends StatelessWidget {
  final bool isSaving;
  final String? error;
  final bool isSuccess;
  final String? successMessage;
  final VoidCallback? onRetry;

  const ActionStatusOverlay({
    super.key,
    this.isSaving = false,
    this.error,
    this.isSuccess = false,
    this.successMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isSaving) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: BrandColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Saving changes...',
              style: TextStyle(
                color: BrandColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: BrandColors.error,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error!,
                style: const TextStyle(
                  color: BrandColors.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: BrandColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    if (isSuccess) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: BrandColors.success,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(
              successMessage ?? 'Saved successfully!',
              style: const TextStyle(
                color: BrandColors.success,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
