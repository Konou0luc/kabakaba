import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_background.dart';

class PaymentPage extends StatelessWidget {
  final Map<String, dynamic>? data;

  const PaymentPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalPrice = data?['totalPrice'] as int? ?? 3700;

    return KabaBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Paiement'),
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
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 120,
                        color: isDark ? AppColors.white : AppColors.primary,
                      ).animate().scale(duration: 400.ms),
                      const SizedBox(height: 24),
                      Text(
                        'Payer avec mon portefeuille',
                        style: AppTextStyles.h2,
                      ).animate().fadeIn(delay: 300.ms),
                      const SizedBox(height: 12),
                      Text(
                        'Solde disponible: 25 000 FCFA',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.greyDark,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          '$totalPrice FCFA',
                          style: AppTextStyles.h1.copyWith(
                            color: isDark ? AppColors.white : AppColors.primary,
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms).scale(),
                    ],
                  ),
                ),
                KabaButton(
                  text: 'Confirmer le paiement',
                  onPressed: () {
                    ToastHelper.showSuccess(
                      'Paiement effectué ! Commande en cours.',
                    );
                    context.push('/order-history');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
