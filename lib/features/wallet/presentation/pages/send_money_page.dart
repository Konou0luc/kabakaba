import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Transfert P2P retiré du backend CDC — redirection portefeuille.
class SendMoneyPage extends StatelessWidget {
  const SendMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go('/wallet');
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
