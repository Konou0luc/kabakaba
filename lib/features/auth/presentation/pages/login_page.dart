import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/auth_scaffold.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  bool _isOTPSent = false;
  int _timerSeconds = 38;
  Timer? _timer;
  final List<String> _otpCode = ['', '', '', ''];
  final List<FocusNode> _otpFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  final List<TextEditingController> _otpControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    for (var ctrl in _otpControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _timerSeconds = 38;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _formatPhoneForDisplay(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 2) {
      return digits;
    }
    if (digits.length <= 4) {
      return '${digits.substring(0, 2)} ${digits.substring(2)}';
    }
    if (digits.length <= 6) {
      return '${digits.substring(0, 2)} ${digits.substring(2, 4)} ${digits.substring(4)}';
    }
    return '${digits.substring(0, 2)} ${digits.substring(2, 4)} ${digits.substring(4, 6)} ${digits.substring(6)}';
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KabaInput(
          label: 'Numéro de téléphone',
          hintText: '90 12 34 56',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          prefixWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🇹🇬 +228',
                style: AppTextStyles.inputText.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 9),
              Container(width: 1, height: 20, color: AppColors.line),
              const SizedBox(width: 10),
            ],
          ),
          maxLength: 8,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            final formatted = _formatPhoneForDisplay(val);
            if (formatted != _phoneController.text) {
              _phoneController.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }
          },
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
        const SizedBox(height: 28),
        KabaButton(
          text: 'Continuer',
          onPressed: () {
            final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
            if (digits.length < 8) {
              ToastHelper.showError('Veuillez entrer un numéro valide');
              return;
            }
            setState(() => _isOTPSent = true);
            _startTimer();
            final currentContext = context;
            Future.delayed(const Duration(milliseconds: 300), () {
              if (!currentContext.mounted) return;
              FocusScope.of(currentContext).requestFocus(_otpFocusNodes[0]);
            });
          },
          trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 16),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 14),
        Center(
          child: TextButton(
            onPressed: () {
              ToastHelper.showInfo('🦄 Mode DÉMO : saut complet du flow');
              ref.read(authProvider.notifier).continueAsDemoUser();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/home');
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('[DÉMO] Aller directement à l\'accueil'),
          ),
        ),
        const SizedBox(height: 2),
        Center(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.footLink,
              children: [
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
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isFilled = _otpCode[index].isNotEmpty;
            final hasCursor = _otpFocusNodes[index].hasFocus && !isFilled;
            return Padding(
              padding: EdgeInsets.only(right: index < 3 ? 9 : 0),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_otpFocusNodes[index]);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    OTPBox(
                      value: _otpCode[index],
                      isFilled: isFilled,
                      hasCursor: hasCursor,
                    ),
                    SizedBox(
                      width: 40,
                      height: 48,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.transparent,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _otpCode[index] = value;
                          });
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_otpFocusNodes[index + 1]);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
        const SizedBox(height: 16),
        Center(
          child: RichText(
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
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 6),
        if (_timerSeconds == 0)
          Center(
            child: TextButton(
              onPressed: () {
                _startTimer();
                ToastHelper.showInfo('Code renvoyé !');
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.white,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Renvoyer le code'),
            ),
          ),
        const SizedBox(height: 36),
        KabaButton(
          text: 'Vérifier le code',
          onPressed: () {
            final code = _otpCode.join();
            if (code.length < 4) {
              ToastHelper.showError('Veuillez entrer le code complet');
              return;
            }
            ToastHelper.showSuccess('Vérification réussie !');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/auth/identity');
            });
          },
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {
              ToastHelper.showInfo('🦄 MODE DÉMO : OTP bypassé');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/auth/identity');
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              textStyle: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('[DÉMO] Sauter la vérification OTP'),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOTPSent) {
      return AuthScaffold(
        currentStep: 1,
        totalSteps: 5,
        heroIcon: Icons.smartphone_rounded,
        heroTitle: 'Crée ton compte',
        heroSubtitle:
            'Entre ton numéro pour recevoir un code de vérification par SMS.',
        showBackButton: false,
        body: _buildPhoneStep(),
      );
    } else {
      return AuthScaffold(
        currentStep: 2,
        totalSteps: 5,
        heroIcon: Icons.lock_rounded,
        heroTitle: 'Vérifie ton numéro',
        heroSubtitle: 'Code envoyé par SMS au +228 ${_phoneController.text}.',
        showBackButton: true,
        onBack: () {
          setState(() {
            _isOTPSent = false;
            _timer?.cancel();
            for (var i = 0; i < 4; i++) {
              _otpCode[i] = '';
              _otpControllers[i].clear();
            }
          });
        },
        body: _buildOtpStep(),
      );
    }
  }
}
