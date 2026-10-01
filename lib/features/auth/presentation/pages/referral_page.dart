import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../features/profile/data/user_repository.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/auth_scaffold.dart';
import '../../data/auth_provider.dart';
import '../../data/signup_draft.dart';

class ReferralPage extends ConsumerStatefulWidget {
  const ReferralPage({super.key});

  @override
  ConsumerState<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends ConsumerState<ReferralPage> {
  final _referralController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _createAccount({required bool skipReferral}) async {
    final draft = ref.read(signupDraftProvider);
    if (draft.phone.isEmpty || draft.otp.isEmpty || draft.campusId == null) {
      ToastHelper.showError('Session incomplète. Repars du numéro.');
      context.go('/auth');
      return;
    }
    setState(() => _busy = true);
    final referral = skipReferral ? '' : _referralController.text.trim();
    ref.read(signupDraftProvider.notifier).setReferral(referral);
    try {
      final response = await ref
          .read(authProvider.notifier)
          .verifyOtp(
            phone: draft.phone,
            code: draft.otp,
            campusId: draft.campusId,
            referralCode: referral.isEmpty ? null : referral,
          );
      final user = response?.user;
      if (user != null &&
          (user.firstName == null || user.firstName!.trim().isEmpty)) {
        final updated = await ref
            .read(userRepositoryProvider)
            .updateUser(
              id: user.id,
              firstName: draft.firstName,
              lastName: draft.lastName,
            );
        ref.read(authProvider.notifier).updateCurrentUser(updated);
      }
      if (!mounted) return;
      context.go('/auth/account-confirmation');
    } catch (error) {
      if (isOtpInvalidError(error)) {
        ToastHelper.showError(
          'Le code SMS a expiré. Repars du numéro pour en recevoir un nouveau.',
        );
        ref.read(signupDraftProvider.notifier).clear();
        if (mounted) context.go('/auth');
        return;
      }
      ToastHelper.showError(apiErrorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      currentStep: 5,
      totalSteps: 5,
      heroIcon: Icons.card_giftcard_outlined,
      heroTitle: 'Qui t\'a invité ?',
      heroSubtitle: 'Code d\'un ambassadeur kabakaba — entièrement facultatif.',
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KabaInput(
            label: 'Code de parrainage (optionnel)',
            hintText: 'ex. KOFFI2026',
            controller: _referralController,
            textCapitalization: TextCapitalization.characters,
            prefixIcon: const Icon(Icons.card_giftcard_outlined, size: 16),
          ),
          const SizedBox(height: 6),
          const HintBox(
            message:
                'Une fois ton compte créé, ce code ne pourra plus être modifié.',
          ),
        ],
      ),
      footer: Column(
        children: [
          KabaButton(
            text: 'Créer mon compte',
            isLoading: _busy,
            onPressed: _busy ? null : () => _createAccount(skipReferral: false),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _busy ? null : () => _createAccount(skipReferral: true),
            child: Text(
              'Passer cette étape',
              style: AppTextStyles.footLink.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}
