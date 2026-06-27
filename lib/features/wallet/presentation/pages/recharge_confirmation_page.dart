import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_background.dart';

class RechargeConfirmationPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const RechargeConfirmationPage({super.key, required this.data});

  @override
  State<RechargeConfirmationPage> createState() =>
      _RechargeConfirmationPageState();
}

class _RechargeConfirmationPageState extends State<RechargeConfirmationPage> {
  @override
  void initState() {
    super.initState();

    // Show success toast
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastHelper.showSuccess(
        'Recharge de ${widget.data['amount']} tickets effectuée avec succès !',
      );
    });

    // Redirect to wallet after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/wallet');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KabaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 80,
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 32),
                  Text(
                    'Recharge effectuée !',
                    style: AppTextStyles.h1.copyWith(
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                  const SizedBox(height: 16),
                  Text(
                    'Redirection vers le portefeuille...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? Colors.white70
                          : AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
