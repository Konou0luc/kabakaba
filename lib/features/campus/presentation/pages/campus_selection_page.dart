import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/auth_scaffold.dart';
import '../../../../shared/widgets/kaba_bottom_sheet_modal.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../auth/data/signup_draft.dart';

class CampusSelectionPage extends ConsumerStatefulWidget {
  const CampusSelectionPage({super.key});

  @override
  ConsumerState<CampusSelectionPage> createState() =>
      _CampusSelectionPageState();
}

class _CampusSelectionPageState extends ConsumerState<CampusSelectionPage> {
  String? _selectedCampusId;

  Future<void> _openPicker(List<CampusModel> campuses) async {
    final chosen = await KabaBottomSheetModal.show<CampusModel>(
      context: context,
      title: 'Choisir ton campus',
      forceDark: true,
      child: Builder(
        builder: (sheetContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final campus in campuses)
                _CampusTile(
                  campus: campus,
                  selected: _selectedCampusId == campus.id,
                  onTap: () => Navigator.of(sheetContext).pop(campus),
                ),
            ],
          );
        },
      ),
    );
    if (chosen != null && mounted) {
      setState(() => _selectedCampusId = chosen.id);
    }
  }

  void _continue(CampusModel? selected) {
    if (selected == null) {
      ToastHelper.showError('Veuillez sélectionner un campus');
      return;
    }
    ref
        .read(signupDraftProvider.notifier)
        .setCampus(id: selected.id, name: selected.name);
    context.go('/auth/referral');
  }

  @override
  Widget build(BuildContext context) {
    final campusesAsync = ref.watch(campusesListProvider);
    final campuses = campusesAsync.valueOrNull ?? const <CampusModel>[];
    final selected = campuses
        .where((campus) => campus.id == _selectedCampusId)
        .firstOrNull;

    return AuthScaffold(
      currentStep: 4,
      totalSteps: 5,
      heroIcon: Icons.school_outlined,
      heroTitle: 'Ton campus',
      heroSubtitle:
          'Choisis ton université — on t’affiche ensuite les cantines de ton campus.',
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: campuses.isEmpty ? null : () => _openPicker(campuses),
            child: KabaSelect(
              label: 'Université / Campus',
              value: selected?.name ?? '',
              placeholder: campusesAsync.isLoading
                  ? 'Chargement des campus…'
                  : campusesAsync.hasError
                  ? 'Impossible de charger — réessaie'
                  : 'Sélectionner — UCAO, UL…',
              isSelected: selected != null,
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
          if (campusesAsync.hasError) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.invalidate(campusesListProvider),
              child: const Text('Réessayer'),
            ),
          ],
        ],
      ),
      footer: KabaButton(
        text: 'Continuer',
        onPressed: () => _continue(selected),
        trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 16),
      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
    );
  }
}

class _CampusTile extends StatelessWidget {
  final CampusModel campus;
  final bool selected;
  final VoidCallback onTap;

  const _CampusTile({
    required this.campus,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      campus.institution,
      campus.city,
    ].where((part) => part.isNotEmpty).join(' · ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.line,
          ),
          color: selected
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.field,
        ),
        child: Row(
          children: [
            Icon(
              Icons.school_outlined,
              color: selected ? AppColors.accent : AppColors.muted,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campus.name,
                    style: AppTextStyles.inputText.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: AppTextStyles.footLink.copyWith(fontSize: 11),
                    ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.accent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
