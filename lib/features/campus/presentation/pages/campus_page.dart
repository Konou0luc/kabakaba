import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class CampusPage extends ConsumerWidget {
  const CampusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final campuses = ref.watch(campusesListProvider).valueOrNull ?? const [];
    final current = campuses.where((c) => c.id == user?.campusId).toList();
    final currentName = current.isNotEmpty ? current.first.name : 'Non défini';
    final currentCity = current.isNotEmpty
        ? '${current.first.institution} · ${current.first.city}'
        : 'Campus rattaché à ton compte';

    return LightPageScaffold(
      title: 'Campus',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          LightCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Campus actuel',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.muted,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currentName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentCity,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: LightPageColors.muted,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Un changement de campus se fait sur dossier (carte scolaire).',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    height: 1.4,
                    color: LightPageColors.text2,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 14),
          LightButton(
            text: 'Contacter le support',
            icon: Icons.support_agent_rounded,
            onPressed: () => context.push('/help-support'),
          ),
          const SizedBox(height: 20),
          Text(
            'Campus disponibles',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 12),
          if (campuses.isEmpty)
            Text(
              'Aucun campus publié pour le moment.',
              style: GoogleFonts.plusJakartaSans(
                color: LightPageColors.muted,
              ),
            )
          else
            ...campuses.map((campus) {
              final selected = campus.id == user?.campusId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LightCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.school_outlined,
                        color: selected
                            ? LightPageColors.orange
                            : LightPageColors.muted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              campus.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.text,
                              ),
                            ),
                            Text(
                              '${campus.institution} · ${campus.city}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: LightPageColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
