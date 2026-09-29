import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/phone_e164.dart';

class KabaFieldShell extends StatelessWidget {
  final bool focused;
  final Widget child;
  final double height;

  const KabaFieldShell({
    super.key,
    required this.focused,
    required this.child,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focused ? AppColors.accent : AppColors.line,
          width: focused ? 2 : 1.5,
        ),
        color: focused ? AppColors.fieldFocus : AppColors.field,
        boxShadow: focused
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.16),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class KabaInput extends StatefulWidget {
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
  final TextCapitalization textCapitalization;

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
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<KabaInput> createState() => _KabaInputState();
}

class _KabaInputState extends State<KabaInput> {
  late final FocusNode _focusNode;
  late final bool _ownsFocus;

  @override
  void initState() {
    super.initState();
    _ownsFocus = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    if (_ownsFocus) _focusNode.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            AppTextStyles.fieldLabelText(widget.label!),
            style: AppTextStyles.fieldLabel,
          ),
          const SizedBox(height: 7),
        ],
        KabaFieldShell(
          focused: _focusNode.hasFocus,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters != null
                ? List<TextInputFormatter>.from(widget.inputFormatters!)
                : null,
            style: AppTextStyles.inputText,
            scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.inputPlaceholder,
              isCollapsed: true,
              isDense: true,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconTheme(
                        data: const IconThemeData(color: AppColors.muted),
                        child: widget.prefixIcon!,
                      ),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              prefix: widget.prefixWidget,
              prefixText: widget.prefixText,
              prefixStyle: AppTextStyles.inputText.copyWith(
                fontWeight: FontWeight.w700,
              ),
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconTheme(
                        data: const IconThemeData(color: AppColors.muted),
                        child: widget.suffixIcon!,
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              counterText: '',
              filled: false,
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

class KabaPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const KabaPhoneField({
    super.key,
    required this.controller,
    this.label,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<KabaPhoneField> createState() => _KabaPhoneFieldState();
}

class _KabaPhoneFieldState extends State<KabaPhoneField> {
  late final FocusNode _focusNode;
  late final bool _ownsFocus;

  @override
  void initState() {
    super.initState();
    _ownsFocus = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    if (_ownsFocus) _focusNode.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            AppTextStyles.fieldLabelText(widget.label!),
            style: AppTextStyles.fieldLabel,
          ),
          const SizedBox(height: 7),
        ],
        KabaFieldShell(
          focused: _focusNode.hasFocus,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (_) {
              if (!_focusNode.hasFocus) {
                _focusNode.requestFocus();
              }
            },
            child: Row(
              children: [
                const SizedBox(width: 14),
                Text(
                  '🇹🇬 +228',
                  style: AppTextStyles.inputText.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 9),
                Container(width: 1, height: 20, color: AppColors.line),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatters: const [TogoPhoneInputFormatter()],
                    cursorColor: AppColors.accent,
                    style: AppTextStyles.inputText,
                    scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                    decoration: InputDecoration(
                      hintText: '90 12 34 56',
                      hintStyle: AppTextStyles.inputPlaceholder,
                      filled: false,
                      fillColor: Colors.transparent,
                      isCollapsed: true,
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(right: 14),
                    ),
                    onChanged: widget.onChanged,
                  ),
                ),
              ],
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
          Text(
            AppTextStyles.fieldLabelText(label!),
            style: AppTextStyles.fieldLabel,
          ),
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

class KabaOtpField extends StatefulWidget {
  final int length;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const KabaOtpField({
    super.key,
    this.length = 6,
    this.enabled = true,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<KabaOtpField> createState() => KabaOtpFieldState();
}

class KabaOtpFieldState extends State<KabaOtpField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String get code => _controller.text.replaceAll(RegExp(r'\D'), '');

  void clear() {
    _controller.clear();
    setState(() {});
  }

  void requestFocus() => _focusNode.requestFocus();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_refresh);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _onChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > widget.length
        ? digits.substring(0, widget.length)
        : digits;
    if (clipped != _controller.text) {
      _controller.value = TextEditingValue(
        text: clipped,
        selection: TextSelection.collapsed(offset: clipped.length),
      );
    }
    widget.onChanged?.call(clipped);
    if (clipped.length == widget.length) {
      widget.onCompleted?.call(clipped);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final digits = code;
    final focused = _focusNode.hasFocus;

    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          Row(
            children: List.generate(widget.length, (index) {
              final digit = index < digits.length ? digits[index] : '';
              final filled = digit.isNotEmpty;
              final active = focused && index == digits.length;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < widget.length - 1 ? 8 : 0,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: filled
                          ? AppColors.accent.withValues(alpha: 0.14)
                          : AppColors.field,
                      border: Border.all(
                        color: active
                            ? AppColors.accent
                            : filled
                            ? AppColors.accent.withValues(alpha: 0.55)
                            : AppColors.line,
                        width: active ? 2 : 1.5,
                      ),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                blurRadius: 0,
                                spreadRadius: 3,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: filled
                          ? Text(
                              digit,
                              style: AppTextStyles.inputText.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          : active
                          ? Container(
                              width: 2,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
          Positioned.fill(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: true,
              showCursor: false,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: widget.length,
              style: const TextStyle(color: Colors.transparent, fontSize: 1),
              scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
              decoration: const InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: _onChanged,
            ),
          ),
        ],
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
