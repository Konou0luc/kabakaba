import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return KabaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    border: Border.all(color: AppColors.greyLight),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_quantity > 1) _quantity--;
                          });
                        },
                        icon: const Icon(
                          AppIcons.remove,
                          color: AppColors.primary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          _quantity.toString(),
                          style: AppTextStyles.h3,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => _quantity++);
                        },
                        icon: const Icon(
                          AppIcons.add,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: KabaButton(
                    text: 'Ajouter au panier - ${1200 * _quantity} FCFA',
                    onPressed: () {
                      ToastHelper.showSuccess(
                        '$_quantity produit(s) ajouté(s) au panier !',
                      );
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.background(context),
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      AppIcons.arrowLeft,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/plat/plat1.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plat Attiéké',
                      style: AppTextStyles.h1,
                    ).animate().fadeIn().slideX(),
                    const SizedBox(height: 8),
                    Text(
                      '1 200 FCFA',
                      style: AppTextStyles.h2.copyWith(
                        color: isDark ? AppColors.white : AppColors.primary,
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: AppTextStyles.h3,
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 12),
                    Text(
                      'Attiéké frais avec poisson braisé, sauce pimentée et accompagnements variés.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.greyDark,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 32),
                    Text(
                      'Personnalisation',
                      style: AppTextStyles.h3,
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 16),
                    _CustomizationSection(
                          title: 'Choix du poisson',
                          options: const ['Poisson frais', 'Poulet', 'Viande'],
                        )
                        .animate()
                        .fadeIn(delay: 500.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 24),
                    _CustomizationSection(
                          title: 'Accompagnements',
                          options: const ['Salade', 'Alloco', 'Plantain'],
                        )
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomizationSection extends StatefulWidget {
  final String title;
  final List<String> options;

  const _CustomizationSection({required this.title, required this.options});

  @override
  State<_CustomizationSection> createState() => _CustomizationSectionState();
}

class _CustomizationSectionState extends State<_CustomizationSection> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = index);
              },
              child: KabaCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                color: isSelected ? AppColors.primary : null,
                child: Text(
                  option,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.textPrimary(context),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
