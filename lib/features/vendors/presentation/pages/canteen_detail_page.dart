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
  String? _composeItemId;
  final Map<String, int> _componentQty = {};

  List<MenuItemModel> get _menu {
    final id = widget.vendorId;
    if (id == null) return const [];
    return ref.watch(vendorMenuProvider(id)).valueOrNull ?? const [];
  }

  List<MenuItemModel> get _composeBases {
    final custom = _menu.where((item) => item.isCustomizable).toList();
    return custom.isNotEmpty
        ? custom
        : _menu.where((item) => item.isAvailable).toList();
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
      data: (vendor) => LightPageScaffold(
        title: vendor.canteenName,
        bottomNavigationBar: cartCount > 0 || _tab != 2
            ? _buildStickyBottomBar()
            : null,
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _buildCover(vendor)
                .animate()
                .fadeIn(duration: 280.ms)
                .slideY(begin: 0.04, duration: 320.ms),
            const SizedBox(height: 16),
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
              _buildCustomizeTab()
            else
              _buildReviewsTab(vendor),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(VendorModel vendor) {
    final image = vendor.bannerUrl ?? vendor.logoUrl;
    final open = vendor.isOpen;
    final desc = vendor.description?.trim();
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            RemotePhoto(
              url: image,
              width: double.infinity,
              height: 220,
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
                    Color(0x33000000),
                    Color(0x14000000),
                    Color(0xE6000000),
                  ],
                  stops: [0, 0.42, 1],
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 14,
              child: KabaStatusPill(
                label: open ? 'Ouverte' : 'Fermée',
                color: open ? AppColors.success : const Color(0xE6000000),
                inverted: true,
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.canteenName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                  if (desc != null && desc.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanteenInfo(VendorModel vendor) {
    final available = _menu.where((item) => item.isAvailable).length;
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
              icon: vendor.isOpen
                  ? Icons.schedule_rounded
                  : Icons.lock_clock_rounded,
              label: vendor.isOpen ? 'Service ouvert' : 'Service fermé',
              color: vendor.isOpen ? AppColors.success : LightPageColors.muted,
            ),
            if (_menu.isNotEmpty)
              _MetaChip(
                icon: Icons.restaurant_menu_rounded,
                label: available == 1 ? '1 plat' : '$available plats',
                color: LightPageColors.indigo,
              ),
            if (_composeBases.isNotEmpty)
              _MetaChip(
                icon: Icons.tune_rounded,
                label: 'Composition possible',
                color: LightPageColors.orange,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomizeTab() {
    final bases = _composeBases;
    if (bases.isEmpty) {
      return const KabaEmptyState(
        icon: Icons.tune_rounded,
        title: 'Rien à composer',
        subtitle: 'Cette cantine n’a pas encore de plat à assembler.',
      );
    }
    final selectedId = _composeItemId ?? bases.first.id;
    final selected = bases.firstWhere(
      (item) => item.id == selectedId,
      orElse: () => bases.first,
    );
    final components =
        ref.watch(menuComponentsProvider(selected.id)).valueOrNull ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LightHintBox(
          icon: Icons.tips_and_updates_rounded,
          text:
              'Choisis une base, ajoute les extras proposés par la cantine, puis ajoute au panier.',
        ),
        const SizedBox(height: 18),
        const LightSectionTitle(
          title: 'Choix de la base',
          subtitle: 'Prix de base en tickets',
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.92,
          ),
          itemCount: bases.length,
          itemBuilder: (context, i) {
            final item = bases[i];
            final selectedBase = item.id == selected.id;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() {
                  _composeItemId = item.id;
                  _componentQty.clear();
                }),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: selectedBase
                        ? LightPageColors.orange.withValues(alpha: 0.08)
                        : LightPageColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selectedBase
                          ? LightPageColors.orange
                          : LightPageColors.border,
                      width: selectedBase ? 1.8 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: RemotePhoto(
                            url: item.imageUrl,
                            width: double.infinity,
                            height: 88,
                            fallback: ColoredBox(
                              color: const Color(0xFF1B2A6B),
                              child: Icon(
                                Icons.restaurant_rounded,
                                color: AppColors.accent.withValues(alpha: 0.85),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${formatTickets(item.priceTickets)} tickets',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        LightSectionTitle(
          title: 'Accompagnements',
          subtitle: components.isEmpty
              ? 'Aucun extra publié pour cette base'
              : 'Quantités limitées par la cantine',
        ),
        if (components.isEmpty)
          Text(
            'Tu peux commander cette base telle quelle.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: LightPageColors.muted,
            ),
          )
        else
          ...components.map((component) {
            final qty = _componentQty[component.id] ?? component.minQty;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildQtyItem(
                component.name,
                component.unitPriceTickets,
                qty,
                qty < component.maxQty
                    ? () => setState(
                          () => _componentQty[component.id] = qty + 1,
                        )
                    : () {},
                qty > component.minQty
                    ? () => setState(
                          () => _componentQty[component.id] = qty - 1,
                        )
                    : null,
              ),
            );
          }),
        const SizedBox(height: 16),
        LightButton(
          text: 'Ajouter au panier',
          icon: Icons.add_rounded,
          onPressed: () => _addComposedItem(selected, components),
        ),
      ],
    );
  }

  void _addComposedItem(
    MenuItemModel item,
    List<MenuComponentModel> components,
  ) {
    final vendorId = widget.vendorId;
    final vendor = vendorId == null
        ? null
        : ref.read(vendorDetailProvider(vendorId)).valueOrNull;
    if (vendor == null) {
      showKabaSnack(context, 'Cantine introuvable', error: true);
      return;
    }
    final extras = [
      for (final component in components)
        if ((_componentQty[component.id] ?? component.minQty) > 0)
          CartComponent(
            componentId: component.id,
            name: component.name,
            unitPriceTickets: component.unitPriceTickets,
            quantity: _componentQty[component.id] ?? component.minQty,
          ),
    ];
    final line = CartLine(
      vendorId: vendor.id,
      vendorName: vendor.canteenName,
      menuItemId: item.id,
      name: extras.isEmpty ? item.name : '${item.name} (composé)',
      priceTickets: item.priceTickets,
      quantity: 1,
      imageUrl: item.imageUrl,
      components: extras,
    );
    final added = ref.read(cartProvider.notifier).add(line);
    if (!added) {
      ref.read(cartProvider.notifier).replaceWith(line);
      showKabaSnack(context, 'Nouveau panier pour ${vendor.canteenName}');
    } else {
      showKabaSnack(context, '${item.name} ajouté');
    }
  }

  Widget _buildQtyItem(
    String name,
    int price,
    int qty,
    VoidCallback onInc,
    VoidCallback? onDec,
  ) {
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
                  '+${formatTickets(price)} tickets / unité',
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
          _QtyStepper(qty: qty, onInc: onInc, onDec: onDec),
        ],
      ),
    );
  }

  Widget _buildMenusTab() {
    final menus = _menu;
    final loading = widget.vendorId != null &&
        ref.watch(vendorMenuProvider(widget.vendorId!)).isLoading;
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
        subtitle: 'Aucun plat n’a été publié pour le moment.',
      );
    }
    return Column(
      children: [
        ...List.generate(menus.length, (i) {
          final item = menus[i];
          return Padding(
            padding: EdgeInsets.only(bottom: i == menus.length - 1 ? 0 : 12),
            child: _FixedMenuCard(
              item: item,
              onTap: item.isAvailable
                  ? () => context.push(
                        '/menu-detail',
                        extra: {
                          'itemId': item.id,
                          'vendorId': widget.vendorId,
                        },
                      )
                  : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReviewsTab(VendorModel vendor) {
    final received = (ref.watch(myOrdersProvider).valueOrNull ?? const [])
        .where(
          (order) =>
              order.vendorId == vendor.id &&
              (order.status == OrderStatus.RECEIVED ||
                  order.status == OrderStatus.AUTO_RECEIVED),
        )
        .toList();
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
        if (received.isEmpty)
          const KabaEmptyState(
            icon: Icons.star_outline_rounded,
            title: 'Pas encore d’avis',
            subtitle:
                'Tu pourras noter cette cantine après avoir retiré une commande.',
          )
        else
          _LeaveReviewCard(order: received.first, vendorId: vendor.id),
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
                        : 'Choisis ton plat',
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

class _FixedMenuCard extends StatelessWidget {
  final MenuItemModel item;
  final VoidCallback? onTap;

  const _FixedMenuCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final desc = item.description?.trim();
    final tag = item.category?.trim().isNotEmpty == true
        ? item.category!.trim()
        : (item.isAvailable ? 'Disponible' : 'Indisponible');
    return LightCard(
      padding: const EdgeInsets.all(10),
      borderRadius: 18,
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: RemotePhoto(
                url: item.imageUrl,
                width: 104,
                height: 112,
                radius: 14,
                fallback: ColoredBox(
                  color: const Color(0xFF1B2A6B),
                  child: SizedBox(
                    width: 104,
                    height: 112,
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: AppColors.accent.withValues(alpha: 0.85),
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: LightPageColors.text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  KabaStatusPill(
                    label: tag,
                    color: item.isAvailable
                        ? LightPageColors.orange
                        : LightPageColors.muted,
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
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${formatTickets(item.priceTickets)} tickets',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: LightPageColors.orange,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: item.isAvailable
                              ? LightPageColors.orange
                              : LightPageColors.muted.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.isAvailable
                              ? Icons.add_rounded
                              : Icons.block_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
