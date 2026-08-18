import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class RechargeStep3Page extends StatefulWidget {
  final Map<String, dynamic> data;
  const RechargeStep3Page({super.key, required this.data});

  @override
  State<RechargeStep3Page> createState() => _RechargeStep3PageState();
}

class _RechargeStep3PageState extends State<RechargeStep3Page> {
  int? selectedPayment = 0;
  final List<Map<String, dynamic>> methods = [
    {
      'name': 'Mobile Money',
      'subtitle': 'Togocom · Moov Money',
      'icon': Icons.phone_android_rounded,
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFD1FAE5),
    },
    {
      'name': 'Carte bancaire',
      'subtitle': 'Visa · Mastercard',
      'icon': Icons.credit_card_rounded,
      'color': const Color(0xFF6366F1),
      'bgColor': const Color(0xFFE0E7FF),
    },
    {
      'name': 'Apple Pay / Google Pay',
      'subtitle': 'Paiement express',
      'icon': Icons.touch_app_rounded,
      'color': const Color(0xFF0D1438),
      'bgColor': const Color(0xFFE4E8F1),
    },
  ];

  bool get isSelf => widget.data['recipient'] == 'self';
  int get amount => widget.data['amount'] as int;
  int get bonus => (widget.data['bonus'] ?? 0) as int;
  int get total => amount + bonus;

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Récapitulatif',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(step: 3, total: 3),
            const SizedBox(height: 16),
            Text(
              'Votre commande',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildRecipientCard(),
            const SizedBox(height: 14),
            _buildAmountSummary(),
            const SizedBox(height: 20),
            Text(
              'Moyen de paiement',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(methods.length, (i) {
              final m = methods[i];
              final sel = selectedPayment == i;
              return Padding(
                padding: EdgeInsets.only(bottom: i == methods.length - 1 ? 0 : 10),
                child: _paymentMethod(m, sel, i).animate().fadeIn(
                      delay: (40 * i).ms,
                      begin: 0.9,
                    ),
              );
            }),
            const SizedBox(height: 20),
            _buildSecurityNote(),
            const SizedBox(height: 20),
            _buildTotalBottom(),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: LightButton(
                text:
                    'Payer ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} FCFA',
                icon: Icons.lock_rounded,
                onPressed: () {
                  context.pushReplacement('/recharge/confirmation', extra: {
                    ...widget.data,
                    'payment': methods[selectedPayment ?? 0]['name'],
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required int step, required int total}) {
    return Row(
      children: [
        ...List.generate(total, (i) {
          final isActive = i < step;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == total - 1 ? 0 : 8),
              height: 4,
              decoration: BoxDecoration(
                color:
                    isActive ? LightPageColors.orange : LightPageColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
        const SizedBox(width: 12),
        LightBadge(
          text: 'Étape $step/$total',
          bgColor: LightPageColors.orangeLight,
          color: LightPageColors.orange,
        ),
      ],
    );
  }

  Widget _buildRecipientCard() {
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelf
                  ? LightPageColors.indigoLight
                  : LightPageColors.orangeLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isSelf ? Icons.person_outline_rounded : Icons.person_add_rounded,
              color: isSelf
                  ? LightPageColors.indigo
                  : LightPageColors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSelf
                      ? 'Mon portefeuille'
                      : (widget.data['recipientName'] ?? 'Ami'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isSelf
                      ? '+228 90 12 34 56 · Koffi Mensah'
                      : (widget.data['recipientPhone'] ?? ''),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          LightBadge(
            text: isSelf ? 'Moi' : 'Ami',
            bgColor: isSelf
                ? LightPageColors.indigoLight
                : LightPageColors.orangeLight,
            color: isSelf
                ? LightPageColors.indigo
                : LightPageColors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: LightPageColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tickets achetés',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: LightPageColors.text2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$amount tickets',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.text,
                ),
              ),
            ],
          ),
          if (bonus > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bonus kabakaba',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: LightPageColors.text2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '+$bonus tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.green,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Frais de service',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: LightPageColors.text2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '0 FCFA',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: LightPageColors.border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total crédité',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: LightPageColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$total tickets',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: LightPageColors.orange,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Montant débité',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: LightPageColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} FCFA',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: LightPageColors.text,
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

  Widget _paymentMethod(Map<String, dynamic> m, bool selected, int i) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => selectedPayment = i),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? LightPageColors.orangeLight.withValues(alpha: 0.7)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: m['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  m['icon'] as IconData,
                  color: m['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m['name'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: LightPageColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m['subtitle'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: LightPageColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? LightPageColors.orange : Colors.white,
                  border: Border.all(
                    color: selected
                        ? LightPageColors.orange
                        : LightPageColors.border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return LightHintBox(
      icon: Icons.verified_user_outlined,
      text:
          'Votre paiement est sécurisé par le protocole 3-D Secure. Aucune information bancaire n\'est stockée sur nos serveurs.',
    );
  }

  Widget _buildTotalBottom() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B2A6B).withValues(alpha: 0.04),
            const Color(0xFFF07840).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF07840).withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2A6B),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Color(0xFFF07840),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paiement instantané',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Tickets crédités immédiatement après validation',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
