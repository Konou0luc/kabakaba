import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../features/cart/data/cart_provider.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? data;

  const PaymentPage({super.key, this.data});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  bool _paying = false;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final total = cart.totalTickets;
    final balance = user?.walletBalance ?? 0;
    final enough = balance >= total && cart.lines.isNotEmpty;

    return LightPageScaffold(
      title: 'Paiement',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          LightCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.vendorName.isEmpty ? 'Panier' : cart.vendorName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${cart.itemCount} article(s) · ${formatTickets(total)} tickets',
                  style: GoogleFonts.plusJakartaSans(
                    color: LightPageColors.muted,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Solde : ${formatTickets(balance)} tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: enough
                        ? LightPageColors.green
                        : LightPageColors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const LightHintBox(
            text:
                'Le paiement se fait uniquement avec tes tickets kabakaba. Aucun frais supplémentaire n’est ajouté ici.',
          ),
          const SizedBox(height: 24),
          LightButton(
            text: !enough
                ? 'Recharger le portefeuille'
                : _paying
                ? 'Paiement…'
                : 'Payer ${formatTickets(total)} tickets',
            isLoading: _paying,
            onPressed: _paying
                ? null
                : () async {
                    if (!enough) {
                      context.push('/recharge/step1');
                      return;
                    }
                    await _pay();
                  },
          ),
        ],
      ),
    );
  }

  Future<void> _pay() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty || cart.vendorId == null) return;
    setState(() => _paying = true);
    try {
      await ref.read(orderRepositoryProvider).createOrder(
        vendorId: cart.vendorId!,
        items: [for (final line in cart.lines) line.toOrderJson()],
        packagingOptionId: cart.packagingOptionId,
      );
      ref.read(cartProvider.notifier).clear();
      ref.invalidate(meProvider);
      ref.invalidate(myOrdersProvider);
      if (!mounted) return;
      showKabaSnack(context, 'Commande envoyée');
      context.go('/order-history');
    } catch (error) {
      if (mounted) showKabaSnack(context, apiErrorMessage(error), error: true);
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }
}
