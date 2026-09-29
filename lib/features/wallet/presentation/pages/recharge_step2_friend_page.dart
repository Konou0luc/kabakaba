import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class RechargeStep2FriendPage extends StatefulWidget {
  const RechargeStep2FriendPage({super.key});

  @override
  State<RechargeStep2FriendPage> createState() =>
      _RechargeStep2FriendPageState();
}

class _RechargeStep2FriendPageState extends State<RechargeStep2FriendPage> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final List<int> amounts = [500, 1000, 2500, 5000, 10000, 20000];
  int? selectedAmount;

  int get total => selectedAmount ?? 0;

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Envoyer à un ami',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(step: 2, total: 3),
            const SizedBox(height: 16),
            Text(
              'Destinataire',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildPhoneField(),
            const SizedBox(height: 12),
            _buildNameField(),
            const SizedBox(height: 20),
            Text(
              'Montant à envoyer',
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
              childAspectRatio: 1.35,
              children: List.generate(amounts.length, (i) {
                final a = amounts[i];
                final sel = selectedAmount == a;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => selectedAmount = a),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: sel
                            ? LightPageColors.orangeLight
                            : LightPageColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel
                              ? LightPageColors.orange.withValues(alpha: 0.6)
                              : LightPageColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$a',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: sel
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
                              color: sel
                                  ? LightPageColors.orange.withValues(
                                      alpha: 0.8,
                                    )
                                  : LightPageColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: (30 * i).ms, begin: 0.8);
              }),
            ),
            const SizedBox(height: 20),
            _buildFeesRow(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: LightButton(
                text: 'Continuer vers le paiement',
                icon: Icons.arrow_forward_rounded,
                isPrimary: total > 0 && phoneController.text.isNotEmpty,
                onPressed: total > 0 && phoneController.text.isNotEmpty
                    ? () {
                        context.push(
                          '/recharge/step3',
                          extra: {
                            'recipient': 'friend',
                            'recipientName': nameController.text,
                            'recipientPhone': '+228 ${phoneController.text}',
                            'amount': total,
                            'bonus': 0,
                          },
                        );
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
                color: isActive
                    ? LightPageColors.orange
                    : LightPageColors.border,
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

  Widget _buildPhoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightPageColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: LightPageColors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                Text('🇹🇬', style: GoogleFonts.plusJakartaSans(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  '+228',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: LightPageColors.text,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '90 12 34 56',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: LightPageColors.muted,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Icon(
            Icons.contacts_outlined,
            size: 18,
            color: LightPageColors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightPageColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 16,
            color: LightPageColors.muted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: nameController,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: LightPageColors.text,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nom du destinataire (optionnel)',
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
        ],
      ),
    );
  }

  Widget _buildFeesRow() {
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
                'Montant envoyé',
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Frais de transfert',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: LightPageColors.text2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '0 ticket',
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
            children: [
              Text(
                'Total à débiter',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.text,
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
        ],
      ),
    );
  }
}
