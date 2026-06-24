import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon panier'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _CartItem(index: index)
                        .animate()
                        .fadeIn(delay: (index * 100).ms)
                        .slideX(begin: 0.1, end: 0);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.9),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          '4 500 FCFA',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    KabaButton(
                      text: 'Valider la commande',
                      onPressed: () {
                        context.push('/payment');
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final int index;
  const _CartItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final images = [
      'assets/images/plat/plat1.webp',
      'assets/images/plat/plat2.webp',
      'assets/images/plat/plat3.webp',
    ];
    return KabaCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              images[index % images.length],
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plat attiéké',
                  style: AppTextStyles.h3.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Cantine Centrale',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1 200 FCFA',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.white
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          _buildQtyBtn(context, Icons.remove, () {}),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '2',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildQtyBtn(context, Icons.add, () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16, color: AppColors.textPrimary(context)),
      ),
    );
  }
}
