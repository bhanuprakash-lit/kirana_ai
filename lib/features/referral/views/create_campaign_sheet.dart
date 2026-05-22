import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../providers/referral_provider.dart';

class CreateCampaignSheet extends ConsumerStatefulWidget {
  final VoidCallback onCreated;
  const CreateCampaignSheet({super.key, required this.onCreated});

  @override
  ConsumerState<CreateCampaignSheet> createState() =>
      _CreateCampaignSheetState();
}

class _CreateCampaignSheetState extends ConsumerState<CreateCampaignSheet> {
  final _nameCtrl = TextEditingController();
  final _discountCtrl = TextEditingController(text: '10');
  final _milestoneNCtrl = TextEditingController(text: '10');
  final _milestoneRewardCtrl = TextEditingController(text: '5');
  final _maxRefsCtrl = TextEditingController(text: '50');
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _discountCtrl.dispose();
    _milestoneNCtrl.dispose();
    _milestoneRewardCtrl.dispose();
    _maxRefsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Campaign name is required');
      return;
    }
    final discount = double.tryParse(_discountCtrl.text);
    final milestoneN = int.tryParse(_milestoneNCtrl.text);
    final milestoneReward = double.tryParse(_milestoneRewardCtrl.text);

    if (discount == null || discount <= 0 || discount > 100) {
      setState(() => _error = 'Enter a valid discount % (1–100)');
      return;
    }
    if (milestoneN == null || milestoneN < 1) {
      setState(() => _error = 'Milestone count must be at least 1');
      return;
    }
    if (milestoneReward == null ||
        milestoneReward <= 0 ||
        milestoneReward > 100) {
      setState(() => _error = 'Enter a valid reward % (1–100)');
      return;
    }
    final maxRefs = int.tryParse(_maxRefsCtrl.text);
    if (maxRefs == null || maxRefs < 1) {
      setState(() => _error = 'Max referrals must be at least 1');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final ok = await ref
        .read(referralCampaignsProvider.notifier)
        .createCampaign(
          name: name,
          referralDiscountPct: discount,
          milestoneEveryN: milestoneN,
          milestoneRewardPct: milestoneReward,
          maxReferralsPerReferrer: maxRefs,
        );

    if (!mounted) return;
    if (ok) {
      widget.onCreated();
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error = 'Failed to create campaign. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Referral Campaign',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.ink,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _Label('Campaign Name'),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. Summer Referral Drive',
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('New Customer Discount %'),
                    TextField(
                      controller: _discountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: '10',
                        suffixText: '%',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Milestone Reward %'),
                    TextField(
                      controller: _milestoneRewardCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: '5',
                        suffixText: '%',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _Label('Reward Every N Referrals'),
          TextField(
            controller: _milestoneNCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: '10',
              helperText:
                  'Referrer earns a milestone reward every N new customers they bring',
            ),
          ),
          const SizedBox(height: 16),
          _Label('Max Referrals per Customer'),
          TextField(
            controller: _maxRefsCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: '50',
              helperText:
                  'Stop rewarding a customer after this many successful referrals',
            ),
          ),

          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(fontSize: 13, color: BrandColors.error),
            ),
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create Campaign'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: BrandColors.muted,
      ),
    ),
  );
}
