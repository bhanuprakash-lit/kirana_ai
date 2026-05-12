import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/brand_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../support/providers/notification_provider.dart';
import '../../providers/onboarding_provider.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.preFilledPhone != null && widget.preFilledFirebaseUid != null) {
      _verifiedPhone = widget.preFilledPhone;
      _verifiedFirebaseUid = widget.preFilledFirebaseUid;
      _step = _AccountStep.chooseUsername;
    }
    _usernameCtrl.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
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
      setState(() => _error = 'Enter your phone number');
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
    try {
      final userCred =
          await FirebaseAuth.instance.signInWithCredential(cred);
      await _handleVerified(userCred);
    } catch (_) {}
  }

  Future<void> _verifyOtp() async {
    final code = _otpCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Enter the 6-digit OTP');
      return;
    }
    if (_verificationId == null) {
      setState(() => _error = 'Session expired. Tap Resend.');
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
    setState(() => _usernameAvailable = null);
    final uname = _usernameCtrl.text.trim();
    if (uname.length < 3) return;
    _debounceCheck(uname);
  }

  DateTime _lastCheck = DateTime(0);
  Future<void> _debounceCheck(String uname) async {
    final now = DateTime.now();
    _lastCheck = now;
    await Future.delayed(const Duration(milliseconds: 500));
    if (_lastCheck != now || !mounted) return;
    setState(() => _checkingUsername = true);
    final available =
        await ref.read(authRepositoryProvider).checkUsernameAvailable(uname);
    if (!mounted) return;
    setState(() {
      _checkingUsername = false;
      _usernameAvailable = available;
    });
  }

  void _submitUsername() {
    final uname = _usernameCtrl.text.trim();
    if (uname.isEmpty) {
      setState(() => _error = 'Choose a unique username for your store');
      return;
    }
    if (uname.length < 3) {
      setState(() => _error = 'Username must be at least 3 characters');
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(uname)) {
      setState(() => _error = 'Only letters, numbers, and underscores allowed');
      return;
    }
    if (_usernameAvailable == false) {
      setState(() => _error = 'That username is taken. Try another.');
      return;
    }

    final notifier = ref.read(onboardingProvider.notifier);
    notifier.updateData(
      ref.read(onboardingProvider).data.copyWith(
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
        return 'Invalid phone number format.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'invalid-verification-code':
        return 'Wrong OTP. Check and try again.';
      case 'session-expired':
        return 'OTP expired. Tap Resend.';
      default:
        return e.message ?? 'Verification failed.';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Verify your\nphone number',
                style: Theme.of(context).textTheme.headlineMedium)
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 8),
        Text('We\'ll send a one-time password to confirm your number.',
                style: Theme.of(context).textTheme.bodyMedium)
            .animate(delay: 50.ms)
            .fadeIn(),
        const SizedBox(height: 32),
        BrandTextField(
          controller: _phoneCtrl,
          label: 'Phone number',
          hint: '9876543210',
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofillHints: const [],
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('+91',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: BrandColors.ink)),
          ),
        ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),
        if (_error != null) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'Send OTP',
          isLoading: _loading,
          onPressed: _sendOtp,
        ).animate(delay: 150.ms).fadeIn(),
      ],
    );
  }

  Widget _buildEnterOtp(BuildContext context) {
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
              child: const Icon(Icons.arrow_back_rounded,
                  size: 20, color: BrandColors.muted),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'OTP sent to +91 ${_phoneCtrl.text.trim()}',
                style: const TextStyle(
                    fontSize: 13,
                    color: BrandColors.muted,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('Enter OTP',
                style: Theme.of(context).textTheme.headlineMedium)
            .animate()
            .fadeIn(duration: 300.ms),
        const SizedBox(height: 8),
        Text('6-digit code sent to your phone.',
                style: Theme.of(context).textTheme.bodyMedium)
            .animate(delay: 50.ms)
            .fadeIn(),
        const SizedBox(height: 28),
        BrandTextField(
          controller: _otpCtrl,
          label: '6-digit OTP',
          hint: '------',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          focusNode: _otpFocusNode,
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 28),
        PrimaryButton(
          label: 'Verify',
          isLoading: _loading,
          onPressed: _verifyOtp,
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: _loading ? null : _sendOtp,
            child: const Text('Resend OTP',
                style: TextStyle(
                    color: BrandColors.primary, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _buildChooseUsername(BuildContext context) {
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
                  color: BrandColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 16, color: BrandColors.success),
                const SizedBox(width: 8),
                Text(
                  'Phone verified: $_verifiedPhone',
                  style: const TextStyle(
                      fontSize: 13,
                      color: BrandColors.success,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 20),
        Text('Choose a\nstore username',
                style: Theme.of(context).textTheme.headlineMedium)
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          'Your username is unique to your store and used to log in.',
          style: Theme.of(context).textTheme.bodyMedium,
        ).animate(delay: 50.ms).fadeIn(),
        const SizedBox(height: 28),
        BrandTextField(
          controller: _usernameCtrl,
          label: 'Username',
          hint: 'e.g. lohiyastore123',
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
            LengthLimitingTextInputFormatter(30),
          ],
          suffix: _checkingUsername
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : _usernameAvailable == true
                  ? const Icon(Icons.check_circle_rounded,
                      color: BrandColors.success, size: 20)
                  : _usernameAvailable == false
                      ? const Icon(Icons.cancel_rounded,
                          color: BrandColors.error, size: 20)
                      : null,
        ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),

        if (_usernameAvailable == false)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Username already taken',
              style: TextStyle(fontSize: 12, color: BrandColors.error),
            ),
          ),

        if (_error != null) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'Continue',
          isLoading: false,
          onPressed: _submitUsername,
        ).animate(delay: 150.ms).fadeIn(),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Letters, numbers, underscores only • min 3 chars',
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
          const Icon(Icons.error_outline_rounded,
              color: BrandColors.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(
                    fontSize: 13,
                    color: BrandColors.error,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
