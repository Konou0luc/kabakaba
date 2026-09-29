import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends ConsumerState<TransactionHistoryPage> {
  int _tab = 0;
  final searchController = TextEditingController();
  final List<String> tabs = const ['Toutes', 'Entrées', 'Sorties', 'Recharges'];

  List<Map<String, dynamic>> get allTx {
    final api = ref.watch(myTransactionsProvider).valueOrNull ?? const [];
    return [for (final tx in api) _mapTx(tx)];
  }

  Map<String, dynamic> _mapTx(TransactionModel tx) {
    final incoming =
        tx.type == TransactionType.RECHARGE ||
        tx.type == TransactionType.TRANSFER_RECEIVED ||
        tx.type == TransactionType.ORDER_REFUND ||
        tx.type == TransactionType.COMMISSION;
    final title = switch (tx.type) {
      TransactionType.RECHARGE => 'Rechargement',
      TransactionType.TRANSFER_SENT => 'Transfert envoyé',
      TransactionType.TRANSFER_RECEIVED => 'Transfert reçu',
      TransactionType.ORDER_PAYMENT => 'Commande',
      TransactionType.ORDER_REFUND => 'Remboursement',
      TransactionType.COMMISSION => 'Commission',
      TransactionType.PAYOUT => 'Retrait',
      TransactionType.ADJUSTMENT => 'Ajustement',
    };
    final category = switch (tx.type) {
      TransactionType.RECHARGE => 'RECHARGE',
      TransactionType.ORDER_PAYMENT => 'PAYMENT',
      TransactionType.ORDER_REFUND => 'REFUND',
      _ => 'TRANSFER',
    };
    final local = tx.createdAt.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return {
      'type': incoming ? 'in' : 'out',
      'category': category,
      'title': title,
      'subtitle': tx.reference ?? tx.status.name,
      'amount': tx.amount,
      'date': '${local.day}/${local.month} · ${hh}h$mm',
      'ref': tx.reference ?? tx.id,
      'icon': incoming ? Icons.add_circle_rounded : Icons.restaurant_rounded,
      'status': tx.status == TransactionStatus.COMPLETED
          ? 'success'
          : tx.status == TransactionStatus.PENDING
              ? 'pending'
              : 'failed',
    };
  }

  List<Map<String, dynamic>> get filtered {
    final q = searchController.text.toLowerCase();
    return allTx.where((t) {
      final matchTab = switch (_tab) {
        1 => t['type'] == 'in',
        2 => t['type'] == 'out',
        3 => t['category'] == 'RECHARGE',
        _ => true,
      };
      final matchSearch =
          q.isEmpty ||
          (t['title'] as String).toLowerCase().contains(q) ||
          (t['ref'] as String).toLowerCase().contains(q);
      return matchTab && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = allTx
        .where((t) => t['type'] == 'in')
        .fold(0, (s, t) => s + (t['amount'] as int));
    final exits = allTx
        .where((t) => t['type'] == 'out')
        .fold(0, (s, t) => s + (t['amount'] as int));
    return LightPageScaffold(
      title: 'Historique',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummary(entries, exits),
            const SizedBox(height: 18),
            _buildSearch(),
            const SizedBox(height: 16),
            LightTabs(
              tabs: tabs,
              selectedIndex: _tab,
              onTap: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: 18),
            if (filtered.isEmpty)
              _buildEmpty()
            else
              ...List.generate(filtered.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i == filtered.length - 1 ? 0 : 10,
                  ),
                  child: _buildTxItem(filtered[i])
                      .animate()
                      .fadeIn(delay: (30 * i).ms, begin: 0.8)
                      .slideX(delay: (30 * i).ms, begin: -0.05),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(int entries, int exits) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B2A6B),
            const Color(0xFF2A3F99).withValues(alpha: 0.95),
            const Color(0xFFF07840).withValues(alpha: 0.25),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2A6B).withValues(alpha: 0.22),
            blurRadius: 32,
            spreadRadius: -10,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Période du mois',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF07840).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Août 2026',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFC7A3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${(entries - exits).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} tickets',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Solde net du mois',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A34A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_downward_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Entrées',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF86EFAC),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entries.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]} ',
                        ),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'tickets',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: const Color(0xFF86EFAC),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFDC2626).withValues(alpha: 0.28),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDC2626),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_upward_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Sorties',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFECACA),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        exits.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]} ',
                        ),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'tickets',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: const Color(0xFFFECACA),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return KabaSearchField(
      controller: searchController,
      hintText: 'Rechercher une transaction',
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildTxItem(Map<String, dynamic> t) {
    final isIn = t['type'] == 'in';
    final status = t['status'] as String;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isIn
                  ? LightPageColors.greenLight
                  : LightPageColors.orangeLight.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              t['icon'] as IconData,
              color: isIn ? LightPageColors.green : LightPageColors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        t['title'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.text,
                        ),
                      ),
                    ),
                    if (t['bonus'] != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: LightPageColors.warningLight,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '+${t['bonus']}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: LightPageColors.warning,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  t['subtitle'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: LightPageColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      t['date'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: LightPageColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '·',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: LightPageColors.border,
                      ),
                    ),
                    Text(
                      t['ref'] as String,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: LightPageColors.text2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIn ? '+' : '-'}${(t['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: isIn ? LightPageColors.green : LightPageColors.text,
                ),
              ),
              const SizedBox(height: 3),
              status == 'pending'
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: LightPageColors.warningLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 6, child: SizedBox()),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: LightPageColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'En cours',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: LightPageColors.warning,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      'tickets',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: LightPageColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: LightPageColors.indigoLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.manage_history_rounded,
              size: 42,
              color: LightPageColors.indigo,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune transaction',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Aucune transaction trouvée dans cette catégorie',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: LightPageColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: 180,
            child: LightButton(
              text: 'Nouvelle recharge',
              icon: Icons.add_card_rounded,
              onPressed: () => context.push('/recharge/step1'),
            ),
          ),
        ],
      ),
    );
  }
}
