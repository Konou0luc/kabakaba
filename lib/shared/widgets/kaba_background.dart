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
        // Background color/gradient
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
        // Background circles
        Positioned(
          top: -100,
          right: -40,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF4A3B6B).withValues(alpha: 0.35)
                  : AppColors.primary.withValues(alpha: 0.12),
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
                  ? const Color(0xFF1B2A6B).withValues(alpha: 0.25)
                  : AppColors.accent.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Page content
        child,
      ],
    );
  }
}
