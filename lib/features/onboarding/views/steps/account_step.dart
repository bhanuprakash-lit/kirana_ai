import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/brand_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../support/providers/notification_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../utils/username_validator.dart';

enum _AccountStep { enterPhone, enterOtp, chooseUsername }

class AccountStep extends ConsumerStatefulWidget {
  /// Pre-filled values when arriving from login screen after OTP was already verified.
  final String? preFilledPhone;
  final String? preFilledFirebaseUid;

  const AccountStep({
    super.key,
    this.preFilledPhone,
    this.preFilledFirebaseUid,
  });

  @override
  ConsumerState<AccountStep> createState() => _AccountStepState();
}

class _AccountStepState extends ConsumerState<AccountStep> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _otpFocusNode = FocusNode();

  _AccountStep _step = _AccountStep.enterPhone;
  bool _loading = false;
  String? _error;
  String? _verificationId;
  int? _resendToken;
  String? _verifiedPhone;
  String? _verifiedFirebaseUid;

  // Username availability check
  bool? _usernameAvailable;
  bool _checkingUsername = false;
  // Local (format) validity, updated live so the user gets instant feedback
  // before we ever hit the availability endpoint.
  UsernameStatus _usernameStatus = UsernameStatus.empty;

  /// Locale-resolved strings for use in async callbacks where reaching for
  /// BuildContext after an await would be unsafe.
  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  void initState() {
    super.initState();
    if (widget.preFilledPhone != null && widget.preFilledFirebaseUid != null) {
      _verifiedPhone = widget.preFilledPhone;
      _verifiedFirebaseUid = widget.preFilledFirebaseUid;
      _step = _AccountStep.chooseUsername;
    }
    _usernameCtrl.addListener(_onUsernameChanged);
    _otpCtrl.addListener(_onOtpChanged);
  }

  void _onOtpChanged() {
    if (_otpCtrl.text.trim().length == 6 &&
        !_loading &&
        _step == _AccountStep.enterOtp) {
      _verifyOtp();
    }
  }

  @override
  void dispose() {
    _otpCtrl.removeListener(_onOtpChanged);
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _usernameCtrl.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  // ── Phone OTP ──────────────────────────────────────────────────────────────

  Future<void> _sendOtp() async {
    final raw = _phoneCtrl.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = _l10n.authErrEnterPhone);
      return;
    }
    final phone = raw.startsWith('+') ? raw : '+91$raw';
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (cred) async => _autoVerify(cred),
      verificationFailed: (e) => setState(() {
        _loading = false;
        _error = _firebaseError(e);
      }),
      codeSent: (verificationId, resendToken) {
        setState(() {
          _loading = false;
          _verificationId = verificationId;
          _resendToken = resendToken;
          _step = _AccountStep.enterOtp;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _otpFocusNode.requestFocus();
        });
      },
      codeAutoRetrievalTimeout: (_) {},
      forceResendingToken: _resendToken,
    );
  }

  Future<void> _autoVerify(PhoneAuthCredential cred) async {
    // Auto-retrieved / instant verification (Android). Show a verifying state
    // and surface failures instead of silently swallowing them.
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final userCred = await FirebaseAuth.instance.signInWithCredential(cred);
      await _handleVerified(userCred);
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = _l10n.authErrVerificationFailed;
        });
      }
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _error = _l10n.authErrEnter6Otp);
      return;
    }
    if (_verificationId == null) {
      setState(() => _error = _l10n.authErrSessionExpired);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );
      final userCred = await FirebaseAuth.instance.signInWithCredential(cred);
      await _handleVerified(userCred);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
        _error = _firebaseError(e);
      });
    }
  }

  Future<void> _handleVerified(UserCredential userCred) async {
    final phone = userCred.user?.phoneNumber ?? '';
    final uid = userCred.user?.uid ?? '';

    setState(() => _loading = true);

    final existing = await ref
        .read(authRepositoryProvider)
        .phoneLogin(phoneNumber: phone, firebaseUid: uid);

    if (!mounted) return;

    if (existing != null) {
      // Account already exists — sign in directly, skip the 4-step registration
      ref.read(notificationServiceProvider).uploadToken();
      context.go('/home');
      return;
    }

    setState(() {
      _loading = false;
      _verifiedPhone = phone;
      _verifiedFirebaseUid = uid;
      _step = _AccountStep.chooseUsername;
    });
  }

  // ── Username ───────────────────────────────────────────────────────────────

  void _onUsernameChanged() {
    final status = UsernameRules.evaluate(_usernameCtrl.text);
    setState(() {
      _usernameStatus = status;
      _usernameAvailable = null; // availability only matters once format is valid
      _error = null;
    });
    // Only spend a network round-trip once the username is well-formed.
    if (status == UsernameStatus.valid) {
      _debounceCheck(_usernameCtrl.text.trim());
    }
  }

  /// Message for a local (format) problem, or null when the username is well-formed.
  String? _usernameFormatError(UsernameStatus s) {
    switch (s) {
      case UsernameStatus.empty:
        return _l10n.accountErrChooseUsername;
      case UsernameStatus.tooShort:
        return _l10n.accountErrUsernameMin3;
      case UsernameStatus.tooLong:
        return _l10n.accountErrUsernameMax30;
      case UsernameStatus.invalidChars:
        return _l10n.accountErrUsernameChars;
      case UsernameStatus.valid:
        return null;
    }
  }

  /// Trailing icon: spinner while checking, green tick when available, red cross
  /// when taken OR locally malformed (bad chars / too long).
  Widget? _usernameSuffix() {
    if (_checkingUsername) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (_usernameAvailable == true) {
      return const Icon(Icons.check_circle_rounded,
          color: BrandColors.success, size: 20);
    }
    if (_usernameAvailable == false ||
        _usernameStatus == UsernameStatus.invalidChars ||
        _usernameStatus == UsernameStatus.tooLong) {
      return const Icon(Icons.cancel_rounded, color: BrandColors.error, size: 20);
    }
    return null;
  }

  /// Inline helper line under the field — instant format feedback as the owner
  /// types, before/independent of the availability round-trip.
  List<Widget> _usernameInlineHint(AppLocalizations l10n) {
    String? text;
    Color color = BrandColors.error;
    if (_usernameAvailable == true) {
      text = l10n.accountUsernameAvailable;
      color = BrandColors.success;
    } else if (_usernameAvailable == false) {
      text = l10n.accountUsernameTaken;
    } else if (_usernameStatus == UsernameStatus.invalidChars) {
      text = l10n.accountErrUsernameChars;
    } else if (_usernameStatus == UsernameStatus.tooLong) {
      text = l10n.accountErrUsernameMax30;
    } else if (_usernameStatus == UsernameStatus.tooShort) {
      // Gentle nudge mid-typing rather than a hard error.
      text = l10n.accountErrUsernameMin3;
      color = BrandColors.muted;
    }
    if (text == null) return const [];
    return [
      Padding(
        padding: const EdgeInsets.only(top: 6, left: 4),
        child: Text(text, style: TextStyle(fontSize: 12, color: color)),
      ),
    ];
  }

  DateTime _lastCheck = DateTime(0);
  Future<void> _debounceCheck(String uname) async {
    final now = DateTime.now();
    _lastCheck = now;
    await Future.delayed(const Duration(milliseconds: 500));
    if (_lastCheck != now || !mounted) return;
    setState(() => _checkingUsername = true);
    final available = await ref
        .read(authRepositoryProvider)
        .checkUsernameAvailable(uname);
    if (!mounted) return;
    setState(() {
      _checkingUsername = false;
      _usernameAvailable = available;
    });
  }

  void _submitUsername() {
    FocusScope.of(context).unfocus();
    final uname = _usernameCtrl.text.trim();
    final formatError = _usernameFormatError(UsernameRules.evaluate(uname));
    if (formatError != null) {
      setState(() => _error = formatError);
      return;
    }
    if (_usernameAvailable == false) {
      setState(() => _error = _l10n.accountErrUsernameTakenTry);
      return;
    }

    final notifier = ref.read(onboardingProvider.notifier);
    notifier.updateData(
      ref
          .read(onboardingProvider)
          .data
          .copyWith(
            phoneNumber: _verifiedPhone ?? '',
            firebaseUid: _verifiedFirebaseUid ?? '',
            username: uname,
          ),
    );
    notifier.advanceFromAccount();
  }

  String _firebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return _l10n.authErrInvalidPhone;
      case 'too-many-requests':
        return _l10n.authErrTooManyRequests;
      case 'invalid-verification-code':
        return _l10n.authErrWrongOtp;
      case 'session-expired':
        return _l10n.authErrOtpExpired;
      default:
        return e.message ?? _l10n.authErrVerificationFailed;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      child: switch (_step) {
        _AccountStep.enterPhone => _buildEnterPhone(context),
        _AccountStep.enterOtp => _buildEnterOtp(context),
        _AccountStep.chooseUsername => _buildChooseUsername(context),
      },
    );
  }

  Widget _buildEnterPhone(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.accountVerifyPhoneTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          l10n.accountVerifyPhoneSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ).animate(delay: 50.ms).fadeIn(),
        const SizedBox(height: 32),
        BrandTextField(
          controller: _phoneCtrl,
          label: l10n.accountPhoneLabel,
          hint: '9876543210',
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofillHints: const [AutofillHints.telephoneNumber],
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '+91',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: BrandColors.ink,
              ),
            ),
          ),
        ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),
        if (_error != null) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 32),
        PrimaryButton(
          label: l10n.accountSendOtp,
          isLoading: _loading,
          onPressed: _sendOtp,
        ).animate(delay: 150.ms).fadeIn(),
      ],
    );
  }

  Widget _buildEnterOtp(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() {
                _step = _AccountStep.enterPhone;
                _otpCtrl.clear();
                _error = null;
              }),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: BrandColors.muted,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.accountOtpSentTo(_phoneCtrl.text.trim()),
                style: const TextStyle(
                  fontSize: 13,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          l10n.accountEnterOtpTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 8),
        Text(
          l10n.accountEnterOtpSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ).animate(delay: 50.ms).fadeIn(),
        const SizedBox(height: 28),
        AutofillGroup(
          child: BrandTextField(
            controller: _otpCtrl,
            label: l10n.accountOtp6Label,
            hint: '------',
            keyboardType: TextInputType.number,
            // One-tap OS suggestion (iOS) / autofill (Android) for the SMS code.
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            focusNode: _otpFocusNode,
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 28),
        PrimaryButton(
          label: l10n.accountVerify,
          isLoading: _loading,
          onPressed: _verifyOtp,
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: _loading ? null : _sendOtp,
            child: Text(
              l10n.accountResendOtp,
              style: const TextStyle(
                color: BrandColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChooseUsername(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_verifiedPhone != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: BrandColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: BrandColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: BrandColors.success,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.accountPhoneVerified(_verifiedPhone!),
                  style: const TextStyle(
                    fontSize: 13,
                    color: BrandColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 20),
        Text(
          l10n.accountChooseUsernameTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          l10n.accountChooseUsernameSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ).animate(delay: 50.ms).fadeIn(),
        const SizedBox(height: 28),
        BrandTextField(
          controller: _usernameCtrl,
          label: l10n.accountUsernameLabel,
          hint: l10n.accountUsernameHint,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
            LengthLimitingTextInputFormatter(30),
          ],
          suffix: _usernameSuffix(),
        ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),

        ..._usernameInlineHint(l10n),

        if (_error != null) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 32),
        PrimaryButton(
          label: l10n.commonContinue,
          isLoading: false,
          onPressed: _submitUsername,
        ).animate(delay: 150.ms).fadeIn(),
        const SizedBox(height: 12),
        Center(
          child: Text(
            l10n.accountUsernameRules,
            style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BrandColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.error.withValues(alpha: 0.2)),
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
              message,
              style: const TextStyle(
                fontSize: 13,
                color: BrandColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
