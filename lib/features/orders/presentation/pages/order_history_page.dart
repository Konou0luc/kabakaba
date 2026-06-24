import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_card.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: 5,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _OrderHistoryItem(index: index)
                .animate()
                .fadeIn(delay: (index * 100).ms)
                .slideX(begin: 0.1, end: 0);
          },
        ),
      ),
    );
  }
}

class _OrderHistoryItem extends StatelessWidget {
  final int index;

  const _OrderHistoryItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return KabaCard(
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.greyLightDarkMode : AppColors.greyLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commande #${1000 + index}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cantine Centrale',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Livrée',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('2 400 FCFA', style: AppTextStyles.h3),
              const SizedBox(height: 4),
              Text(
                'Il y a 2 jours',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
