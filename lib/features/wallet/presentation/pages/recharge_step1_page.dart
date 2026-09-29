import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class RechargeStep1Page extends ConsumerWidget {
  const RechargeStep1Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final balance = formatTickets(user?.walletBalance ?? 0);

    return LightPageScaffold(
      title: 'Recharger le portefeuille',
      onBack: () => context.go('/wallet'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(step: 1, total: 3),
            const SizedBox(height: 16),
            _buildHeroCard(balance),
            const SizedBox(height: 20),
            Text(
              'Que veux-tu faire ?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildBeneficiaryOption(
              icon: Icons.person_outline_rounded,
              title: 'Recharger mon compte',
              subtitle: 'Payer par Flooz ou Mixx, tickets crédités ici',
              isSelected: true,
              onTap: () => context.push('/recharge/step2/self'),
            ).animate().fadeIn(delay: 50.ms, begin: 0.9).slideX(begin: -0.05),
            const SizedBox(height: 12),
            _buildBeneficiaryOption(
              icon: Icons.person_add_alt_rounded,
              title: 'Envoyer à un ami',
              subtitle: 'Transférer tes tickets déjà crédités',
              isSelected: false,
              onTap: () => context.push('/send-money'),
            ).animate().fadeIn(delay: 100.ms, begin: 0.9).slideX(begin: -0.05),
            const SizedBox(height: 28),
            const LightHintBox(
              text:
                  'Le montant saisi est ce que tu paies. Les frais Mobile Money sont inclus, les tickets sont calculés par le serveur.',
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

  Widget _buildHeroCard(String balance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B2A6B), Color(0xFF2D4494)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2A6B).withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFFF07840),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solde actuel',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$balance tickets',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Flooz et Mixx uniquement · 600 à 10 500 FCFA',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? LightPageColors.orangeLight
                : LightPageColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? LightPageColors.orange.withValues(alpha: 0.5)
                  : LightPageColors.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? LightPageColors.orange.withValues(alpha: 0.18)
                      : LightPageColors.indigoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? LightPageColors.orange
                      : LightPageColors.indigo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: LightPageColors.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: LightPageColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: LightPageColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
