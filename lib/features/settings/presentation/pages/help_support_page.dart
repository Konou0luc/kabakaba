import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

Future<void> showReportIssueSheet(
  BuildContext context, {
  String? orderId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: _ReportIssueForm(initialOrderId: orderId),
      ),
    ),
  );
}

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _faqData = [
    {
      'category': 'COMMANDES',
      'questions': [
        {
          'title': 'Que se passe-t-il si le vendeur ne répond pas ?',
          'content':
              '''Dès que tu confirmes, la cantine reçoit la commande. Tu peux l’annuler tant qu’elle n’est pas encore en préparation : tes tickets sont alors remboursés.''',
        },
        {
          'title': 'Comment annuler une commande ?',
          'content':
              '''Tu peux annuler une commande Confirmée, avec un motif. Dès qu’elle passe « En préparation », l’annulation n’est plus possible côté étudiant. Un problème sur un plat déjà prêt se signale depuis l’historique.''',
        },
        {
          'title': 'Combien de temps ai-je pour confirmer la réception ?',
          'content':
              '''1 heure à partir du moment où ta commande passe au statut « Prête ». Passé ce délai, elle est confirmée automatiquement, sans aucune pénalité pour toi.''',
        },
        {
          'title': 'Comment fonctionne une commande programmée ?',
          'content':
              '''Tes tickets sont réservés dès la programmation. Le vendeur ne voit ta commande que quand tu l'as choisie — c'est à ce moment-là que son délai de 5 minutes pour répondre démarre.''',
        },
      ],
    },
    {
      'category': 'TICKETS & RECHARGE',
      'questions': [
        {
          'title': 'Quel est le montant minimum de recharge ?',
          'content':
              '''Tu choisis les tickets à recevoir. Les frais s’ajoutent au paiement, via Flooz ou Mixx by Yas.''',
        },
        {
          'title':
              'Pourquoi le montant payé est différent du nombre de tickets reçus ?',
          'content':
              '''Avant de valider, tu vois les tickets, les frais et le total à payer.''',
        },
        {
          'title': 'Mes tickets expirent-ils ?',
          'content':
              '''Non, tes tickets restent valables sur ton compte sans limite de durée. Ils ne sont en revanche pas convertibles en argent.''',
        },
      ],
    },
    {
      'category': 'PARRAINAGE',
      'questions': [
        {
          'title': 'Comment parrainer un ami ?',
          'content':
              '''Depuis ton profil ou Réglages, ouvre Parrainage kabakaba et partage ton code. Ton filleul le saisit à l’inscription (optionnel).''',
        },
        {
          'title': 'Quand reçois-je mes tickets de parrainage ?',
          'content':
              '''Tu gagnes 100 tickets automatiquement à la première recharge réussie de ton filleul. Les tickets sont crédités sur ton portefeuille.''',
        },
      ],
    },
    {
      'category': 'COMPTE',
      'questions': [
        {
          'title': 'Pourquoi mon compte est-il suspendu ?',
          'content':
              '''Le plus souvent après plusieurs annulations répétées en peu de temps (règle anti-abus). Le motif et la durée exacte ont été communiqués par notification au moment de la suspension.''',
        },
        {
          'title': 'Comment changer de campus ?',
          'content':
              '''Le changement de campus n'est pas automatique : c'est une démarche sur dossier. Tu dois fournir une photo de ta carte scolaire de l'année en cours, attestant que tu es inscrit dans la nouvelle université. Un administrateur vérifie et valide manuellement ta demande.''',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filterFaq() {
    if (_searchQuery.isEmpty) {
      return _faqData;
    }
    return _faqData
        .map((category) {
          final filteredQuestions = category['questions']
              .where(
                (q) =>
                    q['title'].toLowerCase().contains(_searchQuery) ||
                    q['content'].toLowerCase().contains(_searchQuery),
              )
              .toList();
          return {
            'category': category['category'],
            'questions': filteredQuestions,
          };
        })
        .where((category) => category['questions'].isNotEmpty)
        .toList();
  }

  void _openReportIssueSheet() {
    showReportIssueSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final filteredFaq = _filterFaq();

    return LightPageScaffold(
      title: 'Centre d\'aide',
      body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: KabaSearchField(
                  controller: _searchController,
                  hintText: 'Rechercher une question…',
                ).animate().fadeIn(delay: 100.ms),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.accent,
                labelColor: AppColors.accent,
                unselectedLabelColor: LightPageColors.muted,
                labelStyle: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Questions fréquentes'),
                  Tab(text: 'Litiges & remboursements'),
                ],
              ).animate().fadeIn(delay: 200.ms),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    if (_searchQuery.isEmpty)
                      ListView(
                        padding: const EdgeInsets.all(AppSpacing.l),
                        children: [
                          const SizedBox(height: AppSpacing.l),
                          const _SectionTitle(title: 'NOUS CONTACTER'),
                          const SizedBox(height: 12),
                          KabaCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                _HelpItemInCard(
                                  icon: Icons.email_rounded,
                                  title: 'Envoyer un email',
                                  subtitle: 'support@kabakaba.com',
                                ),
                                const _Divider(),
                                _HelpItemInCard(
                                  icon: Icons.phone_rounded,
                                  title: 'Appeler',
                                  subtitle: '+228 00 00 00 00',
                                ),
                                const _Divider(),
                                _HelpItemInCard(
                                  icon: Icons.chat_bubble_rounded,
                                  title: 'Chat en direct',
                                  subtitle: 'Disponible 24h/24',
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                          const SizedBox(height: 24),
                          KabaCard(
                            padding: const EdgeInsets.all(14),
                            color: AppColors.surfaceSecondary(context),
                            onTap: () => context.push('/referral'),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? AppColors.white
                                        : AppColors.surfaceDark,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.card_giftcard_rounded,
                                    color: AppColors.accent,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Parrainage kabakaba',
                                        style: AppTextStyles.h3,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Invite un ami : 100 tickets à sa 1ʳᵉ recharge',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? AppColors.greyDark
                                              : AppColors.textSecondaryDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.textPrimary(context),
                                  size: 18,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),
                          const SizedBox(height: 24),
                          ..._faqData.asMap().entries.map((entry) {
                            final index = entry.key;
                            final category = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionTitle(title: category['category']),
                                const SizedBox(height: 12),
                                ...category['questions'].asMap().entries.map((
                                  questionEntry,
                                ) {
                                  final qIndex = questionEntry.key;
                                  final question = questionEntry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child:
                                        _ExpansionCard(
                                              title: question['title'],
                                              content: question['content'],
                                            )
                                            .animate()
                                            .fadeIn(
                                              delay:
                                                  (400 +
                                                          (index * 3 * 100) +
                                                          (qIndex * 100))
                                                      .ms,
                                            )
                                            .slideY(begin: 0.1),
                                  );
                                }).toList(),
                                const SizedBox(height: 12),
                              ],
                            );
                          }).toList(),
                        ],
                      )
                    else
                      ListView(
                        padding: const EdgeInsets.all(AppSpacing.l),
                        children: [
                          const SizedBox(height: AppSpacing.l),
                          if (filteredFaq.isEmpty)
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 64,
                                    color: AppColors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Aucun résultat trouvé',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...filteredFaq.asMap().entries.map((entry) {
                              final index = entry.key;
                              final category = entry.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SectionTitle(title: category['category']),
                                  const SizedBox(height: 12),
                                  ...category['questions'].asMap().entries.map((
                                    questionEntry,
                                  ) {
                                    final qIndex = questionEntry.key;
                                    final question = questionEntry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child:
                                          _ExpansionCard(
                                                title: question['title'],
                                                content: question['content'],
                                              )
                                              .animate()
                                              .fadeIn(
                                                delay:
                                                    (400 +
                                                            (index * 3 * 100) +
                                                            (qIndex * 100))
                                                        .ms,
                                              )
                                              .slideY(begin: 0.1),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 12),
                                ],
                              );
                            }).toList(),
                        ],
                      ),
                    ListView(
                      padding: const EdgeInsets.all(AppSpacing.l),
                      children: [
                        const SizedBox(height: AppSpacing.l),
                        KabaCard(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.grey.withValues(alpha: 0.2)
                                      : AppColors.greyLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '''Un plat non conforme, manquant, ou une erreur sur ta commande ? Signale-le ici — un administrateur examine ta demande et peut déclencher un remboursement.''',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _openReportIssueSheet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text(
                              'Signaler un problème sur une commande',
                            ),
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                        const SizedBox(height: 24),
                        const _SectionTitle(title: 'MES RÉCLAMATIONS'),
                        const SizedBox(height: 12),
                        const _MyReportsList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

class _MyReportsList extends ConsumerWidget {
  const _MyReportsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(reportRepositoryProvider).findMyReports(limit: 20),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Text(
            apiErrorMessage(snapshot.error!),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
          );
        }
        final reports = snapshot.data?.data ?? const <ReportModel>[];
        if (reports.isEmpty) {
          return Text(
            'Aucun signalement pour l’instant.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
          );
        }
        final orders = ref.watch(myOrdersProvider).valueOrNull ?? const [];
        return Column(
          children: [
            for (final report in reports)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KabaCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              () {
                                for (final order in orders) {
                                  if (order.id == report.orderId) {
                                    return order.displayCode;
                                  }
                                }
                                return 'Commande';
                              }(),
                              style: AppTextStyles.bodyLarge,
                            ),
                            Text(
                              report.comment?.isNotEmpty == true
                                  ? report.comment!
                                  : report.type.name,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        switch (report.status) {
                          ReportStatus.OPEN => 'Ouvert',
                          ReportStatus.IN_PROGRESS => 'En cours',
                          ReportStatus.RESOLVED => 'Traité',
                        },
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ReportIssueForm extends ConsumerStatefulWidget {
  final String? initialOrderId;
  const _ReportIssueForm({this.initialOrderId});

  @override
  ConsumerState<_ReportIssueForm> createState() => _ReportIssueFormState();
}

class _ReportIssueFormState extends ConsumerState<_ReportIssueForm> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedIssue;
  String? _selectedOrder;

  @override
  void initState() {
    super.initState();
    _selectedOrder = widget.initialOrderId;
  }

  /// Valeurs API ReportType.
  static const List<(String label, String type)> _issueTypes = [
    ('Plat non conforme', 'WRONG_MEAL'),
    ('Composant manquant', 'MISSING_COMPONENT'),
    ('Commande incomplète', 'INCOMPLETE_ORDER'),
    ('Autre', 'OTHER'),
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Sélectionnez la commande concernée',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.greyLight,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedOrder,
              hint: Text(
                'Choisissez une commande',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.3)
                      : AppColors.textSecondaryLight,
                ),
              ),
              isExpanded: true,
              items: (ref.watch(myOrdersProvider).valueOrNull ?? const [])
                  .map((order) {
                    final label =
                        '${order.displayCode} · ${order.vendorName}';
                    return DropdownMenuItem(
                      value: order.id,
                      child: Text(label, style: AppTextStyles.bodyMedium),
                    );
                  })
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOrder = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Type de problème',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.greyLight,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedIssue,
              hint: Text(
                'Choisissez le type de problème',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.3)
                      : AppColors.textSecondaryLight,
                ),
              ),
              isExpanded: true,
              items: _issueTypes.map((issue) {
                return DropdownMenuItem(
                  value: issue.$2,
                  child: Text(issue.$1, style: AppTextStyles.bodyMedium),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIssue = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        KabaInput(
          label: 'Description du problème',
          hintText: 'Décrivez le problème en quelques mots...',
          controller: _descriptionController,
          maxLength: 500,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedOrder != null && _selectedIssue != null
                ? () async {
                    try {
                      await ref.read(reportRepositoryProvider).createReport(
                            orderId: _selectedOrder!,
                            type: _selectedIssue!,
                            comment: _descriptionController.text.trim(),
                          );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      showKabaSnack(context, 'Signalement envoyé');
                    } catch (error) {
                      if (context.mounted) {
                        showKabaSnack(
                          context,
                          apiErrorMessage(error),
                          error: true,
                        );
                      }
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Soumettre'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.grey,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 1,
      color: isDark
          ? AppColors.grey.withValues(alpha: 0.2)
          : AppColors.greyLight,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _HelpItemInCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HelpItemInCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.2 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDark ? AppColors.white : AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyLarge),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpansionCard extends StatelessWidget {
  final String title;
  final String content;

  const _ExpansionCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return KabaCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(title, style: AppTextStyles.bodyLarge),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.grey,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
