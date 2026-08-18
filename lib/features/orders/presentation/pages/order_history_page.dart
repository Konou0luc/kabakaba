import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int _tab = 0;
  final List<String> tabs = const [
    'En attente',
    'Préparation',
    'Programmées',
    'Historique',
    'Favoris',
  ];

  final Map<String, List<Map<String, dynamic>>> ordersByTab = {
    'pending': [
      {
        'id': 'CMD-99887',
        'vendor': 'Chez Mama Afi',
        'vendorLogo': '🍲',
        'items': 'Riz sauce arachide · 2x',
        'total': 3500,
        'count': 2,
        'time': '25 min',
        'eta': '13h20',
        'pickup': 'Sur place',
        'status': 'pending',
        'color': LightPageColors.warning,
        'badge': 'En attente',
        'date': 'Aujourd\'hui · 12h55',
        'progress': 1,
        'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
      },
      {
        'id': 'CMD-99801',
        'vendor': 'Cantine du Campus',
        'vendorLogo': '🍛',
        'items': 'Plat du jour · Poulet braisé · Attiéké',
        'total': 1800,
        'count': 1,
        'time': '~15 min',
        'eta': '13h45',
        'pickup': 'À emporter',
        'status': 'pending',
        'color': LightPageColors.warning,
        'badge': 'En attente',
        'date': 'Aujourd\'hui · 13h30',
        'progress': 0,
        'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
      },
    ],
    'prepping': [
      {
        'id': 'CMD-99762',
        'vendor': 'La Paix Restaurant',
        'vendorLogo': '🥘',
        'items': 'Alloco + Poulet · Fanta',
        'total': 2400,
        'count': 3,
        'time': '8 min restantes',
        'eta': '12h50',
        'pickup': 'Sur place',
        'status': 'prepping',
        'color': const Color(0xFF6366F1),
        'badge': 'En préparation',
        'date': 'Aujourd\'hui · 12h30',
        'progress': 2,
        'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
      },
    ],
    'scheduled': [
      {
        'id': 'CMD-S-001',
        'vendor': 'Chez Mama Afi',
        'vendorLogo': '🍲',
        'items': 'Déjeuner du lundi · Menu étudiant',
        'total': 1500,
        'count': 1,
        'time': 'Lun 12h30',
        'eta': 'Récupération lundi',
        'pickup': 'Sur place',
        'status': 'scheduled',
        'color': const Color(0xFF0EA5E9),
        'badge': 'Programmée',
        'date': 'À venir · Lundi 18 août',
        'progress': 0,
        'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
      },
      {
        'id': 'CMD-S-002',
        'vendor': 'Cantine du Campus',
        'vendorLogo': '🍛',
        'items': 'Pack semaine · 5 repas midi',
        'total': 7000,
        'count': 5,
        'time': 'Toute la semaine',
        'eta': 'Du lundi au vendredi',
        'pickup': 'Sur place',
        'status': 'scheduled',
        'color': const Color(0xFF0EA5E9),
        'badge': 'Programmée',
        'date': 'À venir · 18-22 août',
        'progress': 0,
        'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
      },
    ],
    'history': [
      {
        'id': 'CMD-78201',
        'vendor': 'Cantine du Campus',
        'vendorLogo': '🍛',
        'items': 'Plat du jour · Poulet braisé',
        'total': 1800,
        'count': 1,
        'time': '13h22',
        'eta': 'Complété',
        'pickup': 'Sur place',
        'status': 'completed',
        'color': LightPageColors.green,
        'badge': 'Livrée',
        'date': 'Sam 9 août · 13h10',
        'progress': 4,
        'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
      },
      {
        'id': 'CMD-77120',
        'vendor': 'Chez Mama Afi',
        'vendorLogo': '🍲',
        'items': 'Riz gras · 2x · Salade',
        'total': 2900,
        'count': 3,
        'time': '12h15',
        'eta': 'Complété',
        'pickup': 'À emporter',
        'status': 'completed',
        'color': LightPageColors.green,
        'badge': 'Livrée',
        'date': 'Ven 8 août · 12h00',
        'progress': 4,
        'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
      },
      {
        'id': 'CMD-76540',
        'vendor': 'La Paix Restaurant',
        'vendorLogo': '🥘',
        'items': 'Plat végétarien · Kebab',
        'total': 1600,
        'count': 1,
        'time': '19h40',
        'eta': 'Annulée',
        'pickup': 'Sur place',
        'status': 'cancelled',
        'color': LightPageColors.red,
        'badge': 'Annulée',
        'date': 'Jeu 7 août · 19h38',
        'progress': 0,
        'steps': ['Confirmée', 'En préparation', 'Prête', 'Retirée'],
      },
    ],
    'favs': [
      {
        'vendor': 'Chez Mama Afi',
        'vendorLogo': '🍲',
        'dishName': 'Riz sauce arachide',
        'dishDesc': 'Riz long · Sauce riche · Poulet',
        'price': 1750,
        'rating': 4.8,
        'reviews': 327,
        'fav': true,
      },
      {
        'vendor': 'Cantine du Campus',
        'vendorLogo': '🍛',
        'dishName': 'Plat du jour Poulet',
        'dishDesc': 'Menu étudiant · Boisson incluse',
        'price': 1800,
        'rating': 4.6,
        'reviews': 1024,
        'fav': true,
      },
    ],
  };

  List<Map<String, dynamic>> get currentData {
    return switch (_tab) {
      0 => ordersByTab['pending'] ?? [],
      1 => ordersByTab['prepping'] ?? [],
      2 => ordersByTab['scheduled'] ?? [],
      3 => ordersByTab['history'] ?? [],
      4 => ordersByTab['favs'] ?? [],
      _ => [],
    };
  }

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Mes commandes',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: LightIconButton(icon: Icons.search_rounded, onTap: () {}),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: LightTabs(
              tabs: tabs,
              selectedIndex: _tab,
              onTap: (i) => setState(() => _tab = i),
            ),
          ),
          Expanded(child: _tab == 4 ? _buildFavsList() : _buildOrdersList()),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    final data = currentData;
    if (data.isEmpty) return _buildEmptyOrders();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        return _buildOrderCard(data[i])
            .animate()
            .fadeIn(delay: (40 * i).ms, begin: 0.8)
            .slideY(delay: (40 * i).ms, begin: 0.08);
      },
    );
  }

  Widget _buildFavsList() {
    final data = currentData;
    if (data.isEmpty) return _buildEmptyFavs();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        return _buildFavCard(
          data[i],
        ).animate().fadeIn(delay: (40 * i).ms, begin: 0.8);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> o) {
    final isCancelled = o['status'] == 'cancelled';
    final isScheduled = o['status'] == 'scheduled';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LightPageColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: LightPageColors.indigo.withValues(alpha: 0.04),
            blurRadius: 24,
            spreadRadius: -10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: LightPageColors.orangeLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    o['vendorLogo'] as String,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              o['vendor'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.text,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: (o['color'] as Color).withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              o['badge'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: o['color'] as Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        o['id'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: LightPageColors.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        o['items'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: LightPageColors.text2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isScheduled && !isCancelled && (o['progress'] as int) > 0)
            _buildProgressSteps(
              steps: o['steps'] as List<String>,
              current: o['progress'] as int,
              color: o['color'] as Color,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              children: [
                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: [
                    _buildMeta(Icons.access_time_rounded, o['time'] as String),
                    _buildMeta(
                      Icons.shopping_bag_outlined,
                      '${o['count']} articles',
                    ),
                    _buildMeta(
                      o['pickup'] == 'Sur place'
                          ? Icons.restaurant_rounded
                          : Icons.takeout_dining_rounded,
                      o['pickup'] as String,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: LightPageColors.bg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: LightPageColors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(o['total'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} tickets',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: LightPageColors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          children: [
                            if (isCancelled)
                              LightButton(
                                text: 'Commander à nouveau',
                                icon: Icons.refresh_rounded,
                                onPressed: () {},
                              )
                            else if (o['status'] == 'completed')
                              Wrap(
                                spacing: 8,
                                runSpacing: 12,
                                children: [
                                  LightButton(
                                    text: 'Recommander',
                                    icon: Icons.refresh_rounded,
                                    isPrimary: false,
                                    compact: true,
                                    onPressed: () {},
                                  ),
                                  LightButton(
                                    text: 'Détails',
                                    icon: Icons.arrow_forward_rounded,
                                    compact: true,
                                    onPressed: () {},
                                  ),
                                ],
                              )
                            else if (isScheduled)
                              LightButton(
                                text: 'Gérer la réservation',
                                icon: Icons.calendar_today_rounded,
                                compact: true,
                                onPressed: () {},
                              )
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 12,
                                children: [
                                  LightButton(
                                    text: 'Suivre',
                                    icon: Icons.location_on_outlined,
                                    isPrimary: false,
                                    compact: true,
                                    onPressed: () {},
                                  ),
                                  LightButton(
                                    text: 'Contacter',
                                    icon: Icons.chat_bubble_outline_rounded,
                                    compact: true,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSteps({
    required List<String> steps,
    required int current,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 6, 16, 10),
      child: Column(
        children: [
          SizedBox(
            height: 18,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 9,
                  right: 9,
                  child: Container(height: 2, color: LightPageColors.border),
                ),
                Row(
                  children: List.generate(steps.length, (i) {
                    final done = i < current;
                    final active = i == current - 1;
                    return Expanded(
                      child: Center(
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: done ? color : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: done ? color : LightPageColors.border,
                              width: 2,
                            ),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      spreadRadius: -2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: done
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 11,
                                  color: Colors.white,
                                  weight: 6,
                                )
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(steps.length, (i) {
              final done = i < current;
              return Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    steps[i],
                    maxLines: 1,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8.5,
                      fontWeight: done ? FontWeight.w800 : FontWeight.w500,
                      color: done ? color : LightPageColors.muted,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: LightPageColors.muted),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: LightPageColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildFavCard(Map<String, dynamic> f) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [LightPageColors.orangeLight, const Color(0xFFFFE0C9)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              f['vendorLogo'] as String,
              style: const TextStyle(fontSize: 34),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        f['dishName'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.text,
                        ),
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: LightPageColors.redLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: LightPageColors.red,
                        size: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  f['vendor'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.indigo,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  f['dishDesc'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: LightPageColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: LightPageColors.warningLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 10,
                            color: LightPageColors.warning,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${f['rating']}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: LightPageColors.warning,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '(${f['reviews']})',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: LightPageColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(f['price'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} tickets',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: LightPageColors.orange,
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

  Widget _buildEmptyOrders() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: LightPageColors.indigoLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: LightPageColors.indigo,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            switch (_tab) {
              0 => 'Aucune commande en attente',
              1 => 'Rien en préparation',
              2 => 'Aucune commande programmée',
              _ => 'Aucune commande passée',
            },
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            switch (_tab) {
              0 => 'Trouvez une cantine et passez votre première commande',
              1 => 'Vos commandes en cours apparaîtront ici',
              2 => 'Programmez vos repas pour la semaine',
              _ => 'Votre historique de commande apparaîtra ici',
            },
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 1.5,
              color: LightPageColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: 220,
            child: LightButton(
              text: 'Découvrir les cantines',
              icon: Icons.restaurant_menu_rounded,
              onPressed: () => context.go('/home'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFavs() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: LightPageColors.redLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: LightPageColors.red,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Aucun favori pour le moment',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ajoutez vos plats et cantines préférés en appuyant sur l\'icône ❤',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 1.5,
              color: LightPageColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: 220,
            child: LightButton(
              text: 'Explorer les menus',
              icon: Icons.search_rounded,
              onPressed: () => context.go('/home'),
            ),
          ),
        ],
      ),
    );
  }
}
