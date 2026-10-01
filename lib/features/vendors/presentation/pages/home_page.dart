import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final vendors = ref.watch(vendorsListProvider).valueOrNull ?? const [];
    final unreadCount =
        (ref.watch(myNotificationsProvider).valueOrNull ?? const [])
            .where((item) => !item.isRead)
            .length;
    final firstName = user?.displayFirstName ?? 'Étudiant';
    final balance = formatTickets(user?.walletBalance ?? 0);

    return Scaffold(
      backgroundColor: AppColors.adaptiveBg(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHero(firstName, balance, unreadCount),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: LightPageColors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    border: Border(top: BorderSide(color: LightPageColors.border)),
                  ),
                  child: RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: () => refreshStudentSession(ref),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 26, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const KabaSectionKicker('Aujourd’hui'),
                          const SizedBox(height: 6),
                          Text('Accès rapide', style: AppTextStyles.sectionTitle)
                              .animate()
                              .fadeIn(delay: 280.ms),
                          const SizedBox(height: 16),
                          _buildQuickBento()
                              .animate()
                              .fadeIn(delay: 320.ms)
                              .slideY(begin: 0.06, end: 0),
                          const SizedBox(height: 22),
                          _buildPromoBanner()
                              .animate()
                              .fadeIn(delay: 420.ms)
                              .slideY(begin: 0.05, end: 0),
                          const SizedBox(height: 28),
                          const KabaSectionKicker('Campus'),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Cantines du campus',
                                  style: AppTextStyles.sectionTitle,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/canteen-list'),
                                child: Text(
                                  'Voir tout',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 480.ms),
                          const SizedBox(height: 16),
                          _buildCanteens(vendors),
                        ],
                      ),
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

  Widget _buildHero(String firstName, String balance, int unreadCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 36),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bon retour', style: AppTextStyles.greetLabel),
                        const SizedBox(height: 3),
                        Text(
                          'Bonjour, $firstName',
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
                        onTap: () => context.push('/canteen-list'),
                      ),
                      const SizedBox(width: 10),
                      _HomeBellButton(
                        unreadCount: unreadCount,
                        onTap: () => context.push('/notifications'),
                      ),
                    ],
                  ).animate().fadeIn().slideX(begin: 0.05, end: 0),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 14,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 7),
                  Text('Solde tickets', style: AppTextStyles.balanceLabel),
                ],
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 8),
              Text('$balance tickets', style: AppTextStyles.balanceAmount)
                  .animate()
                  .fadeIn(delay: 150.ms)
                  .slideY(begin: 0.1, end: 0),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildPillButton(
                      icon: Icons.add_rounded,
                      label: 'Recharger',
                      isPrimary: true,
                      onTap: () => context.push('/recharge/step1'),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPillButton(
                      icon: Icons.refresh_rounded,
                      label: 'Historique',
                      isPrimary: false,
                      onTap: () => context.push('/transaction-history'),
                    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickBento() {
    return Column(
      children: [
        SizedBox(
          height: 156,
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: _FeatureTile(
                  title: 'Commander',
                  subtitle: 'Cantines ouvertes près de toi',
                  icon: Icons.restaurant_rounded,
                  onTap: () => context.push('/canteen-list'),
                  featured: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Expanded(
                      child: _FeatureTile(
                        title: 'Recharger',
                        subtitle: 'Flooz / Mixx',
                        icon: Icons.add_card_rounded,
                        onTap: () => context.push('/recharge/step1'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _FeatureTile(
                        title: 'Commandes',
                        subtitle: 'Suivi & retrait',
                        icon: Icons.receipt_long_rounded,
                        onTap: () => context.push('/order-history'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _HelpRow(onTap: () => context.push('/help-support')),
      ],
    );
  }

  Widget _buildCanteens(List<VendorModel> vendors) {
    if (vendors.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 18),
        decoration: BoxDecoration(
          color: LightPageColors.indigoLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: LightPageColors.border),
        ),
        child: Column(
          children: [
            Icon(
              Icons.storefront_outlined,
              color: LightPageColors.muted,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              'Aucune cantine pour le moment',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LightPageColors.muted,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 228,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final canteen = vendors[index];
          return KabaCanteenPoster(
            vendor: canteen,
            width: 198,
            height: 228,
            onTap: () => context.push('/canteen-detail', extra: canteen.id),
          )
              .animate()
              .fadeIn(delay: (500 + index * 70).ms)
              .slideX(begin: 0.08, end: 0);
        },
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: 0.08),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.14)),
        ),
        child: Icon(icon, color: AppColors.white, size: 19),
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
            Icon(icon, size: 13, color: AppColors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
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
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.accent.withValues(alpha: 0.18),
              AppColors.accent.withValues(alpha: 0.06),
            ],
          ),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Programme ambassadeur',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: LightPageColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Parraine le campus, gagne des commissions',
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
              Icons.arrow_forward_rounded,
              color: AppColors.accent,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool featured;

  const _FeatureTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: featured
                  ? AppColors.accent.withValues(alpha: 0.35)
                  : LightPageColors.border,
            ),
            gradient: featured
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF07840).withValues(alpha: 0.28),
                      const Color(0xFF1B2A6B).withValues(alpha: 0.9),
                    ],
                  )
                : null,
            color: featured ? null : LightPageColors.indigoLight,
          ),
          child: Padding(
            padding: EdgeInsets.all(featured ? 16 : 10),
            child: featured
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _iconBox(),
                      const Spacer(),
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: AppColors.white.withValues(alpha: 0.62),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _iconBox(),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                                color: LightPageColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _iconBox() {
    return Container(
      width: featured ? 40 : 28,
      height: featured ? 40 : 28,
      decoration: BoxDecoration(
        color: featured
            ? AppColors.accent.withValues(alpha: 0.22)
            : LightPageColors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(featured ? 12 : 8),
      ),
      child: Icon(
        icon,
        size: featured ? 20 : 15,
        color: featured ? AppColors.accent : LightPageColors.indigo,
      ),
    );
  }
}

class _HelpRow extends StatelessWidget {
  final VoidCallback onTap;

  const _HelpRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 58,
          decoration: BoxDecoration(
            color: LightPageColors.indigoLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: LightPageColors.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: LightPageColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  size: 18,
                  color: LightPageColors.indigo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aide & support',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: LightPageColors.text,
                      ),
                    ),
                    Text(
                      'FAQ, litiges, campus',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
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
      ),
    );
  }
}

class _HomeBellButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _HomeBellButton({
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;
    final label = unreadCount > 9 ? '9+' : '$unreadCount';

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 46,
        height: 46,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasUnread
                      ? AppColors.accent.withValues(alpha: 0.18)
                      : AppColors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: hasUnread
                        ? AppColors.accent.withValues(alpha: 0.55)
                        : AppColors.white.withValues(alpha: 0.14),
                  ),
                  boxShadow: hasUnread
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: CustomPaint(
                    size: const Size(20, 20),
                    painter: _BellPainter(
                      color: hasUnread ? AppColors.accent : AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (hasUnread)
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  height: 18,
                  constraints: const BoxConstraints(minWidth: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.indigoDark, width: 1.6),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      color: AppColors.white,
                    ),
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.08, 1.08),
                      duration: 1400.ms,
                      curve: Curves.easeInOut,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BellPainter extends CustomPainter {
  final Color color;

  const _BellPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.28, h * 0.38)
      ..cubicTo(w * 0.28, h * 0.16, w * 0.72, h * 0.16, w * 0.72, h * 0.38)
      ..lineTo(w * 0.78, h * 0.68)
      ..quadraticBezierTo(w * 0.80, h * 0.78, w * 0.70, h * 0.78)
      ..lineTo(w * 0.30, h * 0.78)
      ..quadraticBezierTo(w * 0.20, h * 0.78, w * 0.22, h * 0.68)
      ..close();

    canvas.drawPath(path, stroke);

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.78),
        width: w * 0.22,
        height: h * 0.18,
      ),
      0.12,
      2.90,
      false,
      stroke,
    );

    canvas.drawLine(
      Offset(w * 0.50, h * 0.14),
      Offset(w * 0.50, h * 0.22),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _BellPainter oldDelegate) =>
      oldDelegate.color != color;
}

