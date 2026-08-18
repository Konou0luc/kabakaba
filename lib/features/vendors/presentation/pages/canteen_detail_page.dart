import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class CanteenDetailPage extends StatefulWidget {
  const CanteenDetailPage({super.key});

  @override
  State<CanteenDetailPage> createState() => _CanteenDetailPageState();
}

class _CanteenDetailPageState extends State<CanteenDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tab = 0;
  bool _isFavorite = false;

  final int _baseQty = 1;
  int _eggQty = 0;
  int _sausageQty = 0;
  int _fishQty = 0;
  int _chickenQty = 0;

  int get _customTotal =>
      (_baseQty * 500) +
      (_eggQty * 150) +
      (_sausageQty * 200) +
      (_fishQty * 500) +
      (_chickenQty * 400);

  final List<Map<String, dynamic>> fixedMenus = [
    {
      'name': 'Menu étudiant express',
      'desc': 'Riz + sauce tomate + 1 œuf + boisson',
      'price': 1500,
      'emoji': '🍛',
      'tag': '🎓 Populaire',
      'prep': '10 min',
      'rating': 4.7,
    },
    {
      'name': 'Plat du jour',
      'desc': 'Fufu + sauce arachide + viande + alloco',
      'price': 2000,
      'emoji': '🥘',
      'tag': '🔥 Recommandé',
      'prep': '20 min',
      'rating': 4.9,
    },
    {
      'name': 'Déjeuner Healthy',
      'desc': 'Salade poulet + avocat + jus d\'orange',
      'price': 2500,
      'emoji': '🥗',
      'tag': '💚 Healthy',
      'prep': '12 min',
      'rating': 4.6,
    },
    {
      'name': 'Burger Duo',
      'desc': '2 burgers poulet + frites + 2 sodas',
      'price': 3500,
      'emoji': '🍔',
      'tag': '⚡ Rapide',
      'prep': '15 min',
      'rating': 4.5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(
      () => setState(() => _tab = _tabController.index),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightPageColors.bg,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                LightBackButton(onTap: () => context.pop()),
                const Spacer(),
                LightIconButton(
                  icon: _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: _isFavorite ? LightPageColors.red : null,
                  bgColor: LightPageColors.white.withValues(alpha: 0.92),
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                ),
                const SizedBox(width: 8),
                LightIconButton(
                  icon: Icons.share_outlined,
                  bgColor: LightPageColors.white.withValues(alpha: 0.92),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: (_customTotal > 0 || _tab == 1)
          ? _buildStickyBottomBar()
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCover(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildCanteenInfo(),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildQuickActions(),
            ),
            const SizedBox(height: 18),
            _buildTabs(),
            if (_tab == 0)
              _buildCustomizeTab()
            else if (_tab == 1)
              _buildMenusTab()
            else
              _buildReviewsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF07840), Color(0xFFFFB88C), Color(0xFFFFE5D0)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text('🍲', style: TextStyle(fontSize: 44)),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: LightPageColors.green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: LightPageColors.green.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ouvert · 07h30 - 17h00',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
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

  Widget _buildCanteenInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Chez Mama Afi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: LightPageColors.text,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: LightPageColors.warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 13,
                    color: LightPageColors.warning,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '4.8 · 327 avis',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: LightPageColors.warning,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Spécialités togolaises · Cuisine traditionnelle',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: LightPageColors.muted,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 13,
              color: LightPageColors.indigo,
            ),
            const SizedBox(width: 5),
            Text(
              'UCAO · Bâtiment C · 50 m',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: LightPageColors.text2,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.access_time_rounded,
              size: 13,
              color: LightPageColors.indigo,
            ),
            const SizedBox(width: 5),
            Text(
              '15-25 min',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: LightPageColors.indigo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.delivery_dining_rounded,
              size: 13,
              color: LightPageColors.muted,
            ),
            const SizedBox(width: 5),
            Text(
              'Livraison gratuite dès 3 000 FCFA',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: LightPageColors.muted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.info_outline_rounded, 'label': 'Infos'},
      {'icon': Icons.call_outlined, 'label': 'Appeler'},
      {'icon': Icons.directions_outlined, 'label': 'Itinéraire'},
      {'icon': Icons.flag_outlined, 'label': 'Signaler'},
    ];
    return Row(
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          Expanded(
            child: LightCard(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              onTap: () {},
              borderRadius: 12,
              boxShadow: [
                BoxShadow(
                  color: LightPageColors.indigo.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              child: Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: i == 0
                          ? LightPageColors.indigoLight
                          : i == 1
                          ? LightPageColors.greenLight
                          : i == 2
                          ? LightPageColors.orangeLight
                          : LightPageColors.redLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      actions[i]['icon'] as IconData,
                      size: 16,
                      color: i == 0
                          ? LightPageColors.indigo
                          : i == 1
                          ? LightPageColors.green
                          : i == 2
                          ? LightPageColors.orange
                          : LightPageColors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    actions[i]['label'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: LightPageColors.text2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i != 3) const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _buildTabs() {
    final tabs = ['Composer mon plat', 'Menus prêts', 'Avis'];
    return Container(
      decoration: const BoxDecoration(
        color: LightPageColors.white,
        border: Border(
          bottom: BorderSide(color: LightPageColors.border, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _tab == index;
          return Expanded(
            child: InkWell(
              onTap: () => _tabController.animateTo(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: isSelected
                      ? Border(
                          bottom: BorderSide(
                            color: LightPageColors.orange,
                            width: 3,
                          ),
                        )
                      : null,
                ),
                child: Text(
                  tabs[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? LightPageColors.indigo
                        : LightPageColors.muted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCustomizeTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LightHintBox(
            icon: Icons.tips_and_updates_rounded,
            text:
                'Choisis ta base, ajoute tes accompagnements préférés, et compose ton plat idéal !',
          ),
          const SizedBox(height: 18),
          LightSectionTitle(
            title: 'Choix de la base',
            subtitle: 'Inclut sauce tomate ou arachide',
          ),
          const SizedBox(height: 4),
          _buildBaseSelector(),
          const SizedBox(height: 22),
          LightSectionTitle(
            title: 'Accompagnements',
            subtitle: 'Ajoute ce qui te fait plaisir',
          ),
          const SizedBox(height: 4),
          _buildQtyItem(
            'Œuf (omelette ou au plat)',
            150,
            _eggQty,
            Icons.breakfast_dining_rounded,
            LightPageColors.warningLight,
            LightPageColors.warning,
            () => setState(() => _eggQty++),
            _eggQty > 0 ? () => setState(() => _eggQty--) : null,
          ),
          const SizedBox(height: 8),
          _buildQtyItem(
            'Saucisse de bœuf',
            200,
            _sausageQty,
            Icons.fastfood_rounded,
            LightPageColors.redLight,
            LightPageColors.red,
            () => setState(() => _sausageQty++),
            _sausageQty > 0 ? () => setState(() => _sausageQty--) : null,
          ),
          const SizedBox(height: 8),
          _buildQtyItem(
            'Poulet braisé (1 morceau)',
            400,
            _chickenQty,
            Icons.ramen_dining_rounded,
            LightPageColors.orangeLight,
            LightPageColors.orange,
            () => setState(() => _chickenQty++),
            _chickenQty > 0 ? () => setState(() => _chickenQty--) : null,
          ),
          const SizedBox(height: 8),
          _buildQtyItem(
            'Poisson frais fumé',
            500,
            _fishQty,
            Icons.set_meal_rounded,
            LightPageColors.indigoLight,
            LightPageColors.indigo,
            () => setState(() => _fishQty++),
            _fishQty > 0 ? () => setState(() => _fishQty--) : null,
          ),
          const SizedBox(height: 22),
          LightSectionTitle(title: 'Sauces & extras'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in [
                'Piment +50',
                'Oignons +30',
                'Citron +40',
                'Alloco +300',
                'Banane plantain +250',
                'Avocat +200',
              ])
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: LightPageColors.white,
                    border: Border.all(
                      color: LightPageColors.border,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    s,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: LightPageColors.text2,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  int _selectedBase = 0;
  final _bases = const [
    {'name': 'Riz blanc', 'emoji': '🍚', 'price': 500},
    {'name': 'Fufu', 'emoji': '🫓', 'price': 450},
    {'name': 'Attiéké', 'emoji': '🥘', 'price': 600},
    {'name': 'Pâtes fraîches', 'emoji': '🍝', 'price': 550},
  ];

  Widget _buildBaseSelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemCount: _bases.length,
      itemBuilder: (context, i) {
        final b = _bases[i];
        final selected = _selectedBase == i;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _selectedBase = i),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? LightPageColors.orange.withValues(alpha: 0.06)
                    : LightPageColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? LightPageColors.orange
                      : LightPageColors.border,
                  width: selected ? 1.8 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: LightPageColors.orange.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selected
                          ? LightPageColors.orangeLight
                          : LightPageColors.bg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      b['emoji'] as String,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          b['name'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${b['price']} FCFA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
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
    );
  }

  Widget _buildQtyItem(
    String name,
    int price,
    int qty,
    IconData icon,
    Color bgIcon,
    Color colorIcon,
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
              color: bgIcon,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: colorIcon),
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
                  '$price FCFA / unité',
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(fixedMenus.length, (i) {
            final m = fixedMenus[i];
            return Padding(
              padding: EdgeInsets.only(
                bottom: i == fixedMenus.length - 1 ? 0 : 12,
              ),
              child: _FixedMenuCard(m: m),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final reviews = [
      {
        'name': 'Kossi A.',
        'avatar': '👨🏽',
        'rating': 5,
        'date': 'Il y a 2j',
        'comment':
            'Très bon accueil, le riz sauce arachide était délicieux et la portion généreuse. Je recommande !',
        'like': 12,
      },
      {
        'name': 'Ama S.',
        'avatar': '👩🏾',
        'rating': 4,
        'date': 'Il y a 5j',
        'comment':
            'Livraison rapide (18 min). Le fufu était un peu sec mais la sauce était bonne. Je réessaierai.',
        'like': 5,
      },
      {
        'name': 'Yao M.',
        'avatar': '🧑🏾',
        'rating': 5,
        'date': 'Il y a 1 sem',
        'comment':
            'Le meilleur poulet braisé du campus ! Mama Afi cuisine avec amour, ça se sent. 💯',
        'like': 24,
      },
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LightCard(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '4.8',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: LightPageColors.text,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '/ 5',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: LightPageColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: i < 4
                                ? LightPageColors.warning
                                : LightPageColors.warning.withValues(
                                    alpha: 0.4,
                                  ),
                          );
                        }),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Basé sur 327 avis',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: LightPageColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      for (int i = 5; i >= 1; i--) ...[
                        Row(
                          children: [
                            Text(
                              '$i',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: LightPageColors.muted,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: LightPageColors.border,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: i == 5
                                      ? 0.82
                                      : i == 4
                                      ? 0.12
                                      : i == 3
                                      ? 0.04
                                      : 0.01,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: LightPageColors.warning,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (i != 1) const SizedBox(height: 4),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LightSectionTitle(title: 'Avis récents', action: 'Tous voir'),
          const SizedBox(height: 6),
          ...reviews.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LightCard(
                padding: const EdgeInsets.all(14),
                borderRadius: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: LightPageColors.indigoLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            r['avatar'] as String,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r['name'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: LightPageColors.text,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                r['date'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: LightPageColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            r['rating'] as int,
                            (_) => const Icon(
                              Icons.star_rounded,
                              size: 11,
                              color: LightPageColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      r['comment'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: LightPageColors.text2,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: LightPageColors.indigoLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 11,
                                color: LightPageColors.indigo,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${r['like']}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: LightPageColors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.reply_outlined,
                          size: 14,
                          color: LightPageColors.muted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Répondre',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: LightPageColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar() {
    final hasItems = _customTotal > 0;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        border: const Border(
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
                  child: const Icon(
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
                        '${_baseQty + _eggQty + _sausageQty + _fishQty + _chickenQty}',
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
                    hasItems ? '$_customTotal FCFA' : 'Choisis ton plat',
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
                text: hasItems ? 'Ajouter au panier' : 'Composer',
                icon: hasItems
                    ? Icons.add_shopping_cart_rounded
                    : Icons.restaurant_menu_rounded,
                onPressed: hasItems
                    ? () {
                        context.push('/cart');
                      }
                    : () => _tabController.animateTo(0),
              ),
            ),
          ],
        ),
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
  final Map<String, dynamic> m;

  const _FixedMenuCard({required this.m});

  @override
  Widget build(BuildContext context) {
    return LightCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 16,
      onTap: () => context.push('/menu-detail'),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    LightPageColors.orange,
                    LightPageColors.orange.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    m['emoji'] as String,
                    style: const TextStyle(fontSize: 42),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 9,
                          color: LightPageColors.text2,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          m['prep'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['name'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: LightPageColors.orangeLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m['tag'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m['desc'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: LightPageColors.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: LightPageColors.warning,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${m['rating']}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: LightPageColors.text2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '${m['price']} FCFA',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: LightPageColors.orange,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: LightPageColors.orange,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: LightPageColors.orange.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
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
