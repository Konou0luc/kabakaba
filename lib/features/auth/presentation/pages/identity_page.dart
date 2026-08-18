import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/auth_scaffold.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key});

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      currentStep: 3,
      totalSteps: 5,
      heroIcon: Icons.person_outline_rounded,
      heroTitle: 'Comment t\'appelles-tu ?',
      heroSubtitle: 'Ces informations créent ton profil étudiant kabakaba.',
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KabaInput(
            label: 'Prénom(s)',
            hintText: 'Koffi',
            controller: _firstNameController,
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 16),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 15),
          KabaInput(
            label: 'Nom',
            hintText: 'Mensah',
            controller: _lastNameController,
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 16),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 30),
          KabaButton(
            text: 'Continuer',
            onPressed: () {
              if (_firstNameController.text.trim().isEmpty ||
                  _lastNameController.text.trim().isEmpty) {
                ToastHelper.showError('Veuillez remplir tous les champs');
                return;
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/auth/campus-selection');
              });
            },
            trailingIcon: const Icon(
              Icons.arrow_forward_rounded,
              size: 16,
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
