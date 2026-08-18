import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  int _tab = 0;
  final searchController = TextEditingController();
  final List<String> tabs = const ['Toutes', 'Entrées', 'Sorties', 'Recharges'];

  final List<Map<String, dynamic>> allTx = [
    {
      'type': 'in',
      'category': 'RECHARGE',
      'title': 'Recharge Mobile Money',
      'subtitle': 'Togocom · +228 90 12 34 56',
      'amount': 5000,
      'bonus': 250,
      'date': 'Aujourd\'hui · 14h32',
      'ref': 'KBK-8A3F21',
      'icon': Icons.add_card_rounded,
      'status': 'success',
    },
    {
      'type': 'out',
      'category': 'PAYMENT',
      'title': 'Commande Chez Mama Afi',
      'subtitle': 'Riz sauce arachide · 2 plats',
      'amount': 3500,
      'date': 'Aujourd\'hui · 12h15',
      'ref': 'CMD-78945',
      'icon': Icons.restaurant_rounded,
      'status': 'success',
    },
    {
      'type': 'in',
      'category': 'TRANSFER',
      'title': 'Reçu de Yao Mensah',
      'subtitle': '+228 91 23 45 67',
      'amount': 1500,
      'date': 'Hier · 20h44',
      'ref': 'TRF-11223',
      'icon': Icons.arrow_downward_rounded,
      'status': 'success',
    },
    {
      'type': 'out',
      'category': 'TRANSFER',
      'title': 'Envoyé à Afi Kossi',
      'subtitle': '+228 92 34 56 78',
      'amount': 2000,
      'date': 'Hier · 15h08',
      'ref': 'TRF-99877',
      'icon': Icons.arrow_upward_rounded,
      'status': 'success',
    },
    {
      'type': 'in',
      'category': 'BONUS',
      'title': 'Bonus Ambassadeur',
      'subtitle': '3 filleuls actifs ce mois',
      'amount': 1200,
      'date': 'Lun · 09h00',
      'ref': 'BON-66211',
      'icon': Icons.card_giftcard_rounded,
      'status': 'success',
    },
    {
      'type': 'out',
      'category': 'PAYMENT',
      'title': 'Cantine du Campus',
      'subtitle': 'Plat du jour · Poulet braisé',
      'amount': 1800,
      'date': 'Sam · 13h22',
      'ref': 'CMD-78201',
      'icon': Icons.restaurant_menu_rounded,
      'status': 'success',
    },
    {
      'type': 'in',
      'category': 'RECHARGE',
      'title': 'Recharge Carte Bancaire',
      'subtitle': 'Visa •• 4421',
      'amount': 10000,
      'bonus': 1000,
      'date': 'Ven · 18h05',
      'ref': 'KBK-2E8A10',
      'icon': Icons.credit_card_rounded,
      'status': 'success',
    },
    {
      'type': 'out',
      'category': 'REFUND',
      'title': 'Remboursement commande',
      'subtitle': 'Cantine La Paix · Produit indisponible',
      'amount': 900,
      'date': 'Jeu · 11h40',
      'ref': 'RFD-55128',
      'icon': Icons.refresh_rounded,
      'status': 'pending',
    },
  ];

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
        .fold(
          0,
          (s, t) => s + (t['amount'] as int) + (t['bonus'] as int? ?? 0),
        );
    final exits = allTx
        .where((t) => t['type'] == 'out' && t['category'] != 'REFUND')
        .fold(0, (s, t) => s + t['amount'] as int);
    return LightPageScaffold(
      title: 'Historique',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: LightIconButton(icon: Icons.filter_list_rounded, onTap: () {}),
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightPageColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            size: 18,
            color: LightPageColors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LightPageColors.text,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Rechercher une transaction',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: LightPageColors.muted,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: LightPageColors.bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.mic_none_rounded,
              size: 15,
              color: LightPageColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTxItem(Map<String, dynamic> t) {
    final isIn = t['type'] == 'in';
    final status = t['status'] as String;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
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
        color: Colors.white,
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
            child: const Icon(
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
