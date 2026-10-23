import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../features/cart/data/cart_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/kaba_premium.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import '../../../../shared/widgets/remote_photo.dart';
import 'package:google_fonts/google_fonts.dart';

class CanteenDetailPage extends ConsumerStatefulWidget {
  final String? vendorId;

  const CanteenDetailPage({super.key, this.vendorId});

  @override
  ConsumerState<CanteenDetailPage> createState() => _CanteenDetailPageState();
}

class _CanteenDetailPageState extends ConsumerState<CanteenDetailPage> {
  int _tab = 0;
  final Map<String, int> _componentQty = {};

  List<MenuModel> get _menus {
    final id = widget.vendorId;
    if (id == null) return const [];
    return ref.watch(vendorMenusProvider(id)).valueOrNull ?? const [];
  }

  List<ComponentModel> get _components {
    final id = widget.vendorId;
    if (id == null) return const [];
    return ref.watch(vendorComponentsProvider(id)).valueOrNull ?? const [];
  }

  List<ComponentCategoryModel> get _categories {
    final id = widget.vendorId;
    if (id == null) return const [];
    return ref.watch(vendorComponentCategoriesProvider(id)).valueOrNull ??
        const [];
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.vendorId;
    if (id == null || id.isEmpty) {
      return LightPageScaffold(
        title: 'Cantine',
        body: const KabaEmptyState(
          icon: Icons.storefront_rounded,
          title: 'Cantine introuvable',
          subtitle: 'Reviens à la liste pour en choisir une.',
        ),
      );
    }

    final vendorAsync = ref.watch(vendorDetailProvider(id));
    final cartCount = ref.watch(cartProvider).itemCount;

    return vendorAsync.when(
      loading: () => const LightPageScaffold(
        title: 'Cantine',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => LightPageScaffold(
        title: 'Cantine',
        body: KabaEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Impossible de charger',
          subtitle: apiErrorMessage(error),
        ),
      ),
      data: (vendor) => Scaffold(
        backgroundColor: LightPageColors.white,
        bottomNavigationBar: cartCount > 0 || _tab != 2
            ? _buildStickyBottomBar()
            : null,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildCover(vendor)
                  .animate()
                  .fadeIn(duration: 280.ms),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: LightPageColors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCanteenInfo(vendor),
                      const SizedBox(height: 18),
                      LightTabs(
                        tabs: const ['Menus', 'Composer', 'Avis'],
                        selectedIndex: _tab,
                        onTap: (i) => setState(() => _tab = i),
                      ),
                      const SizedBox(height: 18),
                      if (_tab == 0)
                        _buildMenusTab()
                      else if (_tab == 1)
                        _buildComposeTab(vendor)
                      else
                        _buildReviewsTab(vendor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(VendorModel vendor) {
    final image = vendor.bannerUrl ?? vendor.logoUrl;
    final desc = vendor.description?.trim();
    final topInset = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: 260 + topInset * 0.35,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RemotePhoto(
            url: image,
            width: double.infinity,
            height: 280,
            fallback: ColoredBox(
              color: const Color(0xFF1B2A6B),
              child: Icon(
                Icons.restaurant_rounded,
                color: AppColors.accent.withValues(alpha: 0.85),
                size: 52,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x400D1438),
                  Color(0x140D1438),
                  Color(0x00FFFFFF),
                  Color(0xFFFFFFFF),
                ],
                stops: [0, 0.35, 0.62, 1],
              ),
            ),
          ),
          Positioned(
            top: topInset + 8,
            left: 14,
            child: Material(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Color(0xFF0D1438),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KabaStatusPill(
                  label: vendor.capacityLabel,
                  color: switch (vendor.capacityStatus) {
                    VendorCapacity.OPEN => AppColors.success,
                    VendorCapacity.BUSY => LightPageColors.warning,
                    VendorCapacity.CLOSED => const Color(0xE6000000),
                  },
                  inverted: true,
                ),
                const SizedBox(height: 10),
                Text(
                  vendor.canteenName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -0.5,
                    color: LightPageColors.text,
                  ),
                ),
                if (desc != null && desc.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: LightPageColors.text2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanteenInfo(VendorModel vendor) {
    final availableMenus = _menus.where((m) => m.available).length;
    final availableComponents = _components.where((c) => c.available).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KabaSectionKicker('Cantine du campus'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MetaChip(
              icon: switch (vendor.capacityStatus) {
                VendorCapacity.OPEN => Icons.schedule_rounded,
                VendorCapacity.BUSY => Icons.hourglass_top_rounded,
                VendorCapacity.CLOSED => Icons.lock_clock_rounded,
              },
              label: vendor.capacityLabel,
              color: switch (vendor.capacityStatus) {
                VendorCapacity.OPEN => AppColors.success,
                VendorCapacity.BUSY => LightPageColors.warning,
                VendorCapacity.CLOSED => LightPageColors.muted,
              },
            ),
            if (_menus.isNotEmpty)
              _MetaChip(
                icon: Icons.restaurant_menu_rounded,
                label: availableMenus == 1
                    ? '1 menu'
                    : '$availableMenus menus',
                color: LightPageColors.indigo,
              ),
            if (_components.isNotEmpty)
              _MetaChip(
                icon: Icons.tune_rounded,
                label: availableComponents == 1
                    ? '1 composant'
                    : '$availableComponents composants',
                color: LightPageColors.orange,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenusTab() {
    final menus = _menus;
    final loading = widget.vendorId != null &&
        ref.watch(vendorMenusProvider(widget.vendorId!)).isLoading;
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (menus.isEmpty) {
      return const KabaEmptyState(
        icon: Icons.restaurant_menu_rounded,
        title: 'Menu encore vide',
        subtitle: 'Aucun menu pré-composé n’a été publié pour le moment.',
      );
    }
    return Column(
      children: [
        ...List.generate(menus.length, (i) {
          final item = menus[i];
          return Padding(
            padding: EdgeInsets.only(bottom: i == menus.length - 1 ? 0 : 12),
            child: _MenuCard(
              item: item,
              onTap: () => context.push(
                '/menu-detail',
                extra: {
                  'itemId': item.id,
                  'vendorId': widget.vendorId,
                },
              ),
              onAdd: item.available
                  ? () => _addMenu(item)
                  : null,
            ),
          );
        }),
      ],
    );
  }

  void _addMenu(MenuModel menu) {
    final vendorId = widget.vendorId;
    final vendor = vendorId == null
        ? null
        : ref.read(vendorDetailProvider(vendorId)).valueOrNull;
    if (vendor == null) {
      showKabaSnack(context, 'Cantine introuvable', error: true);
      return;
    }
    if (!vendor.acceptsOrders) {
      showKabaSnack(
        context,
        vendor.capacityStatus == VendorCapacity.BUSY
            ? 'Cette cantine est momentanément indisponible'
            : 'Cette cantine est fermée',
        error: true,
      );
      return;
    }
    final line = CartLine(
      vendorId: vendor.id,
      vendorName: vendor.canteenName,
      menuId: menu.id,
      name: menu.name,
      priceTickets: menu.priceTickets,
      quantity: 1,
    );
    final added = ref.read(cartProvider.notifier).add(line);
    if (!added) {
      ref.read(cartProvider.notifier).replaceWith(line);
      showKabaSnack(context, 'Nouveau panier pour ${vendor.canteenName}');
    } else {
      showKabaSnack(context, '${menu.name} ajouté');
    }
  }

  void _changeComponentQty(ComponentModel component, int nextQty) {
    final vendor = widget.vendorId == null
        ? null
        : ref.read(vendorDetailProvider(widget.vendorId!)).valueOrNull;
    setState(() {
      if (nextQty <= 0) {
        _componentQty.remove(component.id);
      } else {
        _componentQty[component.id] = nextQty;
      }
    });
    if (vendor == null) return;
    final preview = [
      for (final c in _components)
        if ((_componentQty[c.id] ?? 0) > 0 && c.available)
          CartLine(
            vendorId: vendor.id,
            vendorName: vendor.canteenName,
            componentId: c.id,
            name: c.name,
            priceTickets: c.priceTickets,
            quantity: _componentQty[c.id]!,
            soldAlone: c.soldAlone,
          ),
    ];
    final violation = cartSoldAloneViolation(preview);
    if (violation != null) {
      showKabaSnack(context, violation, error: true);
    }
  }

  Widget _buildComposeTab(VendorModel vendor) {
    final components = _components;
    final categories = _categories;
    final loading = widget.vendorId != null &&
        (ref.watch(vendorComponentsProvider(widget.vendorId!)).isLoading ||
            ref
                .watch(vendorComponentCategoriesProvider(widget.vendorId!))
                .isLoading);

    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (components.isEmpty) {
      return const KabaEmptyState(
        icon: Icons.tune_rounded,
        title: 'Rien à composer',
        subtitle: 'Cette cantine n’a pas encore de composants à commander.',
      );
    }

    final byCategory = <String?, List<ComponentModel>>{};
    for (final c in components) {
      byCategory.putIfAbsent(c.categoryId, () => []).add(c);
    }

    String categoryName(String? id) {
      if (id == null) return 'Autres';
      for (final cat in categories) {
        if (cat.id == id) return cat.name;
      }
      return 'Autres';
    }

    final selectedTotal = components.fold<int>(0, (sum, c) {
      final qty = _componentQty[c.id] ?? 0;
      return sum + c.priceTickets * qty;
    });
    final selectedCount =
        _componentQty.values.fold<int>(0, (sum, q) => sum + q);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightHintBox(
          icon: Icons.tips_and_updates_rounded,
          text:
              'Compose ton repas. Un accompagnement (piment, sauce…) ne se commande pas tout seul.',
        ),
        const SizedBox(height: 18),
        for (final entry in byCategory.entries) ...[
          LightSectionTitle(
            title: categoryName(entry.key),
            subtitle: '${entry.value.length} option(s)',
          ),
          ...entry.value.map((component) {
            final qty = _componentQty[component.id] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Opacity(
                opacity: component.available ? 1 : 0.45,
                child: _buildQtyItem(
                  component.name,
                  component.priceTickets,
                  qty,
                  component.available
                      ? () => _changeComponentQty(component, qty + 1)
                      : () {},
                  qty > 0
                      ? () => _changeComponentQty(component, qty - 1)
                      : null,
                  unit: component.unit,
                  unavailable: !component.available,
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
        if (selectedCount > 0) ...[
          LightCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  '$selectedCount article(s)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: LightPageColors.muted,
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatTickets(selectedTotal)} tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: LightPageColors.orange,
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              final preview = [
                for (final c in components)
                  if ((_componentQty[c.id] ?? 0) > 0 && c.available)
                    CartLine(
                      vendorId: vendor.id,
                      vendorName: vendor.canteenName,
                      componentId: c.id,
                      name: c.name,
                      priceTickets: c.priceTickets,
                      quantity: _componentQty[c.id]!,
                      soldAlone: c.soldAlone,
                    ),
              ];
              final violation = cartSoldAloneViolation(preview);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (violation != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      violation,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: LightPageColors.orange,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  LightButton(
                    text: 'Ajouter au panier',
                    icon: Icons.add_rounded,
                    onPressed: violation == null
                        ? () => _addComposedComponents(vendor)
                        : null,
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }

  void _addComposedComponents(VendorModel vendor) {
    if (!vendor.acceptsOrders) {
      showKabaSnack(
        context,
        vendor.capacityStatus == VendorCapacity.BUSY
            ? 'Cette cantine est momentanément indisponible'
            : 'Cette cantine est fermée',
        error: true,
      );
      return;
    }
    final selected = [
      for (final c in _components)
        if ((_componentQty[c.id] ?? 0) > 0 && c.available)
          CartLine(
            vendorId: vendor.id,
            vendorName: vendor.canteenName,
            componentId: c.id,
            name: c.name,
            priceTickets: c.priceTickets,
            quantity: _componentQty[c.id]!,
            unit: c.unit,
            soldAlone: c.soldAlone,
          ),
    ];
    if (selected.isEmpty) {
      showKabaSnack(context, 'Choisis au moins un composant', error: true);
      return;
    }
    final violation = cartSoldAloneViolation(selected);
    if (violation != null) {
      showKabaSnack(context, violation, error: true);
      return;
    }
    var replaced = false;
    for (final line in selected) {
      final added = ref.read(cartProvider.notifier).add(line);
      if (!added) {
        ref.read(cartProvider.notifier).replaceWith(line);
        replaced = true;
        for (final rest in selected.skip(1)) {
          ref.read(cartProvider.notifier).add(rest);
        }
        break;
      }
    }
    setState(() => _componentQty.clear());
    showKabaSnack(
      context,
      replaced
          ? 'Nouveau panier pour ${vendor.canteenName}'
          : 'Composants ajoutés au panier',
    );
  }

  Widget _buildQtyItem(
    String name,
    int price,
    int qty,
    VoidCallback onInc,
    VoidCallback? onDec, {
    String? unit,
    bool unavailable = false,
  }) {
    return LightCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 14,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LightPageColors.orangeLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              size: 18,
              color: LightPageColors.orange,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  unavailable
                      ? 'Indisponible'
                      : 'Disponible · ${formatTickets(price)} tickets${unit != null ? ' · $unit' : ''}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!unavailable)
            _QtyStepper(qty: qty, onInc: onInc, onDec: onDec),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(VendorModel vendor) {
    final received = (ref.watch(myOrdersProvider).valueOrNull ?? const [])
        .where(
          (order) =>
              order.vendorId == vendor.id &&
              (order.status == OrderStatus.READY ||
                  order.status == OrderStatus.RECEIVED),
        )
        .toList();
    final toReview = received.where((order) => !order.hasReview).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LightCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: LightPageColors.indigoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 18,
                  color: LightPageColors.indigo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Les avis restent internes : ils aident kabakaba et le vendeur, ils ne sont pas affichés aux autres étudiants.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: LightPageColors.text2,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (toReview.isEmpty)
          const KabaEmptyState(
            icon: Icons.star_outline_rounded,
            title: 'Pas encore d’avis',
            subtitle:
                'Tu pourras noter cette cantine dès que ta commande sera prête.',
          )
        else
          _LeaveReviewCard(order: toReview.first, vendorId: vendor.id),
      ],
    );
  }

  Widget _buildStickyBottomBar() {
    final cart = ref.watch(cartProvider);
    final hasItems = cart.itemCount > 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        border: Border(
          top: BorderSide(color: LightPageColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: LightPageColors.indigo.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: LightPageColors.indigoLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.shopping_basket_rounded,
                    size: 22,
                    color: LightPageColors.indigo,
                  ),
                ),
                if (hasItems)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: LightPageColors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: LightPageColors.white,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${cart.itemCount}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: LightPageColors.muted,
                      letterSpacing: 0.03,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasItems
                        ? '${formatTickets(cart.totalTickets)} tickets'
                        : 'Choisis ton repas',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: LightPageColors.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: LightButton(
                text: hasItems ? 'Voir le panier' : 'Composer',
                icon: hasItems
                    ? Icons.shopping_basket_rounded
                    : Icons.restaurant_menu_rounded,
                onPressed: hasItems
                    ? () => context.push('/cart')
                    : () => setState(() => _tab = 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onInc;
  final VoidCallback? onDec;

  const _QtyStepper({
    required this.qty,
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    final has = qty > 0;
    return Container(
      decoration: BoxDecoration(
        color: has ? LightPageColors.orangeLight : LightPageColors.bg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: has
              ? LightPageColors.orange.withValues(alpha: 0.3)
              : LightPageColors.border,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepBtn(Icons.remove_rounded, onDec, enabled: has),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$qty',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: has ? LightPageColors.orange : LightPageColors.muted,
              ),
            ),
          ),
          _stepBtn(Icons.add_rounded, onInc, enabled: true),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback? cb, {required bool enabled}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? cb : null,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 15,
            color: enabled
                ? (cb != null ? LightPageColors.orange : LightPageColors.text2)
                : LightPageColors.muted.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuModel item;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const _MenuCard({required this.item, this.onTap, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final desc = item.description?.trim();
    final missing = item.missingComponents.map((m) => m.name).join(', ');
    return LightCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              KabaStatusPill(
                label: item.available ? 'Disponible' : 'Indisponible',
                color: item.available
                    ? LightPageColors.orange
                    : LightPageColors.muted,
              ),
            ],
          ),
          if (desc != null && desc.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: LightPageColors.muted,
                height: 1.35,
              ),
            ),
          ],
          if (item.lines.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.lines
                  .map((l) => '${l.name} ×${l.quantity}')
                  .join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: LightPageColors.text2,
              ),
            ),
          ],
          if (!item.available && missing.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Manque : $missing',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: LightPageColors.red,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${formatTickets(item.priceTickets)} tickets',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: LightPageColors.orange,
                ),
              ),
              const Spacer(),
              if (onAdd != null)
                Material(
                  color: LightPageColors.orange,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: onAdd,
                    borderRadius: BorderRadius.circular(10),
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeaveReviewCard extends ConsumerStatefulWidget {
  final OrderModel order;
  final String vendorId;

  const _LeaveReviewCard({required this.order, required this.vendorId});

  @override
  ConsumerState<_LeaveReviewCard> createState() => _LeaveReviewCardState();
}

class _LeaveReviewCardState extends ConsumerState<_LeaveReviewCard> {
  int _rating = 5;
  final _comment = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _sending = true);
    try {
      await ref.read(reviewRepositoryProvider).createReview(
            orderId: widget.order.id,
            vendorId: widget.vendorId,
            rating: _rating,
            comment: _comment.text.trim(),
          );
      if (!mounted) return;
      showKabaSnack(context, 'Avis envoyé, merci.');
      _comment.clear();
    } catch (error) {
      if (mounted) {
        showKabaSnack(context, apiErrorMessage(error), error: true);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LightCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Noter ta dernière commande',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              final value = i + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = value),
                icon: Icon(
                  value <= _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: LightPageColors.warning,
                ),
              );
            }),
          ),
          TextField(
            controller: _comment,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: LightPageColors.text,
            ),
            decoration: InputDecoration(
              hintText: 'Commentaire optionnel',
              filled: false,
              fillColor: Colors.transparent,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: LightPageColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 12),
          LightButton(
            text: _sending ? 'Envoi…' : 'Envoyer l’avis',
            onPressed: _sending ? null : _submit,
          ),
        ],
      ),
    );
  }
}
