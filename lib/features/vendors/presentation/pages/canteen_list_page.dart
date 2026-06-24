import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_input.dart';

import '../../../../shared/widgets/kaba_background.dart';

class CanteenListPage extends StatelessWidget {
  const CanteenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les cantines'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: const KabaInput(
                    hintText: 'Rechercher une cantine ou un menu...',
                    prefixIcon: Icon(AppIcons.search, color: AppColors.grey),
                  ).animate().fadeIn(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: KabaCard(
                        padding: EdgeInsets.zero,
                        onTap: () => context.push('/canteen-detail'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.greyLightDarkMode
                                    : AppColors.greyLight,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.restaurant_rounded,
                                  size: 40,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Cantine #${index + 1}',
                                        style: AppTextStyles.h3,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'Ouvert',
                                          style: AppTextStyles.labelMedium
                                              .copyWith(
                                                color: AppColors.success,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 14,
                                        color: AppColors.warning,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.${index % 5 + 5} (50 avis)',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: AppColors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '10-15 min',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: (200 + (index * 100)).ms);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
