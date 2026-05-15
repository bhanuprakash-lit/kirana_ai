class PendingReferralScan {
  final String tokenHash;
  final String newCustomerPhone;
  final String newCustomerName;
  final double discountPct;
  final String referrerName;

  const PendingReferralScan({
    required this.tokenHash,
    required this.newCustomerPhone,
    required this.newCustomerName,
    required this.discountPct,
    required this.referrerName,
  });
}

class ReferralCampaign {
  final int campaignId;
  final int storeId;
  final String name;
  final double referralDiscountPct;
  final int milestoneEveryN;
  final double milestoneRewardPct;
  final bool isActive;
  final int tokenCount;
  final int totalReferrals;
  final int maxReferralsPerReferrer;

  const ReferralCampaign({
    required this.campaignId,
    required this.storeId,
    required this.name,
    required this.referralDiscountPct,
    required this.milestoneEveryN,
    required this.milestoneRewardPct,
    required this.isActive,
    this.tokenCount = 0,
    this.totalReferrals = 0,
    this.maxReferralsPerReferrer = 50,
  });

  factory ReferralCampaign.fromJson(Map<String, dynamic> j) => ReferralCampaign(
        campaignId: j['campaign_id'] as int,
        storeId: j['store_id'] as int,
        name: j['name'] as String,
        referralDiscountPct: (j['referral_discount_pct'] as num).toDouble(),
        milestoneEveryN: j['milestone_every_n'] as int,
        milestoneRewardPct: (j['milestone_reward_pct'] as num).toDouble(),
        isActive: j['is_active'] as bool,
        tokenCount: (j['token_count'] as num?)?.toInt() ?? 0,
        totalReferrals: (j['total_referrals'] as num?)?.toInt() ?? 0,
        maxReferralsPerReferrer:
            (j['max_referrals_per_referrer'] as num?)?.toInt() ?? 50,
      );
}

class ReferralToken {
  final int tokenId;
  final String tokenHash;
  const ReferralToken({required this.tokenId, required this.tokenHash});

  factory ReferralToken.fromJson(Map<String, dynamic> j) => ReferralToken(
        tokenId: j['token_id'] as int,
        tokenHash: j['token_hash'] as String,
      );
}

class TokenInfo {
  final String referrerName;
  final String campaignName;
  final double referralDiscountPct;
  final bool isActive;

  const TokenInfo({
    required this.referrerName,
    required this.campaignName,
    required this.referralDiscountPct,
    required this.isActive,
  });

  factory TokenInfo.fromJson(Map<String, dynamic> j) => TokenInfo(
        referrerName: j['referrer_name'] as String,
        campaignName: j['campaign_name'] as String,
        referralDiscountPct: (j['referral_discount_pct'] as num).toDouble(),
        isActive: j['is_active'] as bool,
      );
}

class ReferralScanResult {
  final String status; // new_customer | existing_customer
  final String referrerName;
  final String campaignName;
  final int newCustomerId;
  final String newCustomerName;
  final double discountPct;
  final bool voucherEarned;
  final double? milestoneRewardPct;
  final String message;

  const ReferralScanResult({
    required this.status,
    required this.referrerName,
    required this.campaignName,
    required this.newCustomerId,
    this.newCustomerName = '',
    required this.discountPct,
    required this.voucherEarned,
    this.milestoneRewardPct,
    required this.message,
  });

  bool get isNewCustomer => status == 'new_customer';

  factory ReferralScanResult.fromJson(Map<String, dynamic> j) =>
      ReferralScanResult(
        status: j['status'] as String,
        referrerName: j['referrer_name'] as String,
        campaignName: j['campaign_name'] as String,
        newCustomerId: j['new_customer_id'] as int,
        newCustomerName: j['new_customer_name'] as String? ?? '',
        discountPct: (j['discount_pct'] as num).toDouble(),
        voucherEarned: j['voucher_earned'] as bool,
        milestoneRewardPct: (j['milestone_reward_pct'] as num?)?.toDouble(),
        message: j['message'] as String,
      );
}

class ReferralVoucher {
  final int voucherId;
  final double discountPct;
  final String campaignName;
  final String earnedAt;

  const ReferralVoucher({
    required this.voucherId,
    required this.discountPct,
    required this.campaignName,
    required this.earnedAt,
  });

  factory ReferralVoucher.fromJson(Map<String, dynamic> j) => ReferralVoucher(
        voucherId: j['voucher_id'] as int,
        discountPct: (j['discount_pct'] as num).toDouble(),
        campaignName: j['campaign_name'] as String,
        earnedAt: j['earned_at'] as String,
      );
}
