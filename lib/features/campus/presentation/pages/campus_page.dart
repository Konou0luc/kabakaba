import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/kaba_card.dart';

class CampusPage extends StatefulWidget {
  const CampusPage({super.key});

  @override
  State<CampusPage> createState() => _CampusPageState();
}

class _CampusPageState extends State<CampusPage> {
  String _selectedCampus = 'UCAO';

  final List<Map<String, String>> _campuses = [
    {
      'name': 'UCAO',
      'location': 'Sanguéra, Togo',
    },
    {
      'name': 'Université de Lomé (UL)',
      'location': 'Lomé, Togo',
    },
    {
      'name': 'Université de Kara (UK)',
      'location': 'Kara, Togo',
    },
    {
      'name': 'ESA',
      'location': 'Lomé, Togo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              // Current campus card
              KabaCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campus actuel',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
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
                            Icons.school_rounded,
                            color: isDark ? AppColors.white : AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedCampus,
                                style: AppTextStyles.h3,
                              ),
                              Text(
                                'Changer de campus → sur dossier (carte scolaire)',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.2),
              const SizedBox(height: 24),
              Text(
                'Sélectionner un campus',
                style: AppTextStyles.h3,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 16),
              ..._campuses.asMap().entries.map((entry) {
                final index = entry.key;
                final campus = entry.value;
                final isSelected = campus['name'] == _selectedCampus;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: KabaCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () {
                      setState(() {
                        _selectedCampus = campus['name']!;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.grey,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                campus['name']!,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              Text(
                                campus['location']!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (400 + index * 100).ms).slideX(begin: 0.1),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
