import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_background.dart';

class CanteenDetailPage extends StatefulWidget {
  const CanteenDetailPage({super.key});

  @override
  State<CanteenDetailPage> createState() => _CanteenDetailPageState();
}

class _CanteenDetailPageState extends State<CanteenDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: KabaBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          AppIcons.arrowLeft,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chez Mama Ata',
                      style: AppTextStyles.h1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'UCAO  07h30 - 16h00',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Spécialités togolaises maison - riz, fufu, sauces variées.\nCuisine faite avec amour depuis 2018.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.greyDark,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ouvert',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.grey.withValues(alpha: 0.2)
                        : const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: isDark ? AppColors.primary : AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorPadding: const EdgeInsets.all(4),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.grey,
                    tabs: const [
                      Tab(text: 'Composer mon plat'),
                      Tab(text: 'Menus préfais'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [_CustomizeMealTab(), _FixedMenusTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomizeMealTab extends StatefulWidget {
  const _CustomizeMealTab();

  @override
  State<_CustomizeMealTab> createState() => _CustomizeMealTabState();
}

class _CustomizeMealTabState extends State<_CustomizeMealTab> {
  int _baseQuantity = 1;
  int _eggQuantity = 0;
  int _sausageQuantity = 0;

  int get _totalPrice =>
      (_baseQuantity * 200) + (_eggQuantity * 100) + (_sausageQuantity * 100);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Base du plat',
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          KabaCard(
            padding: const EdgeInsets.all(16),
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.05)
                : const Color(0xFFF9FAFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/plat/plat1.webp',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Riz',
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: AppColors.success,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Sauce tomate incluse',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Quantité',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.grey.withValues(alpha: 0.2)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _baseQuantity > 1
                                ? () => setState(() => _baseQuantity--)
                                : null,
                            icon: Icon(
                              Icons.remove,
                              size: 20,
                              color: _baseQuantity > 1
                                  ? AppColors.primary
                                  : AppColors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '$_baseQuantity',
                              style: AppTextStyles.h3.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _baseQuantity++),
                            icon: const Icon(
                              Icons.add,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${_baseQuantity * 200} tickets',
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.white : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Minimum de commande: 200 tickets',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ajouter des accompagnements',
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          _AccompanimentCard(
            name: 'Œuf',
            price: 100,
            quantity: _eggQuantity,
            onIncrease: () => setState(() => _eggQuantity++),
            onDecrease: _eggQuantity > 0
                ? () => setState(() => _eggQuantity--)
                : null,
            icon: Icons.breakfast_dining,
          ),
          const SizedBox(height: 12),
          _AccompanimentCard(
            name: 'Saucisse',
            price: 100,
            quantity: _sausageQuantity,
            onIncrease: () => setState(() => _sausageQuantity++),
            onDecrease: _sausageQuantity > 0
                ? () => setState(() => _sausageQuantity--)
                : null,
            icon: Icons.fastfood,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : const Color(0xFFF9FAFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_totalPrice tickets',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ToastHelper.showSuccess('Plat ajouté au panier !');
                    context.go('/cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ajouter ',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.add, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AccompanimentCard extends StatelessWidget {
  final String name;
  final int price;
  final int quantity;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final IconData icon;

  const _AccompanimentCard({
    required this.name,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return KabaCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.white : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$price tickets/unité',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.grey.withValues(alpha: 0.2)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onDecrease,
                  icon: Icon(
                    Icons.remove,
                    size: 18,
                    color: quantity > 0 ? AppColors.primary : AppColors.grey,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$quantity',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onIncrease,
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FixedMenusTab extends StatelessWidget {
  const _FixedMenusTab();

  @override
  Widget build(BuildContext context) {
    final menus = [
      {
        'name': 'Pain + 2 oeufs',
        'description':
            'Pain frais du jour, 2 oeufs au choix (omelette ou au plat)',
        'price': 450,
        'image': 'assets/images/plat/plat1.webp',
      },
      {
        'name': 'Plat de spaghetti',
        'description': 'Spaghetti sauce maison, portion généreuse',
        'price': 500,
        'image': 'assets/images/plat/plat2.webp',
      },
      {
        'name': 'Fufu sauce arachide',
        'description': 'Fufu frais avec sauce arachide aux viandes',
        'price': 400,
        'image': 'assets/images/plat/plat3.webp',
      },
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          ...menus.map((menu) {
            final index = menus.indexOf(menu);
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == menus.length - 1 ? 24 : 12,
              ),
              child: _FixedMenuCard(
                name: menu['name'] as String,
                description: menu['description'] as String,
                price: menu['price'] as int,
                image: menu['image'] as String,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FixedMenuCard extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final String image;

  const _FixedMenuCard({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return KabaCard(
      onTap: () {},
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$price tickets',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark ? AppColors.white : AppColors.primary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        size: 36,
                        color: AppColors.accent,
                      ),
                      onPressed: () {
                        ToastHelper.showSuccess('$name ajouté au panier !');
                        context.go('/cart');
                      },
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
}
