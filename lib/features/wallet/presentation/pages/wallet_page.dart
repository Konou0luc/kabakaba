import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final List<Map<String, dynamic>> _transactions = [
    {
      'icon': Icons.add_circle_rounded,
      'title': 'Rechargement',
      'subtitle': 'Mobile Money',
      'amount': '+5 000',
      'unit': 'tickets',
      'time': "Aujourd'hui, 14h30",
      'isPositive': true,
    },
    {
      'icon': Icons.restaurant_rounded,
      'title': 'Commande Chez Mama Afi',
      'subtitle': 'Plat attiéké + poulet',
      'amount': '-1 500',
      'unit': 'tickets',
      'time': 'Hier, 12h15',
      'isPositive': false,
    },
    {
      'icon': Icons.send_rounded,
      'title': 'Transfert à Yao',
      'subtitle': '+228 91 23 45 67',
      'amount': '-2 000',
      'unit': 'tickets',
      'time': 'Lun, 09h40',
      'isPositive': false,
    },
    {
      'icon': Icons.attach_money_rounded,
      'title': 'Commission Ambassadeur',
      'subtitle': '3 filleuls actifs',
      'amount': '+750',
      'unit': 'tickets',
      'time': 'Dim, 18h00',
      'isPositive': true,
    },
    {
      'icon': Icons.restaurant_rounded,
      'title': 'Commande Resto Campus 2',
      'subtitle': 'Riz yassa + boisson',
      'amount': '-2 200',
      'unit': 'tickets',
      'time': 'Sam, 13h20',
      'isPositive': false,
    },
    {
      'icon': Icons.add_circle_rounded,
      'title': 'Rechargement',
      'subtitle': 'Carte bancaire',
      'amount': '+10 000',
      'unit': 'tickets',
      'time': 'Ven, 20h05',
      'isPositive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigoDark,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 34),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.indigoDark],
          transform: const GradientRotation(2.705),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -60,
            right: -50,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.16),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
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
                          'Bonjour, Koffi 👋',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.line, width: 1),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
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
                '5 000 tickets',
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
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.line, width: 1)),
        ),
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: CustomScrollView(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dernières transactions',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/transaction-history'),
                        child: Text(
                          'Voir tout',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverList.separated(
                itemCount: _transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
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
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Entrées',
            value: '+15 750',
            icon: Icons.arrow_downward_rounded,
            iconColor: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: 'Sorties',
            value: '-5 700',
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
        color: AppColors.field,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.line, width: 1),
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
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
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
        color: AppColors.field,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.line, width: 1),
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
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tx['subtitle'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.muted,
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
                  color: tx['isPositive'] ? AppColors.success : AppColors.white,
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
