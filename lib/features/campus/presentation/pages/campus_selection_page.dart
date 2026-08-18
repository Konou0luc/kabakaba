import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/auth_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CampusSelectionPage extends StatefulWidget {
  const CampusSelectionPage({super.key});

  @override
  State<CampusSelectionPage> createState() => _CampusSelectionPageState();
}

class _CampusSelectionPageState extends State<CampusSelectionPage> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _selectedCampus;
  bool _showCampusPicker = false;

  final List<String> _campuses = [
    'Université Catholique de l\'Afrique de l\'Ouest (UCAO)',
    'Université de Lomé (UL)',
    'Université de Kara (UK)',
    'École Supérieure d\'Administration (ESA)',
    'Institut Universitaire de Technologie (IUT)',
    'Faculté des Sciences - UL',
  ];

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AuthScaffold(
          currentStep: 4,
          totalSteps: 5,
          heroIcon: Icons.school_outlined,
          heroTitle: 'Campus & sécurité',
          heroSubtitle:
              'Choisis ton université et crée un mot de passe sécurisé.',
          onBack: () => context.pop(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showCampusPicker = true;
                  });
                },
                child: KabaSelect(
                  label: 'Université / Campus',
                  value: _selectedCampus ?? '',
                  placeholder: 'Sélectionner — UCAO, UL…',
                  isSelected: _selectedCampus != null,
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: 15),
              KabaInput(
                label: 'Mot de passe',
                hintText: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 16),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 16,
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
              const Spacer(),
              KabaButton(
                text: 'Continuer',
                onPressed: () {
                  if (_selectedCampus == null) {
                    ToastHelper.showError('Veuillez sélectionner un campus');
                    return;
                  }
                  if (_passwordController.text.length < 6) {
                    ToastHelper.showError(
                      'Le mot de passe doit contenir au moins 6 caractères',
                    );
                    return;
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go('/auth/referral');
                  });
                },
                trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 16),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 8),
            ],
          ),
        ),
        if (_showCampusPicker) _buildCampusPicker(),
      ],
    );
  }

  Widget _buildCampusPicker() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showCampusPicker = false;
        });
      },
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Choisir ton campus',
                      style: AppTextStyles.sectionTitle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._campuses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final campus = entry.value;
                    final isSelected = _selectedCampus == campus;
                    return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCampus = campus;
                              _showCampusPicker = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.accent.withValues(alpha: 0.5)
                                    : AppColors.line,
                              ),
                              color: isSelected
                                  ? AppColors.accent.withValues(alpha: 0.1)
                                  : AppColors.field,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.school_outlined,
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.muted,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    campus,
                                    style: AppTextStyles.inputText.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.accent,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: (100 + index * 50).ms)
                        .slideX(begin: 0.05, end: 0);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
