import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/kaba_bottom_sheet_modal.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Mock data
  List<Map<String, dynamic>> cartItems = [
    {
      'id': 1,
      'name': 'Plat attiéké',
      'canteen': 'Cantine Centrale',
      'price': 1200,
      'quantity': 2,
      'image': 'assets/images/plat/plat1.webp',
    },
    {
      'id': 2,
      'name': 'Plat yassa',
      'canteen': 'Cantine Centrale',
      'price': 1500,
      'quantity': 1,
      'image': 'assets/images/plat/plat2.webp',
    },
    {
      'id': 3,
      'name': 'Plat poulet',
      'canteen': 'Cantine Centrale',
      'price': 1800,
      'quantity': 1,
      'image': 'assets/images/plat/plat3.webp',
    },
  ];

  // Mock user balance
  final int userBalance = 25000;

  int get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = (cartItems[index]['quantity'] as int) + delta;
      if (newQty <= 0) {
        _showDeleteConfirmation(index);
      } else {
        cartItems[index]['quantity'] = newQty;
      }
    });
  }

  void _showDeleteConfirmation(int index) {
    KabaBottomSheetModal.show(
      context: context,
      height: 300,
      title: 'Supprimer le plat',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.m),
          Text(
            'Êtes-vous sûr de vouloir supprimer "${cartItems[index]['name']}" du panier ?',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: KabaButton(
                  text: 'Annuler',
                  onPressed: () => context.pop(),
                  type: KabaButtonType.ghost,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: KabaButton(
                  text: 'Supprimer',
                  onPressed: () {
                    context.pop();
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteItem(int index) {
    _showDeleteConfirmation(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasEnoughTickets = userBalance >= totalPrice;

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
              if (cartItems.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Votre panier est vide',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _CartItem(
                            index: index,
                            item: item,
                            onDelete: () => _deleteItem(index),
                            onQtyChanged: (delta) =>
                                _updateQuantity(index, delta),
                          )
                          .animate()
                          .fadeIn(delay: (index * 100).ms)
                          .slideX(begin: 0.1, end: 0);
                    },
                  ),
                ),
              if (cartItems.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.l),
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
                            '$totalPrice FCFA',
                            style: AppTextStyles.h2.copyWith(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.l),
                      KabaButton(
                        text: hasEnoughTickets ? 'Continuer' : 'Recharger',
                        onPressed: () {
                          if (hasEnoughTickets) {
                            context.push(
                              '/packaging',
                              extra: {
                                'totalPrice': totalPrice,
                                'items': cartItems,
                              },
                            );
                          } else {
                            context.push('/recharge/step1');
                          }
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
  final Map<String, dynamic> item;
  final VoidCallback onDelete;
  final Function(int) onQtyChanged;

  const _CartItem({
    required this.index,
    required this.item,
    required this.onDelete,
    required this.onQtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KabaCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              item['image'] as String,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'] as String,
                        style: AppTextStyles.h3.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: AppColors.error,
                      onPressed: onDelete,
                    ),
                  ],
                ),
                Text(
                  item['canteen'] as String,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['price']} FCFA',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isDark ? AppColors.white : AppColors.primary,
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
                          _buildQtyBtn(
                            context,
                            Icons.remove,
                            () => onQtyChanged(-1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${item['quantity']}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildQtyBtn(
                            context,
                            Icons.add,
                            () => onQtyChanged(1),
                          ),
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
