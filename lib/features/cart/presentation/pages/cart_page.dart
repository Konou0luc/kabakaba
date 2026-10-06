import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import '../../../../shared/widgets/remote_photo.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/cart_provider.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  bool _paying = false;

  List<CartLine> get _items => ref.watch(cartProvider).lines;

  int get _userBalance {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    return user?.walletBalance ?? 0;
  }

  int get _availableTickets {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    return user?.availableTickets ?? 0;
  }

  int get _totalPrice => ref.watch(cartProvider).totalTickets;

  bool get _hasEnough => _availableTickets >= _totalPrice && _items.isNotEmpty;

  bool get _blockedByHold =>
      _items.isNotEmpty &&
      _userBalance >= _totalPrice &&
      _availableTickets < _totalPrice;

  void _updateQty(int index, int delta) {
    final line = _items[index];
    ref
        .read(cartProvider.notifier)
        .setQuantityByKey(line.lineKey, line.quantity + delta);
  }

  Future<void> _checkout() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty || cart.vendorId == null) return;
    if (!_hasEnough) {
      if (_blockedByHold) {
        showKabaSnack(
          context,
          'Une partie de tes tickets est gelée pour une commande en cours.',
          error: true,
        );
        return;
      }
      context.push('/recharge/step1');
      return;
    }
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
      context.push('/order-history');
    } catch (error) {
      if (mounted) showKabaSnack(context, apiErrorMessage(error), error: true);
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Mon panier',
      showBackButton: true,
      actions: [
        if (_items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LightBadge(
              text: '${_items.length}',
              bgColor: LightPageColors.orangeLight,
              color: LightPageColors.orange,
            ),
          ),
      ],
      body: _items.isEmpty
          ? _buildEmpty()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Column(
                      children: [
                        _buildCanteenHeader(),
                        const SizedBox(height: 14),
                        ...List.generate(_items.length, (i) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: i == _items.length - 1 ? 0 : 12),
                            child: _buildItem(i).animate().fadeIn(
                                  delay: (50 * i).ms,
                                  begin: 0.8,
                                ),
                          );
                        }),
                        const SizedBox(height: 16),
                        _buildPackagingOption(),
                        const SizedBox(height: 16),
                        _buildSummary(),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: KabaEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'Panier vide',
        subtitle: 'Ajoute des plats depuis les cantines de ton campus.',
        actionLabel: 'Découvrir les cantines',
        onAction: () => context.go('/canteen-list'),
      ),
    );
  }

  Widget _buildCanteenHeader() {
    final cart = ref.watch(cartProvider);
    final vendors = ref.watch(vendorsListProvider).valueOrNull ?? const [];
    VendorModel? vendor;
    for (final item in vendors) {
      if (item.id == cart.vendorId) {
        vendor = item;
        break;
      }
    }
    return LightCard(
      padding: const EdgeInsets.all(12),
      onTap: cart.vendorId == null
          ? null
          : () => context.push('/canteen-detail', extra: cart.vendorId),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: RemotePhoto(
              url: vendor?.logoUrl ?? vendor?.bannerUrl,
              width: 52,
              height: 52,
              radius: 14,
              fallback: Container(
                width: 52,
                height: 52,
                color: LightPageColors.indigoLight,
                alignment: Alignment.center,
                child: Icon(
                  Icons.restaurant_rounded,
                  color: LightPageColors.indigo,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.vendorName.isEmpty ? 'Cantine' : cart.vendorName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${cart.itemCount} plats',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          if (vendor != null)
            KabaStatusPill(
              label: vendor.isOpen ? 'Ouverte' : 'Fermée',
              color: vendor.isOpen
                  ? LightPageColors.green
                  : LightPageColors.muted,
            ),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = _items[index];
    return LightCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          RemotePhoto(
            url: item.imageUrl,
            width: 68,
            height: 68,
            radius: 11,
            fallback: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: LightPageColors.indigoLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                Icons.restaurant_rounded,
                color: LightPageColors.indigo,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.components.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.components
                        .map((c) => '${c.name} ×${c.quantity}')
                        .join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: LightPageColors.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 3),
                Text(
                  '${formatTickets(item.unitTotal)} tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.orange,
                  ),
                ),
              ],
            ),
          ),
          _buildQtyControl(index),
        ],
      ),
    );
  }

  Widget _buildQtyControl(int index) {
    final item = _items[index];
    return Container(
      decoration: BoxDecoration(
        color: LightPageColors.bg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyBtn(Icons.remove_rounded, () => _updateQty(index, -1)),
          Container(
            width: 28,
            alignment: Alignment.center,
            child: Text(
              '${item.quantity}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
          ),
          _qtyBtn(Icons.add_rounded, () => _updateQty(index, 1)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon, size: 16, color: LightPageColors.text2),
        ),
      ),
    );
  }

  Widget _buildPackagingOption() {
    final firstItemId = _items.isEmpty ? null : _items.first.menuItemId;
    final options = firstItemId == null
        ? const <PackagingOptionModel>[]
        : ref.watch(packagingOptionsProvider(firstItemId)).valueOrNull ??
            const <PackagingOptionModel>[];
    if (options.isEmpty) return const SizedBox.shrink();
    final selectedId = ref.watch(cartProvider).packagingOptionId;

    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: LightPageColors.indigo,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Options de retrait',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...options.map((option) {
            final selected = selectedId == option.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => ref.read(cartProvider.notifier).setPackaging(
                      optionId: option.id,
                      extra: option.extraCost,
                    ),
                borderRadius: BorderRadius.circular(11),
                child: _packagingRow(
                  icon: option.extraCost > 0
                      ? Icons.takeout_dining_outlined
                      : Icons.restaurant_outlined,
                  title: option.name,
                  subtitle: option.extraCost == 0
                      ? 'Sans supplément'
                      : '+${formatTickets(option.extraCost)} tickets',
                  price: option.extraCost,
                  selected: selected,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _packagingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required int price,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: selected
            ? LightPageColors.orangeLight.withValues(alpha: 0.6)
            : LightPageColors.bg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: selected
              ? LightPageColors.orange.withValues(alpha: 0.5)
              : LightPageColors.border,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: selected
                  ? LightPageColors.orange.withValues(alpha: 0.18)
                  : LightPageColors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 16,
              color: selected ? LightPageColors.orange : LightPageColors.text2,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? LightPageColors.orange : LightPageColors.white,
              border: Border.all(
                color: selected
                    ? LightPageColors.orange
                    : LightPageColors.border,
                width: 2,
              ),
            ),
            child: selected
                ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _summaryRow(
            'Sous-total',
            '${formatTickets(ref.watch(cartProvider).itemsTickets)} tickets',
          ),
          if (ref.watch(cartProvider).packagingExtra > 0) ...[
            const SizedBox(height: 10),
            _summaryRow(
              'Emballage',
              '+${formatTickets(ref.watch(cartProvider).packagingExtra)} tickets',
            ),
          ],
          const SizedBox(height: 10),
          _summaryRow('Frais de service', '0 tickets', isFree: true),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: LightPageColors.border,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.text,
                ),
              ),
              Text(
                '$_totalPrice tickets',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: LightPageColors.text2,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isFree ? LightPageColors.green : LightPageColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        border: Border(
          top: BorderSide(color: LightPageColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: LightPageColors.indigoLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16,
                    color: LightPageColors.indigo,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ton solde',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: LightPageColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '$_userBalance tickets',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: _hasEnough
                              ? LightPageColors.green
                              : LightPageColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_hasEnough ? '✓' : '⚠'}  ${(_userBalance - _totalPrice).abs()}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _hasEnough ? LightPageColors.green : LightPageColors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LightButton(
              text: _hasEnough
                  ? 'Payer avec les tickets'
                  : _blockedByHold
                      ? 'Tickets gelés — commande en cours'
                      : 'Solde insuffisant — Recharger',
              icon: _hasEnough
                  ? Icons.payment_rounded
                  : Icons.add_circle_outline_rounded,
              isPrimary: _hasEnough,
              onPressed: _paying
                  ? null
                  : _hasEnough
                  ? _checkout
                  : () => context.push('/recharge/step1'),
            ),
          ],
        ),
      ),
    );
  }
}
