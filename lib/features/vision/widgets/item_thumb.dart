import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/api_client.dart';

/// A detected vision item's cropped thumbnail — the item's bounding box cropped
/// out of its source shelf photo, loaded from the authenticated backend crop
/// endpoint (`/kirana/vision/item/{id}/crop`).
///
/// Shared by the shelf review list and the onboarding review list so the owner
/// can visually recognise what each detected row is. Falls back to a status icon
/// while the token/image loads or when no image is available (e.g. the source
/// photo isn't stored) — so a row is never blank.
class VisionItemThumb extends StatelessWidget {
  final int itemId;
  final double size;
  final IconData fallbackIcon;
  final Color fallbackColor;

  const VisionItemThumb({
    super.key,
    required this.itemId,
    required this.size,
    required this.fallbackIcon,
    required this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      color: fallbackColor.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Icon(fallbackIcon, color: fallbackColor, size: size * 0.5),
    );
    final url = '${AppConfig.apiBaseUrl}/kirana/vision/item/$itemId/crop';
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: FutureBuilder<String?>(
          future: ApiClient.mediaAuthToken(),
          builder: (_, snap) {
            final token = snap.data;
            if (token == null) return fallback;
            return Image.network(
              url,
              headers: {'Authorization': 'Bearer $token'},
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => fallback,
              loadingBuilder: (ctx, child, progress) =>
                  progress == null ? child : fallback,
            );
          },
        ),
      ),
    );
  }
}
