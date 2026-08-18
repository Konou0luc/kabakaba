import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class RechargeStep2SelfPage extends StatefulWidget {
  const RechargeStep2SelfPage({super.key});

  @override
  State<RechargeStep2SelfPage> createState() => _RechargeStep2SelfPageState();
}

class _RechargeStep2SelfPageState extends State<RechargeStep2SelfPage> {
  final List<int> amounts = [1000, 2500, 5000, 10000, 20000, 50000];
  int? selectedAmount;
  final customController = TextEditingController();

  @override
  void dispose() {
    customController.dispose();
    super.dispose();
  }

  int get total => selectedAmount ?? (int.tryParse(customController.text) ?? 0);
  double get bonus {
    final t = total;
    if (t >= 10000) return t * 0.10;
    if (t >= 5000) return t * 0.05;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Choisir le montant',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(step: 2, total: 3),
            const SizedBox(height: 16),
            _buildRecipientCardSelf(),
            const SizedBox(height: 20),
            Text(
              'Montant à recharger',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.3,
              children: List.generate(amounts.length, (i) {
                final a = amounts[i];
                final sel = selectedAmount == a;
                return _amountChip(a, sel).animate().fadeIn(
                      delay: (30 * i).ms,
                      begin: 0.8,
                    );
              }),
            ),
            const SizedBox(height: 14),
            _buildCustomAmount(),
            if (bonus > 0) ...[
              const SizedBox(height: 16),
              _buildBonusCard(),
            ],
            const SizedBox(height: 24),
            _buildTotalRow(),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: LightButton(
                text: 'Continuer vers le paiement',
                icon: Icons.arrow_forward_rounded,
                isPrimary: total > 0,
                onPressed: total > 0
                    ? () {
                        context.push('/recharge/step3', extra: {
                          'recipient': 'self',
                          'amount': total,
                          'bonus': bonus.toInt(),
                        });
                      }
                    : null,
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

  Widget _buildRecipientCardSelf() {
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: LightPageColors.indigoLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: LightPageColors.indigo,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mon portefeuille',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Koffi Mensah · +228 90 12 34 56',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const LightBadge(text: '5 000'),
        ],
      ),
    );
  }

  Widget _amountChip(int amount, bool selected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedAmount = amount;
            customController.clear();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? LightPageColors.orangeLight.withValues(alpha: 0.9)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? LightPageColors.orange.withValues(alpha: 0.6)
                  : LightPageColors.border,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$amount',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: selected
                      ? LightPageColors.orange
                      : LightPageColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'tickets',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? LightPageColors.orange.withValues(alpha: 0.8)
                      : LightPageColors.muted,
                ),
              ),
              if (amount >= 5000)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: LightPageColors.greenLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      amount >= 10000 ? '+10%' : '+5%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: LightPageColors.green,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAmount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightPageColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.edit_outlined,
            size: 16,
            color: LightPageColors.muted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: customController,
              keyboardType: TextInputType.number,
              onChanged: (_) {
                setState(() {
                  selectedAmount = null;
                });
              },
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: LightPageColors.text,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Montant personnalisé',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: LightPageColors.muted,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Text(
            'tickets',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: LightPageColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LightPageColors.greenLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: LightPageColors.green.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              size: 16,
              color: LightPageColors.green,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonus de bienvenue !',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.green,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '+${bonus.toInt()} tickets offerts pour votre recharge',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: LightPageColors.green.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: LightPageColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sous-total',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: LightPageColors.text2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$total tickets',
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
                  'Bonus offert',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: LightPageColors.text2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '+${bonus.toInt()} tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.green,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Container(height: 1, color: LightPageColors.border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total crédité',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.text,
                ),
              ),
              Text(
                '${total + bonus.toInt()} tickets',
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
}
