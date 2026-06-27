import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';

import '../../../../shared/widgets/kaba_background.dart';

class AmbassadorDashboardPage extends StatelessWidget {
  const AmbassadorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary(context),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('Programme Ambassadeur'),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card: Total Gains
                      KabaCard(
                        padding: const EdgeInsets.all(AppSpacing.l),
                        color: AppColors.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gains totaux',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '12 500 FCFA',
                                  style: AppTextStyles.h1.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.monetization_on_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                      const SizedBox(height: AppSpacing.l),
                      // Stats Cards Row
                      Row(
                            children: [
                              Expanded(
                                child: KabaCard(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Inscriptions',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '42',
                                        style: AppTextStyles.h2.copyWith(
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(
                                child: KabaCard(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Commandes',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '78',
                                        style: AppTextStyles.h2.copyWith(
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: AppSpacing.l),
                      Text(
                        'Actions rapides',
                        style: AppTextStyles.h3,
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: AppSpacing.m),
                      Row(
                            children: [
                              Expanded(
                                child: KabaCard(
                                  padding: const EdgeInsets.all(12),
                                  onTap: () => context.push('/promo-code'),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceSecondary(
                                            context,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.local_offer_rounded,
                                          color: AppColors.accent,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Mon code',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(
                                child: KabaCard(
                                  padding: const EdgeInsets.all(12),
                                  onTap: () =>
                                      context.push('/ambassador-stats'),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.greyDarkMode
                                              : AppColors.primary.withValues(
                                                  alpha: 0.1,
                                                ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.bar_chart_rounded,
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.primary,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Statistiques',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(
                                child: KabaCard(
                                  padding: const EdgeInsets.all(12),
                                  onTap: () =>
                                      context.push('/commission-history'),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(
                                            alpha: 0.1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.history_edu_rounded,
                                          color: AppColors.success,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Commissions',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                          .animate()
                          .fadeIn(delay: 500.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: AppSpacing.l),
                      // Last Commission
                      Text(
                        'Dernière commission',
                        style: AppTextStyles.h3,
                      ).animate().fadeIn(delay: 600.ms),
                      const SizedBox(height: AppSpacing.m),
                      KabaCard(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.add_circle_rounded,
                                    color: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.m),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Commande #1089',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Il y a 3 heures',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '+500 FCFA',
                                  style: AppTextStyles.h3.copyWith(
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 700.ms)
                          .slideX(begin: 0.1, end: 0),
                      const SizedBox(height: AppSpacing.l),
                      KabaButton(
                            text: 'Retirer mes gains',
                            onPressed: () {
                              ToastHelper.showSuccess(
                                'Gains transférés sur votre portefeuille !',
                              );
                            },
                          )
                          .animate()
                          .fadeIn(delay: 800.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: AppSpacing.l),
                    ],
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
