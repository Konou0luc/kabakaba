import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';

class PackagingPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const PackagingPage({super.key, required this.data});

  @override
  State<PackagingPage> createState() => _PackagingPageState();
}

class _PackagingPageState extends State<PackagingPage> {
  String? _selectedPackaging;

  final List<Map<String, dynamic>> packagingOptions = [
    {
      'id': 'surplace',
      'name': 'Sur place',
      'icon': Icons.restaurant,
      'price': 0,
    },
    {'id': 'sachet', 'name': 'Sachet', 'icon': Icons.shopping_bag, 'price': 0},
    {
      'id': 'takeaway',
      'name': 'Take away',
      'icon': Icons.takeout_dining,
      'price': 100,
    },
  ];

  int get totalPrice =>
      (widget.data['totalPrice'] as int) +
      (_selectedPackaging == 'takeaway' ? 100 : 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KabaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary(context),
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Conditionnement',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choisissez votre conditionnement',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.l),
                      ...packagingOptions.map((option) {
                        final index = packagingOptions.indexOf(option);
                        final isSelected = _selectedPackaging == option['id'];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == packagingOptions.length - 1
                                ? 0
                                : AppSpacing.m,
                          ),
                          child:
                              KabaCard(
                                    onTap: () {
                                      setState(() {
                                        _selectedPackaging =
                                            option['id'] as String;
                                      });
                                    },
                                    padding: const EdgeInsets.all(AppSpacing.s),
                                    borderColor: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? AppColors.primary.withValues(
                                                    alpha: 0.1,
                                                  )
                                                : AppColors.primary.withValues(
                                                    alpha: 0.1,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: Icon(
                                            option['icon'] as IconData,
                                            color: isDark
                                                ? AppColors.white
                                                : AppColors.primary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.m),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                option['name'] as String,
                                                style: AppTextStyles.bodyLarge
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if ((option['price'] as int) > 0)
                                          Text(
                                            '+${option['price']} tickets',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  color: AppColors.accent,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          )
                                        else
                                          Text(
                                            'Inclus',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  color: AppColors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        const SizedBox(width: AppSpacing.m),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.grey,
                                              width: 2,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: isSelected
                                              ? Center(
                                                  child: Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color:
                                                              AppColors.primary,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    duration: 300.ms,
                                    delay: (index * 100).ms,
                                  )
                                  .slideY(begin: 0.1, end: 0),
                        );
                      }),
                      const SizedBox(height: AppSpacing.xl),
                      KabaCard(
                        padding: const EdgeInsets.all(AppSpacing.l),
                        color: isDark
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.primary.withValues(alpha: 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total final',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$totalPrice FCFA',
                              style: AppTextStyles.h2.copyWith(
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: KabaButton(
                  text: 'Continuer',
                  onPressed: _selectedPackaging != null
                      ? () {
                          context.push(
                            '/payment',
                            extra: {
                              ...widget.data,
                              'packaging': _selectedPackaging,
                              'totalPrice': totalPrice,
                            },
                          );
                        }
                      : null,
                ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
