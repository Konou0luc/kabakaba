import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class CanteenListPage extends StatefulWidget {
  const CanteenListPage({super.key});

  @override
  State<CanteenListPage> createState() => _CanteenListPageState();
}

class _CanteenListPageState extends State<CanteenListPage> {
  int _cat = 0;
  final searchController = TextEditingController();
  final categories = const [
    '🍽️ Toutes',
    '🌿 Végétarien',
    '🍗 Poulet',
    '🐟 Poisson',
    '🍝 Pâtes',
    '🍚 Riz',
    '🥗 Salades',
    '🍔 Fast food',
  ];

  final List<Map<String, dynamic>> canteens = [
    {
      'name': 'Chez Mama Afi',
      'logo': '🍲',
      'coverColors': [Color(0xFFF07840), Color(0xFFFFAB70)],
      'location': 'UCAO · Bâtiment C',
      'distance': '50 m',
      'rating': 4.8,
      'reviews': 327,
      'open': true,
      'deliverTime': '15-25 min',
      'minOrder': '1 000',
      'promo': '-20% sur 2 plats',
      'tag': '🌶️ Populaire',
    },
    {
      'name': 'Cantine du Campus',
      'logo': '🍛',
      'coverColors': [Color(0xFF1B2A6B), Color(0xFF6366F1)],
      'location': 'UCAO · Restaurant universitaire',
      'distance': '100 m',
      'rating': 4.6,
      'reviews': 1024,
      'open': true,
      'deliverTime': '20-30 min',
      'minOrder': '800',
      'promo': 'Menu étudiant à 1 500',
      'tag': '🎓 Étudiant',
    },
    {
      'name': 'La Paix Restaurant',
      'logo': '🥘',
      'coverColors': [Color(0xFF10B981), Color(0xFF34D399)],
      'location': 'UCAO · Entrée principale',
      'distance': '180 m',
      'rating': 4.5,
      'reviews': 412,
      'open': true,
      'deliverTime': '25-35 min',
      'minOrder': '1 200',
      'promo': null,
      'tag': '💚 Végan-friendly',
    },
    {
      'name': 'Chez Kossi Fast Food',
      'logo': '🍔',
      'coverColors': [Color(0xFFDC2626), Color(0xFFF97316)],
      'location': 'UCAO · Bâtiment A',
      'distance': '75 m',
      'rating': 4.3,
      'reviews': 588,
      'open': false,
      'deliverTime': '10-20 min',
      'minOrder': '1 500',
      'promo': 'Menu burger à 2 000',
      'tag': '⚡ Rapide',
    },
    {
      'name': 'Saveurs d\'Afrique',
      'logo': '🍝',
      'coverColors': [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      'location': 'UCAO · Derrière amphi 1',
      'distance': '220 m',
      'rating': 4.9,
      'reviews': 186,
      'open': true,
      'deliverTime': '30-45 min',
      'minOrder': '2 000',
      'promo': null,
      'tag': '⭐ Nouvelle',
    },
    {
      'name': 'Le Petit Marché',
      'logo': '🥗',
      'coverColors': [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
      'location': 'UCAO · Résidence A',
      'distance': '300 m',
      'rating': 4.7,
      'reviews': 94,
      'open': true,
      'deliverTime': '20-30 min',
      'minOrder': '1 800',
      'promo': 'Salade offerte dès 3 000',
      'tag': '🥗 Healthy',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = searchController.text.toLowerCase();
    final filtered = canteens
        .where((c) {
          if (_cat == 0) return true;
          return true;
        })
        .where((c) {
          if (q.isEmpty) return true;
          return (c['name'] as String).toLowerCase().contains(q);
        })
        .toList();

    return LightPageScaffold(
      title: 'Cantines',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: LightIconButton(
            icon: Icons.notifications_none_rounded,
            badge: '3',
            onTap: () {},
          ),
        ),
      ],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: _buildSearch(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
              child: _buildPromoBanner().animate().fadeIn().slideY(
                begin: 0.1,
                curve: Curves.easeOut,
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: LightSectionTitle(
                title: 'Cantines à proximité',
                subtitle: '${filtered.length} ouvertes près de toi',
                action: 'Tout voir',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                mainAxisSpacing: 14,
                crossAxisSpacing: 12,
                // A small handset gets a single, comfortably readable card;
                // wider phones retain the two-column layout.
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _buildCanteenCard(filtered[i])
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 40 * i), begin: 0.8)
                    .slideY(delay: Duration(milliseconds: 40 * i), begin: 0.1),
                childCount: filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LightPageColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: LightPageColors.indigo.withValues(alpha: 0.04),
            blurRadius: 20,
            spreadRadius: -8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            size: 20,
            color: LightPageColors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LightPageColors.text,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cantines, plats, boissons…',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: LightPageColors.muted,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: LightPageColors.indigoLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: LightPageColors.indigo,
                ),
                const SizedBox(width: 4),
                Text(
                  'UCAO',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF07840),
            const Color(0xFFFF9966),
            const Color(0xFFFFB88C),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF07840).withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: -8,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'OFFRE LIMITÉE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '-30% sur ton\npremier plat',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Valide sur toutes les cantines UCAO',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: -4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'J\'en profite',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.orange,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: LightPageColors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Column(
            children: [
              Container(
                width: 88,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🍱', style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Code: WELCOME30',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = _cat == i;
          return GestureDetector(
            onTap: () => setState(() => _cat = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? LightPageColors.indigo : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? LightPageColors.indigo
                      : LightPageColors.border,
                  width: 1.3,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: LightPageColors.indigo.withValues(alpha: 0.3),
                          blurRadius: 14,
                          spreadRadius: -4,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                categories[i],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : LightPageColors.text,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCanteenCard(Map<String, dynamic> c) {
    final colors = c['coverColors'] as List<Color>;
    final open = c['open'] as bool;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/canteen-detail'),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: LightPageColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: LightPageColors.indigo.withValues(alpha: 0.05),
                blurRadius: 20,
                spreadRadius: -8,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 114,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -18,
                          right: -14,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -22,
                          left: -12,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                c['logo'] as String,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 11,
                            color: Color(0xFFFFD54F),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${c['rating']}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${c['reviews']})',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            spreadRadius: -3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 15,
                        color: LightPageColors.red,
                      ),
                    ),
                  ),
                  if (!open)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(17),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: LightPageColors.red.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Fermé · Ouvre 07h30',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Expanded(
                          child: Text(
                            c['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: LightPageColors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      c['location'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        color: LightPageColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 10,
                          color: LightPageColors.indigo.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          c['deliverTime'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: LightPageColors.indigo,
                          ),
                        ),
                        Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: LightPageColors.muted,
                        ),
                        Text(
                          c['distance'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: LightPageColors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    if (c['promo'] != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: LightPageColors.orangeLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_offer_rounded,
                              size: 9.5,
                              color: LightPageColors.orange,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                c['promo'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: LightPageColors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: LightPageColors.indigoLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          c['tag'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.indigo,
                          ),
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
  }
}
