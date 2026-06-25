import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class KabaBottomSheetModal extends StatelessWidget {
  final Widget child;
  final double? height;
  final bool isDismissible;
  final bool enableDrag;
  final String? title;
  final Widget? trailing;
  final bool isStatic;

  const KabaBottomSheetModal({
    super.key,
    required this.child,
    this.height,
    this.isDismissible = true,
    this.enableDrag = true,
    this.title,
    this.trailing,
    this.isStatic = false,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    String? title,
    Widget? trailing,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => KabaBottomSheetModal(
        height: height,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        title: title,
        trailing: trailing,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget content = Container(
      height: height ?? 520,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag indicator (always show)
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.greyDark.withValues(alpha: 0.3)
                  : AppColors.greyLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title bar
          if (title != null || trailing != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: AppTextStyles.h3.copyWith(
                        color: isDarkMode
                            ? AppColors.white
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              child: child,
            ),
          ),
        ],
      ),
    );

    if (isStatic) {
      return content;
    }

    return DraggableScrollableSheet(
      initialChildSize: height != null
          ? (height! / MediaQuery.of(context).size.height)
          : 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return content;
      },
    );
  }
}
