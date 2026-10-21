import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ancien écran emballage — redirigé vers le panier (takeaway in-cart).
class PackagingPage extends StatelessWidget {
  final Object? data;

  const PackagingPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go('/cart');
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
