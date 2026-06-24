import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
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

  final _amounts = const [1000, 2000, 5000, 10000, 20000, 50000];

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
                const Spacer(),
                KabaButton(
                  text: 'Continuer',
                  onPressed: _selectedAmount == null
                      ? null
                      : () {
                          context.push('/payment');
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

  const _PaymentMethodCard({
    required this.icon,
    required this.name,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return KabaCard(
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
    );
  }
}
