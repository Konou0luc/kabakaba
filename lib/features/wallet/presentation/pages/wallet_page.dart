import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  List<Map<String, dynamic>> get _displayTx {
    final api = ref.watch(myTransactionsProvider).valueOrNull;
    if (api == null) return const [];
    return api.map(_mapTx).toList();
  }

  bool _isIncoming(TransactionModel tx) =>
      tx.type == TransactionType.RECHARGE ||
      tx.type == TransactionType.TRANSFER_RECEIVED ||
      tx.type == TransactionType.ORDER_REFUND ||
      tx.type == TransactionType.COMMISSION;

  int _sumFor({required bool incoming}) {
    final api = ref.watch(myTransactionsProvider).valueOrNull ?? const [];
    return api
        .where(
          (tx) =>
              tx.status == TransactionStatus.COMPLETED &&
              _isIncoming(tx) == incoming,
        )
        .fold(0, (sum, tx) => sum + tx.amount);
  }

  Map<String, dynamic> _mapTx(TransactionModel tx) {
    final incoming = _isIncoming(tx);
    return {
      'icon': incoming
          ? Icons.add_circle_rounded
          : Icons.restaurant_rounded,
      'title': switch (tx.type) {
        TransactionType.RECHARGE => 'Rechargement',
        TransactionType.TRANSFER_SENT => 'Transfert envoyé',
        TransactionType.TRANSFER_RECEIVED => 'Transfert reçu',
        TransactionType.ORDER_PAYMENT => 'Commande',
        TransactionType.ORDER_REFUND => 'Remboursement',
        TransactionType.COMMISSION => 'Commission',
        TransactionType.PAYOUT => 'Retrait',
        TransactionType.ADJUSTMENT => 'Ajustement',
      },
      'subtitle': tx.reference ?? tx.status.name,
      'amount': '${incoming ? '+' : '-'}${formatTickets(tx.amount)}',
      'unit': 'tickets',
      'time':
          '${tx.createdAt.day}/${tx.createdAt.month} · ${tx.createdAt.hour.toString().padLeft(2, '0')}h${tx.createdAt.minute.toString().padLeft(2, '0')}',
      'isPositive': incoming,
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
            _buildHero(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return KabaIndigoHero(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 34),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mon portefeuille',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.03,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Bonjour, ${ref.watch(meProvider).valueOrNull?.displayFirstName ?? ref.watch(currentUserProvider)?.displayFirstName ?? 'Étudiant'}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  KabaHeroIconButton(
                    icon: Icons.history_rounded,
                    onTap: () => context.push('/transaction-history'),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 14,
                    color: AppColors.white.withValues(alpha: 0.55),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Solde tickets',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.04,
                      color: AppColors.white.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${formatTickets(ref.watch(meProvider).valueOrNull?.walletBalance ?? ref.watch(currentUserProvider)?.walletBalance ?? 0)} tickets',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.02,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceAction(
                      icon: Icons.add,
                      label: 'Recharger',
                      isPrimary: true,
                      onTap: () => context.push('/recharge/step1'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildBalanceAction(
                      icon: Icons.send_rounded,
                      label: 'Envoyer',
                      isPrimary: false,
                      onTap: () => context.push('/send-money'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildBalanceAction(
                      icon: Icons.history_rounded,
                      label: 'Historique',
                      isPrimary: false,
                      onTap: () => context.push('/transaction-history'),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Widget _buildBalanceAction({
    required IconData icon,
    required String label,
    required bool isPrimary,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.accent
              : AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(11),
          border: isPrimary
              ? null
              : Border.all(color: AppColors.line, width: 1),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: Colors.white),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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

  Widget _buildBody() {
    final txs = _displayTx;
    return KabaOverlapSheet(
      child: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () => refreshStudentSession(ref),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  children: [
                    _buildQuickStats().animate().fadeIn().slideY(
                      begin: 0.1,
                      end: 0,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: KabaSectionHeader(
                  kicker: 'Mouvements',
                  title: 'Dernières transactions',
                  action: 'Voir tout',
                  onAction: () => context.push('/transaction-history'),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            if (txs.isEmpty)
              const SliverToBoxAdapter(
                child: KabaEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'Aucun mouvement',
                  subtitle:
                      'Tes recharges et paiements de commandes apparaîtront ici.',
                ),
              )
            else
              SliverList.separated(
                itemCount: txs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final tx = txs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildTxItem(
                      tx,
                    ).animate().fadeIn(delay: (100 + index * 60).ms),
                  );
                },
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Entrées',
            value: '+${formatTickets(_sumFor(incoming: true))}',
            icon: Icons.arrow_downward_rounded,
            iconColor: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: 'Sorties',
            value: '-${formatTickets(_sumFor(incoming: false))}',
            icon: Icons.arrow_upward_rounded,
            iconColor: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LightPageColors.indigoLight,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: LightPageColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTxItem(Map<String, dynamic> tx) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LightPageColors.indigoLight,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (tx['isPositive'] ? AppColors.success : AppColors.error)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              tx['icon'] as IconData,
              color: tx['isPositive'] ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx['title'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tx['subtitle'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${tx['amount']} ${tx['unit']}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: tx['isPositive']
                      ? AppColors.success
                      : LightPageColors.text,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                tx['time'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  color: AppColors.mutedSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
