import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/kaba_background.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  int? _selectedAmount;

  final List<int> _quickAmounts = [500, 1000, 2000, 5000, 10000];

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer de l\'argent'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À qui voulez-vous envoyer ?',
                        style: AppTextStyles.h2,
                      ).animate().fadeIn().slideX(),
                      const SizedBox(height: AppSpacing.xl),
                      KabaInput(
                        controller: _phoneController,
                        label: 'Numéro de téléphone',
                        hintText: '01 23 45 67 89',
                        prefixIcon: const Icon(Icons.phone_rounded),
                        keyboardType: TextInputType.phone,
                      ).animate().fadeIn(delay: 200.ms).slideY(),
                      const SizedBox(height: AppSpacing.l),
                      KabaInput(
                        controller: _amountController,
                        label: 'Montant',
                        hintText: '0 FCFA',
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _selectedAmount = null;
                          });
                        },
                      ).animate().fadeIn(delay: 300.ms).slideY(),
                      const SizedBox(height: AppSpacing.l),
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
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: KabaButton(
                  text: 'Envoyer',
                  onPressed: () {
                    if (_phoneController.text.isNotEmpty &&
                        _amountController.text.isNotEmpty) {
                      ToastHelper.showSuccess(
                        'Envoi de ${_amountController.text} FCFA réussi !',
                      );
                      context.pop();
                    } else {
                      ToastHelper.showError('Veuillez remplir tous les champs');
                    }
                  },
                ).animate().fadeIn(delay: 500.ms),
              ),
            ],
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
