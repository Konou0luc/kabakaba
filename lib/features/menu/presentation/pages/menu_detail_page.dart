import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/cart/data/cart_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import '../../../../shared/widgets/remote_photo.dart';

class MenuDetailPage extends ConsumerStatefulWidget {
  final String? itemId;
  final String? vendorId;

  const MenuDetailPage({super.key, this.itemId, this.vendorId});

  @override
  ConsumerState<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends ConsumerState<MenuDetailPage> {
  int _quantity = 1;
  final Map<String, int> _componentQty = {};

  @override
  Widget build(BuildContext context) {
    final itemId = widget.itemId;
    if (itemId == null || itemId.isEmpty) {
      return const LightPageScaffold(
        title: 'Plat',
        body: KabaEmptyState(
          icon: Icons.restaurant_rounded,
          title: 'Plat introuvable',
          subtitle: 'Ce menu n’est plus disponible.',
        ),
      );
    }

    final itemAsync = ref.watch(menuItemProvider(itemId));
    return itemAsync.when(
      loading: () => const LightPageScaffold(
        title: 'Plat',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => LightPageScaffold(
        title: 'Plat',
        body: KabaEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Impossible de charger',
          subtitle: '$error',
        ),
      ),
      data: (item) => _buildLoaded(item),
    );
  }

  Widget _buildLoaded(MenuItemModel item) {
    final vendorId = widget.vendorId ?? item.vendorId;
    final vendor = ref.watch(vendorDetailProvider(vendorId)).valueOrNull;
    final components =
        ref.watch(menuComponentsProvider(item.id)).valueOrNull ?? const [];

    final extras = components.fold<int>(0, (sum, component) {
      final qty = _componentQty[component.id] ?? component.minQty;
      return sum + component.unitPriceTickets * qty;
    });
    final total = (item.priceTickets + extras) * _quantity;

    return LightPageScaffold(
      title: item.name,
      bottomNavigationBar: _StickyAddBar(
        quantity: _quantity,
        total: total,
        available: item.isAvailable,
        onMinus: _quantity > 1 ? () => setState(() => _quantity -= 1) : null,
        onPlus: () => setState(() => _quantity += 1),
        onAdd: item.isAvailable ? () => _add(item, vendor, components) : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _HeroCover(item: item)
              .animate()
              .fadeIn(duration: 280.ms)
              .slideY(begin: 0.04, duration: 320.ms),
          const SizedBox(height: 16),
          KabaSectionKicker(vendor?.canteenName ?? 'Cantine'),
          const SizedBox(height: 6),
          Text(
            item.name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.15,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              KabaStatusPill(
                label: item.isAvailable ? 'Disponible' : 'Indisponible',
                color: item.isAvailable
                    ? AppColors.success
                    : LightPageColors.muted,
              ),
              if (item.category != null && item.category!.trim().isNotEmpty)
                KabaStatusPill(
                  label: item.category!.trim(),
                  color: LightPageColors.orange,
                ),
            ],
          ),
          if (item.description != null && item.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              item.description!.trim(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: LightPageColors.text2,
              ),
            ),
          ],
          const SizedBox(height: 18),
          LightCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  'Prix de base',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: LightPageColors.muted,
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatTickets(item.priceTickets)} tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: LightPageColors.orange,
                  ),
                ),
              ],
            ),
          ),
          if (components.isNotEmpty) ...[
            const SizedBox(height: 22),
            const LightSectionTitle(
              title: 'Options',
              subtitle: 'Ajuste les extras proposés',
            ),
            ...components.map((component) {
              final qty = _componentQty[component.id] ?? component.minQty;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LightCard(
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: LightPageColors.orangeLight,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(
                          Icons.add_circle_outline_rounded,
                          size: 18,
                          color: LightPageColors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              component.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+${formatTickets(component.unitPriceTickets)} tickets',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: LightPageColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _QtyChip(
                        qty: qty,
                        onMinus: qty > component.minQty
                            ? () => setState(
                                  () => _componentQty[component.id] = qty - 1,
                                )
                            : null,
                        onPlus: qty < component.maxQty
                            ? () => setState(
                                  () => _componentQty[component.id] = qty + 1,
                                )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  void _add(
    MenuItemModel item,
    VendorModel? vendor,
    List<MenuComponentModel> components,
  ) {
    if (vendor == null) {
      showKabaSnack(context, 'Cantine introuvable', error: true);
      return;
    }
    final extras = [
      for (final component in components)
        if ((_componentQty[component.id] ?? component.minQty) > 0)
          CartComponent(
            componentId: component.id,
            name: component.name,
            unitPriceTickets: component.unitPriceTickets,
            quantity: _componentQty[component.id] ?? component.minQty,
          ),
    ];
    final line = CartLine(
      vendorId: vendor.id,
      vendorName: vendor.canteenName,
      menuItemId: item.id,
      name: item.name,
      priceTickets: item.priceTickets,
      quantity: _quantity,
      imageUrl: item.imageUrl,
      components: extras,
    );
    final added = ref.read(cartProvider.notifier).add(line);
    if (!added) {
      ref.read(cartProvider.notifier).replaceWith(line);
      showKabaSnack(context, 'Nouveau panier pour ${vendor.canteenName}');
    } else {
      showKabaSnack(context, '${item.name} ajouté');
    }
    context.push('/cart');
  }
}

class _HeroCover extends StatelessWidget {
  final MenuItemModel item;

  const _HeroCover({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            RemotePhoto(
              url: item.imageUrl,
              width: double.infinity,
              height: 240,
              fallback: ColoredBox(
                color: const Color(0xFF1B2A6B),
                child: Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.accent.withValues(alpha: 0.85),
                  size: 56,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x26000000),
                    Color(0x08000000),
                    Color(0xCC000000),
                  ],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Text(
                  '${formatTickets(item.priceTickets)} tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyChip extends StatelessWidget {
  final int qty;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _QtyChip({required this.qty, this.onMinus, this.onPlus});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightPageColors.orangeLight,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: LightPageColors.orange.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove_rounded, onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$qty',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: LightPageColors.orange,
              ),
            ),
          ),
          _btn(Icons.add_rounded, onPlus),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          icon,
          size: 15,
          color: onTap == null
              ? LightPageColors.muted.withValues(alpha: 0.5)
              : LightPageColors.orange,
        ),
      ),
    );
  }
}

class _StickyAddBar extends StatelessWidget {
  final int quantity;
  final int total;
  final bool available;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;
  final VoidCallback? onAdd;

  const _StickyAddBar({
    required this.quantity,
    required this.total,
    required this.available,
    required this.onMinus,
    required this.onPlus,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        border: Border(
          top: BorderSide(color: LightPageColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: LightPageColors.indigo.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: LightPageColors.indigoLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: LightPageColors.border),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onMinus,
                    icon: const Icon(Icons.remove_rounded, size: 18),
                    color: LightPageColors.indigo,
                  ),
                  Text(
                    '$quantity',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: LightPageColors.text,
                    ),
                  ),
                  IconButton(
                    onPressed: onPlus,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    color: LightPageColors.indigo,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LightButton(
                text: available
                    ? 'Ajouter · ${formatTickets(total)}'
                    : 'Indisponible',
                icon: available ? Icons.add_shopping_cart_rounded : Icons.block,
                onPressed: onAdd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
