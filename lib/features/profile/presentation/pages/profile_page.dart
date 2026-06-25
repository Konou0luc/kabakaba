import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../features/auth/data/auth_provider.dart';

import '../../../../shared/widgets/kaba_background.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary(context),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 50,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Luc Konan', style: AppTextStyles.h2),
                    Text(
                      'luc.konan@univ.ci',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: -0.2, end: 0),
              ),
              const SizedBox(height: 32),
              ..._profileMenuItems.map((item) {
                final index = _profileMenuItems.indexOf(item);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _ProfileMenuItem(
                    item: item,
                    onLogout: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                  )
                      .animate()
                      .fadeIn(delay: (200 + (index * 100)).ms)
                      .slideX(begin: 0.1, end: 0),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final _ProfileMenuModel item;
  final VoidCallback? onLogout;

  const _ProfileMenuItem({required this.item, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return KabaCard(
      onTap: item.onTap != null 
        ? () => item.onTap!(context) 
        : onLogout != null 
          ? () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Déconnexion'),
                content: const Text('Tu es sûr de vouloir te déconnecter ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onLogout!();
                    },
                    child: const Text('Se déconnecter'),
                  ),
                ],
              ),
            )
          : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(item.title, style: AppTextStyles.bodyLarge)),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuModel {
  final IconData icon;
  final String title;
  final Color color;
  final Function(BuildContext)? onTap;

  _ProfileMenuModel({
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });
}

final _profileMenuItems = [
  _ProfileMenuModel(
    icon: Icons.edit_rounded,
    title: 'Modifier le profil',
    color: AppColors.primary,
    onTap: (context) => context.push('/edit-profile'),
  ),
  _ProfileMenuModel(
    icon: Icons.track_changes_rounded,
    title: 'Suivi de ma commande',
    color: AppColors.success,
    onTap: (context) => context.push('/order-tracking'),
  ),
  _ProfileMenuModel(
    icon: AppIcons.history,
    title: 'Historique des commandes',
    color: AppColors.primary,
    onTap: (context) => context.push('/order-history'),
  ),
  _ProfileMenuModel(
    icon: Icons.workspace_premium_rounded,
    title: 'Programme Ambassadeur',
    color: AppColors.accent,
    onTap: (context) => context.push('/ambassador-dashboard'),
  ),
  _ProfileMenuModel(
    icon: AppIcons.settings,
    title: 'Paramètres',
    color: AppColors.greyDark,
    onTap: (context) => context.push('/settings'),
  ),
  _ProfileMenuModel(
    icon: AppIcons.info,
    title: 'A propos',
    color: AppColors.accent,
    onTap: (context) => context.push('/about'),
  ),
  _ProfileMenuModel(
    icon: AppIcons.logout,
    title: 'Se déconnecter',
    color: AppColors.error,
  ),
];
