import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_card.dart';

import '../../../../shared/widgets/kaba_background.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des transactions'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: 10,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final isNegative = index % 2 == 0;
              return _TransactionHistoryItem(
                index: index,
                isNegative: isNegative,
              ).animate().fadeIn(delay: (index * 50).ms).slideX();
            },
          ),
        ),
      ),
    );
  }
}

class _TransactionHistoryItem extends StatelessWidget {
  final int index;
  final bool isNegative;

  const _TransactionHistoryItem({
    required this.index,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    return KabaCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isNegative ? AppColors.error : AppColors.success)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isNegative
                  ? Icons.arrow_outward_rounded
                  : Icons.arrow_downward_rounded,
              color: isNegative ? AppColors.error : AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNegative ? 'Envoi' : 'Rechargement',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  isNegative
                      ? 'À +225 01 23 45 67'
                      : 'Mobile Money',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isNegative ? '-' : '+'}${5000 + (index * 1000)} FCFA',
                style: AppTextStyles.h3.copyWith(
                  color: isNegative ? AppColors.error : AppColors.success,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                index == 0
                    ? 'Aujourd\'hui, 14h30'
                    : 'Il y a ${index + 1}h',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
