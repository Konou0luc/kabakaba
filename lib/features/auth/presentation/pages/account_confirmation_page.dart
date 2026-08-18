import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/auth_scaffold.dart';

class AccountConfirmationPage extends ConsumerStatefulWidget {
  const AccountConfirmationPage({super.key});

  @override
  ConsumerState<AccountConfirmationPage> createState() =>
      _AccountConfirmationPageState();
}

class _AccountConfirmationPageState
    extends ConsumerState<AccountConfirmationPage> {
  bool _autoNavigating = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted && _autoNavigating) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: 'Bienvenue, Koffi !',
      subtitle:
          'Ton compte kabakaba est prêt. Tu peux commander dès maintenant dans les cantines de ton campus.',
      buttonText: 'Accéder à mon compte',
      onPressed: () {
        _autoNavigating = false;
        _timer?.cancel();
        context.go('/home');
      },
      trailingIcon: const Icon(
        Icons.arrow_forward_rounded,
        size: 16,
      ),
    );
  }
}
