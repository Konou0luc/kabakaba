import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class AmbassadorPresentationPage extends StatelessWidget {
  const AmbassadorPresentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Devenez Ambassadeur'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: KabaBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 72),
                Text(
                  'Devenez\nAmbassadeur 👑',
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.textPrimary(context),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideY(begin: -0.2),
                const SizedBox(height: 12),
                Text(
                  'Gagnez des commissions sur chaque commande effectuée avec votre code promo !',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textSecondaryDark
                        : AppColors.greyDark,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.1),
                const SizedBox(height: 32),
                Column(
                  children: [
                    _BenefitCard(
                      icon: Icons.attach_money_rounded,
                      title: '5% de commission',
                      description: 'Sur chaque commande validée',
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    const SizedBox(height: 16),
                    _BenefitCard(
                      icon: Icons.card_giftcard_rounded,
                      title: 'Statut premium',
                      description: 'Accès exclusifs et récompenses',
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                    const SizedBox(height: 16),
                    _BenefitCard(
                      icon: Icons.show_chart_rounded,
                      title: 'Suivi en temps réel',
                      description: 'Voir vos performances facilement',
                    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
                  ],
                ),
                const SizedBox(height: 32),
                KabaButton(
                  text: 'Je suis intéressé !',
                  onPressed: () => context.push('/ambassador/conditions'),
                ).animate().fadeIn(delay: 1000.ms).scale(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return KabaCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accent, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h3),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
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
