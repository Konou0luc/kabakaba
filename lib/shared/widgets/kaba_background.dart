import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class KabaBackground extends StatelessWidget {
  final Widget child;

  const KabaBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1B2A6B), Color(0xFF0D1438)],
                    )
                  : null,
              color: isDark ? null : AppColors.backgroundLight,
            ),
          ),
        ),
        Positioned(
          top: -100,
          right: -40,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.accent.withValues(alpha: 0.16)
                  : AppColors.accent.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -60,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.04)
                  : AppColors.white.withValues(alpha: 0.04),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.accent.withValues(alpha: 0.08)
                  : AppColors.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
