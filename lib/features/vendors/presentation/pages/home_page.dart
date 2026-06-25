import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;
  static const String _balance = '15 000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KabaBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bonjour, Luc 👋', style: AppTextStyles.h2),
                              Row(
                                children: [
                                  const Icon(
                                    AppIcons.location,
                                    size: 14,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Campus de Cocody',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.push('/notifications'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.greyLight
                                      : AppColors.greyLightDarkMode,
                                ),
                              ),
                              child: Icon(
                                AppIcons.notification,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 24),
                      KabaCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                   
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Solde tickets',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: AppColors.grey,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _isBalanceVisible
                                                ? '$_balance tickets'
                                                : '••••••••',
                                            style: AppTextStyles.h2.copyWith(
                                              color: AppColors.textPrimary(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isBalanceVisible =
                                              !_isBalanceVisible;
                                        });
                                      },
                                      icon: Icon(
                                        _isBalanceVisible
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: KabaButton(
                                        text: 'Recharger',
                                        onPressed: () {
                                          context.push('/recharge-wallet');
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: KabaButton(
                                        text: 'Historique',
                                        onPressed: () {
                                          context.push('/transaction-history');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 24),
                      Text(
                        'Services',
                        style: AppTextStyles.h3,
                      ).animate().fadeIn(delay: 300.ms),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _CategoryItem(
                              icon: Icons.restaurant_menu_rounded,
                              label: 'Cantines',
                            ),
                            _CategoryItem(
                              icon: Icons.help_outline_rounded,
                              label: 'Aide',
                            ),
                            _CategoryItem(
                              icon: Icons.refresh_rounded,
                              label: 'Recharger',
                            ),
                            _CategoryItem(
                              icon: Icons.view_agenda_rounded,
                              label: 'Tout voir',
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cantines populaires', style: AppTextStyles.h3),
                          TextButton(
                            onPressed: () => context.push('/canteen-list'),
                            child: Text(
                              'Voir plus',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 500.ms),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                                  width: 280,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: KabaCard(
                                    padding: EdgeInsets.zero,
                                    onTap: () =>
                                        context.push('/canteen-detail'),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 120,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                ),
                                            child: Image.asset(
                                              index % 3 == 0
                                                  ? 'assets/images/onboarding1.webp'
                                                  : index % 3 == 1
                                                  ? 'assets/images/onboarding2.webp'
                                                  : 'assets/images/onbording.webp',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: AppColors.greyLight,
                                                  child: const Icon(
                                                    Icons.restaurant_rounded,
                                                    size: 40,
                                                    color: AppColors.primary,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Cantine Centrale',
                                                    style: AppTextStyles.h3,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.success
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      'Ouvert',
                                                      style: AppTextStyles
                                                          .labelMedium
                                                          .copyWith(
                                                            color: AppColors
                                                                .success,
                                                            fontSize: 10,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    AppIcons.star,
                                                    size: 12,
                                                    color: AppColors.warning,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '4.8 (120 avis)',
                                                    style:
                                                        AppTextStyles.bodySmall,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Icon(
                                                    Icons.access_time_rounded,
                                                    size: 12,
                                                    color: AppColors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '15-20 min',
                                                    style:
                                                        AppTextStyles.bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(delay: (600 + (index * 100)).ms)
                                .slideX(begin: 0.1, end: 0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: KabaCard(
                    color: AppColors.surfaceSecondary(context),
                    padding: const EdgeInsets.all(14),
                    onTap: () => context.push('/ambassador-presentation'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? AppColors.white
                                : AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: AppColors.accent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Devenez Ambassadeur',
                                style: AppTextStyles.h3,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Gagnez des commissions sur chaque commande',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.greyDark
                                      : AppColors.textSecondaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.textPrimary(context),
                          size: 18,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1, end: 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.soft,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
