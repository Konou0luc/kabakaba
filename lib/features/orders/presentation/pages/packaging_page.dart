import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/cart/data/cart_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class PackagingPage extends ConsumerWidget {
  final Map<String, dynamic> data;

  const PackagingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final firstItemId = cart.lines.isEmpty ? null : cart.lines.first.menuItemId;
    final options = firstItemId == null
        ? const <PackagingOptionModel>[]
        : ref.watch(packagingOptionsProvider(firstItemId)).valueOrNull ??
            const <PackagingOptionModel>[];

    return LightPageScaffold(
      title: 'Conditionnement',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          Text(
            'Choisis l’option proposée par la cantine',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 14),
          if (options.isEmpty)
            Text(
              'Aucune option d’emballage pour ce panier.',
              style: GoogleFonts.plusJakartaSans(color: LightPageColors.muted),
            )
          else
            ...options.map((option) {
              final selected = cart.packagingOptionId == option.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LightCard(
                  onTap: () => ref.read(cartProvider.notifier).setPackaging(
                    optionId: option.id,
                    extra: option.extraCost,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: selected
                            ? LightPageColors.orange
                            : LightPageColors.muted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.text,
                          ),
                        ),
                      ),
                      Text(
                        option.extraCost == 0
                            ? 'Inclus'
                            : '+${formatTickets(option.extraCost)}',
                        style: GoogleFonts.plusJakartaSans(
                          color: LightPageColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 20),
          LightButton(
            text: 'Continuer',
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
    );
  }
}
