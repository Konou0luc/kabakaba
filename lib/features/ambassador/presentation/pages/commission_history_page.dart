import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class CommissionHistoryPage extends ConsumerWidget {
  const CommissionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = (ref.watch(myTransactionsProvider).valueOrNull ?? const [])
        .where((tx) => tx.type == TransactionType.COMMISSION)
        .toList();

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
          child: txs.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Aucune commission pour le moment.'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  itemCount: txs.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.l),
                  itemBuilder: (context, index) {
                    final tx = txs[index];
                    final local = tx.createdAt.toLocal();
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
                                  tx.reference ?? 'Commission',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${local.day}/${local.month}/${local.year}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '+${formatTickets(tx.amount)}',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
