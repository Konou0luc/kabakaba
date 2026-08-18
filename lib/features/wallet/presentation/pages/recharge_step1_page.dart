import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class RechargeStep1Page extends StatelessWidget {
  const RechargeStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
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
            _buildHeroCard(),
            const SizedBox(height: 20),
            Text(
              'À qui voulez-vous envoyer des tickets ?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildBeneficiaryOption(
              icon: Icons.person_outline_rounded,
              title: 'Mon compte',
              subtitle: 'Ajouter des tickets à mon portefeuille',
              isSelected: true,
              onTap: () => context.push('/recharge/step2/self'),
            ).animate().fadeIn(delay: 50.ms, begin: 0.9).slideX(begin: -0.05),
            const SizedBox(height: 12),
            _buildBeneficiaryOption(
              icon: Icons.person_add_alt_rounded,
              title: 'Un ami',
              subtitle: 'Envoyer des tickets à un proche',
              isSelected: false,
              onTap: () => context.push('/recharge/step2/friend'),
            ).animate().fadeIn(delay: 100.ms, begin: 0.9).slideX(begin: -0.05),
            const SizedBox(height: 28),
            LightHintBox(
              text:
                  'Les tickets achetés sont non remboursables. Vérifiez bien le numéro avant de valider.',
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
          final isCurrent = i == step - 1;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == total - 1 ? 0 : 8),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? LightPageColors.orange : LightPageColors.border,
                borderRadius: BorderRadius.circular(3),
                border: isCurrent && !isActive
                    ? Border.all(color: LightPageColors.orange, width: 1)
                    : null,
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

  Widget _buildHeroCard() {
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
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LightPageColors.orange.withValues(alpha: 0.16),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                        width: 1,
                      ),
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
                          letterSpacing: 0.04,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '5 000 tickets',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Paiement sécurisé 3DS - Aucune carte stockée',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                ? LightPageColors.orangeLight.withValues(alpha: 0.7)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? LightPageColors.orange.withValues(alpha: 0.5)
                  : LightPageColors.border,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B2A6B).withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
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
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? LightPageColors.orange : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? LightPageColors.orange
                        : LightPageColors.border,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
