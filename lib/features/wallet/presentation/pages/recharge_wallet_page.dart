import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class RechargeWalletPage extends StatefulWidget {
  const RechargeWalletPage({super.key});

  @override
  State<RechargeWalletPage> createState() => _RechargeWalletPageState();
}

class _RechargeWalletPageState extends State<RechargeWalletPage> {
  int? _selectedAmount;
  int? _selectedPaymentMethod;

  final _amounts = const [1000, 2000, 5000, 10000, 20000, 50000];
  final _paymentMethods = const [
    {'name': 'MoMo', 'icon': Icons.phone_android_rounded},
    {'name': 'Orange Money', 'icon': Icons.phone_iphone_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recharger'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choisissez le montant',
                  style: AppTextStyles.h2,
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _amounts.length,
                  itemBuilder: (context, index) {
                    final amount = _amounts[index];
                    final isSelected = _selectedAmount == amount;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAmount = amount),
                      child: KabaCard(
                        padding: EdgeInsets.zero,
                        color: isSelected ? AppColors.primary : null,
                        child: Center(
                          child: Text(
                            '$amount\nFCFA',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textPrimary(context),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (index * 50).ms).scale();
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Méthode de paiement',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.greyDark,
                  ),
                ).animate().fadeIn(delay: 100.ms).slideX(),
                const SizedBox(height: 16),
                ...List.generate(_paymentMethods.length, (index) {
                  final payment = _paymentMethods[index];
                  final isSelected = _selectedPaymentMethod == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PaymentMethodCard(
                      icon: payment['icon'] as IconData,
                      name: payment['name'] as String,
                      isSelected: isSelected,
                      onTap: () =>
                          setState(() => _selectedPaymentMethod = index),
                    ),
                  ).animate().fadeIn(delay: (150 + index * 50).ms).slideX();
                }),
                const Spacer(),
                KabaButton(
                  text: 'Recharger',
                  onPressed:
                      (_selectedAmount == null ||
                          _selectedPaymentMethod == null)
                      ? null
                      : () async {
                          ToastHelper.showSuccess(
                            'Recharge effectuée avec succès!',
                          );
                          final navigator = Navigator.of(context);
                          await Future.delayed(const Duration(seconds: 1));
                          if (mounted) {
                            navigator.pop();
                          }
                        },
                ).animate().fadeIn(delay: 400.ms),
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
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: KabaCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(name, style: AppTextStyles.bodyLarge)),
            if (isSelected)
              Icon(AppIcons.check, color: AppColors.success, size: 28),
          ],
        ),
      ),
    );
  }
}
