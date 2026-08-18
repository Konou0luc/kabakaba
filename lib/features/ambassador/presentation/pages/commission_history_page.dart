import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class CommissionHistoryPage extends StatelessWidget {
  const CommissionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Historique des commissions'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: KabaBackground(
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.l),
            itemCount: 10,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.l),
            itemBuilder: (context, index) {
              return _CommissionItem(index: index)
                  .animate()
                  .fadeIn(delay: (index * 100).ms)
                  .slideX(begin: 0.1, end: 0);
            },
          ),
        ),
      ),
    );
  }
}

class _CommissionItem extends StatelessWidget {
  final int index;

  const _CommissionItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return KabaCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              color: AppColors.success,
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
                  'Par Ami ${index + 1}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Il y a ${index + 1} jours',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+500 FCFA',
            style: AppTextStyles.h3.copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
