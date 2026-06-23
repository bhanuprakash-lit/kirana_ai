import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kirana_ai/features/support/providers/notification_provider.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../repositories/auth_repository.dart';
import '../../../shared/widgets/brand_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../subscription/providers/subscription_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [BrandColors.primary, Color(0xFF3730A3)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 26,
                  color: Colors.white,
                ),
              ).animate().scale(
                begin: const Offset(0.5, 0.5),
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),
              const SizedBox(height: 28),
              Text(
                l10n.loginWelcomeBack,
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate(delay: 50.ms).fadeIn().slideY(begin: 0.2, end: 0),
              const SizedBox(height: 6),
              Text(
                l10n.loginSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate(delay: 100.ms).fadeIn(),
              const SizedBox(height: 28),

              // ── Auth method tabs ──────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: BrandColors.surfaceTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tab,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  labelColor: BrandColors.primary,
                  unselectedLabelColor: BrandColors.muted,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.phone_rounded, size: 18),
                      text: l10n.loginTabPhone,
                    ),
                    Tab(
                      icon: const Icon(Icons.lock_outline_rounded, size: 18),
                      text: l10n.loginTabUsername,
                    ),
                  ],
                ),
              ).animate(delay: 150.ms).fadeIn(),
              const SizedBox(height: 24),

              SizedBox(
                height: 340,
                child: TabBarView(
                  controller: _tab,
                  children: const [_PhoneLoginForm(), _EmailLoginForm()],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/onboarding'),
                  child: RichText(
                    text: TextSpan(
                      text: l10n.loginNoAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: l10n.loginCreateOne,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: BrandColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Phone OTP form ─────────────────────────────────────────────────────────────

class _PhoneLoginForm extends ConsumerStatefulWidget {
  const _PhoneLoginForm();

  @override
  ConsumerState<_PhoneLoginForm> createState() => _PhoneLoginFormState();
}

enum _PhoneStep { enterPhone, enterOtp }

class _PhoneLoginFormState extends ConsumerState<_PhoneLoginForm> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _otpFocusNode = FocusNode();
  _PhoneStep _step = _PhoneStep.enterPhone;
  bool _loading = false;
  String? _error;
  String? _verificationId;
  int? _resendToken;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  void initState() {
    super.initState();
    _phoneCtrl.addListener(_onPhoneChanged);
    _otpCtrl.addListener(_onOtpChanged);
  }

  void _onPhoneChanged() {
    if (_phoneCtrl.text.trim().length == 10 &&
        !_loading &&
        _step == _PhoneStep.enterPhone) {
      _sendOtp();
    }
  }

  void _onOtpChanged() {
    if (_otpCtrl.text.trim().length == 6 &&
        !_loading &&
        _step == _PhoneStep.enterOtp) {
      _verifyOtp();
    }
  }

  @override
  void dispose() {
    _phoneCtrl.removeListener(_onPhoneChanged);
    _otpCtrl.removeListener(_onOtpChanged);
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final raw = _phoneCtrl.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = _l10n.authErrEnterPhone);
      return;
    }
    if (_loading) return;
    // Normalise to E.164 — assume India (+91) if no country code
    final phone = raw.startsWith('+') ? raw : '+91$raw';

    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (cred) async {
        // Auto-retrieved / instant verification (Android). Surface a verifying
        // state so the hands-free sign-in doesn't look like a frozen pause.
        if (mounted) {
          setState(() {
            _loading = true;
            _error = null;
            _step = _PhoneStep.enterOtp;
          });
        }
        await _signInWithCredential(cred);
      },
      verificationFailed: (e) {
        setState(() {
          _loading = false;
          _error = _firebaseError(e);
        });
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _loading = false;
          _verificationId = verificationId;
          _resendToken = resendToken;
          _step = _PhoneStep.enterOtp;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _otpFocusNode.requestFocus();
        });
      },
      codeAutoRetrievalTimeout: (_) {},
      forceResendingToken: _resendToken,
    );
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
    final cred = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: code,
    );
    await _signInWithCredential(cred);
  }

  Future<void> _signInWithCredential(PhoneAuthCredential cred) async {
    try {
      final userCred = await FirebaseAuth.instance.signInWithCredential(cred);
      final firebaseUser = userCred.user!;
      final phone = firebaseUser.phoneNumber!;
      final uid = firebaseUser.uid;

      final result = await ref
          .read(authRepositoryProvider)
          .phoneLogin(phoneNumber: phone, firebaseUid: uid);

      if (!mounted) return;

      if (result == null) {
        // No account — send to onboarding with phone pre-filled
        context.go('/onboarding', extra: {'phone': phone, 'firebase_uid': uid});
        return;
      }

      await ref.read(notificationServiceProvider).requestPermission();
      ref.invalidate(subscriptionProvider);
      // Multi-store: land on the picker (auto-proceeds to /home if only 1 store).
      if (mounted) context.go('/select-store');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
        _error = _firebaseError(e);
      });
    } on ApiException catch (e) {
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = _l10n.commonSomethingWrong;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_step == _PhoneStep.enterPhone) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandTextField(
            controller: _phoneCtrl,
            label: l10n.loginPhoneLabel,
            hint: '9876543210',
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
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
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            _ErrorBanner(message: _error!),
          ],
          const SizedBox(height: 24),
          PrimaryButton(
            label: l10n.loginSendOtp,
            isLoading: _loading,
            onPressed: _sendOtp,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.loginOtpHelp,
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    // OTP entry step
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() {
                _step = _PhoneStep.enterPhone;
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
            Text(
              l10n.loginOtpSentTo(_phoneCtrl.text.trim()),
              style: const TextStyle(
                fontSize: 13,
                color: BrandColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AutofillGroup(
          child: BrandTextField(
            controller: _otpCtrl,
            label: l10n.loginOtp6Label,
            hint: '------',
            keyboardType: TextInputType.number,
            focusNode: _otpFocusNode,
            // Lets the OS surface the incoming SMS code as a one-tap keyboard
            // suggestion (iOS) / autofill (Android). On Android, Firebase's
            // verificationCompleted also auto-verifies hands-free.
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 24),
        PrimaryButton(
          label: l10n.loginVerifyOtp,
          isLoading: _loading,
          onPressed: _verifyOtp,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _loading ? null : _sendOtp,
            child: Text(
              l10n.loginResendOtp,
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
}

// ── Email login form ───────────────────────────────────────────────────────────

class _EmailLoginForm extends ConsumerStatefulWidget {
  const _EmailLoginForm();

  @override
  ConsumerState<_EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends ConsumerState<_EmailLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  String? _error;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .login(
            username: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
      await ref.read(notificationServiceProvider).requestPermission();
      ref.invalidate(subscriptionProvider);
      // Multi-store: land on the picker (auto-proceeds to /home if only 1 store).
      if (mounted) context.go('/select-store');
    } on ApiException catch (e) {
      setState(() {
        _error = e.statusCode == 401
            ? _l10n.loginIncorrect
            : _l10n.loginFailed(e.message);
      });
    } catch (_) {
      setState(() {
        _error = _l10n.commonServerError;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandTextField(
            controller: _emailCtrl,
            label: l10n.loginUsernameLabel,
            hint: l10n.loginUsernameHint,
            keyboardType: TextInputType.text,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.loginUsernameRequired
                : null,
          ),
          const SizedBox(height: 14),
          BrandTextField(
            controller: _passwordCtrl,
            label: l10n.loginPasswordLabel,
            hint: l10n.loginPasswordHint,
            obscureText: !_showPassword,
            suffix: IconButton(
              icon: Icon(
                _showPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: BrandColors.muted,
                size: 20,
              ),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? l10n.loginPasswordRequired : null,
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            _ErrorBanner(message: _error!),
          ],
          const SizedBox(height: 24),
          PrimaryButton(
            label: l10n.loginSignIn,
            isLoading: _isLoading,
            onPressed: _signIn,
          ),
        ],
      ),
    );
  }
}

// ── Shared ─────────────────────────────────────────────────────────────────────

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
    ).animate().fadeIn(duration: 250.ms);
  }
}
