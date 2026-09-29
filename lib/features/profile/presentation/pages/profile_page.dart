import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../core/utils/phone_e164.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../features/profile/data/user_repository.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_bottom_sheet_modal.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import '../../../../shared/widgets/remote_photo.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  UserModel? get _user =>
      ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);

  String get _phoneLabel {
    final phone = _user?.phone;
    if (phone == null || phone.isEmpty) return 'Non renseigné';
    return '+228 ${formatTogoDisplay(phone)}';
  }

  String get _campusLabel {
    final campusId = _user?.campusId;
    if (campusId == null) return 'Campus non défini';
    final campuses = ref.watch(campusesListProvider).valueOrNull ?? const [];
    for (final campus in campuses) {
      if (campus.id == campusId) return campus.name;
    }
    return 'Campus';
  }

  Future<void> _setNotify({
    bool? orders,
    bool? ambassador,
    bool? promos,
  }) async {
    final user = _user;
    if (user == null) return;
    try {
      final updated = await ref.read(userRepositoryProvider).updateUser(
        id: user.id,
        notifyOrders: orders,
        notifyAmbassador: ambassador,
        notifyPromotions: promos,
      );
      ref.read(authProvider.notifier).updateCurrentUser(updated);
      ref.invalidate(meProvider);
    } catch (error) {
      if (mounted) showKabaSnack(context, apiErrorMessage(error), error: true);
    }
  }

  Future<void> _logout() async {
    final confirmed = await KabaBottomSheetModal.confirmLogout(context);
    if (!confirmed || !mounted) return;
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    return Scaffold(
      backgroundColor: AppColors.adaptiveBg(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            KabaIndigoHero(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mon profil', style: AppTextStyles.greetLabel),
                            const SizedBox(height: 3),
                            Text(
                              user?.displayFirstName ?? 'Étudiant',
                              style: AppTextStyles.greetName,
                            ),
                          ],
                        ),
                      ),
                      KabaHeroIconButton(
                        icon: Icons.settings_outlined,
                        onTap: () => context.push('/settings'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.push('/edit-profile'),
                    child: Row(
                      children: [
                        _avatar(user),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayFullName ?? 'Étudiant',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _campusLabel,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.62),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.edit_outlined,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: KabaOverlapSheet(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  child: Column(
                    children: [
                      _buildPersonalInfo(user),
                      const SizedBox(height: 20),
                      _buildCampus(),
                      const SizedBox(height: 20),
                      _buildNotifications(user),
                      const SizedBox(height: 20),
                      _buildAmbassadorCard(),
                      const SizedBox(height: 20),
                      _buildPlusSection(),
                      const SizedBox(height: 20),
                      _buildLogout(),
                      const SizedBox(height: 16),
                      Text(
                        'kabakaba · compte étudiant',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: LightPageColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(UserModel? user) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: RemotePhoto(
        url: user?.avatarUrl,
        width: 58,
        height: 58,
        radius: 18,
        fallback: ColoredBox(
          color: AppColors.accent.withValues(alpha: 0.22),
          child: Center(
            child: Text(
              user?.initials ?? 'É',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(UserModel? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Informations personnelles'),
        LightSettingsCard(
          children: [
            LightFieldRow(
              label: 'Prénom(s)',
              value: user?.firstName?.trim().isNotEmpty == true
                  ? user!.firstName!
                  : '—',
              isEditable: false,
            ),
            LightFieldRow(
              label: 'Nom',
              value: user?.lastName?.trim().isNotEmpty == true
                  ? user!.lastName!
                  : '—',
              isEditable: false,
            ),
            LightFieldRow(
              label: 'Téléphone',
              value: _phoneLabel,
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
              title: _campusLabel,
              subtitle: 'Changer de campus sur dossier',
              onTap: () => context.push('/campus'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotifications(UserModel? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightSectionTitle(title: 'Notifications'),
        LightSettingsCard(
          children: [
            LightToggleRow(
              icon: Icons.receipt_long_outlined,
              title: 'Mes commandes',
              subtitle: 'Acceptation, refus, prête',
              value: user?.notifyOrders ?? true,
              onChanged: (v) => _setNotify(orders: v),
            ),
            LightToggleRow(
              icon: Icons.emoji_events_outlined,
              title: 'Programme ambassadeur',
              subtitle: 'Niveau, commissions, décisions',
              value: user?.notifyAmbassador ?? true,
              onChanged: (v) => _setNotify(ambassador: v),
            ),
            LightToggleRow(
              icon: Icons.local_offer_outlined,
              title: 'Promotions & nouveautés',
              subtitle: 'Offres et actualités kabakaba',
              value: user?.notifyPromotions ?? false,
              onChanged: (v) => _setNotify(promos: v),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmbassadorCard() {
    final ambassador = ref.watch(myAmbassadorProvider).valueOrNull;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B2A6B), Color(0xFF2D4494)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
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
                  ambassador?.status ?? 'PAS ENCORE INSCRIT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
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
            ambassador == null
                ? 'Candidate pour gagner des commissions sur les recharges.'
                : '${ambassador.totalReferrals} filleuls · ${ambassador.status}',
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
                  value: '${ambassador?.totalReferrals ?? 0}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ambStat(
                  label: 'COMMISSION',
                  value: '${ambassador?.totalCommissionEarned ?? 0}',
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
                onTap: () => context.push(
                  ambassador == null
                      ? '/ambassador-presentation'
                      : '/ambassador-dashboard',
                ),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: LightPageColors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    ambassador == null
                        ? 'Devenir ambassadeur'
                        : 'Tableau de bord',
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
              icon: Icons.info_outline_rounded,
              title: 'À propos',
              onTap: () => context.push('/about'),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: _logout,
          child: Container(
            decoration: BoxDecoration(
              color: LightPageColors.redLight,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: LightPageColors.red.withValues(alpha: 0.35)),
            ),
            alignment: Alignment.center,
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
}
