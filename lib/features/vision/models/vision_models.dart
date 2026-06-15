// Models for the Vision shelf-inventory feature.
// Mirror the backend contract in kirana-master-backend/vision/schemas.py.

class VisionSession {
  final int sessionId;
  final String sessionType; // 'morning' | 'evening'
  final String sessionDate; // YYYY-MM-DD
  final String status; // 'pending' | 'done' | 'failed'
  final int totalSkus;
  final int totalUnits;
  final int unknownCount;
  final String? createdAt;

  const VisionSession({
    required this.sessionId,
    required this.sessionType,
    required this.sessionDate,
    required this.status,
    required this.totalSkus,
    required this.totalUnits,
    required this.unknownCount,
    this.createdAt,
  });

  bool get isMorning => sessionType == 'morning';
  bool get isPending => status == 'pending';
  bool get isDone => status == 'done';
  bool get isFailed => status == 'failed';

  factory VisionSession.fromJson(Map<String, dynamic> j) => VisionSession(
    sessionId: (j['session_id'] as num).toInt(),
    sessionType: j['session_type'] as String? ?? 'morning',
    sessionDate: j['session_date']?.toString() ?? '',
    status: j['status'] as String? ?? 'pending',
    totalSkus: (j['total_skus'] as num?)?.toInt() ?? 0,
    totalUnits: (j['total_units'] as num?)?.toInt() ?? 0,
    unknownCount: (j['unknown_count'] as num?)?.toInt() ?? 0,
    createdAt: j['created_at']?.toString(),
  );
}

class VisionItem {
  final int itemId;
  final int? productId;
  final String? displayName;
  final String geminiName;
  final String? visibleText;
  final int count;
  final double matchScore;
  final bool isUnknown;
  final int? correctedProductId;

  const VisionItem({
    required this.itemId,
    required this.productId,
    required this.displayName,
    required this.geminiName,
    required this.visibleText,
    required this.count,
    required this.matchScore,
    required this.isUnknown,
    required this.correctedProductId,
  });

  /// Best human label: the corrected/matched catalog name if known, else what
  /// Gemini read off the package.
  String get label => (displayName != null && displayName!.isNotEmpty)
      ? displayName!
      : geminiName;

  bool get isCorrected => correctedProductId != null;
  bool get needsReview => isUnknown && !isCorrected;

  factory VisionItem.fromJson(Map<String, dynamic> j) => VisionItem(
    itemId: (j['item_id'] as num).toInt(),
    productId: (j['product_id'] as num?)?.toInt(),
    displayName: j['display_name'] as String?,
    geminiName: j['gemini_name'] as String? ?? '',
    visibleText: j['visible_text'] as String?,
    count: (j['count'] as num?)?.toInt() ?? 1,
    matchScore: (j['match_score'] as num?)?.toDouble() ?? 0.0,
    isUnknown: j['is_unknown'] as bool? ?? true,
    correctedProductId: (j['corrected_product_id'] as num?)?.toInt(),
  );
}

class SalesDeltaItem {
  final int productId;
  final String displayName;
  final int morningCount;
  final int eveningCount;
  final int sold;

  const SalesDeltaItem({
    required this.productId,
    required this.displayName,
    required this.morningCount,
    required this.eveningCount,
    required this.sold,
  });

  factory SalesDeltaItem.fromJson(Map<String, dynamic> j) => SalesDeltaItem(
    productId: (j['product_id'] as num).toInt(),
    displayName: j['display_name'] as String? ?? '',
    morningCount: (j['morning_count'] as num?)?.toInt() ?? 0,
    eveningCount: (j['evening_count'] as num?)?.toInt() ?? 0,
    sold: (j['sold'] as num?)?.toInt() ?? 0,
  );
}
