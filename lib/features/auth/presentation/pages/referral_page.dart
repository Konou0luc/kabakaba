import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/auth_scaffold.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  final _referralController = TextEditingController();

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  void _goToConfirmation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/auth/account-confirmation');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      currentStep: 5,
      totalSteps: 5,
      heroIcon: Icons.card_giftcard_outlined,
      heroTitle: 'Qui t\'a invité ?',
      heroSubtitle:
          'Code d\'un ambassadeur kabakaba — entièrement facultatif.',
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KabaInput(
            label: 'Code de parrainage (optionnel)',
            hintText: 'ex. KOFFI2026',
            controller: _referralController,
            prefixIcon: const Icon(Icons.card_giftcard_outlined, size: 16),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 6),
          const HintBox(
            message:
                'Une fois ton compte créé, ce code ne pourra plus être modifié.',
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 30),
          KabaButton(
            text: 'Créer mon compte',
            onPressed: () {
              if (_referralController.text.trim().isNotEmpty) {
                ToastHelper.showSuccess('Code de parrainage accepté !');
              }
              _goToConfirmation();
            },
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 14),
          Center(
            child: TextButton(
              onPressed: _goToConfirmation,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.muted,
                textStyle: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Passer cette étape'),
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
