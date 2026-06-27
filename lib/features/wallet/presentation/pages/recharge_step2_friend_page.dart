import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_input.dart';

class RechargeStep2FriendPage extends StatefulWidget {
  const RechargeStep2FriendPage({super.key});

  @override
  State<RechargeStep2FriendPage> createState() =>
      _RechargeStep2FriendPageState();
}

class _RechargeStep2FriendPageState extends State<RechargeStep2FriendPage> {
  final _uidController = TextEditingController();
  final _amountController = TextEditingController();
  int? _selectedAmount;
  String _selectedPaymentMethod = 'balance';

  final List<int> _quickAmounts = [500, 1000, 2000, 5000, 10000];

  @override
  void dispose() {
    _uidController.dispose();
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
            'Recharger un ami',
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
                // UID Input
                KabaInput(
                  label: 'UID de ton ami',
                  controller: _uidController,
                  hintText: 'Ex: KBK-4F92A',
                  prefixIcon: const Icon(
                    AppIcons.search,
                    color: AppColors.grey,
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.xs),
                Text(
                      "L'UID se trouve dans le profil de ton ami → \"Mon UID\"",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondaryLight,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.l),
                // Payment Methods
                Text(
                      'Payer avec',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 150.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.m),
                Row(
                  children: [
                    Expanded(
                      child:
                          _PaymentMethodCard(
                                icon: Icons.account_balance_wallet,
                                label: 'Mon solde',
                                subtitle: '5 200 tickets dispo.',
                                isSelected: _selectedPaymentMethod == 'balance',
                                onTap: () => setState(
                                  () => _selectedPaymentMethod = 'balance',
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 300.ms, delay: 200.ms)
                              .slideY(begin: 0.1),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child:
                          _PaymentMethodCard(
                                icon: Icons.phone_android,
                                label: 'Mobile Money',
                                subtitle: 'Flooz, Moov by Yoo',
                                isSelected:
                                    _selectedPaymentMethod == 'mobile_money',
                                onTap: () => setState(
                                  () => _selectedPaymentMethod = 'mobile_money',
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 300.ms, delay: 250.ms)
                              .slideY(begin: 0.1),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.l),
                // Amount Input
                KabaInput(
                      label: 'Montant à envoyer',
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
                    .fadeIn(duration: 300.ms, delay: 300.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.m),
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
                    .fadeIn(duration: 300.ms, delay: 350.ms)
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
                              'Les tickets seront crédités immédiatement sur le compte de ton ami après confirmation.',
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
                    .fadeIn(duration: 300.ms, delay: 400.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppSpacing.xl),
                KabaButton(
                      text: 'Voir le récapitulatif',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        final amount = int.tryParse(_amountController.text);
                        if (amount != null &&
                            amount >= 500 &&
                            _uidController.text.isNotEmpty) {
                          context.push(
                            '/recharge/step3',
                            extra: {
                              'beneficiaryType': 'friend',
                              'friendUid': _uidController.text,
                              'amount': amount,
                              'paymentMethod': _selectedPaymentMethod,
                            },
                          );
                        }
                      },
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 500.ms)
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

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KabaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.m),
      borderColor: isSelected ? AppColors.primary : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.primary.withValues(alpha: 0.05)),
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                            ? Colors.white60
                            : AppColors.textSecondaryLight),
                  size: 24,
                ),
                if (isSelected)
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
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
