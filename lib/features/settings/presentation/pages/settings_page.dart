import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/phone_e164.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/widgets/kaba_bottom_sheet_modal.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final phone = user?.phone;
    final phoneLabel = (phone == null || phone.isEmpty)
        ? 'Compte étudiant'
        : '+228 ${formatTogoDisplay(phone)}';

    return LightPageScaffold(
      title: 'Paramètres',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          LightCard(
            padding: const EdgeInsets.all(14),
            borderRadius: 18,
            onTap: () => context.push('/edit-profile'),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1B2A6B), Color(0xFFF07840)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user?.initials ?? 'É',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayFullName ?? 'Étudiant',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: LightPageColors.text,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        phoneLabel,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: LightPageColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: LightPageColors.muted,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const LightSectionTitle(
            title: 'COMPTE',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              LightNavRow(
                icon: Icons.person_rounded,
                title: 'Modifier le profil',
                subtitle: 'Nom et photo',
                onTap: () => context.push('/edit-profile'),
              ),
              LightNavRow(
                icon: Icons.school_rounded,
                title: 'Mon campus',
                onTap: () => context.push('/campus'),
              ),
              LightNavRow(
                icon: Icons.wallet_rounded,
                title: 'Portefeuille',
                onTap: () => context.go('/wallet'),
              ),
              LightNavRow(
                icon: Icons.history_rounded,
                title: 'Mes commandes',
                onTap: () => context.go('/order-history'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const LightSectionTitle(
            title: 'PRÉFÉRENCES',
            icon: Icons.tune_rounded,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              LightNavRow(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                onTap: () => context.push('/notifications'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const LightSectionTitle(
            title: 'APPARENCE',
            icon: Icons.palette_outlined,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              _ThemeChoice(
                icon: Icons.wb_sunny_outlined,
                title: 'Clair',
                selected: ref.watch(themeModeProvider) == AppThemeMode.light,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(AppThemeMode.light),
              ),
              _ThemeChoice(
                icon: Icons.dark_mode_outlined,
                title: 'Sombre',
                selected: ref.watch(themeModeProvider) == AppThemeMode.dark,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(AppThemeMode.dark),
              ),
              _ThemeChoice(
                icon: Icons.brightness_auto_outlined,
                title: 'Système',
                selected: ref.watch(themeModeProvider) == AppThemeMode.system,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(AppThemeMode.system),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const LightSectionTitle(
            title: 'SUPPORT',
            icon: Icons.help_outline_rounded,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              LightNavRow(
                icon: Icons.help_center_rounded,
                title: 'Centre d\'aide',
                onTap: () => context.push('/help-support'),
              ),
              LightNavRow(
                icon: Icons.info_outline_rounded,
                title: 'À propos',
                onTap: () => context.push('/about'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LightCard(
            padding: const EdgeInsets.all(14),
            borderRadius: 16,
            onTap: () => context.push('/ambassador-presentation'),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: LightPageColors.orangeLight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: LightPageColors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Devenir ambassadeur',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: LightPageColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Gagne des commissions sur les recharges de tes filleuls.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: LightPageColors.muted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          LightButton(
            text: 'Se déconnecter',
            icon: Icons.logout_rounded,
            isPrimary: false,
            isDanger: true,
            onPressed: () async {
              final confirmed = await KabaBottomSheetModal.confirmLogout(
                context,
              );
              if (!confirmed || !context.mounted) return;
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/auth');
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeChoice extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeChoice({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LightNavRow(
      icon: icon,
      title: title,
      trailing: selected
          ? Icon(Icons.check_rounded, color: LightPageColors.orange, size: 20)
          : const SizedBox.shrink(),
      onTap: onTap,
    );
  }
}
