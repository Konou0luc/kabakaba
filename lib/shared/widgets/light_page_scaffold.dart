import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LightPageColors {
  LightPageColors._();

  static Color bg = const Color(0xFF0D1438);
  static Color white = const Color(0xFF111A45);
  static Color text = const Color(0xFFFFFFFF);
  static Color text2 = const Color(0xB3FFFFFF);
  static Color muted = const Color(0x80FFFFFF);
  static Color border = const Color(0x1FFFFFFF);
  static Color indigo = const Color(0xFF9BB0FF);
  static Color indigoLight = const Color(0xFF1B2A6B);
  static const Color orange = Color(0xFFF07840);
  static Color orangeLight = const Color(0x26F07840);
  static const Color warning = Color(0xFFF59E0B);
  static Color warningLight = const Color(0x26F59E0B);
  static const Color green = Color(0xFF16A34A);
  static Color greenLight = const Color(0x2616A34A);
  static const Color red = Color(0xFFDC2626);
  static Color redLight = const Color(0x26DC2626);

  static void apply(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    bg = dark ? const Color(0xFF0D1438) : const Color(0xFFF4F6FF);
    white = dark ? const Color(0xFF111A45) : const Color(0xFFFFFFFF);
    text = dark ? const Color(0xFFFFFFFF) : const Color(0xFF0D1438);
    text2 = dark ? const Color(0xB3FFFFFF) : const Color(0xFF5C6584);
    muted = dark ? const Color(0x80FFFFFF) : const Color(0xFF8B93A7);
    border = dark ? const Color(0x1FFFFFFF) : const Color(0x1A1B2A6B);
    indigo = dark ? const Color(0xFF9BB0FF) : const Color(0xFF1B2A6B);
    indigoLight = dark ? const Color(0xFF1B2A6B) : const Color(0xFFE8ECFF);
    orangeLight = dark ? const Color(0x26F07840) : const Color(0xFFFFE8DC);
    warningLight = dark ? const Color(0x26F59E0B) : const Color(0xFFFFF4DE);
    greenLight = dark ? const Color(0x2616A34A) : const Color(0xFFDCFCE7);
    redLight = dark ? const Color(0x26DC2626) : const Color(0xFFFEE2E2);
  }
}

class LightPageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final VoidCallback? onBack;
  final Widget? bottomNavigationBar;
  final bool extendBody;

  const LightPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
    this.onBack,
    this.bottomNavigationBar,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? LightPageColors.bg,
      extendBody: extendBody,
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton && onBack != null
            ? IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              )
            : null,
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class LightTopNav extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const LightTopNav({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightPageColors.white,
        border: Border(
          bottom: BorderSide(color: LightPageColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              if (showBackButton)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 4),
                  child: LightBackButton(onTap: onBack),
                )
              else
                const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class LightBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const LightBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            onTap ??
            () {
              final router = GoRouter.of(context);
              if (router.canPop()) {
                router.pop();
              } else {
                router.go('/home');
              }
            },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: LightPageColors.bg,
            border: Border.all(color: LightPageColors.border, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 15,
            color: LightPageColors.text2,
          ),
        ),
      ),
    );
  }
}

class LightTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;

  const LightTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor ?? LightPageColors.indigoLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LightPageColors.border),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: onTap != null ? () => onTap!(index) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? LightPageColors.orange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tabs[index],
                    maxLines: 1,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : LightPageColors.muted,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class LightSectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? subtitle;
  final String? action;
  final VoidCallback? onActionTap;

  const LightSectionTitle({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    this.action,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: LightPageColors.text2),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: LightPageColors.text2,
                        letterSpacing: 0.04,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: LightPageColors.border,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: LightPageColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onActionTap,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        action!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: LightPageColors.orange,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 9,
                        color: LightPageColors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LightSettingsCard extends StatelessWidget {
  final List<Widget> children;

  const LightSettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightPageColors.white,
        border: Border.all(color: LightPageColors.border, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Container(
                height: 1,
                color: LightPageColors.border,
                margin: const EdgeInsets.symmetric(horizontal: 14),
              ),
          ],
        ],
      ),
    );
  }
}

class LightFieldRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool isLocked;
  final bool isEditable;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  const LightFieldRow({
    super.key,
    required this.label,
    this.value,
    this.isLocked = false,
    this.isEditable = true,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isLocked) ...[
                Icon(
                  Icons.lock_outline_rounded,
                  size: 11,
                  color: LightPageColors.muted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.muted,
                  letterSpacing: 0.03,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isEditable && !isLocked)
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: LightPageColors.text,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: value,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.text,
                ),
                suffixIcon: suffix,
              ),
            )
          else
            Text(
              value ?? '',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: LightPageColors.muted,
              ),
            ),
        ],
      ),
    );
  }
}

class LightNavRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDanger;
  final Widget? trailing;

  const LightNavRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDanger = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDanger
        ? LightPageColors.redLight
        : LightPageColors.indigoLight;
    final iconColor = isDanger ? LightPageColors.red : LightPageColors.indigo;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: LightPageColors.text,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: LightPageColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: LightPageColors.muted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LightToggleRow extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? iconBgColor;
  final Color? iconColor;

  const LightToggleRow({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.iconBgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBgColor ?? LightPageColors.indigoLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 16,
                color: iconColor ?? LightPageColors.indigo,
              ),
            ),
            const SizedBox(width: 11),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: LightPageColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          LightSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class LightSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const LightSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: SizedBox(
        width: 42,
        height: 24,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: value ? LightPageColors.orange : LightPageColors.border,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              top: 3,
              left: value ? 21 : 3,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LightIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final Color? bgColor;
  final double size;
  final String? badge;

  const LightIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.bgColor,
    this.size = 34,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: bgColor ?? LightPageColors.bg,
                border: Border.all(color: LightPageColors.border, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: size * 0.47,
                color: color ?? LightPageColors.text2,
              ),
            ),
            if (badge != null)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: BoxDecoration(
                    color: LightPageColors.orange,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: LightPageColors.white,
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badge!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
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

class LightButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final bool isPrimary;
  final bool isDanger;
  final bool isLoading;
  final bool compact;
  final double height;

  const LightButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.isPrimary = true,
    this.isDanger = false,
    this.isLoading = false,
    this.compact = false,
    this.height = 46,
  });

  @override
  Widget build(BuildContext context) {
    final h = compact ? 34.0 : height;
    final iconSz = compact ? 13.0 : 15.0;
    final fSz = compact ? 11.0 : 13.0;
    final iconGap = compact ? 5.0 : 8.0;
    final padH = compact ? 10.0 : 0.0;
    Widget child;
    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isDanger ? LightPageColors.red : Colors.white,
          ),
        ),
      );
    } else {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSz, color: _foregroundColor),
            SizedBox(width: iconGap),
          ],
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: fSz,
              fontWeight: FontWeight.w700,
              color: _foregroundColor,
            ),
          ),
        ],
      );
    }

    final container = Container(
      width: fullWidth && !compact ? double.infinity : null,
      height: h,
      padding: compact ? EdgeInsets.symmetric(horizontal: padH) : null,
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: isDanger
            ? Border.all(color: const Color(0xFFFECACA), width: 1.5)
            : (isPrimary
                  ? null
                  : Border.all(color: LightPageColors.border, width: 1.5)),
        borderRadius: BorderRadius.circular(compact ? 10 : 13),
        boxShadow: isPrimary && !isDanger && !compact
            ? [
                BoxShadow(
                  color: LightPageColors.orange.withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(compact ? 10 : 13),
          child: Center(child: child),
        ),
      ),
    );

    return container;
  }

  Color get _backgroundColor {
    if (isDanger) return LightPageColors.redLight;
    if (isPrimary) return LightPageColors.orange;
    return LightPageColors.white;
  }

  Color get _foregroundColor {
    if (isDanger) return LightPageColors.red;
    if (isPrimary) return Colors.white;
    return LightPageColors.text;
  }
}

class LightBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? bgColor;
  final Color? borderColor;

  const LightBadge({
    super.key,
    required this.text,
    this.color,
    this.bgColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor ?? LightPageColors.indigoLight,
        borderRadius: BorderRadius.circular(6),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color ?? LightPageColors.indigo,
        ),
      ),
    );
  }
}

class LightHintBox extends StatelessWidget {
  final IconData? icon;
  final String text;
  final bool isSuccess;
  final bool isWarning;
  final bool isDanger;

  const LightHintBox({
    super.key,
    this.icon,
    required this.text,
    this.isSuccess = false,
    this.isWarning = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData defaultIcon;

    if (isSuccess) {
      bgColor = LightPageColors.greenLight;
      borderColor = LightPageColors.green.withValues(alpha: 0.3);
      textColor = LightPageColors.green;
      defaultIcon = Icons.check_circle_outline_rounded;
    } else if (isWarning || isDanger) {
      bgColor = LightPageColors.redLight;
      borderColor = LightPageColors.red.withValues(alpha: 0.3);
      textColor = LightPageColors.red;
      defaultIcon = Icons.error_outline_rounded;
    } else {
      bgColor = LightPageColors.indigoLight;
      borderColor = LightPageColors.indigo.withValues(alpha: 0.2);
      textColor = LightPageColors.indigo;
      defaultIcon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defaultIcon, size: 14, color: textColor),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LightCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const LightCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius = 16,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? LightPageColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: LightPageColors.border, width: 1),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: const Color(0xFF1B2A6B).withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
