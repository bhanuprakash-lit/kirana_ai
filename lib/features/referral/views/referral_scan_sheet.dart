import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../models/referral_models.dart';
import '../providers/referral_provider.dart';

/// Shows referrer info and collects the new customer's phone.
/// Returns [PendingReferralScan] — the actual API call happens at order placement.
Future<PendingReferralScan?> showReferralScanSheet(
  BuildContext context,
  WidgetRef ref,
  String tokenHash,
) async {
  return showModalBottomSheet<PendingReferralScan>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _ReferralScanSheet(tokenHash: tokenHash),
  );
}

class _ReferralScanSheet extends ConsumerStatefulWidget {
  final String tokenHash;
  const _ReferralScanSheet({required this.tokenHash});

  @override
  ConsumerState<_ReferralScanSheet> createState() => _ReferralScanSheetState();
}

class _ReferralScanSheetState extends ConsumerState<_ReferralScanSheet> {
  TokenInfo? _tokenInfo;
  bool _loadingInfo = true;
  String? _infoError;

  final _phoneCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTokenInfo();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadTokenInfo() async {
    try {
      final info = await fetchTokenInfo(widget.tokenHash);
      if (mounted) {
        setState(() {
          _tokenInfo = info;
          _loadingInfo = false;
          if (info == null) _infoError = 'Invalid QR code';
          if (info != null && !info.isActive) {
            _infoError = 'This referral campaign is no longer active';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingInfo = false;
          _infoError = 'Could not load referral info';
        });
      }
    }
  }

  void _apply() {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      setState(() => _error = 'Enter a valid 10-digit phone number');
      return;
    }
    final e164 = phone.startsWith('+') ? phone : '+91$phone';
    Navigator.pop(
      context,
      PendingReferralScan(
        tokenHash: widget.tokenHash,
        newCustomerPhone: e164,
        newCustomerName: _nameCtrl.text.trim(),
        discountPct: _tokenInfo!.referralDiscountPct,
        referrerName: _tokenInfo!.referrerName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: _loadingInfo
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: ListShimmer(itemCount: 3, itemHeight: 60),
            )
          : _infoError != null
          ? _buildError()
          : _buildForm(),
    );
  }

  Widget _buildError() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(
        Icons.error_outline_rounded,
        size: 48,
        color: BrandColors.error,
      ),
      const SizedBox(height: 12),
      Text(
        _infoError!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: BrandColors.error,
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ),
    ],
  );

  Widget _buildForm() {
    final info = _tokenInfo!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: BrandColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BrandColors.success.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: BrandColors.success.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.verified_user_rounded,
                color: BrandColors.success,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referral from ${info.referrerName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: BrandColors.success,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${info.campaignName}  •  ${info.referralDiscountPct.toStringAsFixed(0)}% discount for new customer',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: 20),
        const Text(
          'New Customer Details',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: BrandColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enter the new customer\'s phone. The discount will be applied when you place the order.',
          style: TextStyle(fontSize: 12, color: BrandColors.muted, height: 1.5),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '9876543210',
            prefixText: '+91  ',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Customer Name (optional)',
            hintText: 'e.g. Gnyan Kumar',
          ),
        ),

        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            style: const TextStyle(fontSize: 13, color: BrandColors.error),
          ),
        ],

        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _apply,
            child: Text(
              'Apply ${info.referralDiscountPct.toStringAsFixed(0)}% Referral Discount',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}
