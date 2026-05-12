import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../providers/config_provider.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  UserPrefs? _draft;
  String? _defaultPayment;
  bool _saving = false;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    // Snapshots loaded after first frame via ref.listen in build
  }

  void _init(UserPrefs prefs, String payment) {
    if (_draft == null) {
      _draft = prefs;
      _defaultPayment = payment;
    }
  }

  void _update(UserPrefs updated) {
    setState(() {
      _draft = updated;
      _dirty = true;
    });
  }

  void _updatePayment(String method) {
    setState(() {
      _defaultPayment = method;
      _dirty = true;
    });
  }

  Future<void> _save() async {
    if (_draft == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(configProvider.notifier).save(_draft!);
      await ref.read(posPrefsProvider.notifier).setDefaultPaymentMethod(_defaultPayment ?? 'cash');
      setState(() => _dirty = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved'), backgroundColor: BrandColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e'), backgroundColor: BrandColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _reset() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset to defaults', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('All settings will be reset to their default values.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset', style: TextStyle(color: BrandColors.error)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _saving = true);
    try {
      await ref.read(configProvider.notifier).resetToDefaults();
      await ref.read(posPrefsProvider.notifier).setDefaultPaymentMethod('cash');
      setState(() {
        _draft = const UserPrefs();
        _defaultPayment = 'cash';
        _dirty = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reset to defaults')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(configProvider);
    final paymentAsync = ref.watch(posPrefsProvider);

    return prefsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (prefs) {
        return paymentAsync.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
          data: (payment) {
            _init(prefs, payment);
            final d = _draft!;
            final pm = _defaultPayment ?? 'cash';

            return Scaffold(
              backgroundColor: BrandColors.background,
              appBar: AppBar(
                title: const Text(
                  'Configuration',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                actions: [
                  TextButton(
                    onPressed: _saving ? null : _reset,
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: BrandColors.muted, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                children: [
                  // ── POS Preferences ────────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.point_of_sale_rounded,
                    title: 'POS Preferences',
                    color: BrandColors.primary,
                  ),
                  _Card(
                    children: [
                      const _SettingLabel(
                        label: 'Default Payment Method',
                        hint: 'Pre-selected method when adding a new sale',
                      ),
                      const SizedBox(height: 10),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'cash',
                            icon: Icon(Icons.payments_rounded, size: 16),
                            label: Text('Cash'),
                          ),
                          ButtonSegment(
                            value: 'upi',
                            icon: Icon(Icons.qr_code_rounded, size: 16),
                            label: Text('UPI'),
                          ),
                          ButtonSegment(
                            value: 'card',
                            icon: Icon(Icons.credit_card_rounded, size: 16),
                            label: Text('Card'),
                          ),
                        ],
                        selected: {pm},
                        onSelectionChanged: (val) => _updatePayment(val.first),
                        style: SegmentedButton.styleFrom(
                          backgroundColor: BrandColors.surfaceTint,
                          selectedBackgroundColor:
                              BrandColors.primary.withValues(alpha: 0.1),
                          selectedForegroundColor: BrandColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── AI & Forecasting ───────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.auto_awesome_rounded,
                    title: 'AI & Forecasting',
                    color: const Color(0xFF7C3AED),
                  ),
                  _Card(
                    children: [
                      _SettingLabel(
                        label: 'Forecast Horizon',
                        hint: 'How many days ahead the AI predicts stock needs',
                        value: '${d.forecastHorizonDays} days',
                      ),
                      const SizedBox(height: 6),
                      _ChipSelector<int>(
                        options: const [7, 14, 30],
                        labels: const ['7 days', '14 days', '30 days'],
                        selected: d.forecastHorizonDays,
                        onSelected: (v) =>
                            _update(d.copyWith(forecastHorizonDays: v)),
                      ),
                      const _Divider(),
                      _SettingLabel(
                        label: 'Stockout Risk Threshold',
                        hint: 'Show stockout alert when 7-day risk exceeds this',
                        value: '${(d.alertStockoutThreshold * 100).toStringAsFixed(0)}%',
                      ),
                      Slider(
                        value: d.alertStockoutThreshold,
                        min: 0.1,
                        max: 0.9,
                        divisions: 8,
                        activeColor: BrandColors.primary,
                        label:
                            '${(d.alertStockoutThreshold * 100).toStringAsFixed(0)}%',
                        onChanged: (v) =>
                            _update(d.copyWith(alertStockoutThreshold: v)),
                      ),
                      const _Divider(),
                      _SettingLabel(
                        label: 'Min Velocity Threshold',
                        hint: 'Items selling slower than this are flagged as dead stock',
                        value: '${(d.alertMinVelocity * 100).toStringAsFixed(0)}%',
                      ),
                      Slider(
                        value: d.alertMinVelocity,
                        min: 0.05,
                        max: 0.9,
                        divisions: 17,
                        activeColor: BrandColors.primary,
                        label:
                            '${(d.alertMinVelocity * 100).toStringAsFixed(0)}%',
                        onChanged: (v) =>
                            _update(d.copyWith(alertMinVelocity: v)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Alert Thresholds ───────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.notifications_active_rounded,
                    title: 'Alert Thresholds',
                    color: BrandColors.accent,
                  ),
                  _Card(
                    children: [
                      _SettingLabel(
                        label: 'Reorder Alert Days',
                        hint: 'Alert when projected stock will run out within N days',
                        value: '${d.alertReorderDays} days',
                      ),
                      const SizedBox(height: 6),
                      _ChipSelector<int>(
                        options: const [1, 2, 3, 5, 7],
                        labels: const ['1d', '2d', '3d', '5d', '7d'],
                        selected: d.alertReorderDays,
                        onSelected: (v) =>
                            _update(d.copyWith(alertReorderDays: v)),
                      ),
                      const _Divider(),
                      _SettingLabel(
                        label: 'Dead Stock Days',
                        hint: 'Flag items with no sales for N or more days',
                        value: '${d.alertDeadStockDays} days',
                      ),
                      const SizedBox(height: 6),
                      _ChipSelector<int>(
                        options: const [7, 14, 21, 30, 60],
                        labels: const ['7d', '14d', '21d', '30d', '60d'],
                        selected: d.alertDeadStockDays,
                        onSelected: (v) =>
                            _update(d.copyWith(alertDeadStockDays: v)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Notifications ──────────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.campaign_rounded,
                    title: 'Notifications',
                    color: BrandColors.success,
                  ),
                  _Card(
                    children: [
                      _ToggleRow(
                        icon: Icons.notifications_rounded,
                        label: 'In-app Alerts',
                        hint: 'Show alerts inside the app',
                        value: d.notifyInApp,
                        onChanged: (v) => _update(d.copyWith(notifyInApp: v)),
                      ),
                      const _Divider(),
                      _ToggleRow(
                        icon: Icons.chat_rounded,
                        label: 'WhatsApp Notifications',
                        hint: 'Send restocking and udhaar alerts via WhatsApp',
                        value: d.notifyWhatsapp,
                        onChanged: (v) => _update(d.copyWith(notifyWhatsapp: v)),
                      ),
                      const _Divider(),
                      _SettingLabel(
                        label: 'Quiet Hours',
                        hint: 'No notifications will be sent during this window',
                        value:
                            '${_fmtHour(d.quietHoursStart)} – ${_fmtHour(d.quietHoursEnd)}',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _HourDropdown(
                              label: 'Start',
                              value: d.quietHoursStart,
                              onChanged: (v) =>
                                  _update(d.copyWith(quietHoursStart: v)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 16, color: BrandColors.muted),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _HourDropdown(
                              label: 'End',
                              value: d.quietHoursEnd,
                              onChanged: (v) =>
                                  _update(d.copyWith(quietHoursEnd: v)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              bottomNavigationBar: _SaveBar(
                dirty: _dirty,
                saving: _saving,
                onSave: _save,
              ),
            );
          },
        );
      },
    );
  }

  String _fmtHour(int h) {
    final suffix = h < 12 ? 'AM' : 'PM';
    final display = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$display $suffix';
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: BrandColors.border),
    );
  }
}

class _SettingLabel extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;

  const _SettingLabel({required this.label, required this.hint, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: BrandColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                style: const TextStyle(fontSize: 12, color: BrandColors.muted),
              ),
            ],
          ),
        ),
        if (value != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: BrandColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: BrandColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ChipSelector<T> extends StatelessWidget {
  final List<T> options;
  final List<String> labels;
  final T selected;
  final ValueChanged<T> onSelected;

  const _ChipSelector({
    required this.options,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(options.length, (i) {
        final isSelected = options[i] == selected;
        return GestureDetector(
          onTap: () => onSelected(options[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected
                  ? BrandColors.primary.withValues(alpha: 0.1)
                  : BrandColors.surfaceTint,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color:
                    isSelected ? BrandColors.primary : BrandColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? BrandColors.primary : BrandColors.muted,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
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
          child: Icon(icon, size: 18, color: BrandColors.muted),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: BrandColors.ink,
                ),
              ),
              Text(
                hint,
                style: const TextStyle(fontSize: 12, color: BrandColors.muted),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: BrandColors.success,
          activeTrackColor: BrandColors.success.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

class _HourDropdown extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _HourDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: BrandColors.surfaceTint,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BrandColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: List.generate(24, (h) {
                final suffix = h < 12 ? 'AM' : 'PM';
                final display = h == 0 ? 12 : (h > 12 ? h - 12 : h);
                return DropdownMenuItem(
                  value: h,
                  child: Text(
                    '$display:00 $suffix',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: BrandColors.ink,
                    ),
                  ),
                );
              }),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SaveBar extends StatelessWidget {
  final bool dirty;
  final bool saving;
  final VoidCallback onSave;

  const _SaveBar({
    required this.dirty,
    required this.saving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: dirty ? 90 : 0,
      child: dirty
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: saving ? null : onSave,
                child: saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
