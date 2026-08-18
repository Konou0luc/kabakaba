import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _balance = '5 000';

  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.shopping_bag_outlined,
      'label': 'Commander',
      'route': '/canteen-list',
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'label': 'Portefeuille',
      'route': '/wallet',
    },
    {
      'icon': Icons.receipt_long_outlined,
      'label': 'Commandes',
      'route': '/order-history',
    },
    {
      'icon': Icons.person_add_alt_outlined,
      'label': 'Parrainage',
      'route': '/ambassador-presentation',
    },
    {
      'icon': Icons.school_outlined,
      'label': 'Cantines',
      'route': '/canteen-list',
    },
    {
      'icon': Icons.help_outline_rounded,
      'label': 'Aide',
      'route': '/help-support',
    },
    {
      'icon': Icons.add_circle_outline_rounded,
      'label': 'Recharger',
      'route': '/recharge-wallet',
    },
    {
      'icon': Icons.lock_outline_rounded,
      'label': 'Sécurité',
      'route': '/settings',
    },
    {'icon': Icons.apps_rounded, 'label': 'Tout voir', 'route': null},
  ];

  final List<Map<String, String>> _canteens = [
    {'name': 'Chez Mama Afi'},
    {'name': 'Resto Campus 2'},
    {'name': 'Le Petit Coin'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigoDark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Hero Section with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 34),
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
                  // Decorative circles
                  Positioned(
                    top: -60,
                    right: -50,
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withValues(alpha: 0.16),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -90,
                    left: -50,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar: greeting + icons
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bon retour',
                                  style: AppTextStyles.greetLabel,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Bonjour, Koffi 👋',
                                  style: AppTextStyles.greetName,
                                ),
                              ],
                            ),
                          ).animate().fadeIn().slideX(begin: -0.05, end: 0),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              _buildIconButton(
                                icon: Icons.search_rounded,
                                onTap: () {},
                              ),
                              const SizedBox(width: 9),
                              _buildIconButton(
                                icon: Icons.notifications_outlined,
                                onTap: () => context.push('/notifications'),
                                hasBadge: true,
                              ),
                            ],
                          ).animate().fadeIn().slideX(begin: 0.05, end: 0),
                        ],
                      ),
                      const SizedBox(height: 22),
                      // Balance label
                      Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 14,
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Solde tickets',
                            style: AppTextStyles.balanceLabel,
                          ),
                        ],
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 8),
                      // Balance amount
                      Text(
                            '$_balance tickets',
                            style: AppTextStyles.balanceAmount,
                          )
                          .animate()
                          .fadeIn(delay: 150.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 18),
                      // Balance actions
                      Row(
                        children: [
                          Expanded(
                            child:
                                _buildPillButton(
                                      icon: Icons.add_rounded,
                                      label: 'Recharger',
                                      isPrimary: true,
                                      onTap: () =>
                                          context.push('/recharge-wallet'),
                                    )
                                    .animate()
                                    .fadeIn(delay: 200.ms)
                                    .slideY(begin: 0.1, end: 0),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                                _buildPillButton(
                                      icon: Icons.refresh_rounded,
                                      label: 'Historique',
                                      isPrimary: false,
                                      onTap: () =>
                                          context.push('/transaction-history'),
                                    )
                                    .animate()
                                    .fadeIn(delay: 250.ms)
                                    .slideY(begin: 0.1, end: 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Card Body
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    border: Border(top: BorderSide(color: AppColors.line)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Actions title
                        Text(
                          'Accès rapide',
                          style: AppTextStyles.sectionTitle,
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 14),
                        // Quick Actions Grid
                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 18,
                          children: List.generate(_quickActions.length, (index) {
                            final action = _quickActions[index];
                            return _QuickItem(
                                  icon: action['icon'] as IconData,
                                  label: action['label'] as String,
                                  onTap: () {
                                    final route = action['route'] as String?;
                                    if (route != null) {
                                      context.push(route);
                                    }
                                  },
                                )
                                .animate()
                                .fadeIn(delay: (350 + index * 40).ms)
                                .slideY(begin: 0.1, end: 0);
                          }),
                        ),
                        const SizedBox(height: 24),
                        // Promo banner
                        _buildPromoBanner()
                            .animate()
                            .fadeIn(delay: 700.ms)
                            .slideY(begin: 0.05, end: 0),
                        const SizedBox(height: 24),
                        // Canteens section title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cantines · UCAO',
                              style: AppTextStyles.sectionTitle,
                            ),
                            GestureDetector(
                              onTap: () => context.push('/canteen-list'),
                              child: Text(
                                'Voir tout',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 750.ms),
                        const SizedBox(height: 14),
                        // Canteens horizontal scroll
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _canteens.length,
                            itemBuilder: (context, index) {
                              final canteen = _canteens[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index == _canteens.length - 1 ? 0 : 11,
                                ),
                                child: _CanteenCard(
                                  name: canteen['name']!,
                                  onTap: () => context.push('/canteen-detail'),
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: (800 + index * 80).ms)
                                  .slideX(begin: 0.1, end: 0);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
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
                  width: 6,
                  height: 6,
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

  Widget _buildPillButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: isPrimary
              ? AppColors.accent
              : AppColors.white.withValues(alpha: 0.08),
          border: isPrimary ? null : Border.all(color: AppColors.line),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: AppColors.white, weight: 2.5),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return GestureDetector(
      onTap: () => context.push('/ambassador-presentation'),
      child: Container(
        height: 78,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: AppColors.accent.withValues(alpha: 0.10),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_alt_outlined,
              color: AppColors.accent,
              size: 18,
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                'Devenir ambassadeur kabakaba',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: AppColors.field,
              border: Border.all(color: AppColors.line),
            ),
            child: Icon(icon, color: AppColors.accent, size: 18),
          ),
          const SizedBox(height: 7),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.white.withValues(alpha: 0.65),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CanteenCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _CanteenCard({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: AppColors.field,
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.06),
                border: Border(bottom: BorderSide(color: AppColors.line)),
              ),
              child: Icon(
                Icons.restaurant_outlined,
                color: AppColors.mutedSoft,
                size: 28,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 5,
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
