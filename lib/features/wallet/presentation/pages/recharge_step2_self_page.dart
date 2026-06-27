import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_input.dart';

class RechargeStep2SelfPage extends StatefulWidget {
  const RechargeStep2SelfPage({super.key});

  @override
  State<RechargeStep2SelfPage> createState() => _RechargeStep2SelfPageState();
}

class _RechargeStep2SelfPageState extends State<RechargeStep2SelfPage> {
  final _amountController = TextEditingController();
  int? _selectedAmount;

  final List<int> _quickAmounts = [500, 1000, 2000, 5000, 10000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

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
            'Montant de recharge',
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
                // Amount Input
                KabaInput(
                      label: 'Montant à recharger',
                      controller: _amountController,
                      hintText: '0',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        setState(() {
                          _selectedAmount = null;
                        });
                      },
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.l),
                // Quick Amounts
                Wrap(
                      spacing: AppSpacing.s,
                      runSpacing: AppSpacing.s,
                      children: _quickAmounts.map((amount) {
                        return _QuickAmountButton(
                          amount: amount,
                          isSelected: _selectedAmount == amount,
                          onTap: () {
                            setState(() {
                              _selectedAmount = amount;
                              _amountController.text = amount.toString();
                            });
                          },
                        );
                      }).toList(),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 200.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.l),
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
                              'Montant minimum: 500 tickets. Le paiement sera effectué via Mobile Money (Flooz / Moov).',
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
                    .fadeIn(duration: 300.ms, delay: 300.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.xl),
                KabaButton(
                      text: 'Voir le récapitulatif',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        final amount = int.tryParse(_amountController.text);
                        if (amount != null && amount >= 500) {
                          context.push(
                            '/recharge/step3',
                            extra: {
                              'beneficiaryType': 'self',
                              'amount': amount,
                            },
                          );
                        }
                      },
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 400.ms)
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

class _QuickAmountButton extends StatelessWidget {
  final int amount;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickAmountButton({
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.05)),
          borderRadius: AppRadius.largeBorderRadius,
        ),
        child: Text(
          '$amount',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : AppColors.primary),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
