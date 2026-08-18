import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum KabaButtonType { primary, secondary, outline, ghost }

class KabaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final KabaButtonType type;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final Widget? trailingIcon;

  const KabaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = KabaButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: FittedBox(fit: BoxFit.scaleDown, child: Text(text)),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                trailingIcon!,
              ],
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 50,
      child: _buildButton(child, isDark),
    );
  }

  Widget _buildButton(Widget child, bool isDark) {
    switch (type) {
      case KabaButtonType.primary:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
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
            child: child,
          ),
        );
      case KabaButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            textStyle: AppTextStyles.buttonPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: child,
        );
      case KabaButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.line),
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.field,
            textStyle: AppTextStyles.buttonPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: child,
        );
      case KabaButtonType.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: isDark ? AppColors.white : AppColors.primary,
            textStyle: AppTextStyles.buttonPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: child,
        );
    }
  }
}
