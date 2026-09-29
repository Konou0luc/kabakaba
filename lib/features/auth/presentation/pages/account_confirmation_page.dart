import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/auth_scaffold.dart';
import '../../data/auth_provider.dart';
import '../../data/signup_draft.dart';

class AccountConfirmationPage extends ConsumerWidget {
  const AccountConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final draft = ref.watch(signupDraftProvider);
    final name =
        user?.displayFirstName ??
        (draft.firstName.isNotEmpty ? draft.firstName : 'toi');

    return SuccessScreen(
      title: 'Bienvenue, $name !',
      subtitle:
          'Ton compte kabakaba est prêt. Tu peux commander dès maintenant dans les cantines de ton campus.',
      buttonText: 'Accéder à mon compte',
      onPressed: () {
        ref.read(signupDraftProvider.notifier).clear();
        context.go('/home');
      },
      trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 16),
    );
  }
}
