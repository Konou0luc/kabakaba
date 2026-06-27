import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';

class RechargeStep3Page extends StatelessWidget {
  final Map<String, dynamic> data;

  const RechargeStep3Page({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final beneficiaryType = data['beneficiaryType'] as String;
    final amount = data['amount'] as int;
    final friendUid = data['friendUid'] as String?;
    final paymentMethod = data['paymentMethod'] as String?;

    return KabaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : AppColors.primary,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Récapitulatif',
            style: AppTextStyles.h3.copyWith(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Recap Card
                KabaCard(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryItem(
                        label: 'Bénéficiaire',
                        value: beneficiaryType == 'self'
                            ? 'Moi-même'
                            : 'Kofi Amegan (ami)',
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppSpacing.l),
                      if (beneficiaryType == 'friend') ...[
                        _SummaryItem(
                          label: 'UID',
                          value: friendUid ?? '',
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.l),
                      ],
                      _SummaryItem(
                        label: 'Montant',
                        value: '$amount tickets',
                        isDark: isDark,
                        isAmount: true,
                      ),
                      const SizedBox(height: AppSpacing.l),
                      _SummaryItem(
                        label: 'Équivalent',
                        value: '$amount FCFA',
                        isDark: isDark,
                      ),
                      if (beneficiaryType == 'friend') ...[
                        const SizedBox(height: AppSpacing.l),
                        _SummaryItem(
                          label: 'Paiement via',
                          value: paymentMethod == 'balance'
                              ? 'Mon solde'
                              : 'Mobile Money (Flooz / Moov)',
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.l),
                      ],
                      _SummaryItem(
                        label: 'Crédit après',
                        value: 'Immédiat ✓',
                        isDark: isDark,
                        isSuccess: true,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.l),
                // Info Card
                Container(
                      padding: const EdgeInsets.all(AppSpacing.l),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: AppRadius.largeBorderRadius,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 20,
                            color: isDark
                                ? Colors.white54
                                : AppColors.textSecondaryLight,
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              'Cette opération est irréversible. Vérifie bien les informations avant de confirmer.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? Colors.white60
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.xl),
                KabaButton(
                      text: 'Confirmer et payer',
                      icon: Icons.lock_outline,
                      onPressed: () {
                        context.push('/recharge/confirmation', extra: data);
                      },
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 200.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.m),
                Center(
                  child:
                      TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              'Modifier',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 250.ms)
                          .slideY(begin: 0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isAmount;
  final bool isSuccess;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.isDark,
    this.isAmount = false,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Flexible(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyLarge.copyWith(
              color: isSuccess
                  ? AppColors.success
                  : (isDark ? Colors.white : AppColors.textPrimaryLight),
              fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
