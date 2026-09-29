import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class CanteenListPage extends ConsumerStatefulWidget {
  const CanteenListPage({super.key});

  @override
  ConsumerState<CanteenListPage> createState() => _CanteenListPageState();
}

class _CanteenListPageState extends ConsumerState<CanteenListPage> {
  final searchController = TextEditingController();
  bool _openOnly = false;

  String get _campusLabel {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final campusId = user?.campusId;
    if (campusId == null) return 'Ton campus';
    final campuses = ref.watch(campusesListProvider).valueOrNull ?? const [];
    for (final campus in campuses) {
      if (campus.id == campusId) return campus.name;
    }
    return 'Ton campus';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<VendorModel> get _filtered {
    final q = searchController.text.trim().toLowerCase();
    final vendors = ref.watch(vendorsListProvider).valueOrNull ?? const [];
    return [
      for (final vendor in vendors)
        if ((!_openOnly || vendor.isOpen) &&
            (q.isEmpty || vendor.canteenName.toLowerCase().contains(q)))
          vendor,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final openCount = (ref.watch(vendorsListProvider).valueOrNull ?? const [])
        .where((v) => v.isOpen)
        .length;

    return LightPageScaffold(
      title: 'Cantines',
      actions: [
        IconButton(
          onPressed: () => context.push('/notifications'),
          icon: const Icon(Icons.notifications_outlined),
        ),
      ],
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () => refreshStudentSession(ref),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KabaSearchField(
                      controller: searchController,
                      hintText: 'Cantines, plats…',
                      onChanged: (_) => setState(() {}),
                    ).animate().fadeIn(delay: 80.ms),
                    const SizedBox(height: 18),
                    KabaSectionHeader(
                      kicker: _campusLabel,
                      title: openCount > 0
                          ? '$openCount ouvertes près de toi'
                          : 'Cantines à proximité',
                    ),
                    const SizedBox(height: 14),
                    _buildFilters(),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            if (filtered.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: KabaEmptyState(
                  icon: Icons.storefront_outlined,
                  title: 'Aucune cantine',
                  subtitle:
                      'Rien ne correspond à ta recherche pour le moment.',
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vendor = filtered[index];
                    return KabaCanteenPoster(
                      vendor: vendor,
                      height: 176,
                      onTap: () =>
                          context.push('/canteen-detail', extra: vendor.id),
                    )
                        .animate()
                        .fadeIn(delay: (40 * index).ms)
                        .slideY(begin: 0.06, end: 0);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _FilterChip(
          label: 'Toutes',
          selected: !_openOnly,
          onTap: () => setState(() => _openOnly = false),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: 'Ouvertes',
          selected: _openOnly,
          onTap: () => setState(() => _openOnly = true),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : LightPageColors.indigoLight,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: selected ? AppColors.accent : LightPageColors.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : LightPageColors.text,
          ),
        ),
      ),
    );
  }
}
