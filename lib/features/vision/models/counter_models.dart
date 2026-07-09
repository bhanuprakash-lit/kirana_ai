// Models for the sale-area COUNTER (on-device). Mirror the backend contract in
// kirana-master-backend/vision/schemas.py (Counter* models) and
// counter_repository.py.

/// One product line the app sends up after a counting session.
class CounterItemPayload {
  final String className;
  final int qty;
  final double? avgConfidence;

  const CounterItemPayload({
    required this.className,
    required this.qty,
    this.avgConfidence,
  });

  Map<String, dynamic> toJson() => {
    'class_name': className,
    'qty': qty,
    if (avgConfidence != null) 'avg_confidence': avgConfidence,
  };

  factory CounterItemPayload.fromJson(Map<String, dynamic> j) =>
      CounterItemPayload(
        className: j['class_name'] as String? ?? '',
        qty: (j['qty'] as num?)?.toInt() ?? 0,
        avgConfidence: (j['avg_confidence'] as num?)?.toDouble(),
      );
}

/// A finalized on-device counting session, pending or done syncing. Persisted
/// locally (shared_preferences) so it survives a failed sync and retries later —
/// the counter must work fully on-device even when the backend isn't reachable.
class CounterSession {
  final String clientUid; // on-device UUID → idempotent server upsert
  final String sessionDate; // YYYY-MM-DD
  final String? deviceLabel;
  final String? startedAt; // ISO8601
  final String? endedAt;
  final List<CounterItemPayload> items;
  final bool synced;

  const CounterSession({
    required this.clientUid,
    required this.sessionDate,
    required this.items,
    this.deviceLabel,
    this.startedAt,
    this.endedAt,
    this.synced = false,
  });

  int get totalUnits => items.fold(0, (a, e) => a + e.qty);
  int get totalSkus => items.length;

  Map<String, dynamic> toSyncJson() => {
    'client_uid': clientUid,
    'session_date': sessionDate,
    if (deviceLabel != null) 'device_label': deviceLabel,
    if (startedAt != null) 'started_at': startedAt,
    if (endedAt != null) 'ended_at': endedAt,
    'items': items.map((e) => e.toJson()).toList(),
  };

  Map<String, dynamic> toStorageJson() => {...toSyncJson(), 'synced': synced};

  factory CounterSession.fromStorageJson(Map<String, dynamic> j) =>
      CounterSession(
        clientUid: j['client_uid'] as String,
        sessionDate: j['session_date'] as String? ?? '',
        deviceLabel: j['device_label'] as String?,
        startedAt: j['started_at'] as String?,
        endedAt: j['ended_at'] as String?,
        items: (j['items'] as List<dynamic>? ?? [])
            .map((e) => CounterItemPayload.fromJson(e as Map<String, dynamic>))
            .toList(),
        synced: j['synced'] as bool? ?? false,
      );

  CounterSession copyWith({bool? synced}) => CounterSession(
    clientUid: clientUid,
    sessionDate: sessionDate,
    deviceLabel: deviceLabel,
    startedAt: startedAt,
    endedAt: endedAt,
    items: items,
    synced: synced ?? this.synced,
  );
}

/// One row of the server-aggregated daily counter summary.
class CounterSummaryItem {
  final int? productId;
  final String className;
  final String displayName;
  final int qty;
  final bool isUnknown;

  const CounterSummaryItem({
    required this.productId,
    required this.className,
    required this.displayName,
    required this.qty,
    required this.isUnknown,
  });

  factory CounterSummaryItem.fromJson(Map<String, dynamic> j) =>
      CounterSummaryItem(
        productId: (j['product_id'] as num?)?.toInt(),
        className: j['class_name'] as String? ?? '',
        displayName: j['display_name'] as String? ?? '',
        qty: (j['qty'] as num?)?.toInt() ?? 0,
        isUnknown: j['is_unknown'] as bool? ?? true,
      );
}
