import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_radius.dart';

class MainNavigationWrapper extends StatelessWidget {
  final Widget child;

  const MainNavigationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 94),
        child: child,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            height: 72,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.96)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.08)
                    : AppColors.greyLight.withValues(alpha: 0.55),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(
                    alpha: isDark ? 0.22 : 0.08,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _NavItem(
                    icon: AppIcons.home,
                    label: 'Accueil',
                    isSelected: location == '/home',
                    onTap: () => context.go('/home'),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: AppIcons.cart,
                    label: 'Panier',
                    isSelected: location == '/cart',
                    onTap: () => context.go('/cart'),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: AppIcons.wallet,
                    label: 'Portefeuille',
                    isSelected: location == '/wallet',
                    onTap: () => context.go('/wallet'),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: AppIcons.profile,
                    label: 'Profil',
                    isSelected: location == '/profile',
                    onTap: () => context.go('/profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? AppColors.accent.withValues(alpha: 0.12)
                    : AppColors.accent.withValues(alpha: 0.10))
              : Colors.transparent,
          borderRadius: AppRadius.largeBorderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent
                    : (isDark
                          ? AppColors.white.withValues(alpha: 0.12)
                          : AppColors.surfaceSecondary(context)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.white
                    : (isDark
                          ? AppColors.white.withValues(alpha: 0.86)
                          : AppColors.grey),
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.accent
                    : (isDark
                          ? AppColors.white.withValues(alpha: 0.78)
                          : AppColors.grey),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
