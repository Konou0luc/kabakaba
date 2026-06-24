import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/step_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: KabaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepIndicator(
                  currentStep: 5,
                  totalSteps: 5,
                ).animate().fadeIn(),
                const SizedBox(height: 24),
                Text(
                  'Etape 5/5',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.accent,
                  ),
                ).animate().fadeIn(),
                const SizedBox(height: 8),
                Text(
                  'Qui t\'a invité ?',
                  style: AppTextStyles.h1,
                ).animate().fadeIn().slideX(begin: -0.1),
                const SizedBox(height: 8),
                Text(
                  'Si tu as un code de parrainage, entrez-le ici',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.greyDark,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 48),
                KabaInput(
                  label: 'Code de parrainage (optionnel)',
                  hintText: 'ex: KABA2025',
                  controller: _referralController,
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.greyDarkMode.withValues(alpha: 0.3)
                        : AppColors.surfaceSecondaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Une fois ton compte créé, ce code ne peut pas être modifié.',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const Spacer(),
                KabaButton(
                  text: 'Créer mon compte',
                  onPressed: () {
                    if (_referralController.text.trim().isNotEmpty) {
                      ToastHelper.showSuccess('Code de parrainage accepté !');
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go('/auth/account-confirmation');
                    });
                  },
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.go('/account-confirmation');
                      });
                    },
                    child: Text(
                      'Passer cette étape',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
