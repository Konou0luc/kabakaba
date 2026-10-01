import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

class AuthScaffold extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final IconData heroIcon;
  final String heroTitle;
  final String heroSubtitle;
  final Widget body;
  final Widget? footer;
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
    this.footer,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (currentStep / totalSteps).clamp(0.0, 1.0);
    final media = MediaQuery.of(context);
    final bottomSafe = media.padding.bottom;
    final keyboardOpen = media.viewInsets.bottom > 0;

    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
      backgroundColor: AppColors.indigoDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _AuthHero(
              currentStep: currentStep,
              totalSteps: totalSteps,
              progressPercent: progressPercent,
              heroIcon: heroIcon,
              heroTitle: heroTitle,
              heroSubtitle: heroSubtitle,
              showBackButton: showBackButton,
              onBack: onBack,
              compact: keyboardOpen,
            ),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, keyboardOpen ? -10 : -22),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    border: Border(top: BorderSide(color: AppColors.line)),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    22,
                    keyboardOpen ? 16 : 26,
                    22,
                    16 + (keyboardOpen ? 8 : bottomSafe),
                  ),
                  child: CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            body,
                            if (footer != null) ...[
                              const Spacer(),
                              const SizedBox(height: 28),
                              footer!,
                            ],
                          ],
                        ),
                      ),
                    ],
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
}

class _AuthBackButton extends StatelessWidget {
  final VoidCallback? onBack;

  const _AuthBackButton({this.onBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

class _AuthStepPill extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _AuthStepPill({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white.withValues(alpha: 0.12),
      ),
      child: Text(
        'Étape $currentStep/$totalSteps',
        style: AppTextStyles.progressPill,
      ),
    );
  }
}

class _AuthProgressBar extends StatelessWidget {
  final double progressPercent;

  const _AuthProgressBar({required this.progressPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _AuthHero extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double progressPercent;
  final IconData heroIcon;
  final String heroTitle;
  final String heroSubtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool compact;

  const _AuthHero({
    required this.currentStep,
    required this.totalSteps,
    required this.progressPercent,
    required this.heroIcon,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.showBackButton,
    this.onBack,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: compact
          ? const EdgeInsets.fromLTRB(24, 10, 24, 28)
          : const EdgeInsets.fromLTRB(24, 18, 24, 46),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.indigoDark],
          transform: const GradientRotation(2.705),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -60,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            left: -40,
            child: IgnorePointer(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showBackButton)
                      _AuthBackButton(onBack: onBack)
                    else
                      const SizedBox(width: 32, height: 32),
                    const Spacer(),
                    _AuthStepPill(
                      currentStep: currentStep,
                      totalSteps: totalSteps,
                    ),
                  ],
                ),
                SizedBox(height: compact ? 12 : 22),
                if (!compact) ...[
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
                    child: Icon(heroIcon, color: AppColors.accent, size: 26),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(heroTitle, style: AppTextStyles.heroTitle),
                if (!compact) ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 230,
                    child: Text(heroSubtitle, style: AppTextStyles.heroSubtitle),
                  ),
                ],
                SizedBox(height: compact ? 12 : 18),
                _AuthProgressBar(progressPercent: progressPercent),
              ],
            ),
          ),
        ],
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
                    colors: [AppColors.primary, AppColors.indigoDark],
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
                                  color: AppColors.white.withValues(
                                    alpha: 0.16,
                                  ),
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
                border: Border(top: BorderSide(color: AppColors.line)),
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
