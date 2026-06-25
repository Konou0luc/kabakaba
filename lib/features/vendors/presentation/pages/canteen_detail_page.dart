import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_card.dart';

import '../../../../shared/widgets/kaba_background.dart';

class CanteenDetailPage extends StatelessWidget {
  const CanteenDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KabaBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      AppIcons.arrowLeft,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.greyLight,
                  child: const Icon(
                    Icons.restaurant_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cantine Centrale',
                          style: AppTextStyles.h1,
                        ).animate().fadeIn().slideX(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Ouvert',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          AppIcons.location,
                          size: 16,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Campus de Cocody, Bâtiment A',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Icon(
                            AppIcons.star,
                            size: 18,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.8 (120 avis)',
                            style: AppTextStyles.bodyLarge,
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: AppColors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text('15-20 min', style: AppTextStyles.bodyLarge),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 32),
                    Text(
                      'Menus disponibles',
                      style: AppTextStyles.h3,
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 16),
                    ...List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _MenuItemCard(index: index)
                            .animate()
                            .fadeIn(delay: (600 + (index * 100)).ms)
                            .slideY(begin: 0.2, end: 0),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final int index;

  const _MenuItemCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final images = [
      'assets/images/plat/plat1.webp',
      'assets/images/plat/plat2.webp',
      'assets/images/plat/plat3.webp',
      'assets/images/plat/plat4.webp',
    ];
    return KabaCard(
      onTap: () => context.push('/menu-detail'),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              images[index % images.length],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plat Attiéké', style: AppTextStyles.h3),
                const SizedBox(height: 6),
                Text(
                  'Attiéké avec poisson braisé et sauce pimentée',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Text(
                  '1 200 FCFA',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
