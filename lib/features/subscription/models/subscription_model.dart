/// Two subscription tiers: basic (₹200/mo) and pro (₹500/mo).
/// New users choose basic or pro trial; admin approves → trial activates for that tier.
enum SubTier { none, pending, trial, basic, pro }

extension SubTierX on SubTier {
  String displayName({String trialTier = 'basic'}) {
    switch (this) {
      case SubTier.none:
        return 'No Subscription';
      case SubTier.pending:
        return 'Awaiting Activation';
      case SubTier.trial:
        return trialTier == 'pro' ? 'Pro (Free Trial)' : 'Basic (Free Trial)';
      case SubTier.basic:
        return 'Basic';
      case SubTier.pro:
        return 'Pro';
    }
  }

  // Keep a no-arg getter for places that don't need trial differentiation
  String get displayNameSimple => displayName();

  String get priceLabel {
    switch (this) {
      case SubTier.none:
        return '';
      case SubTier.pending:
        return 'Free';
      case SubTier.trial:
        return 'Free';
      case SubTier.basic:
        return '₹200/mo · just ₹7/day';
      case SubTier.pro:
        return '₹500/mo · just ₹17/day';
    }
  }

  bool get isPaid => this == SubTier.basic || this == SubTier.pro;
}

class SubscriptionInfo {
  final SubTier tier;
  final bool isTrial;
  final String trialTier; // 'basic' or 'pro' — which tier is being trialled
  final String requestedTier; // chosen by user during request, before approval
  final DateTime? trialEndsAt;
  final DateTime? startedAt;
  final int daysRemaining;
  final int secondsRemaining;

  /// When this info was fetched from the server (device clock). Used to anchor
  /// the server's `seconds_remaining` countdown so we never depend on parsing
  /// the naive `trial_ends_at` timestamp against the device timezone.
  final DateTime? fetchedAt;

  const SubscriptionInfo({
    required this.tier,
    this.isTrial = false,
    this.trialTier = 'basic',
    this.requestedTier = 'basic',
    this.trialEndsAt,
    this.startedAt,
    this.daysRemaining = 0,
    this.secondsRemaining = 0,
    this.serverExpired = false,
    this.fetchedAt,
  });

  static const none = SubscriptionInfo(tier: SubTier.none);

  bool get _isProTrial => tier == SubTier.trial && trialTier == 'pro';

  /// Resolved tier for feature-gate checks: pro trial counts as pro.
  SubTier get effectiveTier => _isProTrial ? SubTier.pro : tier;

  // ── Feature gates ──────────────────────────────────────────────────────────

  /// Vendor management (procurement) — Pro or Pro trial
  bool get canAccessVendorManagement => tier == SubTier.pro || _isProTrial;

  /// Cashflow support — Pro or Pro trial
  bool get canAccessCashflow => tier == SubTier.pro || _isProTrial;

  /// Referral marketing — Pro or Pro trial
  bool get canAccessReferral => tier == SubTier.pro || _isProTrial;

  /// App access (trial, basic, pro — not none/pending/expired)
  bool get hasAppAccess =>
      (tier == SubTier.trial || tier == SubTier.basic || tier == SubTier.pro) &&
      !isExpired;

  bool get isActive => hasAppAccess && !isExpired;

  /// Authoritative remaining trial time. Prefers the server's `seconds_remaining`
  /// (a pure duration, immune to device timezone/clock parsing of the naive
  /// `trial_ends_at` TIMESTAMP) anchored to when we fetched it. Falls back to the
  /// parsed `trial_ends_at` only if the server didn't send a countdown.
  Duration? get trialRemaining {
    if (!isTrial) return null;
    if (fetchedAt != null && secondsRemaining > 0) {
      final rem =
          Duration(seconds: secondsRemaining) -
          DateTime.now().difference(fetchedAt!);
      return rem.isNegative ? Duration.zero : rem;
    }
    if (trialEndsAt != null) {
      final rem = trialEndsAt!.difference(DateTime.now());
      return rem.isNegative ? Duration.zero : rem;
    }
    return null;
  }

  // Server is authoritative. Only treat a trial as expired when the server says
  // so, or when its own countdown has truly run out — never from a locally
  // (mis)parsed trial_ends_at while time still remains.
  bool get isExpired {
    if (serverExpired) return true;
    if (!isTrial) return false;
    if (secondsRemaining > 0) return false; // server still counting down
    final rem = trialRemaining;
    return rem != null && rem.inSeconds <= 0;
  }

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
      trialTier: (json['trial_tier'] as String?) ?? 'basic',
      requestedTier: (json['requested_tier'] as String?) ?? 'basic',
      trialEndsAt: json['trial_ends_at'] != null
          ? DateTime.tryParse(json['trial_ends_at'] as String)
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      daysRemaining: json['days_remaining'] as int? ?? 0,
      secondsRemaining: json['seconds_remaining'] as int? ?? 0,
      serverExpired: json['is_expired'] as bool? ?? false,
      fetchedAt: DateTime.now(),
    );
  }
}
