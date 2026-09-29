import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/network/session_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/utils/kaba_snack.dart';
import '../../features/cart/data/cart_provider.dart';
import '../../shared/models/api_models.dart';
import '../../shared/widgets/light_page_scaffold.dart';

class MainNavigationWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const MainNavigationWrapper({super.key, required this.child});

  @override
  ConsumerState<MainNavigationWrapper> createState() =>
      _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends ConsumerState<MainNavigationWrapper> {
  Timer? _poll;
  Map<String, OrderStatus> _lastStatuses = {};
  int _lastUnread = 0;
  bool _booted = false;

  int _selectedIndex(String path) {
    if (path.startsWith('/order-history') || path.startsWith('/order-detail')) {
      return 1;
    }
    if (path == '/cart' ||
        path.startsWith('/packaging') ||
        path.startsWith('/payment')) {
      return 2;
    }
    if (path.startsWith('/wallet') ||
        path.startsWith('/recharge') ||
        path.startsWith('/send-money') ||
        path.startsWith('/transaction-history')) {
      return 3;
    }
    if (path.startsWith('/profile') ||
        path.startsWith('/settings') ||
        path.startsWith('/edit-profile') ||
        path.startsWith('/notifications') ||
        path.startsWith('/help-support') ||
        path.startsWith('/about') ||
        path.startsWith('/legal') ||
        path.startsWith('/campus') ||
        path.startsWith('/ambassador')) {
      return 4;
    }
    return 0;
  }

  bool _hideTabBar(String path) {
    return path.startsWith('/canteen-detail') ||
        path.startsWith('/menu-detail') ||
        path.startsWith('/payment') ||
        path.startsWith('/packaging') ||
        path.startsWith('/recharge') ||
        path.startsWith('/send-money') ||
        path.startsWith('/order-detail');
  }

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 20), (_) => _tick());
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _tick() async {
    if (!mounted) return;
    try {
      await refreshStudentSession(ref);
      final orders = ref.read(myOrdersProvider).valueOrNull ?? const [];
      final notifs =
          ref.read(myNotificationsProvider).valueOrNull ?? const [];
      final unread = notifs.where((n) => !n.isRead).length;
      if (_booted) {
        for (final order in orders) {
          final previous = _lastStatuses[order.id];
          if (previous != null &&
              previous != OrderStatus.READY &&
              order.status == OrderStatus.READY) {
            if (mounted) {
              showKabaSnack(
                context,
                'Ta commande chez ${order.vendorName} est prête',
              );
            }
          }
        }
        if (unread > _lastUnread && mounted) {
          showKabaSnack(context, 'Nouvelle notification');
        }
      }
      _lastStatuses = {
        for (final order in orders) order.id: order.status,
      };
      _lastUnread = unread;
      _booted = true;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final selected = _selectedIndex(path);
    final hideBar = _hideTabBar(path);
    final cartCount = ref.watch(cartProvider).itemCount;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.adaptiveBg(context),
      body: widget.child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: hideBar
          ? null
          : _CartFab(
              count: cartCount,
              selected: selected == 2,
              onTap: () => context.go('/cart'),
            ),
      bottomNavigationBar: hideBar
          ? null
          : BottomAppBar(
              color: LightPageColors.white,
              elevation: 12,
              shadowColor: Colors.black.withValues(alpha: 0.45),
              surfaceTintColor: Colors.transparent,
              padding: EdgeInsets.zero,
              height: 64 + bottomInset,
              notchMargin: 7,
              shape: const CircularNotchedRectangle(),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      _NavItem(
                        icon: AppIcons.home,
                        label: 'Accueil',
                        isSelected: selected == 0,
                        onTap: () => context.go('/home'),
                      ),
                      _NavItem(
                        icon: AppIcons.orders,
                        label: 'Commandes',
                        isSelected: selected == 1,
                        onTap: () => context.go('/order-history'),
                      ),
                      const SizedBox(width: 72),
                      _NavItem(
                        icon: AppIcons.wallet,
                        label: 'Portefeuille',
                        isSelected: selected == 3,
                        onTap: () => context.go('/wallet'),
                      ),
                      _NavItem(
                        icon: AppIcons.profile,
                        label: 'Profil',
                        isSelected: selected == 4,
                        onTap: () => context.go('/profile'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _CartFab extends StatelessWidget {
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _CartFab({
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 58,
        height: 58,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF9A62), Color(0xFFF07840)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.5),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: selected ? 26 : 24,
              ),
            ),
            if (count > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                      height: 1,
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
    final color = isSelected
        ? AppColors.accent
        : LightPageColors.muted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.accent.withValues(alpha: 0.12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isSelected ? 16 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
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
