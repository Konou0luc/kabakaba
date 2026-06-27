import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/icons/kabakaba.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('KabaKaba', style: AppTextStyles.h1),
                    Text(
                      'Version 1.0.0',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().scale(),
              const SizedBox(height: AppSpacing.xl),
              KabaCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notre mission', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    Text(
                      'Kabakaba est une solution de paiement digitale conçue pour faciliter les transactions au sein des campus universitaires. Nous visons à offrir une expérience fluide, rapide et sécurisée pour tous les étudiants et prestataires.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(),
              const SizedBox(height: AppSpacing.m),
              KabaCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contactez-nous', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: 'support@kabakaba.ci',
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      icon: Icons.language_rounded,
                      label: 'Site web',
                      value: 'www.kabakaba.ci',
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value, style: AppTextStyles.bodyMedium),
          ],
        ),
      ],
    );
  }
}
