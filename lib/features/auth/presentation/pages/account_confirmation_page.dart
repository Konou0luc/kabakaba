import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_background.dart';

class AccountConfirmationPage extends StatefulWidget {
  const AccountConfirmationPage({super.key});

  @override
  State<AccountConfirmationPage> createState() =>
      _AccountConfirmationPageState();
}

class _AccountConfirmationPageState extends State<AccountConfirmationPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/home');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: KabaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 60,
                    ),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 24),
                  Text(
                    'Bienvenue !',
                    style: AppTextStyles.h1,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                  const SizedBox(height: 12),
                  Text(
                    'Ton compte kabakaba est prêt. Tu peux commander tes repas dans les cantines dès maintenant.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.greyDark,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
