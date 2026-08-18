import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class RechargeConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const RechargeConfirmationPage({super.key, required this.data});

  bool get isSelf => data['recipient'] == 'self';
  int get amount => (data['amount'] ?? 0) as int;
  int get bonus => (data['bonus'] ?? 0) as int;
  int get total => amount + bonus;
  String get ref =>
      'KBK-${DateTime.now().millisecondsSinceEpoch.toString().substring(6, 12).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Recharge réussie',
      showBackButton: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSuccessIllustration()
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 500), begin: 0)
                .scaleY(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  begin: 0.85,
                ),
            const SizedBox(height: 20),
            Text(
                  isSelf ? 'Recharge effectuée !' : 'Envoi réussi !',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 200))
                .slideY(delay: const Duration(milliseconds: 200), begin: 0.15),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                isSelf
                    ? 'Votre portefeuille a été crédité. Vous pouvez maintenant commander dans vos cantines préférées.'
                    : 'Les tickets ont bien été envoyés à ${data['recipientName'] ?? 'votre ami'}. Il recevra une notification SMS.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  height: 1.5,
                  color: LightPageColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
            const SizedBox(height: 24),
            _buildReceiptCard()
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 400), begin: 0.95)
                .slideY(delay: const Duration(milliseconds: 400), begin: 0.1),
            const SizedBox(height: 20),
            _buildReceiptDetail(
              icon: Icons.receipt_long_outlined,
              label: 'Référence',
              value: ref,
              copyable: true,
            ),
            _buildReceiptDetail(
              icon: Icons.schedule_rounded,
              label: 'Date',
              value: _formatDate(DateTime.now()),
            ),
            _buildReceiptDetail(
              icon: Icons.payment_outlined,
              label: 'Méthode',
              value: (data['payment'] as String?) ?? 'Mobile Money',
              last: true,
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: LightButton(
                    text: 'Voir les détails',
                    icon: Icons.receipt_outlined,
                    isPrimary: false,
                    onPressed: () {
                      context.go('/wallet');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LightButton(
                    text: 'Retour accueil',
                    icon: Icons.home_rounded,
                    onPressed: () {
                      context.go('/home');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.push('/recharge/step1');
              },
              child: Text(
                'Effectuer une autre recharge',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIllustration() {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LightPageColors.greenLight.withValues(alpha: 0.5),
            ),
          ),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LightPageColors.greenLight,
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  LightPageColors.green.withValues(alpha: 0.95),
                  const Color(0xFF059669),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: LightPageColors.green.withValues(alpha: 0.35),
                  blurRadius: 28,
                  spreadRadius: -6,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 52,
              color: Colors.white,
              weight: 4,
            ),
          ),
          Positioned(
            top: 12,
            right: 18,
            child: _buildSparkle(const Color(0xFFF07840), size: 10),
          ),
          Positioned(
            top: 40,
            left: 8,
            child: _buildSparkle(const Color(0xFF6366F1), size: 8),
          ),
          Positioned(
            bottom: 22,
            right: 6,
            child: _buildSparkle(const Color(0xFF10B981), size: 9),
          ),
          Positioned(
            bottom: 44,
            left: 16,
            child: _buildSparkle(const Color(0xFFF59E0B), size: 7),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle(Color color, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: LightPageColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: LightPageColors.indigo.withValues(alpha: 0.06),
            blurRadius: 32,
            spreadRadius: -12,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1B2A6B),
                  const Color(0xFF2A3F99).withValues(alpha: 0.9),
                  const Color(0xFFF07840).withValues(alpha: 0.3),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(17),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        isSelf
                            ? Icons.account_balance_wallet
                            : Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSelf
                                ? 'Crédit portefeuille'
                                : 'Transfert tickets',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isSelf
                                ? 'Mon compte'
                                : (data['recipientName'] ?? ''),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: LightPageColors.green.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: LightPageColors.green.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 12,
                            color: Color(0xFF86EFAC),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Confirmé',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF86EFAC),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '$total tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} FCFA payés',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          _buildDashedDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                if (bonus > 0) ...[
                  _buildReceiptLine(
                    'Bonus kabakaba offert',
                    '+$bonus tickets',
                    valueColor: LightPageColors.green,
                  ),
                  const SizedBox(height: 10),
                ],
                _buildReceiptLine('Sous-total tickets', '$amount tickets'),
                const SizedBox(height: 10),
                _buildReceiptLine(
                  'Frais de service',
                  'Gratuit',
                  valueColor: LightPageColors.green,
                ),
                const SizedBox(height: 12),
                Container(height: 1, color: LightPageColors.border),
                const SizedBox(height: 12),
                _buildReceiptLine(
                  'Total crédité',
                  '$total tickets',
                  bold: true,
                  valueColor: LightPageColors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          const dashWidth = 6.0;
          const dashSpace = 4.0;
          final dashCount = (width / (dashWidth + dashSpace)).floor();
          return Row(
            children: List.generate(dashCount, (_) {
              return const Padding(
                padding: EdgeInsets.only(right: dashSpace),
                child: SizedBox(
                  width: dashWidth,
                  height: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: LightPageColors.border),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildReceiptLine(
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            color: bold ? LightPageColors.text : LightPageColors.text2,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: bold ? 14.5 : 12.5,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            color: valueColor ?? LightPageColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptDetail({
    required IconData icon,
    required String label,
    required String value,
    bool copyable = false,
    bool last = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: last ? 0 : 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: LightPageColors.indigoLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 15, color: LightPageColors.indigo),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: LightPageColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                ),
              ],
            ),
          ),
          if (copyable)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: LightPageColors.orangeLight.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.copy_rounded,
                    size: 11,
                    color: LightPageColors.orange,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Copier',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: LightPageColors.orange,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final months = [
      'janv.',
      'févr.',
      'mars',
      'avr.',
      'mai',
      'juin',
      'juil.',
      'août',
      'sept.',
      'oct.',
      'nov.',
      'déc.',
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$day ${months[d.month - 1]} ${d.year} · $h:$m';
  }
}
