import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final firstNameController = TextEditingController(text: 'Koffi');
  final lastNameController = TextEditingController(text: 'Mensah');
  final currentPwController = TextEditingController();
  final newPwController = TextEditingController();
  final confirmPwController = TextEditingController();

  bool notifOrders = true;
  bool notifAmbassador = true;
  bool notifPromos = false;
  bool twoFactorEnabled = true;

  int get pwStrength {
    final pw = newPwController.text;
    if (pw.isEmpty) return 0;
    int score = 0;
    if (pw.length >= 6) score++;
    if (pw.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(pw)) score++;
    if (RegExp(r'[0-9]').hasMatch(pw)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(pw)) score++;
    return score.clamp(0, 4);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    newPwController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    currentPwController.dispose();
    newPwController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Mon profil',
      showBackButton: false,
      backgroundColor: LightPageColors.bg,
      body: Column(
        children: [
          LightTabs(
            tabs: const ['Profil', 'Sécurité'],
            selectedIndex: _tabController.index,
            onTap: (i) => _tabController.animateTo(i),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab().animate(key: const ValueKey(0)).fadeIn(begin: 0.9),
                _buildSecurityTab().animate(key: const ValueKey(1)).fadeIn(begin: 0.9),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildPersonalInfo(),
          const SizedBox(height: 20),
          _buildCampus(),
          const SizedBox(height: 20),
          _buildNotifications(),
          const SizedBox(height: 20),
          _buildAmbassadorCard(),
          const SizedBox(height: 20),
          _buildPlusSection(),
          const SizedBox(height: 20),
          _buildLogout(),
          const SizedBox(height: 16),
          Text(
            'kabakaba v1.1 · UCAO',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              color: LightPageColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return LightCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: LightPageColors.indigo,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  'KM',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: LightPageColors.orange,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Koffi Mensah',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    const LightBadge(text: 'UCAO'),
                    Text(
                      '+228 90 12 34 56',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: LightPageColors.muted,
                      ),
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

  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Informations personnelles'),
        LightSettingsCard(
          children: [
            LightFieldRow(
              label: 'Prénom(s)',
              controller: firstNameController,
            ),
            LightFieldRow(
              label: 'Nom',
              controller: lastNameController,
            ),
            LightFieldRow(
              label: 'Téléphone — non modifiable',
              value: '+228 90 12 34 56',
              isLocked: true,
              isEditable: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCampus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Campus'),
        LightSettingsCard(
          children: [
            LightNavRow(
              icon: Icons.school_outlined,
              title: 'UCAO',
              subtitle: 'Changer de campus — sur dossier (carte scolaire)',
              onTap: () => context.push('/campus'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Notifications'),
        LightSettingsCard(
          children: [
            LightToggleRow(
              icon: Icons.receipt_long_outlined,
              title: 'Mes commandes',
              subtitle: 'Acceptation, refus, prête, rappels',
              value: notifOrders,
              onChanged: (v) => setState(() => notifOrders = v),
            ),
            LightToggleRow(
              icon: Icons.emoji_events_outlined,
              title: 'Programme ambassadeur',
              subtitle: 'Niveau, commissions, décisions',
              value: notifAmbassador,
              onChanged: (v) => setState(() => notifAmbassador = v),
            ),
            LightToggleRow(
              icon: Icons.local_offer_outlined,
              title: 'Promotions & nouveautés',
              subtitle: 'Offres et actualités kabakaba',
              value: notifPromos,
              onChanged: (v) => setState(() => notifPromos = v),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmbassadorCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B2A6B), Color(0xFF2D4494)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2A6B).withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LightPageColors.orange.withValues(alpha: 0.16),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'NIVEAU BRONZE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.03,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFFFB347),
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Ambassadeur kabakaba',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '3 filleuls actifs · Prochain niveau: 5 filleuls',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.65),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ambStat(
                      label: 'FILLEULS',
                      value: '3',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ambStat(
                      label: 'COMMISSION',
                      value: '+750',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.push('/ambassador-dashboard'),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: LightPageColors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Tableau de bord',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ambStat({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.03,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Plus'),
        LightSettingsCard(
          children: [
            LightNavRow(
              icon: Icons.help_outline_rounded,
              title: "Centre d'aide",
              onTap: () => context.push('/help-support'),
            ),
            LightNavRow(
              icon: Icons.description_outlined,
              title: 'Conditions d\'utilisation',
              onTap: () {},
            ),
            LightNavRow(
              icon: Icons.privacy_tip_outlined,
              title: 'Politique de confidentialité',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogout() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: Container(
        decoration: BoxDecoration(
          color: LightPageColors.redLight,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: () {
              context.go('/auth');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  size: 15,
                  color: LightPageColors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Se déconnecter',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        children: [
          _buildPasswordSection(),
          const SizedBox(height: 20),
          _buildTwoFactorSection(),
          const SizedBox(height: 20),
          _buildActiveSessions(),
          const SizedBox(height: 20),
          _buildSecurityNote(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: LightButton(
              text: 'Enregistrer les modifications',
              icon: Icons.save_rounded,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Changer le mot de passe'),
        LightCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: currentPwController,
                obscureText: true,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.text,
                ),
                decoration: InputDecoration(
                  labelText: 'Mot de passe actuel',
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.muted,
                    letterSpacing: 0.03,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: LightPageColors.muted,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.border),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.border),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.indigo, width: 2),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 8, top: 4),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPwController,
                obscureText: true,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.text,
                ),
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.muted,
                    letterSpacing: 0.03,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    Icons.visibility_off_outlined,
                    size: 16,
                    color: LightPageColors.muted,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.border),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.border),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.indigo, width: 2),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 8, top: 4),
                ),
              ),
              const SizedBox(height: 10),
              _buildPwStrength(),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPwController,
                obscureText: true,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.text,
                ),
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.muted,
                    letterSpacing: 0.03,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(
                    Icons.visibility_off_outlined,
                    size: 16,
                    color: LightPageColors.muted,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.border),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.border),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: LightPageColors.indigo, width: 2),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 8, top: 4),
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mot de passe oublié ? Récupérer par SMS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPwStrength() {
    final strength = pwStrength;
    final labels = ['', 'Faible', 'Moyen', 'Bon', 'Excellent'];
    final colors = [
      LightPageColors.border,
      LightPageColors.red,
      LightPageColors.warning,
      const Color(0xFF0EA5E9),
      LightPageColors.green,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i == 3 ? 0 : 4),
                decoration: BoxDecoration(
                  color: i < strength
                      ? colors[strength]
                      : LightPageColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          strength > 0
              ? 'Force du mot de passe : ${labels[strength]}'
              : 'Force du mot de passe',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            color: LightPageColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTwoFactorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Double authentification'),
        LightSettingsCard(
          children: [
            LightToggleRow(
              icon: Icons.shield_outlined,
              title: 'Vérification par SMS',
              subtitle: 'Code envoyé au +228 90 12 34 56 lors des connexions',
              value: twoFactorEnabled,
              onChanged: (v) => setState(() => twoFactorEnabled = v),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Sessions actives'),
        LightCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Column(
            children: [
              _sessionRow(
                device: 'iPhone 14 Pro',
                location: 'Lomé, Togo',
                isCurrent: true,
                time: 'Actif maintenant',
              ),
              _divider(),
              _sessionRow(
                device: 'Xiaomi Redmi Note 12',
                location: 'Lomé, Togo',
                isCurrent: false,
                time: 'Il y a 2 jours',
              ),
              _divider(),
              _sessionRow(
                device: 'Chrome — MacBook Pro',
                location: 'Lomé, Togo',
                isCurrent: false,
                time: 'Il y a 1 semaine',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: LightPageColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 14),
    );
  }

  Widget _sessionRow({
    required String device,
    required String location,
    required bool isCurrent,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isCurrent
                  ? LightPageColors.greenLight
                  : LightPageColors.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCurrent ? Icons.smartphone_rounded : Icons.devices_rounded,
              size: 16,
              color: isCurrent ? LightPageColors.green : LightPageColors.text2,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        device,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: LightPageColors.text,
                        ),
                      ),
                    ),
                    if (isCurrent) const LightBadge(text: 'Actuel'),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$location · $time',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            Icon(
              Icons.logout_rounded,
              size: 16,
              color: LightPageColors.muted,
            ),
        ],
      ),
    );
  }

  Widget _buildSecurityNote() {
    return LightHintBox(
      icon: Icons.verified_user_outlined,
      text:
          'Pour protéger ton compte, kabakaba ne demande JAMAIS ton mot de passe par SMS ou appel. Partage jamais tes codes de vérification.',
    );
  }
}
