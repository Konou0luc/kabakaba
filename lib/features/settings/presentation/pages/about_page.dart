import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'À propos',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildHero(),
          const SizedBox(height: 20),
          LightSectionTitle(title: 'NOTRE MISSION', icon: Icons.flag_rounded),
          const SizedBox(height: 6),
          _buildCard(
            icon: Icons.favorite_rounded,
            iconColor: LightPageColors.red,
            iconBg: LightPageColors.redLight,
            title: 'Faciliter la vie sur campus',
            desc:
                'KabaKaba est une solution de paiement digitale conçue pour simplifier les transactions au sein des campus universitaires togolais. Notre mission : rendre la restauration, les petits achats et les paiements de services fluides, rapides et sécurisés pour tous les étudiants et prestataires.',
          ),
          const SizedBox(height: 14),
          _buildCard(
            icon: Icons.visibility_rounded,
            iconColor: LightPageColors.indigo,
            iconBg: LightPageColors.indigoLight,
            title: 'Notre vision',
            desc:
                'Devenir le compagnon incontournable de chaque étudiant africain : un portefeuille unique pour manger, payer, économiser, et même gagner de l\'argent grâce au programme ambassadeur.',
          ),
          const SizedBox(height: 20),
          LightSectionTitle(
            title: 'CONTACTEZ-NOUS',
            icon: Icons.contact_support_rounded,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              _contactRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: 'hello@kabakaba.app',
              ),
              _contactRow(
                icon: Icons.language_outlined,
                label: 'Site web',
                value: 'www.kabakaba.app',
              ),
              _contactRow(
                icon: Icons.place_outlined,
                label: 'Siège',
                value: 'Lomé, Togo',
              ),
            ],
          ),
          const SizedBox(height: 20),
          LightSectionTitle(title: 'NOS VALEURS', icon: Icons.groups_rounded),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _valueCard(
                  icon: Icons.security_rounded,
                  iconColor: LightPageColors.indigo,
                  iconBg: LightPageColors.indigoLight,
                  title: 'Sécurité',
                  desc: 'Paiements chiffrés et 100% traçables.',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _valueCard(
                  icon: Icons.bolt_rounded,
                  iconColor: LightPageColors.warning,
                  iconBg: LightPageColors.warningLight,
                  title: 'Rapidité',
                  desc: 'Transactions validées en quelques secondes.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _valueCard(
                  icon: Icons.people_alt_rounded,
                  iconColor: LightPageColors.orange,
                  iconBg: LightPageColors.orangeLight,
                  title: 'Communauté',
                  desc: 'Conçu avec et pour les étudiants.',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _valueCard(
                  icon: Icons.public_rounded,
                  iconColor: LightPageColors.green,
                  iconBg: LightPageColors.greenLight,
                  title: 'Impact',
                  desc: 'Valoriser les prestataires locaux.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LightSectionTitle(
            title: 'INFORMATIONS LÉGALES',
            icon: Icons.gavel_rounded,
          ),
          const SizedBox(height: 6),
          LightSettingsCard(
            children: [
              LightNavRow(
                icon: Icons.description_outlined,
                title: 'Conditions d\'utilisation',
                onTap: () => context.push('/legal/terms'),
              ),
              LightNavRow(
                icon: Icons.lock_outline_rounded,
                title: 'Politique de confidentialité',
                onTap: () => context.push('/legal/privacy'),
              ),
              LightNavRow(
                icon: Icons.receipt_long_outlined,
                title: 'Mentions légales',
                onTap: () => context.push('/legal/mentions'),
              ),
              LightNavRow(
                icon: Icons.cookie_outlined,
                title: 'Gestion des cookies',
                onTap: () => context.push('/legal/cookies'),
              ),
              LightNavRow(
                icon: Icons.verified_outlined,
                title: 'Licences & Open Source',
                onTap: () => showLicensePage(context: context),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: Column(
              children: [
                Text(
                  'KabaKaba · Version 1.0.0 (build 42)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '© 2025 KabaKaba SAS. Tous droits réservés.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: LightPageColors.muted,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialBtn(Icons.facebook_rounded, const Color(0xFF1877F2)),
                    const SizedBox(width: 10),
                    _socialBtn(
                      Icons.flutter_dash_rounded,
                      const Color(0xFF000000),
                    ),
                    const SizedBox(width: 10),
                    _socialBtn(
                      Icons.chat_bubble_rounded,
                      const Color(0xFF25D366),
                    ),
                    const SizedBox(width: 10),
                    _socialBtn(
                      Icons.alternate_email_rounded,
                      const Color(0xFF1DA1F2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return LightCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B2A6B), Color(0xFFF07840)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: LightPageColors.orange.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'KB',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'KabaKaba',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Le portefeuille solidaire des campus',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: LightPageColors.muted,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LightBadge(
                text: 'Campus · Togo',
                bgColor: LightPageColors.indigoLight,
                color: LightPageColors.indigo,
              ),
              const SizedBox(width: 8),
              LightBadge(
                text: 'Flooz / Mixx',
                bgColor: LightPageColors.orangeLight,
                color: LightPageColors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String desc,
  }) {
    return LightCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: LightPageColors.text2,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _valueCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String desc,
  }) {
    return LightCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(height: 9),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            desc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: LightPageColors.muted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return LightNavRow(icon: icon, title: label, subtitle: value);
  }

  Widget _socialBtn(IconData icon, Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: LightPageColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: color),
    );
  }
}
