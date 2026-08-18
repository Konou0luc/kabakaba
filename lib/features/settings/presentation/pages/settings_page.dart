import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == AppThemeMode.dark;

    return LightPageScaffold(
      title: 'Paramètres',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: LightIconButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          LightSectionTitle(title: 'COMPTE', icon: Icons.person_outline_rounded),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              LightNavRow(
                icon: Icons.person_rounded,
                title: 'Modifier le profil',
                subtitle: 'Nom, photo, téléphone…',
                onTap: () => context.push('/edit-profile'),
              ),
              LightNavRow(
                icon: Icons.school_rounded,
                title: 'Mon campus',
                subtitle: 'UCAO · Université Catholique',
                onTap: () => context.push('/campus'),
              ),
              LightNavRow(
                icon: Icons.wallet_rounded,
                title: 'Portefeuille & paiements',
                subtitle: 'Recharges, cartes, méthodes',
                onTap: () => context.push('/wallet'),
              ),
              LightNavRow(
                icon: Icons.history_rounded,
                title: 'Historiques',
                subtitle: 'Commandes, transactions, commissions',
                onTap: () => context.push('/order-history'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LightSectionTitle(
            title: 'PRÉFÉRENCES',
            icon: Icons.tune_rounded,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              LightToggleRow(
                icon: Icons.dark_mode_rounded,
                title: 'Mode sombre',
                subtitle: isDark ? 'Activé' : 'Désactivé',
                value: isDark,
                iconBgColor: LightPageColors.indigoLight,
                iconColor: LightPageColors.indigo,
                onChanged: (value) {
                  final notifier = ref.read(themeModeProvider.notifier);
                  notifier.setThemeMode(
                    value ? AppThemeMode.dark : AppThemeMode.light,
                  );
                },
              ),
              LightNavRow(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                subtitle: 'Commandes, promos, alertes',
                onTap: () => context.push('/notifications'),
              ),
              LightToggleRow(
                icon: Icons.translate_rounded,
                title: 'Langue',
                subtitle: 'Français',
                value: true,
                iconBgColor: LightPageColors.orangeLight,
                iconColor: LightPageColors.orange,
              ),
              LightNavRow(
                icon: Icons.location_on_outlined,
                title: 'Adresses de livraison',
                subtitle: '3 adresses enregistrées',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          LightSectionTitle(
            title: 'CONFIDENTIALITÉ & SÉCURITÉ',
            icon: Icons.security_rounded,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              LightNavRow(
                icon: Icons.lock_outline_rounded,
                title: 'Sécurité du compte',
                subtitle: 'Mot de passe, biométrie, 2FA',
                onTap: () {},
              ),
              LightNavRow(
                icon: Icons.visibility_outlined,
                title: 'Confidentialité',
                subtitle: 'Données, permissions, historique',
                onTap: () {},
              ),
              LightNavRow(
                icon: Icons.gpp_good_outlined,
                title: 'Vérifications',
                subtitle: 'Identité · Email · Téléphone ✓',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          LightSectionTitle(
            title: 'SUPPORT & À PROPOS',
            icon: Icons.help_outline_rounded,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              LightNavRow(
                icon: Icons.help_center_rounded,
                title: 'Centre d\'aide & FAQ',
                subtitle: 'Trouver une réponse rapidement',
                onTap: () => context.push('/help-support'),
              ),
              LightNavRow(
                icon: Icons.support_agent_rounded,
                title: 'Contacter le support',
                subtitle: 'Chat en ligne · 7j/7',
                onTap: () {},
              ),
              LightNavRow(
                icon: Icons.flag_outlined,
                title: 'Signaler un problème',
                subtitle: 'Bug, litige, comportement',
                onTap: () {},
              ),
              LightNavRow(
                icon: Icons.info_outline_rounded,
                title: 'À propos de KabaKaba',
                subtitle: 'Version 1.0.0 · Build 42',
                onTap: () => context.push('/about'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LightSectionTitle(title: 'PARIAGE AMBASSADEUR', icon: Icons.emoji_events_rounded),
          const SizedBox(height: 6),
          LightCard(
            padding: const EdgeInsets.all(14),
            borderRadius: 16,
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GradText('Deviens Ambassadeur KabaKaba'),
                      SizedBox(height: 2),
                      _SubText(
                        'Gagne des commissions, accès anticipé, et récompenses exclusives.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => context.push('/ambassador/presentation'),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: LightButton(
              text: 'Se déconnecter',
              icon: Icons.logout_rounded,
              isPrimary: false,
              isDanger: true,
              onPressed: () => context.go('/login'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '© 2025 KabaKaba · Tous droits réservés',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: LightPageColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return LightCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
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
              'KA',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleText('Koffi Amaël'),
                SizedBox(height: 3),
                _SubText('Étudiant · +228 91 23 45 67'),
                SizedBox(height: 6),
                _BadgeRow(),
              ],
            ),
          ),
          LightIconButton(
            icon: Icons.chevron_right_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  final String text;
  const _TitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: LightPageColors.text,
      ),
    );
  }
}

class _SubText extends StatelessWidget {
  final String text;
  const _SubText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: LightPageColors.muted,
        height: 1.35,
      ),
    );
  }
}

class _GradText extends StatelessWidget {
  final String text;
  const _GradText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12.5,
        fontWeight: FontWeight.w900,
        color: LightPageColors.text,
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LightBadge(
          text: '⭐ Premium',
          bgColor: LightPageColors.orangeLight,
          color: LightPageColors.orange,
        ),
        const SizedBox(width: 6),
        LightBadge(
          text: '✓ Vérifié',
          bgColor: LightPageColors.greenLight,
          color: LightPageColors.green,
        ),
      ],
    );
  }
}
