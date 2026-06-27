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

class RechargeStep1Page extends StatelessWidget {
  const RechargeStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            'Recharger le portefeuille',
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
                // Balance Card
                KabaCard(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Solde actuel',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? Colors.white60
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '5 200',
                              style: AppTextStyles.h2.copyWith(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'tickets',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.credit_card,
                          color: isDark ? Colors.white70 : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.xl * 1.5),
                Text(
                      'Pour qui ?',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.l),
                // Beneficiary Cards
                Row(
                  children: [
                    Expanded(
                      child:
                          _BeneficiaryCard(
                                icon: Icons.person,
                                label: 'Mon compte',
                                subtitle: "Recharger mon propre solde",
                                isSelf: true,
                                onTap: () =>
                                    context.push('/recharge/step2/self'),
                              )
                              .animate()
                              .fadeIn(duration: 300.ms, delay: 200.ms)
                              .slideY(begin: 0.1),
                    ),
                    const SizedBox(width: AppSpacing.l),
                    Expanded(
                      child:
                          _BeneficiaryCard(
                                icon: Icons.people,
                                label: 'Un ami',
                                subtitle: "Recharger le compte d'un proche",
                                isSelf: false,
                                onTap: () =>
                                    context.push('/recharge/step2/friend'),
                              )
                              .animate()
                              .fadeIn(duration: 300.ms, delay: 300.ms)
                              .slideY(begin: 0.1),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl * 1.5),
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
                            Icons.info_outline,
                            size: 20,
                            color: isDark
                                ? Colors.white54
                                : AppColors.textSecondaryLight,
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              '1 ticket = 1 FCFA. Le rechargement est immédiat et non remboursable après confirmation.',
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
                    .fadeIn(duration: 300.ms, delay: 400.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.xl),
                KabaButton(
                      text: 'Continuer',
                      icon: Icons.arrow_forward,
                      onPressed: () => context.push('/recharge/step2/self'),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 500.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BeneficiaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelf;
  final VoidCallback onTap;

  const _BeneficiaryCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelf,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KabaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: isSelf
                  ? (isDark
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.1))
                  : (isDark
                        ? AppColors.accent.withValues(alpha: 0.2)
                        : AppColors.accent.withValues(alpha: 0.1)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelf ? AppColors.primary : AppColors.accent,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
