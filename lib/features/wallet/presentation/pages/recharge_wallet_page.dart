import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RechargeWalletPage extends StatelessWidget {
  const RechargeWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go('/recharge/step1');
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
