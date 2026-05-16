/// Two subscription tiers: basic (₹200/mo) and pro (₹500/mo).
/// New users request a free trial of basic features; trial activates after admin approval.
enum SubTier { none, pending, trial, basic, pro }

extension SubTierX on SubTier {
  String get displayName {
    switch (this) {
      case SubTier.none: return 'No Subscription';
      case SubTier.pending: return 'Awaiting Activation';
      case SubTier.trial: return 'Basic (Free Trial)';
      case SubTier.basic: return 'Basic';
      case SubTier.pro: return 'Pro';
    }
  }

  String get priceLabel {
    switch (this) {
      case SubTier.none: return '';
      case SubTier.pending: return 'Free';
      case SubTier.trial: return 'Free';
      case SubTier.basic: return '₹200/mo · just ₹7/day';
      case SubTier.pro: return '₹500/mo · just ₹17/day';
    }
  }

  bool get isPaid => this == SubTier.basic || this == SubTier.pro;
}

class SubscriptionInfo {
  final SubTier tier;
  final bool isTrial;
  final DateTime? trialEndsAt;
  final DateTime? startedAt;
  final int daysRemaining;
  final int secondsRemaining;

  const SubscriptionInfo({
    required this.tier,
    this.isTrial = false,
    this.trialEndsAt,
    this.startedAt,
    this.daysRemaining = 0,
    this.secondsRemaining = 0,
    this.serverExpired = false,
  });

  static const none = SubscriptionInfo(tier: SubTier.none);

  // ── Feature gates ──────────────────────────────────────────────────────────

  /// Vendor management (procurement) — Pro only
  bool get canAccessVendorManagement => tier == SubTier.pro;

  /// Cashflow support — Pro only
  bool get canAccessCashflow => tier == SubTier.pro;

  /// Referral marketing — Pro only
  bool get canAccessReferral => tier == SubTier.pro;

  /// App access (trial, basic, pro — not none/pending/expired)
  bool get hasAppAccess => (tier == SubTier.trial || tier == SubTier.basic || tier == SubTier.pro) && !isExpired;

  bool get isActive => hasAppAccess && !isExpired;
  // Server is authoritative; fall back to local clock if server didn't send the flag.
  bool get isExpired => serverExpired || (isTrial && trialEndsAt != null && trialEndsAt!.isBefore(DateTime.now()));
  bool get isPending => tier == SubTier.pending;

  // Server explicitly told us this trial is expired.
  final bool serverExpired;

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    final tierStr = json['tier'] as String? ?? 'none';
    final SubTier tier;
    if (tierStr == 'pending_trial') {
      tier = SubTier.pending;
    } else {
      tier = SubTier.values.firstWhere(
        (t) => t.name == tierStr,
        orElse: () => SubTier.none,
      );
    }
    return SubscriptionInfo(
      tier: tier,
      isTrial: json['is_trial'] as bool? ?? false,
      trialEndsAt: json['trial_ends_at'] != null
          ? DateTime.tryParse(json['trial_ends_at'] as String)
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      daysRemaining: json['days_remaining'] as int? ?? 0,
      secondsRemaining: json['seconds_remaining'] as int? ?? 0,
      serverExpired: json['is_expired'] as bool? ?? false,
    );
  }
}
