import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../providers/cashflow_provider.dart';
import '../providers/store_settings_provider.dart';

// ── Partner bank data ─────────────────────────────────────────────────────────

class _Bank {
  final String name;
  final String subtitle;
  final String rate;
  final Color color;
  const _Bank({
    required this.name,
    required this.subtitle,
    required this.rate,
    required this.color,
  });
}

const _partners = [
  _Bank(
    name: 'SBI Mudra Loan',
    subtitle: 'Government-backed scheme for small businesses',
    rate: 'From 9.75% p.a.',
    color: Color(0xFF1A3A5C),
  ),
  _Bank(
    name: 'HDFC Business Loan',
    subtitle: 'Quick disbursal for retail growth',
    rate: 'From 11.5% p.a.',
    color: Color(0xFF00427A),
  ),
  _Bank(
    name: 'ICICI SME Credit',
    subtitle: 'Flexible credit for kirana owners',
    rate: 'From 12% p.a.',
    color: Color(0xFF8B1A1A),
  ),
  _Bank(
    name: 'Axis Business Loan',
    subtitle: 'Tailored finance for retail stores',
    rate: 'From 11% p.a.',
    color: Color(0xFF6B0F0F),
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class CashflowScreen extends ConsumerStatefulWidget {
  const CashflowScreen({super.key});

  @override
  ConsumerState<CashflowScreen> createState() => _CashflowScreenState();
}

class _CashflowScreenState extends ConsumerState<CashflowScreen> {
  double _selectedAmount = 300000.0;
  String? _selectedBank;
  bool _submitting = false;
  bool _submitted = false;

  Future<void> _submit() async {
    if (_selectedBank == null) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(cashflowStatusProvider.notifier)
          .submitRequest(amount: _selectedAmount, selectedBank: _selectedBank!);
      if (mounted) setState(() => _submitted = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(cashflowStatusProvider);
    final storeAsync = ref.watch(storeSettingsProvider);

    final storeName = storeAsync.value?.name ?? '';
    final location = storeAsync.value?.location ?? '';
    final footfall = storeAsync.value?.footfall ?? 0;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'Cashflow Support',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _buildContent(storeName, location, footfall),
        data: (status) {
          if (status.hasRequest && !_submitted) {
            return _buildExistingRequest(status);
          }
          if (_submitted) { return _buildSuccess(); }
          return _buildContent(storeName, location, footfall);
        },
      ),
    );
  }

  // ── Already has a pending request ─────────────────────────────────────────

  // ignore: strict_top_level_inference
  Widget _buildExistingRequest(cashflowStatus) {
    final amount = cashflowStatus.amount as double?;
    final bank = cashflowStatus.selectedBank as String?;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: BrandColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                size: 56,
                color: BrandColors.accent,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            const Text(
              'Request Under Review',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your cashflow request${amount != null ? ' for ₹${_fmt(amount)}' : ''}'
              '${bank != null ? ' via $bank' : ''} is being processed.\n\n'
              'Our team will contact you within 2 business days.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: BrandColors.muted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: BrandColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: BrandColors.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, size: 8, color: BrandColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    (cashflowStatus.status as String? ?? 'pending')
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: BrandColors.accent,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Success screen ────────────────────────────────────────────────────────

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: BrandColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 64,
                color: BrandColors.success,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 28),
            const Text(
              'Request Submitted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We\'ve received your cashflow request.\nOur team will contact you within\n2 business days.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: BrandColors.muted,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main content ──────────────────────────────────────────────────────────

  Widget _buildContent(String storeName, String location, int footfall) {
    final canSubmit = _selectedBank != null && !_submitting;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        const Text(
          'Apply for\nCashflow Support',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: BrandColors.ink,
            height: 1.15,
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15, end: 0),
        const SizedBox(height: 6),
        const Text(
          'Quick business finance, powered by LohiyaAI partners.',
          style: TextStyle(fontSize: 14, color: BrandColors.muted),
        ).animate(delay: 60.ms).fadeIn(),
        const SizedBox(height: 24),

        // ── Business Profile card ────────────────────────────────────────────
        _SectionLabel(label: 'Your Business Profile'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BrandColors.border),
          ),
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.storefront_rounded,
                label: 'Store',
                value: storeName.isNotEmpty ? storeName : '—',
              ),
              const Divider(height: 20),
              _InfoRow(
                icon: Icons.location_on_rounded,
                label: 'Location',
                value: location.isNotEmpty ? location : '—',
              ),
              const Divider(height: 20),
              _InfoRow(
                icon: Icons.people_rounded,
                label: 'Daily Footfall',
                value: footfall > 0 ? '$footfall customers/day' : '—',
              ),
            ],
          ),
        ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),

        const SizedBox(height: 28),

        // ── Amount selector ──────────────────────────────────────────────────
        _SectionLabel(label: 'How much do you need?'),
        const SizedBox(height: 4),
        const Text(
          'Drag to select — ₹50,000 to ₹10,00,000',
          style: TextStyle(fontSize: 12, color: BrandColors.muted),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BrandColors.border),
          ),
          child: Column(
            children: [
              Text(
                _fmt(_selectedAmount),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'loan amount',
                style: TextStyle(fontSize: 12, color: BrandColors.muted),
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                  activeTrackColor: BrandColors.primary,
                  inactiveTrackColor: BrandColors.border,
                  thumbColor: BrandColors.primary,
                  overlayColor: BrandColors.primary.withValues(alpha: 0.15),
                ),
                child: Slider(
                  value: _selectedAmount,
                  min: 50000,
                  max: 1000000,
                  divisions: 95,
                  onChanged: (v) => setState(() => _selectedAmount = v),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '₹50K',
                    style: TextStyle(
                      fontSize: 11,
                      color: BrandColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '₹10L',
                    style: TextStyle(
                      fontSize: 11,
                      color: BrandColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate(delay: 150.ms).fadeIn(),

        // ── Partner banks ────────────────────────────────────────────────────
        ...[
          const SizedBox(height: 32),
          _SectionLabel(label: 'Choose a Partner Bank'),
          const SizedBox(height: 4),
          const Text(
            'Select a bank to proceed with your request.',
            style: TextStyle(fontSize: 12, color: BrandColors.muted),
          ),
          const SizedBox(height: 12),
          ..._partners.asMap().entries.map((e) {
            final idx = e.key;
            final bank = e.value;
            final selected = _selectedBank == bank.name;
            return GestureDetector(
              onTap: () => setState(() => _selectedBank = bank.name),
              child:
                  AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selected
                              ? BrandColors.primary.withValues(alpha: 0.06)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? BrandColors.primary
                                : BrandColors.border,
                            width: selected ? 1.8 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: bank.color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.account_balance_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bank.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: BrandColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    bank.subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: BrandColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: BrandColors.success.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      bank.rate,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: BrandColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: BrandColors.primary,
                                size: 22,
                              ),
                          ],
                        ),
                      )
                      .animate(delay: Duration(milliseconds: 80 * idx))
                      .fadeIn()
                      .slideX(begin: 0.05, end: 0),
            );
          }),

          const SizedBox(height: 24),

          // ── Submit button ──────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canSubmit ? _submit : null,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Submit Request'),
            ),
          ).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: 12),
          const Text(
            'By submitting, you agree to be contacted by our team regarding this request.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: BrandColors.muted),
          ),
        ],
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 100000) {
      return '₹${(v / 100000).toStringAsFixed(v % 100000 == 0 ? 0 : 1)}L';
    }
    return '₹${(v / 1000).toStringAsFixed(0)}K';
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: BrandColors.ink,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: BrandColors.surfaceTint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: BrandColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.ink,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
