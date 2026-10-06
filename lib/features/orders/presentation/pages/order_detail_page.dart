import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/cart/data/cart_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import '../../../../shared/widgets/remote_photo.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  bool _busy = false;
  Timer? _clock;
  Timer? _poller;

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    _poller = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final order = ref.read(orderDetailProvider(widget.orderId)).valueOrNull;
      if (order == null) return;
      if (order.status == OrderStatus.PENDING ||
          order.status == OrderStatus.READY) {
        ref.invalidate(orderDetailProvider(widget.orderId));
      }
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    _poller?.cancel();
    super.dispose();
  }

  String _label(OrderStatus status) => switch (status) {
        OrderStatus.PENDING => 'En attente du vendeur',
        OrderStatus.ACCEPTED => 'Acceptée',
        OrderStatus.IN_PREPARATION => 'En préparation',
        OrderStatus.READY => 'Prête à retirer',
        OrderStatus.RECEIVED ||
        OrderStatus.AUTO_RECEIVED ||
        OrderStatus.COMPLETED =>
          'Retirée',
        OrderStatus.REFUSED => 'Refusée',
        OrderStatus.CANCELLED_VENDOR ||
        OrderStatus.CANCELLED_STUDENT ||
        OrderStatus.CANCELLED =>
          'Annulée',
        OrderStatus.REFUNDED => 'Remboursée',
        _ => status.name,
      };

  Color _statusColor(OrderStatus status) => switch (status) {
        OrderStatus.READY => AppColors.success,
        OrderStatus.IN_PREPARATION || OrderStatus.ACCEPTED => const Color(0xFF6366F1),
        OrderStatus.PENDING => LightPageColors.warning,
        OrderStatus.REFUSED ||
        OrderStatus.CANCELLED_VENDOR ||
        OrderStatus.CANCELLED_STUDENT ||
        OrderStatus.CANCELLED =>
          LightPageColors.red,
        OrderStatus.REFUNDED => LightPageColors.muted,
        _ => LightPageColors.indigo,
      };

  int _progress(OrderStatus status) => switch (status) {
        OrderStatus.PENDING || OrderStatus.ACCEPTED => 1,
        OrderStatus.IN_PREPARATION => 2,
        OrderStatus.READY => 3,
        OrderStatus.RECEIVED ||
        OrderStatus.AUTO_RECEIVED ||
        OrderStatus.COMPLETED =>
          4,
        _ => 0,
      };

  String _ref(OrderModel order) => '#${order.displayCode}';

  int _remainingSeconds(OrderModel order) {
    if (order.status == OrderStatus.PENDING) {
      final elapsed = DateTime.now().difference(order.createdAt).inSeconds;
      return (300 - elapsed).clamp(0, 300);
    }
    if (order.status == OrderStatus.READY) {
      final start = order.readyAt ?? order.updatedAt;
      final elapsed = DateTime.now().difference(start).inSeconds;
      return (3600 - elapsed).clamp(0, 3600);
    }
    return 0;
  }

  String _formatCountdown(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final rest = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${rest.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${rest.toString().padLeft(2, '0')}';
  }

  String _when(DateTime date) {
    final local = date.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '${local.day}/${local.month} · ${hh}h$mm';
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(orderDetailProvider(widget.orderId));
    return LightPageScaffold(
      title: 'Commande',
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => KabaEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Impossible de charger',
          subtitle: apiErrorMessage(error),
        ),
        data: (order) => _body(order),
      ),
      bottomNavigationBar: async.maybeWhen(
        data: (order) => _actions(order),
        orElse: () => null,
      ),
    );
  }

  Widget _body(OrderModel order) {
    final color = _statusColor(order.status);
    final step = _progress(order.status);
    const steps = ['Envoyée', 'Préparation', 'Prête', 'Retirée'];
    final failed = step == 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.indigoDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    KabaStatusPill(
                      label: _label(order.status),
                      color: color,
                      inverted: true,
                    ),
                    const Spacer(),
                    Text(
                      _ref(order),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  order.vendorName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _when(order.createdAt),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      if (i > 0)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 18),
                            color: failed
                                ? Colors.white.withValues(alpha: 0.12)
                                : (i < step
                                    ? AppColors.accent
                                    : Colors.white.withValues(alpha: 0.16)),
                          ),
                        ),
                      _TimelineDot(
                        label: steps[i],
                        active: !failed && i < step,
                        current: !failed && i == step - 1,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 280.ms)
            .slideY(begin: 0.04, duration: 320.ms),
        const SizedBox(height: 16),
        _PickupCodeCard(code: order.displayCode),
        if (order.status == OrderStatus.PENDING ||
            order.status == OrderStatus.READY) ...[
          const SizedBox(height: 12),
          _CountdownCard(
            seconds: _remainingSeconds(order),
            label: order.status == OrderStatus.PENDING
                ? 'Le vendeur a 5 min pour accepter'
                : 'Tu as 1 h pour récupérer et confirmer',
            formatted: _formatCountdown(_remainingSeconds(order)),
            pending: order.status == OrderStatus.PENDING,
          ),
        ],
        const SizedBox(height: 20),
        const LightSectionTitle(title: 'Articles'),
        ...order.items.map(
          (line) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LightCard(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  RemotePhoto(
                    url: line.imageUrl,
                    width: 64,
                    height: 64,
                    radius: 14,
                    fallback: ColoredBox(
                      color: const Color(0xFF1B2A6B),
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: Icon(
                          Icons.restaurant_rounded,
                          color: AppColors.accent.withValues(alpha: 0.85),
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
                          line.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${line.quantity}x',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: LightPageColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (line.priceTickets > 0)
                    Text(
                      formatTickets(line.priceTickets * line.quantity),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: LightPageColors.orange,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        LightCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                'Total',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.text,
                ),
              ),
              const Spacer(),
              Text(
                '${formatTickets(order.totalTickets)} tickets',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: LightPageColors.orange,
                ),
              ),
            ],
          ),
        ),
        if (order.reason != null && order.reason!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          LightHintBox(
            text: order.reason!.trim(),
            isWarning: order.status == OrderStatus.REFUSED ||
                order.status == OrderStatus.CANCELLED_VENDOR ||
                order.status == OrderStatus.CANCELLED_STUDENT ||
                order.status == OrderStatus.CANCELLED,
          ),
        ],
        if (_canReview(order)) ...[
          const SizedBox(height: 16),
          _OrderReviewCard(order: order),
        ],
      ],
    );
  }

  bool _canReview(OrderModel order) {
    if (order.hasReview) return false;
    return order.status == OrderStatus.READY ||
        order.status == OrderStatus.RECEIVED ||
        order.status == OrderStatus.AUTO_RECEIVED;
  }

  Widget? _actions(OrderModel order) {
    final canReceive = order.status == OrderStatus.READY;
    final canCancel = order.status == OrderStatus.PENDING;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canReceive)
              LightButton(
                text: 'J’ai récupéré',
                icon: Icons.check_rounded,
                isLoading: _busy,
                onPressed: _busy ? null : () => _receive(order.id),
              ),
            if (canCancel) ...[
              if (canReceive) const SizedBox(height: 8),
              LightButton(
                text: 'Annuler la commande',
                isPrimary: false,
                isDanger: true,
                isLoading: _busy,
                onPressed: _busy ? null : () => _cancel(order.id),
              ),
            ],
            if (canReceive || canCancel) const SizedBox(height: 8),
            LightButton(
              text: 'Recommander',
              isPrimary: false,
              icon: Icons.replay_rounded,
              onPressed: _busy ? null : () => _reorder(order),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _receive(String id) async {
    setState(() => _busy = true);
    try {
      await ref.read(orderRepositoryProvider).confirmReceive(id);
      ref.invalidate(myOrdersProvider);
      ref.invalidate(orderDetailProvider(id));
      ref.invalidate(meProvider);
      if (mounted) showKabaSnack(context, 'Commande marquée comme retirée');
    } catch (error) {
      if (mounted) {
        showKabaSnack(context, apiErrorMessage(error), error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancel(String id) async {
    setState(() => _busy = true);
    try {
      await ref.read(orderRepositoryProvider).cancelOrder(id);
      ref.invalidate(myOrdersProvider);
      ref.invalidate(orderDetailProvider(id));
      ref.invalidate(meProvider);
      if (mounted) {
        showKabaSnack(context, 'Commande annulée');
        context.pop();
      }
    } catch (error) {
      if (mounted) {
        showKabaSnack(context, apiErrorMessage(error), error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
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
}

class _TimelineDot extends StatelessWidget {
  final String label;
  final bool active;
  final bool current;

  const _TimelineDot({
    required this.label,
    required this.active,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final fill = current
        ? AppColors.accent
        : active
            ? Colors.white
            : Colors.white.withValues(alpha: 0.22);
    return Column(
      children: [
        Container(
          width: current ? 12 : 9,
          height: current ? 12 : 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fill,
            border: current
                ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2)
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: active || current
                ? Colors.white
                : Colors.white.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _PickupCodeCard extends StatelessWidget {
  final String code;
  const _PickupCodeCard({required this.code});

  @override
  Widget build(BuildContext context) {
    return LightCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        children: [
          Text(
            'Numéro de commande',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: LightPageColors.muted,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            code,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: LightPageColors.indigo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Présente ce numéro au vendeur pour récupérer ta commande.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: LightPageColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownCard extends StatelessWidget {
  final int seconds;
  final String formatted;
  final String label;
  final bool pending;

  const _CountdownCard({
    required this.seconds,
    required this.formatted,
    required this.label,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    final total = pending ? 300 : 3600;
    final progress = total == 0 ? 0.0 : (seconds / total).clamp(0.0, 1.0);
    final color = pending ? LightPageColors.warning : AppColors.success;
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor: color.withValues(alpha: 0.16),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
                Text(
                  formatted,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: seconds >= 3600 ? 9 : 11,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: LightPageColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderReviewCard extends ConsumerStatefulWidget {
  final OrderModel order;
  const _OrderReviewCard({required this.order});

  @override
  ConsumerState<_OrderReviewCard> createState() => _OrderReviewCardState();
}

class _OrderReviewCardState extends ConsumerState<_OrderReviewCard> {
  int _rating = 5;
  bool _sending = false;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _sending = true);
    try {
      await ref.read(reviewRepositoryProvider).createReview(
            orderId: widget.order.id,
            vendorId: widget.order.vendorId,
            rating: _rating,
            comment: _comment.text.trim(),
          );
      ref.invalidate(orderDetailProvider(widget.order.id));
      if (!mounted) return;
      showKabaSnack(context, 'Avis envoyé, merci.');
    } catch (error) {
      if (mounted) {
        showKabaSnack(context, apiErrorMessage(error), error: true);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LightCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donne ton avis',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ta commande est prête. Dis-nous comment ça s’est passé.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: LightPageColors.muted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final value = i + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = value),
                icon: Icon(
                  value <= _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: LightPageColors.warning,
                ),
              );
            }),
          ),
          TextField(
            controller: _comment,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: LightPageColors.text,
            ),
            decoration: InputDecoration(
              hintText: 'Commentaire optionnel',
              filled: false,
              fillColor: Colors.transparent,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: LightPageColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 12),
          LightButton(
            text: _sending ? 'Envoi…' : 'Envoyer l’avis',
            onPressed: _sending ? null : _submit,
          ),
        ],
      ),
    );
  }
}
