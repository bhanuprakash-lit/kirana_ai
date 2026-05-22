import 'package:flutter/material.dart';

import '../../core/theme/brand_theme.dart';

void showSuccessSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(milliseconds: 2000),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: BrandColors.success,
      duration: duration,
    ),
  );
}

void showErrorSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: BrandColors.error,
      duration: duration,
    ),
  );
}

void showInfoSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(milliseconds: 2000),
}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), duration: duration));
}
