import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/auth_scaffold.dart';
import '../../data/signup_draft.dart';

class IdentityPage extends ConsumerStatefulWidget {
  const IdentityPage({super.key});

  @override
  ConsumerState<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends ConsumerState<IdentityPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(signupDraftProvider);
    _firstNameController = TextEditingController(text: draft.firstName);
    _lastNameController = TextEditingController(text: draft.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _continue() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    if (first.isEmpty || last.isEmpty) {
      ToastHelper.showError('Veuillez remplir tous les champs');
      return;
    }
    ref
        .read(signupDraftProvider.notifier)
        .setNames(firstName: first, lastName: last);
    context.go('/auth/campus-selection');
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
            hintText: 'Prénom',
            controller: _firstNameController,
            textCapitalization: TextCapitalization.words,
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 16),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 15),
          KabaInput(
            label: 'Nom',
            hintText: 'Nom',
            controller: _lastNameController,
            textCapitalization: TextCapitalization.words,
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 16),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
        ],
      ),
      footer: KabaButton(
        text: 'Continuer',
        onPressed: _continue,
        trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 16),
      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
    );
  }
}
