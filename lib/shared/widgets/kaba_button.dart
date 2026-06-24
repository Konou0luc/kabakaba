import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

enum KabaButtonType { primary, secondary, outline, ghost }

class KabaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final KabaButtonType type;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  const KabaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = KabaButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(text),
                ),
              ),
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: _buildButton(child),
    );
  }

  Widget _buildButton(Widget child) {
    switch (type) {
      case KabaButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent, // Using Peach as primary CTA
            foregroundColor: AppColors.white,
          ),
          child: child,
        );
      case KabaButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, // Using Indigo as secondary
            foregroundColor: AppColors.white,
          ),
          child: child,
        );
      case KabaButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case KabaButtonType.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.largeBorderRadius,
            ),
          ),
          child: child,
        );
    }
  }
}
