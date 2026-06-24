import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();

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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'À qui voulez-vous envoyer ?',
                  style: AppTextStyles.h2,
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 32),
                KabaCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Numéro de téléphone', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '01 23 45 67 89',
                          prefixIcon: const Icon(Icons.phone_rounded),
                          filled: true,
                          fillColor: AppColors.background(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(),
                const SizedBox(height: 24),
                KabaCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Montant', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0 FCFA',
                          prefixIcon: const Icon(Icons.attach_money_rounded),
                          filled: true,
                          fillColor: AppColors.background(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(),
                const Spacer(),
                KabaButton(
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
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
