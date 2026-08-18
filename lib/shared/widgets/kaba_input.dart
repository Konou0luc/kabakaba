import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class KabaInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final Widget? prefixWidget;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLength;
  final List<dynamic>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;

  const KabaInput({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.prefixWidget,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.fieldLabel),
          const SizedBox(height: 7),
        ],
        Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line, width: 1.5),
            color: AppColors.field,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            maxLength: maxLength,
            focusNode: focusNode,
            autofocus: autofocus,
            inputFormatters: inputFormatters != null
                ? List<TextInputFormatter>.from(inputFormatters!)
                : null,
            style: AppTextStyles.inputText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.inputPlaceholder,
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconTheme(
                        data: const IconThemeData(color: AppColors.muted),
                        child: prefixIcon!,
                      ),
                    )
                  : null,
              prefix: prefixWidget,
              prefixText: prefixText,
              prefixStyle: AppTextStyles.inputText.copyWith(
                fontWeight: FontWeight.w700,
              ),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconTheme(
                        data: const IconThemeData(color: AppColors.muted),
                        child: suffixIcon!,
                      ),
                    )
                  : null,
              counterText: "",
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class KabaSelect extends StatelessWidget {
  final String? label;
  final String value;
  final String placeholder;
  final VoidCallback? onTap;
  final bool isSelected;

  const KabaSelect({
    super.key,
    this.label,
    required this.value,
    required this.placeholder,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.fieldLabel),
          const SizedBox(height: 7),
        ],
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line, width: 1.5),
              color: AppColors.field,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isSelected ? value : placeholder,
                    style: isSelected
                        ? AppTextStyles.inputText
                        : AppTextStyles.inputPlaceholder,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.muted,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OTPBox extends StatelessWidget {
  final String value;
  final bool isFilled;
  final bool hasCursor;

  const OTPBox({
    super.key,
    this.value = '',
    this.isFilled = false,
    this.hasCursor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isFilled
            ? AppColors.accent.withValues(alpha: 0.12)
            : AppColors.field,
        border: Border.all(
          color: hasCursor
              ? AppColors.accent
              : isFilled
              ? AppColors.accent.withValues(alpha: 0.5)
              : AppColors.line,
          width: hasCursor ? 2 : 1.5,
        ),
        boxShadow: hasCursor
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.18),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isFilled ? AppColors.white : Colors.white,
          ),
        ),
      ),
    );
  }
}

class HintBox extends StatelessWidget {
  final String message;
  final IconData icon;

  const HintBox({
    super.key,
    required this.message,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.accent.withValues(alpha: 0.10),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 16),
          const SizedBox(width: 9),
          Expanded(child: Text(message, style: AppTextStyles.hintText)),
        ],
      ),
    );
  }
}
