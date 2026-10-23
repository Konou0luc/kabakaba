import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/push/push_notifications.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/widgets/kaba_bottom_sheet_modal.dart';
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
  bool _schedule = false;
  DateTime? _scheduledFor;

  List<CartLine> get _items => ref.watch(cartProvider).lines;

  int get _availableTickets {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    return user?.availableTickets ?? 0;
  }

  int get _totalPrice => ref.watch(cartProvider).totalTickets;

  bool get _hasEnough => _availableTickets >= _totalPrice && _items.isNotEmpty;

  void _updateQty(int index, int delta) {
    final line = _items[index];
    ref
        .read(cartProvider.notifier)
        .setQuantityByKey(line.lineKey, line.quantity + delta);
  }

  Future<void> _confirmClearCart() async {
    if (_items.isEmpty) return;
    final confirmed = await KabaBottomSheetModal.confirmClearCart(context);
    if (!confirmed || !mounted) return;
    ref.read(cartProvider.notifier).clear();
    showKabaSnack(context, 'Panier vidé');
  }

  VendorModel? _cartVendor() {
    final vendorId = ref.read(cartProvider).vendorId;
    final vendors = ref.read(vendorsListProvider).valueOrNull ?? const [];
    for (final vendor in vendors) {
      if (vendor.id == vendorId) return vendor;
    }
    return null;
  }

  Future<void> _pickScheduleTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 20))),
    );
    if (time == null || !mounted) return;
    setState(() {
      _scheduledFor = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _signalSoldAloneError(String message) {
    showKabaSnack(context, message, error: true);
    unawaited(
      ref.read(pushNotificationsProvider).showUserAlert(
            title: 'Commande impossible',
            body: message,
          ),
    );
  }

  Future<void> _checkout() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty || cart.vendorId == null) return;
    final soldAloneError = cartSoldAloneViolation(cart.lines);
    if (soldAloneError != null) {
      _signalSoldAloneError(soldAloneError);
      return;
    }
    final vendor = _cartVendor();
    if (!_schedule && vendor != null && !vendor.acceptsOrders) {
      showKabaSnack(
        context,
        vendor.capacityStatus == VendorCapacity.BUSY
            ? 'Cantine occupée — programme plutôt ton repas.'
            : 'Cette cantine n’accepte plus de commandes.',
        error: true,
      );
      return;
    }
    if (vendor != null && vendor.capacityStatus == VendorCapacity.CLOSED) {
      showKabaSnack(
        context,
        'Cette cantine est fermée.',
        error: true,
      );
      return;
    }
    if (!_schedule && !_hasEnough) {
      context.push('/recharge/step1');
      return;
    }
    if (cart.consumptionMode == ConsumptionMode.TAKEAWAY &&
        (cart.takeawayOptionId == null || cart.takeawayOptionId!.isEmpty)) {
      showKabaSnack(
        context,
        'Choisis une option d’emporté',
        error: true,
      );
      return;
    }
    if (_schedule) {
      final when = _scheduledFor;
      if (when == null) {
        showKabaSnack(context, 'Choisis une heure', error: true);
        return;
      }
      final lead = when.difference(DateTime.now());
      if (lead.inMinutes < 15 || lead.inHours > 24) {
        showKabaSnack(
          context,
          'L’heure doit être entre 15 minutes et 24 heures',
          error: true,
        );
        return;
      }
    }
    setState(() => _paying = true);
    try {
      final items = [for (final line in cart.lines) line.toOrderJson()];
      if (_schedule) {
        await ref.read(scheduledOrderRepositoryProvider).create(
              vendorId: cart.vendorId!,
              scheduledFor: _scheduledFor!.toUtc().toIso8601String(),
              items: items,
              consumptionMode: cart.consumptionMode.name,
              takeawayOptionId: cart.consumptionMode == ConsumptionMode.TAKEAWAY
                  ? cart.takeawayOptionId
                  : null,
            );
        ref.read(cartProvider.notifier).clear();
        ref.invalidate(myScheduledOrdersProvider);
        if (!mounted) return;
        showKabaSnack(
          context,
          'Commande programmée. Les tickets seront débités à l’heure prévue.',
        );
        context.push('/order-history');
        return;
      }
      await ref.read(orderRepositoryProvider).createOrder(
            vendorId: cart.vendorId!,
            items: items,
            consumptionMode: cart.consumptionMode.name,
            takeawayOptionId: cart.consumptionMode == ConsumptionMode.TAKEAWAY
                ? cart.takeawayOptionId
                : null,
          );
      ref.read(cartProvider.notifier).clear();
      ref.invalidate(meProvider);
      ref.invalidate(myOrdersProvider);
      if (!mounted) return;
      showKabaSnack(context, 'Commande confirmée');
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
        if (_items.isNotEmpty) ...[
          IconButton(
            tooltip: 'Vider le panier',
            onPressed: _confirmClearCart,
            icon: Icon(
              Icons.delete_outline_rounded,
              color: LightPageColors.muted,
              size: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LightBadge(
              text: '${_items.length}',
              bgColor: LightPageColors.orangeLight,
              color: LightPageColors.orange,
            ),
          ),
        ],
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
                        if (cartSoldAloneViolation(_items) != null) ...[
                          const SizedBox(height: 12),
                          LightHintBox(
                            icon: Icons.error_outline_rounded,
                            text: cartSoldAloneViolation(_items)!,
                          ),
                        ],
                        const SizedBox(height: 14),
                        ...List.generate(_items.length, (i) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: i == _items.length - 1 ? 0 : 12,
                            ),
                            child: _buildItem(i).animate().fadeIn(
                                  delay: (50 * i).ms,
                                  begin: 0.8,
                                ),
                          );
                        }),
                        const SizedBox(height: 16),
                        _buildConsumptionMode(),
                        const SizedBox(height: 16),
                        _buildSchedule(),
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
                  '${cart.itemCount} article(s)',
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
              label: vendor.capacityLabel,
              color: switch (vendor.capacityStatus) {
                VendorCapacity.OPEN => LightPageColors.green,
                VendorCapacity.BUSY => LightPageColors.warning,
                VendorCapacity.CLOSED => LightPageColors.muted,
              },
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
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: LightPageColors.indigoLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              item.isMenu
                  ? Icons.restaurant_menu_rounded
                  : Icons.egg_alt_rounded,
              color: LightPageColors.indigo,
              size: 26,
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
                const SizedBox(height: 2),
                Text(
                  item.isMenu
                      ? 'Menu'
                      : (item.unit ?? 'Composant'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: LightPageColors.muted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${formatTickets(item.priceTickets)} tickets / u. · ${formatTickets(item.lineTotal)} tickets',
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

  Widget _buildConsumptionMode() {
    final cart = ref.watch(cartProvider);
    final vendorId = cart.vendorId;
    final options = vendorId == null
        ? const <TakeawayOptionModel>[]
        : ref.watch(takeawayOptionsProvider(vendorId)).valueOrNull ??
            const <TakeawayOptionModel>[];

    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mode de consommation',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _modeChip(
                  label: 'Sur place',
                  icon: Icons.restaurant_rounded,
                  selected: cart.consumptionMode == ConsumptionMode.ON_SITE,
                  onTap: () => ref
                      .read(cartProvider.notifier)
                      .setConsumptionMode(ConsumptionMode.ON_SITE),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _modeChip(
                  label: 'À emporter',
                  icon: Icons.takeout_dining_rounded,
                  selected: cart.consumptionMode == ConsumptionMode.TAKEAWAY,
                  onTap: () {
                    ref
                        .read(cartProvider.notifier)
                        .setConsumptionMode(ConsumptionMode.TAKEAWAY);
                    if (options.length == 1) {
                      ref.read(cartProvider.notifier).setTakeawayOption(
                            optionId: options.first.id,
                            fee: options.first.priceTickets,
                          );
                    }
                  },
                ),
              ),
            ],
          ),
          if (cart.consumptionMode == ConsumptionMode.TAKEAWAY) ...[
            const SizedBox(height: 14),
            if (options.isEmpty)
              Text(
                'Aucune option d’emporté pour cette cantine.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: LightPageColors.red,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              ...options.map((option) {
                final selected = cart.takeawayOptionId == option.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => ref.read(cartProvider.notifier).setTakeawayOption(
                          optionId: option.id,
                          fee: option.priceTickets,
                        ),
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 11,
                      ),
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: LightPageColors.text,
                                  ),
                                ),
                                Text(
                                  option.priceTickets == 0
                                      ? 'Sans supplément'
                                      : '+${formatTickets(option.priceTickets)} tickets',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    color: LightPageColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            size: 20,
                            color: selected
                                ? LightPageColors.orange
                                : LightPageColors.muted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          ],
        ],
      ),
    );
  }

  Widget _modeChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? LightPageColors.orange.withValues(alpha: 0.12)
              : LightPageColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? LightPageColors.orange : LightPageColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? LightPageColors.orange : LightPageColors.muted,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: selected ? LightPageColors.orange : LightPageColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule() {
    final when = _scheduledFor;
    final label = when == null
        ? 'Choisir l’heure'
        : '${when.day.toString().padLeft(2, '0')}/${when.month.toString().padLeft(2, '0')} · ${when.hour.toString().padLeft(2, '0')}h${when.minute.toString().padLeft(2, '0')}';
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quand commander ?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _modeChip(
                  label: 'Maintenant',
                  icon: Icons.flash_on_rounded,
                  selected: !_schedule,
                  onTap: () => setState(() => _schedule = false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _modeChip(
                  label: 'Programmer',
                  icon: Icons.schedule_rounded,
                  selected: _schedule,
                  onTap: () => setState(() => _schedule = true),
                ),
              ),
            ],
          ),
          if (_schedule) ...[
            const SizedBox(height: 12),
            Text(
              'Le stock et les tickets ne sont vérifiés qu’à l’heure prévue.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                color: LightPageColors.muted,
              ),
            ),
            const SizedBox(height: 10),
            LightButton(
              text: label,
              icon: Icons.access_time_rounded,
              isPrimary: false,
              onPressed: _pickScheduleTime,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final cart = ref.watch(cartProvider);
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _summaryRow(
            'Sous-total',
            '${formatTickets(cart.itemsTickets)} tickets',
          ),
          if (cart.consumptionMode == ConsumptionMode.TAKEAWAY &&
              cart.takeawayFeeTickets > 0) ...[
            const SizedBox(height: 10),
            _summaryRow(
              'Emporté',
              '+${formatTickets(cart.takeawayFeeTickets)} tickets',
            ),
          ],
          const SizedBox(height: 10),
          Container(height: 1, color: LightPageColors.border),
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
          const SizedBox(height: 10),
          _summaryRow('Solde actuel', '${formatTickets(_availableTickets)} tickets'),
          const SizedBox(height: 8),
          _summaryRow(
            _schedule ? 'Sera débité à l’heure prévue' : 'Il te restera',
            '${formatTickets((_availableTickets - _totalPrice).clamp(0, 1 << 30))} tickets',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: LightPageColors.text2,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: LightPageColors.text,
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
                        '$_availableTickets tickets',
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
              ],
            ),
            const SizedBox(height: 12),
            LightButton(
              text: _paying
                  ? 'Confirmation…'
                  : _schedule
                      ? 'Programmer la commande'
                      : _hasEnough
                          ? 'Confirmer la commande'
                          : 'Solde insuffisant — Recharger',
              icon: _schedule
                  ? Icons.schedule_rounded
                  : _hasEnough
                      ? Icons.check_rounded
                      : Icons.add_circle_outline_rounded,
              isPrimary: _schedule || _hasEnough,
              isLoading: _paying,
              onPressed: _paying
                  ? null
                  : (_schedule || _hasEnough)
                      ? _checkout
                      : () => context.push('/recharge/step1'),
            ),
          ],
        ),
      ),
    );
  }
}
