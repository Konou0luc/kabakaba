import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_background.dart';

class PromoCodePage extends StatelessWidget {
  const PromoCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Mon code promo'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: KabaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Partagez votre code !',
                        style: AppTextStyles.h2,
                      ).animate().fadeIn().slideX(),
                      const SizedBox(height: 32),
                      // Code Display Card
                      KabaCard(
                        padding: const EdgeInsets.all(32),
                        color: AppColors.primary,
                        child: Column(
                          children: [
                            Text(
                              'VOTRE CODE',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'KABA-LUC-24',
                              style: AppTextStyles.h1.copyWith(
                                color: AppColors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms).scale(),
                      const SizedBox(height: 24),
                      Text(
                        'Chaque ami qui s\'inscrit avec votre code vous donne 500 FCFA de commission !',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 48),
                      // Share Buttons
                      Row(
                            children: [
                              Expanded(
                                child: KabaButton(
                                  text: 'Copier le code',
                                  onPressed: () {},
                                  type: KabaButtonType.secondary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: KabaButton(
                                  text: 'Partager',
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          )
                          .animate()
                          .fadeIn(delay: 600.ms)
                          .slideY(begin: 0.1, end: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
