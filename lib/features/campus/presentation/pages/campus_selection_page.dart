import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/step_indicator.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_bottom_sheet_modal.dart';

class CampusSelectionPage extends StatelessWidget {
  const CampusSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final campuses = [
      {
        'name': 'Université de Lomé (UL)',
        'location': 'Lomé, Togo',
        'image': 'https://placeholder.com/150',
      },
      {
        'name': 'Université de Kara (UK)',
        'location': 'Kara, Togo',
        'image': 'https://placeholder.com/150',
      },
      {
        'name': 'UCAO-UUT',
        'location': 'Sanguéra, Togo',
        'image': 'https://placeholder.com/150',
      },
      {
        'name': 'ESA',
        'location': 'Lomé, Togo',
        'image': 'https://placeholder.com/150',
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/auth');
            }
          },
        ),
      ),
      body: KabaBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Contenu supérieur (toujours affiché)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepIndicator(
                      currentStep: 4,
                      totalSteps: 5,
                    ).animate().fadeIn(),
                    const SizedBox(height: AppSpacing.l),
                    Text(
                      'Etape 4/5',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.accent,
                      ),
                    ).animate().fadeIn(),
                    const SizedBox(height: 8),
                    Text(
                      'Où étudies-tu ?',
                      style: AppTextStyles.h1,
                    ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      'Choisis ton campus pour accéder à tes cantines',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.greyDark,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),
              // BottomSheet statique
              const SizedBox(height: 60),
              Expanded(
                child: KabaBottomSheetModal(
                  isStatic: true,
                  title: 'Choix du campus',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sélectionne ton établissement.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.greyDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: campuses.length,
                          itemBuilder: (context, index) {
                            final campus = campuses[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child:
                                  Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.greyLightDarkMode
                                                : AppColors.greyLight,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                color: AppColors
                                                    .surfaceSecondaryLight,
                                                child: Icon(
                                                  Icons.school_outlined,
                                                  size: 30,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    campus['name'] as String,
                                                    style:
                                                        AppTextStyles.bodyLarge,
                                                  ),
                                                  Text(
                                                    campus['location']
                                                        as String,
                                                    style: AppTextStyles
                                                        .bodyMedium
                                                        .copyWith(
                                                          color: AppColors
                                                              .greyDark,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 16,
                                              color: AppColors.grey,
                                            ),
                                          ],
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(delay: (400 + index * 100).ms)
                                      .slideY(begin: 0.1, end: 0),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      KabaButton(
                        text: 'Continuer →',
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.go('/auth/referral');
                          });
                        },
                      ).animate().fadeIn(delay: 800.ms),
                      const SizedBox(height: AppSpacing.l),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
