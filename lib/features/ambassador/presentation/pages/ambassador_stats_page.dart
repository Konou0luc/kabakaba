import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class AmbassadorStatsPage extends StatelessWidget {
  const AmbassadorStatsPage({super.key});

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
        title: const Text('Statistiques'),
        centerTitle: true,
      ),
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
                      // Overview Cards
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Total inscriptions',
                              value: '42',
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              title: 'Total commandes',
                              value: '78',
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 16),
                      Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Taux de conversion',
                                  value: '18%',
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  title: 'Moyenne / commande',
                                  value: '160 FCFA',
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: -0.1, end: 0),
                      const SizedBox(height: 32),
                      Text(
                        'Performance mensuelle',
                        style: AppTextStyles.h3,
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 16),
                      // Monthly Stats List
                      ...[
                        ('Janvier', 5),
                        ('Février', 8),
                        ('Mars', 12),
                        ('Avril', 15),
                        ('Mai', 2),
                      ].asMap().entries.map((entry) {
                        final index = entry.key;
                        final month = entry.value.$1;
                        final count = entry.value.$2;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _MonthlyStatItem(month: month, count: count)
                              .animate()
                              .fadeIn(delay: (500 + (index * 100)).ms)
                              .slideX(begin: 0.1, end: 0),
                        );
                      }),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return KabaCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h2.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _MonthlyStatItem extends StatelessWidget {
  final String month;
  final int count;

  const _MonthlyStatItem({required this.month, required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return KabaCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month, style: AppTextStyles.bodyLarge),
          Text(
            '$count inscriptions',
            style: AppTextStyles.bodyLarge.copyWith(
              color: isDark ? AppColors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
