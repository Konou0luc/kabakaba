import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/phone_e164.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../features/profile/data/user_repository.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/auth_scaffold.dart';
import '../../data/auth_provider.dart';
import '../../data/signup_draft.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _otpKey = GlobalKey<KabaOtpFieldState>();
  bool _isOTPSent = false;
  bool _isLoginMode = false;
  bool _busy = false;
  String _otpCode = '';
  int _timerSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(signupDraftProvider);
    if (draft.phone.isNotEmpty) {
      _phoneController.text = formatTogoDisplay(draft.phone);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  String get _e164 => toTogoE164(_phoneController.text);

  void _startTimer() {
    setState(() => _timerSeconds = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _sendOtp() async {
    final digits = toTogoLocalDigits(_phoneController.text);
    if (digits.length < 8) {
      ToastHelper.showError('Veuillez entrer un numéro valide');
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(authProvider.notifier).sendOtp(phone: _e164);
      ref.read(signupDraftProvider.notifier).setPhone(_e164);
      if (!mounted) return;
      setState(() {
        _isOTPSent = true;
        _otpCode = '';
      });
      _otpKey.currentState?.clear();
      _startTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _otpKey.currentState?.requestFocus();
      });
    } catch (error) {
      ToastHelper.showError(apiErrorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _applySignupNames() async {
    final draft = ref.read(signupDraftProvider);
    final user = ref.read(currentUserProvider);
    if (user == null || draft.firstName.trim().isEmpty) return;
    if (user.firstName != null && user.firstName!.trim().isNotEmpty) return;
    final updated = await ref
        .read(userRepositoryProvider)
        .updateUser(
          id: user.id,
          firstName: draft.firstName,
          lastName: draft.lastName,
        );
    ref.read(authProvider.notifier).updateCurrentUser(updated);
  }

  Future<void> _verifyOtp() async {
    final code = _otpCode.length == 6
        ? _otpCode
        : (_otpKey.currentState?.code ?? '');
    if (code.length < 6) {
      ToastHelper.showError('Entre les 6 chiffres du SMS');
      return;
    }
    setState(() => _busy = true);
    ref.read(signupDraftProvider.notifier).setOtp(code);

    if (!_isLoginMode) {
      if (mounted) setState(() => _busy = false);
      context.go('/auth/identity');
      return;
    }

    final draft = ref.read(signupDraftProvider);
    try {
      await ref
          .read(authProvider.notifier)
          .verifyOtp(
            phone: _e164,
            code: code,
            campusId: draft.campusId,
            referralCode: draft.referralCode,
          );
      await _applySignupNames();
      if (!mounted) return;
      if (draft.campusId != null) {
        context.go('/auth/account-confirmation');
      } else {
        context.go('/home');
      }
    } catch (error) {
      if (isCampusRequiredError(error)) {
        if (!mounted) return;
        context.go('/auth/identity');
      } else {
        ToastHelper.showError(apiErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _goBack() {
    if (_isOTPSent) {
      setState(() {
        _isOTPSent = false;
        _otpCode = '';
        _timer?.cancel();
      });
      _otpKey.currentState?.clear();
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/onboarding');
    }
  }

  Widget _phoneBody() {
    return KabaPhoneField(
      label: 'Numéro de téléphone',
      controller: _phoneController,
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _phoneFooter() {
    return Column(
      children: [
        KabaButton(
          text: 'Continuer',
          isLoading: _busy,
          onPressed: _busy ? null : _sendOtp,
          trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 16),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _isLoginMode = !_isLoginMode),
          child: Text.rich(
            TextSpan(
              style: AppTextStyles.footLink,
              children: _isLoginMode
                  ? [
                      const TextSpan(text: 'Pas encore de compte ? '),
                      TextSpan(
                        text: 'Créer un compte',
                        style: AppTextStyles.footLink.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ]
                  : [
                      const TextSpan(text: 'Déjà un compte ? '),
                      TextSpan(
                        text: 'Se connecter',
                        style: AppTextStyles.footLink.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
            ),
            textAlign: TextAlign.center,
          ),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _otpBody() {
    return Column(
      children: [
        Text(
          AppTextStyles.fieldLabelText('Code SMS'),
          style: AppTextStyles.fieldLabel,
        ),
        const SizedBox(height: 12),
        KabaOtpField(
          key: _otpKey,
          enabled: !_busy,
          onChanged: (value) => _otpCode = value,
          onCompleted: (value) {
            _otpCode = value;
            _verifyOtp();
          },
        ),
        const SizedBox(height: 18),
        Center(
          child: _timerSeconds > 0
              ? RichText(
                  text: TextSpan(
                    style: AppTextStyles.footLink.copyWith(fontSize: 12.5),
                    children: [
                      const TextSpan(text: 'Renvoyer le code dans '),
                      TextSpan(
                        text: '00:${_timerSeconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              : TextButton(
                  onPressed: _busy ? null : _sendOtp,
                  child: Text(
                    'Renvoyer le code',
                    style: AppTextStyles.footLink.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ).animate().fadeIn(delay: 160.ms),
      ],
    );
  }

  Widget _otpFooter() {
    return KabaButton(
      text: _isLoginMode ? 'Vérifier le code' : 'Continuer',
      isLoading: _busy,
      onPressed: _busy ? null : _verifyOtp,
    ).animate().fadeIn(delay: 240.ms).slideY(begin: 0.1, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SignupDraft>(signupDraftProvider, (previous, next) {
      if (next.phone.isEmpty && _isOTPSent) {
        setState(() {
          _isOTPSent = false;
          _otpCode = '';
        });
        _otpKey.currentState?.clear();
      }
    });

    final totalSteps = _isLoginMode ? 2 : 5;

    if (!_isOTPSent) {
      return AuthScaffold(
        currentStep: 1,
        totalSteps: totalSteps,
        heroIcon: Icons.smartphone_rounded,
        heroTitle: _isLoginMode ? 'Connecte-toi' : 'Crée ton compte',
        heroSubtitle: _isLoginMode
            ? 'Entre ton numéro pour recevoir un code de connexion par SMS.'
            : 'Entre ton numéro pour recevoir un code de vérification par SMS.',
        showBackButton: true,
        onBack: _goBack,
        body: _phoneBody(),
        footer: _phoneFooter(),
      );
    }
    return AuthScaffold(
      currentStep: 2,
      totalSteps: totalSteps,
      heroIcon: Icons.lock_rounded,
      heroTitle: 'Vérifie ton numéro',
      heroSubtitle: 'Code envoyé par SMS au +228 ${_phoneController.text}.',
      showBackButton: true,
      onBack: _goBack,
      body: _otpBody(),
      footer: _otpFooter(),
    );
  }
}
