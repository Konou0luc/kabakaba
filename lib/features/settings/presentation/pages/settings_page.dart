import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/kaba_card.dart';

import '../../../../shared/widgets/kaba_background.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    final settingsItems = [
      _SettingItem(
        icon: Icons.person_rounded,
        title: 'Modifier le profil',
        color: AppColors.primary,
        onTap: (context) => context.push('/edit-profile'),
      ),
      _SettingItem(
        icon: Icons.dark_mode_rounded,
        title: 'Mode sombre',
        color: AppColors.greyDark,
        isToggle: true,
        toggleValue: themeMode == AppThemeMode.dark,
        onToggle: (value) {
          final themeNotifier = ref.read(themeModeProvider.notifier);
          themeNotifier.setThemeMode(
            value ? AppThemeMode.dark : AppThemeMode.light,
          );
        },
      ),
      _SettingItem(
        icon: Icons.notifications_rounded,
        title: 'Notifications',
        color: AppColors.accent,
        onTap: (context) => context.push('/notifications'),
      ),
      _SettingItem(
        icon: Icons.security_rounded,
        title: 'Confidentialité',
        color: AppColors.success,
      ),
      _SettingItem(
        icon: Icons.help_rounded,
        title: 'Aide & Support',
        color: AppColors.warning,
      ),
      _SettingItem(
        icon: Icons.info_rounded,
        title: 'À propos',
        color: AppColors.greyDark,
        onTap: (context) => context.push('/about'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.l),
            itemCount: settingsItems.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.m),
            itemBuilder: (context, index) {
              final item = settingsItems[index];
              return KabaCard(
                onTap: item.onTap != null ? () => item.onTap!(context) : null,
                child: _SettingItemWidget(item: item),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final Color color;
  final Function(BuildContext)? onTap;
  final bool isToggle;
  final bool toggleValue;
  final Function(bool)? onToggle;

  _SettingItem({
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
    this.isToggle = false,
    this.toggleValue = false,
    this.onToggle,
  });
}

class _SettingItemWidget extends StatelessWidget {
  final _SettingItem item;

  const _SettingItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = (item.color == AppColors.primary && isDark)
        ? AppColors.white
        : item.color;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(item.title, style: AppTextStyles.bodyLarge)),
        if (item.isToggle)
          Switch(
            value: item.toggleValue,
            onChanged: item.onToggle,
            activeThumbColor: isDark ? AppColors.white : AppColors.primary,
          )
        else
          const Icon(AppIcons.arrowRight, color: AppColors.grey, size: 16),
      ],
    );
  }
}
