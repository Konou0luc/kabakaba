import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/api_models.dart';
import 'light_page_scaffold.dart';
import 'remote_photo.dart';

class KabaSectionKicker extends StatelessWidget {
  final String text;

  const KabaSectionKicker(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: LightPageColors.muted,
      ),
    );
  }
}

class KabaSectionHeader extends StatelessWidget {
  final String kicker;
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const KabaSectionHeader({
    super.key,
    required this.kicker,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KabaSectionKicker(kicker),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(title, style: AppSectionTitle.style),
            ),
            if (action != null)
              GestureDetector(
                onTap: onAction,
                child: Text(
                  action!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class AppSectionTitle {
  static TextStyle get style => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: LightPageColors.text,
      );
}

class KabaIndigoHero extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const KabaIndigoHero({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(22, 18, 22, 36),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.indigoDark],
          transform: const GradientRotation(2.705),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -60,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            left: -50,
            child: IgnorePointer(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class KabaOverlapSheet extends StatelessWidget {
  final Widget child;
  final double lift;

  const KabaOverlapSheet({
    super.key,
    required this.child,
    this.lift = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -lift),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: LightPageColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: LightPageColors.border)),
        ),
        child: child,
      ),
    );
  }
}

class KabaStatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final bool inverted;

  const KabaStatusPill({
    super.key,
    required this.label,
    required this.color,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: inverted ? color : color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: inverted ? Colors.white : color,
        ),
      ),
    );
  }
}

class KabaSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const KabaSearchField({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: LightPageColors.indigoLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LightPageColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 20,
            color: LightPageColors.muted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              cursorColor: AppColors.accent,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: LightPageColors.text,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                filled: false,
                fillColor: Colors.transparent,
                hintText: hintText,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: LightPageColors.muted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KabaCanteenPoster extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback onTap;
  final double? width;
  final double height;

  const KabaCanteenPoster({
    super.key,
    required this.vendor,
    required this.onTap,
    this.width,
    this.height = 188,
  });

  @override
  Widget build(BuildContext context) {
    final image = vendor.bannerUrl ?? vendor.logoUrl;
    final open = vendor.isOpen;
    final desc = vendor.description?.trim();

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = width ??
              (constraints.maxWidth.isFinite ? constraints.maxWidth : 198);
          return SizedBox(
            width: width ?? double.infinity,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  RemotePhoto(
                    url: image,
                    width: w,
                    height: height,
                    fallback: ColoredBox(
                      color: const Color(0xFF1B2A6B),
                      child: Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.accent.withValues(alpha: 0.85),
                        size: 36,
                      ),
                    ),
                  ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x0D000000),
                      Color(0x2E000000),
                      Color(0xD1000000),
                    ],
                    stops: [0, 0.42, 1],
                  ),
                ),
              ),
              if (!open) const ColoredBox(color: Color(0x47000000)),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: open
                        ? AppColors.success.withValues(alpha: 0.92)
                        : Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    open ? 'Ouverte' : 'Fermée',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.canteenName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        color: Colors.white,
                      ),
                    ),
                    if (desc != null && desc.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class KabaEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const KabaEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: LightPageColors.indigoLight,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: LightPageColors.border),
            ),
            child: Icon(icon, size: 36, color: LightPageColors.indigo),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: LightPageColors.muted,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 22),
            SizedBox(
              width: 220,
              child: LightButton(
                text: actionLabel!,
                onPressed: onAction,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class KabaHeroIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const KabaHeroIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white.withValues(alpha: 0.08),
          border: Border.all(color: AppColors.line),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: 16),
            if (hasBadge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
