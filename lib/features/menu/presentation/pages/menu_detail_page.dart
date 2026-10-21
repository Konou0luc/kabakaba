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

class MenuDetailPage extends ConsumerStatefulWidget {
  final String? itemId;
  final String? vendorId;

  const MenuDetailPage({super.key, this.itemId, this.vendorId});

  @override
  ConsumerState<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends ConsumerState<MenuDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final itemId = widget.itemId;
    final vendorId = widget.vendorId;
    if (itemId == null || itemId.isEmpty || vendorId == null || vendorId.isEmpty) {
      return const LightPageScaffold(
        title: 'Menu',
        body: KabaEmptyState(
          icon: Icons.restaurant_rounded,
          title: 'Menu introuvable',
          subtitle: 'Ce menu n’est plus disponible.',
        ),
      );
    }

    final menuAsync = ref.watch(
      menuFromVendorProvider((vendorId: vendorId, menuId: itemId)),
    );
    return menuAsync.when(
      loading: () => const LightPageScaffold(
        title: 'Menu',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => LightPageScaffold(
        title: 'Menu',
        body: KabaEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Impossible de charger',
          subtitle: '$error',
        ),
      ),
      data: (menu) {
        if (menu == null) {
          return const LightPageScaffold(
            title: 'Menu',
            body: KabaEmptyState(
              icon: Icons.restaurant_rounded,
              title: 'Menu introuvable',
              subtitle: 'Ce menu n’est plus disponible.',
            ),
          );
        }
        return _buildLoaded(menu, vendorId);
      },
    );
  }

  Widget _buildLoaded(MenuModel item, String vendorId) {
    final vendor = ref.watch(vendorDetailProvider(vendorId)).valueOrNull;
    final total = item.priceTickets * _quantity;
    final missing = item.missingComponents.map((m) => m.name).join(', ');

    return LightPageScaffold(
      title: item.name,
      bottomNavigationBar: _StickyAddBar(
        quantity: _quantity,
        total: total,
        available: item.available && (vendor?.acceptsOrders ?? true),
        onMinus: _quantity > 1 ? () => setState(() => _quantity -= 1) : null,
        onPlus: () => setState(() => _quantity += 1),
        onAdd: item.available ? () => _add(item, vendor) : null,
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
                label: item.available ? 'Disponible' : 'Indisponible',
                color: item.available
                    ? AppColors.success
                    : LightPageColors.muted,
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
                  'Prix',
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
          if (item.lines.isNotEmpty) ...[
            const SizedBox(height: 22),
            const LightSectionTitle(
              title: 'Composition',
              subtitle: 'Composants inclus dans ce menu',
            ),
            ...item.lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LightCard(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
                          Icons.check_circle_outline_rounded,
                          size: 18,
                          color: LightPageColors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          line.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.text,
                          ),
                        ),
                      ),
                      Text(
                        '×${line.quantity}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: LightPageColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (!item.available && missing.isNotEmpty) ...[
            const SizedBox(height: 12),
            LightHintBox(
              text: 'Indisponible : $missing',
              isWarning: true,
            ),
          ],
        ],
      ),
    );
  }

  void _add(MenuModel item, VendorModel? vendor) {
    if (vendor == null) {
      showKabaSnack(context, 'Cantine introuvable', error: true);
      return;
    }
    if (!vendor.acceptsOrders) {
      showKabaSnack(
        context,
        vendor.capacityStatus == VendorCapacity.BUSY
            ? 'Cette cantine est momentanément indisponible'
            : 'Cette cantine est fermée',
        error: true,
      );
      return;
    }
    final line = CartLine(
      vendorId: vendor.id,
      vendorName: vendor.canteenName,
      menuId: item.id,
      name: item.name,
      priceTickets: item.priceTickets,
      quantity: _quantity,
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
  final MenuModel item;

  const _HeroCover({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: const Color(0xFF1B2A6B),
              child: Icon(
                Icons.restaurant_rounded,
                color: AppColors.accent.withValues(alpha: 0.85),
                size: 56,
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
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.12)),
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

class _StickyAddBar extends StatelessWidget {
  final int quantity;
  final int total;
  final bool available;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final VoidCallback? onAdd;

  const _StickyAddBar({
    required this.quantity,
    required this.total,
    required this.available,
    this.onMinus,
    this.onPlus,
    this.onAdd,
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
                color: LightPageColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LightPageColors.border),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onMinus,
                    icon: const Icon(Icons.remove_rounded, size: 18),
                  ),
                  Text(
                    '$quantity',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: onPlus,
                    icon: const Icon(Icons.add_rounded, size: 18),
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
                onPressed: available ? onAdd : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
