import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class AmbassadorDashboardPage extends ConsumerWidget {
  const AmbassadorDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myAmbassadorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Programme Ambassadeur'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(apiErrorMessage(error)),
              ),
            ),
            data: (ambassador) {
              if (ambassador == null) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tu n’as pas encore de profil ambassadeur.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      KabaButton(
                        text: 'Devenir ambassadeur',
                        onPressed: () =>
                            context.push('/ambassador-presentation'),
                      ),
                    ],
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.l),
                children: [
                  KabaCard(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    color: AppColors.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ambassador.isPending
                              ? 'Candidature en cours'
                              : 'Gains totaux',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ambassador.isPending
                              ? 'En attente de validation'
                              : '${formatTickets(ambassador.totalCommissionEarned)} tickets',
                          style: AppTextStyles.h1.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Code ${ambassador.promoCode.isEmpty ? '—' : ambassador.promoCode} · ${ambassador.status}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: AppSpacing.l),
                  Row(
                    children: [
                      Expanded(
                        child: KabaCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Filleuls', style: AppTextStyles.bodySmall),
                              const SizedBox(height: 8),
                              Text(
                                '${ambassador.totalReferrals}',
                                style: AppTextStyles.h2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: KabaCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'En attente',
                                style: AppTextStyles.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatTickets(ambassador.pendingCommission),
                                style: AppTextStyles.h2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.l),
                  KabaButton(
                    text: 'Retour à l’accueil',
                    onPressed: () => context.go('/home'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
