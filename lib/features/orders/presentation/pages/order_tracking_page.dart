import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_button.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de commande'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 80,
                        color: AppColors.success,
                      ),
                    ).animate().scale(
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Commande confirmée!',
                      style: AppTextStyles.h2,
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 12),
                    Text(
                      'Votre commande est en préparation',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.grey,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 48),
                    _OrderStatusStepper().animate().fadeIn(delay: 600.ms),
                  ],
                ),
              ),
              KabaButton(
                text: 'Retour à l\'accueil',
                onPressed: () {
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderStatusStepper extends StatelessWidget {
  const _OrderStatusStepper();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatusStep(title: 'Commande confirmée', isCompleted: true),
        _StatusStep(title: 'En préparation', isCompleted: true),
        _StatusStep(title: 'Prête à récupérer', isCompleted: false),
        _StatusStep(title: 'Terminée', isCompleted: false, isLast: true),
      ],
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isLast;

  const _StatusStep({
    required this.title,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? AppColors.success : AppColors.greyLight,
          ),
          child: isCompleted
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
              : null,
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 60,
            color: isCompleted ? AppColors.success : AppColors.greyLight,
          ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isCompleted ? AppColors.textPrimary(context) : AppColors.grey,
              fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
