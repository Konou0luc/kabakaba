import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pill indicator top right
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Text(
              'Étape $currentStep/$totalSteps',
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Line indicators
        Row(
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isCompleted = stepNumber < currentStep;
            final isActive = stepNumber == currentStep;

            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: (isCompleted || isActive)
                      ? AppColors.accent
                      : isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.greyLight,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
