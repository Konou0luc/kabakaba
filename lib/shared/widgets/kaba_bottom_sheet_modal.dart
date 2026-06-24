import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class KabaBottomSheetModal {
  static void show({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.greyLightDarkMode
                      : AppColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
