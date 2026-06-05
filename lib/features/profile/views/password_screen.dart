import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/brand_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../../auth/repositories/auth_repository.dart';

// ── Provider ──────────────────────────────────────────────────────────────────

final _passwordStatusProvider = FutureProvider<_PasswordStatus>((ref) async {
  final repo = AuthRepository();
  final token = await repo.getToken();
  if (token == null) throw Exception('Not authenticated');
  final res = await http.get(
    Uri.parse('${AppConfig.apiBaseUrl}/kirana/auth/password-status'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    return _PasswordStatus.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }
  throw Exception('Failed to load password status');
});

class _PasswordStatus {
  final bool hasPassword;
  final DateTime? lastChangedAt;
  final bool canChange;
  final int daysUntilChange;

  const _PasswordStatus({
    required this.hasPassword,
    required this.lastChangedAt,
    required this.canChange,
    required this.daysUntilChange,
  });

  factory _PasswordStatus.fromJson(Map<String, dynamic> json) =>
      _PasswordStatus(
        hasPassword: json['has_password'] as bool? ?? false,
        lastChangedAt: json['last_changed_at'] != null
            ? DateTime.tryParse(json['last_changed_at'] as String)
            : null,
        canChange: json['can_change'] as bool? ?? true,
        daysUntilChange: json['days_until_change'] as int? ?? 0,
      );
}

// ── Screen ────────────────────────────────────────────────────────────────────

class PasswordScreen extends ConsumerWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(_passwordStatusProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.psetPasswordSecurity,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: statusAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: ListShimmer(itemCount: 3, itemHeight: 56),
        ),
        error: (e, _) => Center(
          child: Text(
            l10n.psetCouldNotLoadStatus(e.toString()),
            style: const TextStyle(color: BrandColors.muted),
          ),
        ),
        data: (status) => _PasswordForm(
          status: status,
          onSuccess: () => ref.invalidate(_passwordStatusProvider),
        ),
      ),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────

class _PasswordForm extends ConsumerStatefulWidget {
  final _PasswordStatus status;
  final VoidCallback onSuccess;

  const _PasswordForm({required this.status, required this.onSuccess});

  @override
  ConsumerState<_PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends ConsumerState<_PasswordForm> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _loading = false;
  String? _error;
  String? _success;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final newPass = _newCtrl.text.trim();
    final confirmPass = _confirmCtrl.text.trim();

    if (newPass.isEmpty) {
      setState(() => _error = _l10n.psetEnterNewPassword);
      return;
    }
    if (newPass.length < 6) {
      setState(() => _error = _l10n.psetPasswordMin6);
      return;
    }
    if (newPass != confirmPass) {
      setState(() => _error = _l10n.psetPasswordsNoMatch);
      return;
    }
    if (widget.status.hasPassword && _oldCtrl.text.trim().isEmpty) {
      setState(() => _error = _l10n.psetEnterCurrentPassword);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    try {
      final repo = AuthRepository();
      final token = await repo.getToken();
      if (token == null) throw Exception('Not authenticated');

      final body = <String, dynamic>{
        'new_password': newPass,
        'confirm_password': confirmPass,
      };
      if (widget.status.hasPassword) {
        body['old_password'] = _oldCtrl.text.trim();
      }

      final res = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/kirana/auth/change-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        _oldCtrl.clear();
        _newCtrl.clear();
        _confirmCtrl.clear();
        setState(
          () => _success = widget.status.hasPassword
              ? _l10n.psetPasswordUpdated
              : _l10n.psetPasswordCreated,
        );
        widget.onSuccess();
      } else {
        final detail = _extractError(res.body);
        setState(() => _error = detail);
      }
    } catch (e) {
      setState(() => _error = _l10n.psetCouldNotConnect);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _extractError(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['detail']?.toString() ?? _l10n.psetSomethingWrong;
    } catch (_) {
      return _l10n.psetSomethingWrong;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      children: [
        // Status card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: BrandColors.ink.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      (status.hasPassword
                              ? BrandColors.success
                              : BrandColors.primary)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  status.hasPassword
                      ? Icons.lock_rounded
                      : Icons.lock_open_rounded,
                  color: status.hasPassword
                      ? BrandColors.success
                      : BrandColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.hasPassword
                          ? l10n.psetPasswordSet
                          : l10n.psetNoPasswordYet,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: BrandColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status.hasPassword && status.lastChangedAt != null
                          ? l10n.psetLastChanged(
                              _formatDate(status.lastChangedAt!),
                            )
                          : status.hasPassword
                          ? l10n.psetPasswordActive
                          : l10n.psetCreatePasswordHint,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Cooldown notice
        if (!status.canChange && status.daysUntilChange > 0) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: Color(0xFFB45309),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.psetPasswordCooldown(status.daysUntilChange),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF92400E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 28),
        Text(
          status.hasPassword
              ? l10n.psetChangePassword
              : l10n.psetCreatePassword,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          status.hasPassword
              ? l10n.psetChangeSubtitle
              : l10n.psetCreateSubtitle,
          style: const TextStyle(fontSize: 13, color: BrandColors.muted),
        ),
        const SizedBox(height: 24),

        // Old password (only if user already has one)
        if (status.hasPassword) ...[
          _PasswordField(
            controller: _oldCtrl,
            label: l10n.psetCurrentPassword,
            show: _showOld,
            onToggle: () => setState(() => _showOld = !_showOld),
            enabled: status.canChange,
          ),
          const SizedBox(height: 16),
        ],

        _PasswordField(
          controller: _newCtrl,
          label: l10n.psetNewPassword,
          show: _showNew,
          onToggle: () => setState(() => _showNew = !_showNew),
          enabled: status.canChange,
        ),
        const SizedBox(height: 16),
        _PasswordField(
          controller: _confirmCtrl,
          label: l10n.psetConfirmNewPassword,
          show: _showConfirm,
          onToggle: () => setState(() => _showConfirm = !_showConfirm),
          enabled: status.canChange,
        ),

        if (_error != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BrandColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: BrandColors.error.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: BrandColors.error,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: BrandColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (_success != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BrandColors.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: BrandColors.success.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: BrandColors.success,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _success!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: BrandColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 28),
        PrimaryButton(
          label: status.hasPassword
              ? l10n.psetUpdatePassword
              : l10n.psetCreatePassword,
          isLoading: _loading,
          onPressed: status.canChange ? _submit : null,
        ),

        const SizedBox(height: 16),
        Center(
          child: Text(
            l10n.psetPasswordCooldownNote,
            style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool show;
  final VoidCallback onToggle;
  final bool enabled;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.show,
    required this.onToggle,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return BrandTextField(
      controller: controller,
      label: label,
      obscureText: !show,
      suffix: IconButton(
        icon: Icon(
          show ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          color: BrandColors.muted,
          size: 20,
        ),
        onPressed: enabled ? onToggle : null,
      ),
    );
  }
}
