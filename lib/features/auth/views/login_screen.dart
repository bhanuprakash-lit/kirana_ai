import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kirana_ai/features/support/providers/notification_provider.dart';

import '../../../core/theme/brand_theme.dart';
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
                child: const Icon(Icons.storefront_rounded,
                    size: 26, color: Colors.white),
              ).animate().scale(
                    begin: const Offset(0.5, 0.5),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(height: 28),
              Text('Welcome back',
                      style: Theme.of(context).textTheme.headlineMedium)
                  .animate(delay: 50.ms)
                  .fadeIn()
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 6),
              Text('Sign in to your Kirana AI account.',
                      style: Theme.of(context).textTheme.bodyMedium)
                  .animate(delay: 100.ms)
                  .fadeIn(),
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
                      fontWeight: FontWeight.w800, fontSize: 14),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.phone_rounded, size: 18),
                      text: 'Phone OTP',
                    ),
                    Tab(
                      icon: Icon(Icons.email_outlined, size: 18),
                      text: 'Email',
                    ),
                  ],
                ),
              ).animate(delay: 150.ms).fadeIn(),
              const SizedBox(height: 24),

              SizedBox(
                height: 340,
                child: TabBarView(
                  controller: _tab,
                  children: const [
                    _PhoneLoginForm(),
                    _EmailLoginForm(),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/onboarding'),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Create one',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
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
      setState(() => _error = 'Enter your phone number');
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
        // Auto-retrieved OTP (Android only)
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
    final cred = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: code,
    );
    await _signInWithCredential(cred);
  }

  Future<void> _signInWithCredential(PhoneAuthCredential cred) async {
    try {
      final userCred =
          await FirebaseAuth.instance.signInWithCredential(cred);
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

      ref.read(notificationServiceProvider).uploadToken();
      ref.invalidate(subscriptionProvider);
      context.go('/home');
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
        _error = 'Something went wrong. Please try again.';
      });
    }
  }

  String _firebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Invalid phone number. Include country code (e.g. +91...).';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-verification-code':
        return 'Wrong OTP. Please check and try again.';
      case 'session-expired':
        return 'OTP expired. Tap Resend to get a new code.';
      default:
        return e.message ?? 'Verification failed. Try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step == _PhoneStep.enterPhone) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandTextField(
            controller: _phoneCtrl,
            label: 'Phone number',
            hint: '9876543210',
            keyboardType: TextInputType.phone,
            autofillHints: const [],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('+91',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: BrandColors.ink)),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            _ErrorBanner(message: _error!),
          ],
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Send OTP',
            isLoading: _loading,
            onPressed: _sendOtp,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'We\'ll send a one-time password to this number',
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
              child: const Icon(Icons.arrow_back_rounded,
                  size: 20, color: BrandColors.muted),
            ),
            const SizedBox(width: 8),
            Text(
              'OTP sent to ${_phoneCtrl.text.trim()}',
              style: const TextStyle(
                  fontSize: 13,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BrandTextField(
          controller: _otpCtrl,
          label: '6-digit OTP',
          hint: '------',
          keyboardType: TextInputType.number,
          focusNode: _otpFocusNode,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          _ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Verify OTP',
          isLoading: _loading,
          onPressed: _verifyOtp,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _loading ? null : _sendOtp,
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                  color: BrandColors.primary, fontWeight: FontWeight.w700),
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
      await ref.read(authRepositoryProvider).login(
            username: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
      ref.read(notificationServiceProvider).uploadToken();
      ref.invalidate(subscriptionProvider);
      if (mounted) context.go('/home');
    } on ApiException catch (e) {
      setState(() {
        _error = e.statusCode == 401
            ? 'Incorrect username or password. Please try again.'
            : 'Login failed: ${e.message}';
      });
    } catch (_) {
      setState(() {
        _error = 'Could not connect to the server. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandTextField(
            controller: _emailCtrl,
            label: 'Username / Email',
            hint: 'mystore or you@example.com',
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Username is required' : null,
          ),
          const SizedBox(height: 14),
          BrandTextField(
            controller: _passwordCtrl,
            label: 'Password',
            hint: 'Your password',
            obscureText: !_showPassword,
            suffix: IconButton(
              icon: Icon(
                _showPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: BrandColors.muted,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _showPassword = !_showPassword),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Password is required' : null,
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            _ErrorBanner(message: _error!),
          ],
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Sign In',
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
        border:
            Border.all(color: BrandColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: BrandColors.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  fontSize: 13,
                  color: BrandColors.error,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
