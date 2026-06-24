import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/step_indicator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  bool _isOTPSent = false;
  int _timerSeconds = 30;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _timerSeconds = 30;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _isOTPSent
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  setState(() {
                    _isOTPSent = false;
                    _timer?.cancel();
                  });
                },
              )
            : null,
      ),
      body: KabaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StepIndicator(
                  currentStep: _isOTPSent ? 2 : 1,
                  totalSteps: 5,
                ).animate().fadeIn(),
                const SizedBox(height: 24),
                Text(
                  'Etape ${_isOTPSent ? 2 : 1}/5',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.accent,
                  ),
                ).animate().fadeIn(),
                const SizedBox(height: 8),
                Text(
                  _isOTPSent ? 'Vérification' : 'Bienvenue sur KabaKaba',
                  style: AppTextStyles.h1,
                ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: 8),
                Text(
                  _isOTPSent
                      ? 'Entrez le code envoyé au ${_phoneController.text}'
                      : 'Entrez votre numéro de téléphone pour continuer.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.greyDark,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 48),
                if (!_isOTPSent) ...[
                  KabaInput(
                    label: 'Numéro de téléphone',
                    hintText: 'ex: 90 00 00 00',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone_iphone_rounded),
                          const SizedBox(width: 8),
                          Text(
                            '+228',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 20,
                            color: AppColors.greyLight,
                          ),
                        ],
                      ),
                    ),
                    maxLength: 8,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                ] else ...[
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: SizedBox(
                            width: 70,
                            child: KabaInput(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.length == 1 && index < 3) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                ],
                const Spacer(),
                KabaButton(
                  text: _isOTPSent ? 'Vérifier' : 'Recevoir le code',
                  onPressed: () {
                    if (!_isOTPSent) {
                      setState(() => _isOTPSent = true);
                      _startTimer();
                      ToastHelper.showSuccess('Code OTP envoyé avec succès !');
                    } else {
                      ToastHelper.showSuccess('Vérification réussie !');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.go('/auth/identity');
                      });
                    }
                  },
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),
                if (_isOTPSent)
                  Center(
                    child: _timerSeconds > 0
                        ? Text(
                            'Renvoyer le code dans $_timerSeconds s',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.greyDark,
                            ),
                          )
                        : KabaButton(
                            text: 'Renvoyer le code',
                            type: KabaButtonType.ghost,
                            onPressed: () {
                              _startTimer();
                              ToastHelper.showInfo('Code renvoyé !');
                            },
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
