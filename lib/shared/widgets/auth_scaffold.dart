import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AuthScaffold extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final IconData heroIcon;
  final String heroTitle;
  final String heroSubtitle;
  final Widget body;
  final VoidCallback? onBack;
  final bool showBackButton;

  const AuthScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.heroIcon,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.body,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (currentStep / totalSteps).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.indigoDark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Hero Section with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 46),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.indigoDark,
                  ],
                  transform: const GradientRotation(2.705),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Decorative circles
                  Positioned(
                    top: -60,
                    right: -50,
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withValues(alpha: 0.16),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -70,
                    left: -40,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar: back + progress pill
                      Row(
                        children: [
                          if (showBackButton)
                            GestureDetector(
                              onTap: onBack ?? () => Navigator.of(context).pop(),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.white.withValues(alpha: 0.12),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: AppColors.white,
                                  size: 14,
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 32, height: 32),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.white.withValues(alpha: 0.12),
                            ),
                            child: Text(
                              'Étape $currentStep/$totalSteps',
                              style: AppTextStyles.progressPill,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      // Hero Icon
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.white.withValues(alpha: 0.12),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Icon(
                          heroIcon,
                          color: AppColors.accent,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        heroTitle,
                        style: AppTextStyles.heroTitle,
                      ),
                      const SizedBox(height: 6),
                      // Subtitle
                      SizedBox(
                        width: 230,
                        child: Text(
                          heroSubtitle,
                          style: AppTextStyles.heroSubtitle,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Progress bar
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: AppColors.white.withValues(alpha: 0.16),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: constraints.maxWidth * progressPercent,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColors.accent,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Card Body
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  border: Border(
                    top: BorderSide(color: AppColors.line),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                  child: body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;
  final Widget? trailingIcon;

  const SuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigoDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.indigoDark,
                    ],
                    transform: const GradientRotation(2.705),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      left: -60,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withValues(alpha: 0.14),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -80,
                      right: -50,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withValues(alpha: 0.04),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.16),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accent,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.white,
                                    size: 30,
                                    weight: 3,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              title,
                              style: AppTextStyles.successTitle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 220,
                              child: Text(
                                subtitle,
                                style: AppTextStyles.successSubtitle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                border: Border(
                  top: BorderSide(color: AppColors.line),
                ),
              ),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.white,
                    textStyle: AppTextStyles.buttonPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(buttonText),
                        ),
                      ),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        trailingIcon!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
