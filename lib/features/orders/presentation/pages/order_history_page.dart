import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../features/cart/data/cart_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryPage extends ConsumerStatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  ConsumerState<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends ConsumerState<OrderHistoryPage> {
  int _tab = 0;
  final List<String> tabs = const ['En attente', 'Préparation', 'Historique'];
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) refreshStudentSession(ref);
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _cancelOrder(String id) async {
    try {
      await ref.read(orderRepositoryProvider).cancelOrder(id);
      ref.invalidate(myOrdersProvider);
      ref.invalidate(meProvider);
      if (mounted) showKabaSnack(context, 'Commande annulée');
    } catch (error) {
      if (mounted) showKabaSnack(context, apiErrorMessage(error), error: true);
    }
  }

  Future<void> _confirmReceive(String id) async {
    try {
      await ref.read(orderRepositoryProvider).confirmReceive(id);
      ref.invalidate(myOrdersProvider);
      ref.invalidate(meProvider);
      if (mounted) showKabaSnack(context, 'Commande marquée comme retirée');
    } catch (error) {
      if (mounted) showKabaSnack(context, apiErrorMessage(error), error: true);
    }
  }

  void _reorder(OrderModel order) {
    final lines = [
      for (final item in order.items)
        if (item.menuItemId != null && item.menuItemId!.isNotEmpty)
          CartLine(
            vendorId: order.vendorId,
            vendorName: order.vendorName,
            menuItemId: item.menuItemId!,
            name: item.name,
            priceTickets: item.priceTickets,
            quantity: item.quantity,
            imageUrl: item.imageUrl,
          ),
    ];
    if (lines.isEmpty) {
      context.push('/canteen-detail', extra: order.vendorId);
      return;
    }
    ref.read(cartProvider.notifier).reorderFrom(
          vendorId: order.vendorId,
          vendorName: order.vendorName,
          lines: lines,
        );
    showKabaSnack(context, 'Articles ajoutés au panier');
    context.push('/cart');
  }

  Map<String, dynamic> _cardOf(OrderModel order) {
    final items = order.items.isEmpty
        ? '${order.totalTickets} tickets'
        : order.items
              .map((line) => '${line.name} · ${line.quantity}x')
              .join(' · ');
    final (badge, color, progress, statusKey) = switch (order.status) {
      OrderStatus.PENDING => (
        'En attente',
        LightPageColors.warning,
        1,
        'pending',
      ),
      OrderStatus.ACCEPTED => (
        'Acceptée',
        LightPageColors.warning,
        1,
        'pending',
      ),
      OrderStatus.IN_PREPARATION => (
        'En préparation',
        const Color(0xFF6366F1),
        2,
        'prepping',
      ),
      OrderStatus.READY => ('Prête', LightPageColors.green, 3, 'prepping'),
      OrderStatus.REFUSED => ('Refusée', LightPageColors.red, 0, 'cancelled'),
      OrderStatus.CANCELLED_VENDOR ||
      OrderStatus.CANCELLED_STUDENT ||
      OrderStatus.CANCELLED => ('Annulée', LightPageColors.red, 0, 'cancelled'),
      _ => ('Terminée', LightPageColors.muted, 4, 'history'),
    };
    return {
      'id': order.id,
      'order': order,
      'vendor': order.vendorName,
      'vendorId': order.vendorId,
      'items': items,
      'total': order.totalTickets,
      'count': order.items.fold<int>(0, (sum, line) => sum + line.quantity),
      'time': _formatWhen(order.createdAt),
      'eta': order.readyAt != null ? _formatWhen(order.readyAt!) : '—',
      'pickup': 'Sur place',
      'status': statusKey,
      'ready': order.status == OrderStatus.READY,
      'color': color,
      'badge': badge,
      'date': _formatWhen(order.createdAt),
      'progress': progress,
      'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
    };
  }

  String _formatWhen(DateTime date) {
    final local = date.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '${local.day}/${local.month} · ${hh}h$mm';
  }

  List<Map<String, dynamic>> get currentData {
    final orders = ref.watch(myOrdersProvider).valueOrNull ?? const [];
    final cards = orders.map(_cardOf).toList();
    return switch (_tab) {
      0 => cards.where((o) => o['status'] == 'pending').toList(),
      1 => cards.where((o) => o['status'] == 'prepping').toList(),
      _ =>
        cards
            .where(
              (o) => o['status'] == 'history' || o['status'] == 'cancelled',
            )
            .toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adaptiveBg(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            KabaIndigoHero(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Suivi', style: AppTextStyles.greetLabel),
                  const SizedBox(height: 4),
                  Text('Mes commandes', style: AppTextStyles.greetName),
                ],
              ),
            ),
            Expanded(
              child: KabaOverlapSheet(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: LightTabs(
                        tabs: tabs,
                        selectedIndex: _tab,
                        onTap: (i) => setState(() => _tab = i),
                      ),
                    ),
                    Expanded(child: _buildOrdersList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    final data = currentData;
    final list = data.isEmpty
        ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.45,
                child: _buildEmptyOrders(),
              ),
            ],
          )
        : ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              return _buildOrderCard(data[i])
                  .animate()
                  .fadeIn(delay: (40 * i).ms, begin: 0.8)
                  .slideY(delay: (40 * i).ms, begin: 0.08);
            },
          );
    return RefreshIndicator(
      color: LightPageColors.orange,
      onRefresh: () => refreshStudentSession(ref),
      child: list,
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> o) {
    final isCancelled = o['status'] == 'cancelled';
    final isScheduled = o['status'] == 'scheduled';
    return Container(
      decoration: BoxDecoration(
        color: LightPageColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LightPageColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: LightPageColors.indigo.withValues(alpha: 0.04),
            blurRadius: 24,
            spreadRadius: -10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: LightPageColors.indigoLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                        (o['vendor'] as String).isEmpty
                            ? 'K'
                            : (o['vendor'] as String)[0].toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: LightPageColors.indigo,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              o['vendor'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.text,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: (o['color'] as Color).withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              o['badge'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: o['color'] as Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        o['id'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: LightPageColors.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        o['items'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: LightPageColors.text2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isScheduled && !isCancelled && (o['progress'] as int) > 0)
            _buildProgressSteps(
              steps: o['steps'] as List<String>,
              current: o['progress'] as int,
              color: o['color'] as Color,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              children: [
                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: [
                    _buildMeta(Icons.access_time_rounded, o['time'] as String),
                    _buildMeta(
                      Icons.shopping_bag_outlined,
                      '${o['count']} articles',
                    ),
                    _buildMeta(
                      o['pickup'] == 'Sur place'
                          ? Icons.restaurant_rounded
                          : Icons.takeout_dining_rounded,
                      o['pickup'] as String,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: LightPageColors.bg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: LightPageColors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${formatTickets(o['total'] as int)} tickets',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: LightPageColors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          children: [
                            if (o['ready'] == true)
                              LightButton(
                                text: 'J’ai récupéré',
                                compact: true,
                                onPressed: () =>
                                    _confirmReceive(o['id'] as String),
                              ),
                            if (o['status'] == 'pending')
                              LightButton(
                                text: 'Annuler',
                                icon: Icons.close_rounded,
                                isPrimary: false,
                                compact: true,
                                onPressed: () =>
                                    _cancelOrder(o['id'] as String),
                              ),
                            if (o['status'] == 'history' ||
                                o['status'] == 'cancelled')
                              LightButton(
                                text: 'Recommander',
                                icon: Icons.refresh_rounded,
                                isPrimary: false,
                                compact: true,
                                onPressed: () =>
                                    _reorder(o['order'] as OrderModel),
                              ),
                            LightButton(
                              text: 'Détails',
                              icon: Icons.arrow_forward_rounded,
                              compact: true,
                              isPrimary: o['ready'] != true &&
                                  o['status'] != 'pending',
                              onPressed: () => context.push(
                                '/order-detail',
                                extra: o['id'] as String,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSteps({
    required List<String> steps,
    required int current,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 6, 16, 10),
      child: Column(
        children: [
          SizedBox(
            height: 18,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 9,
                  right: 9,
                  child: Container(height: 2, color: LightPageColors.border),
                ),
                Row(
                  children: List.generate(steps.length, (i) {
                    final done = i < current;
                    final active = i == current - 1;
                    return Expanded(
                      child: Center(
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: done ? color : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: done ? color : LightPageColors.border,
                              width: 2,
                            ),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      spreadRadius: -2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: done
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 11,
                                  color: Colors.white,
                                  weight: 6,
                                )
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(steps.length, (i) {
              final done = i < current;
              return Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    steps[i],
                    maxLines: 1,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8.5,
                      fontWeight: done ? FontWeight.w800 : FontWeight.w500,
                      color: done ? color : LightPageColors.muted,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: LightPageColors.muted),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: LightPageColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyOrders() {
    return KabaEmptyState(
      icon: Icons.receipt_long_outlined,
      title: switch (_tab) {
        0 => 'Aucune commande en attente',
        1 => 'Rien en préparation',
        _ => 'Aucune commande passée',
      },
      subtitle: switch (_tab) {
        0 => 'Trouve une cantine et passe ta première commande.',
        1 => 'Tes commandes en cours apparaîtront ici.',
        _ => 'Ton historique de commandes apparaîtra ici.',
      },
      actionLabel: 'Découvrir les cantines',
      onAction: () => context.go('/canteen-list'),
    );
  }
}
