import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int _quantity = 1;
  bool _isFavorite = false;
  int? _proteinSelected = 0;
  final Set<int> _extrasSelected = {0, 2};
  int? _spiceLevel = 1;

  final _proteins = const [
    {'label': 'Poisson frais', 'price': 0, 'emoji': '🐟'},
    {'label': 'Poulet braisé', 'price': 100, 'emoji': '🍗'},
    {'label': 'Viande de bœuf', 'price': 150, 'emoji': '🥩'},
    {'label': 'Chèvre', 'price': 200, 'emoji': '🐐'},
  ];

  final _extras = const [
    {'label': 'Alloco', 'price': 300, 'emoji': '🍌'},
    {'label': 'Plantain', 'price': 250, 'emoji': '🍠'},
    {'label': 'Salade', 'price': 200, 'emoji': '🥗'},
    {'label': 'Avocat', 'price': 200, 'emoji': '🥑'},
    {'label': 'Oignons frits', 'price': 80, 'emoji': '🧅'},
    {'label': 'Piments', 'price': 50, 'emoji': '🌶️'},
  ];

  final _spices = const [
    {'label': 'Sans piment', 'emoji': '😇', 'level': 0},
    {'label': 'Doux', 'emoji': '🙂', 'level': 1},
    {'label': 'Moyen', 'emoji': '😋', 'level': 2},
    {'label': 'Fort', 'emoji': '🥵', 'level': 3},
  ];

  int get _proteinPrice => _proteinSelected != null
      ? _proteins[_proteinSelected!]['price'] as int
      : 0;

  int get _extrasPrice =>
      _extrasSelected.fold(0, (s, i) => s + (_extras[i]['price'] as int));

  int get _subtotal => 1200 + _proteinPrice + _extrasPrice;
  int get _total => _subtotal * _quantity;

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
      bottomNavigationBar: _buildStickyBottomBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCover(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildMenuHeader(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildChefCard(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LightSectionTitle(
                title: 'Choix de la protéine',
                subtitle: 'Incluse dans le prix',
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildProteinsGrid(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LightSectionTitle(
                title: 'Extras & accompagnements',
                subtitle: 'Sélection multiple',
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildExtrasGrid(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LightSectionTitle(title: 'Niveau de piment'),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSpiceLevel(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LightSectionTitle(
                title: 'Note pour la cuisine',
                subtitle: 'Allergies, préférences…',
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildNoteInput(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFAB70), Color(0xFFFFB88C), Color(0xFFFFF5ED)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 60),
                const Text('🥘', style: TextStyle(fontSize: 100)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        size: 11,
                        color: LightPageColors.indigo,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Chez Mama Afi · Cantine',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Plat Attiéké Deluxe',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: LightPageColors.text,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: LightPageColors.orangeLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '🔥 Best-seller',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.orange,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Attiéké frais, poisson braisé, sauce pimentée maison',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: LightPageColors.muted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: LightPageColors.warning,
                ),
                const SizedBox(width: 3),
                Text(
                  '4.9',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  '(128 avis)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                color: LightPageColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: LightPageColors.indigo,
                ),
                const SizedBox(width: 3),
                Text(
                  '15-20 min',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.indigo,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '1 200 FCFA',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: LightPageColors.orange,
                decoration: TextDecoration.lineThrough,
                decorationColor: LightPageColors.muted.withValues(alpha: 0.6),
                decorationThickness: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: LightPageColors.greenLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '-15% OFFRE SPECIALE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: LightPageColors.green,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              '${(1200 * 0.85).round()} FCFA',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: LightPageColors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChefCard() {
    return LightCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 14,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Text('👩🏾‍🍳', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Préparé par Mama Afi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Chef propriétaire · 6 ans d\'expérience',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: LightPageColors.greenLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 12,
                  color: LightPageColors.green,
                ),
                const SizedBox(width: 3),
                Text(
                  'Vérifié',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProteinsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemCount: _proteins.length,
      itemBuilder: (context, i) {
        final p = _proteins[i];
        final selected = _proteinSelected == i;
        final extra = p['price'] as int;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _proteinSelected = i),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? LightPageColors.indigo.withValues(alpha: 0.05)
                    : LightPageColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? LightPageColors.indigo
                      : LightPageColors.border,
                  width: selected ? 1.8 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: LightPageColors.indigo.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Text(
                    p['emoji'] as String,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          p['label'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          extra == 0 ? 'Inclus' : '+$extra FCFA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: extra == 0
                                ? LightPageColors.green
                                : LightPageColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: selected
                          ? LightPageColors.indigo
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? LightPageColors.indigo
                            : LightPageColors.border,
                        width: 1.8,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 11,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExtrasGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemCount: _extras.length,
      itemBuilder: (context, i) {
        final e = _extras[i];
        final selected = _extrasSelected.contains(i);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() {
              if (selected) {
                _extrasSelected.remove(i);
              } else {
                _extrasSelected.add(i);
              }
            }),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? LightPageColors.orange.withValues(alpha: 0.06)
                    : LightPageColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? LightPageColors.orange
                      : LightPageColors.border,
                  width: selected ? 1.6 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    e['emoji'] as String,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          e['label'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: LightPageColors.text,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '+${e['price']} FCFA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: selected
                          ? LightPageColors.orange
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: selected
                            ? LightPageColors.orange
                            : LightPageColors.border,
                        width: 1.6,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpiceLevel() {
    return Row(
      children: List.generate(_spices.length, (i) {
        final s = _spices[i];
        final selected = _spiceLevel == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == _spices.length - 1 ? 0 : 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _spiceLevel = i),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? i == 0
                              ? LightPageColors.greenLight
                              : i == 1
                              ? LightPageColors.indigoLight
                              : i == 2
                              ? LightPageColors.warningLight
                              : LightPageColors.redLight
                        : LightPageColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? i == 0
                                ? LightPageColors.green
                                : i == 1
                                ? LightPageColors.indigo
                                : i == 2
                                ? LightPageColors.warning
                                : LightPageColors.red
                          : LightPageColors.border,
                      width: selected ? 1.6 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        s['emoji'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        s['label'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: selected
                              ? i == 0
                                    ? LightPageColors.green
                                    : i == 1
                                    ? LightPageColors.indigo
                                    : i == 2
                                    ? LightPageColors.warning
                                    : LightPageColors.red
                              : LightPageColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      decoration: BoxDecoration(
        color: LightPageColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LightPageColors.border, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: TextField(
        maxLines: 3,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: LightPageColors.text,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: 'Ex: Sans gluten, bien cuit, sauce séparée, sans oignons…',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: LightPageColors.muted,
          ),
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Icon(
              Icons.edit_note_rounded,
              size: 18,
              color: LightPageColors.muted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar() {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LightPageColors.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildPriceRow(
                    'Prix de base',
                    '${(1200 * 0.85).round()} FCFA',
                  ),
                  const SizedBox(height: 5),
                  _buildPriceRow('Protéine', '+$_proteinPrice FCFA'),
                  const SizedBox(height: 5),
                  _buildPriceRow(
                    'Extras (${_extrasSelected.length})',
                    '+$_extrasPrice FCFA',
                  ),
                  if (_quantity > 1) ...[
                    const SizedBox(height: 5),
                    _buildPriceRow('Quantité', '× $_quantity'),
                  ],
                  const SizedBox(height: 8),
                  Container(height: 1, color: LightPageColors.border),
                  const SizedBox(height: 8),
                  _buildPriceRow(
                    'Total',
                    '$_total FCFA',
                    isBold: true,
                    valueColor: LightPageColors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: LightPageColors.indigoLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: LightPageColors.indigo.withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _qtyBtn(
                        Icons.remove_rounded,
                        _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          '$_quantity',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: LightPageColors.indigo,
                          ),
                        ),
                      ),
                      _qtyBtn(
                        Icons.add_rounded,
                        () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LightButton(
                    text: 'Ajouter au panier',
                    icon: Icons.add_shopping_cart_rounded,
                    onPressed: () {
                      context.push('/cart');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback? cb) {
    final enabled = cb != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: cb,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 36,
          height: 38,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 17,
            color: enabled ? LightPageColors.indigo : LightPageColors.muted,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isBold ? 12 : 11,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? LightPageColors.text : LightPageColors.text2,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isBold ? 16 : 11,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: valueColor ?? LightPageColors.text,
          ),
        ),
      ],
    );
  }
}
