import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/step_indicator.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key});

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
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
                  currentStep: 3,
                  totalSteps: 5,
                ).animate().fadeIn(),
                const SizedBox(height: 24),
                Text(
                  'Etape 3/5',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.accent,
                  ),
                ).animate().fadeIn(),
                const SizedBox(height: 8),
                Text(
                  'Comment t\'appelles-tu ?',
                  style: AppTextStyles.h1,
                ).animate().fadeIn().slideX(begin: -0.1),
                const SizedBox(height: 8),
                Text(
                  'Ces informations créent ton profil étudiant kabakaba.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.greyDark,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 48),
                KabaInput(
                  label: 'PRÉNOM(S)',
                  hintText: 'Koffi',
                  controller: _surnameController,
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),
                KabaInput(
                  label: 'NOM',
                  hintText: 'Mensah',
                  controller: _nameController,
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                const Spacer(),
                KabaButton(
                  text: 'Continuer →',
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go('/auth/campus-selection');
                    });
                  },
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
