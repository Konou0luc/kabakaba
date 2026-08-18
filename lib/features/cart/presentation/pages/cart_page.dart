import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> _items = [
    {
      'id': 1,
      'name': 'Plat Attiéké + Poisson',
      'canteen': 'Chez Mama Afi',
      'price': 1500,
      'quantity': 2,
      'image': 'assets/images/plat/plat1.webp',
      'note': 'Piment fort svp',
    },
    {
      'id': 2,
      'name': 'Riz Yassa Poulet',
      'canteen': 'Chez Mama Afi',
      'price': 1800,
      'quantity': 1,
      'image': 'assets/images/plat/plat2.webp',
      'note': null,
    },
    {
      'id': 3,
      'name': 'Spaghetti Bolognaise',
      'canteen': 'Chez Mama Afi',
      'price': 1200,
      'quantity': 1,
      'image': 'assets/images/spaghetti.webp',
      'note': null,
    },
  ];

  final int _userBalance = 5000;

  int get _totalPrice => _items.fold(
        0,
        (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
      );

  bool get _hasEnough => _userBalance >= _totalPrice;

  void _updateQty(int index, int delta) {
    setState(() {
      final newQty = (_items[index]['quantity'] as int) + delta;
      if (newQty <= 0) {
        _items.removeAt(index);
      } else {
        _items[index]['quantity'] = newQty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Mon panier',
      showBackButton: false,
      actions: [
        if (_items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LightBadge(
              text: '${_items.length}',
              bgColor: LightPageColors.orangeLight,
              color: LightPageColors.orange,
            ),
          ),
      ],
      body: _items.isEmpty
          ? _buildEmpty()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Column(
                      children: [
                        _buildCanteenHeader(),
                        const SizedBox(height: 14),
                        ...List.generate(_items.length, (i) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: i == _items.length - 1 ? 0 : 12),
                            child: _buildItem(i).animate().fadeIn(
                                  delay: (50 * i).ms,
                                  begin: 0.8,
                                ),
                          );
                        }),
                        const SizedBox(height: 16),
                        _buildPackagingOption(),
                        const SizedBox(height: 16),
                        _buildSummary(),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: LightPageColors.indigoLight,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 44,
                color: LightPageColors.indigo,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Votre panier est vide',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des plats depuis les cantines de votre campus.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: LightPageColors.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: LightButton(
                text: 'Découvrir les cantines',
                icon: Icons.restaurant_menu_rounded,
                onPressed: () => context.go('/canteen-list'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanteenHeader() {
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: LightPageColors.orangeLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: LightPageColors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chez Mama Afi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '3 plats · UCAO Campus',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const LightBadge(text: 'Ouvert'),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = _items[index];
    return LightCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.asset(
              item['image'] as String,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: LightPageColors.indigoLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: LightPageColors.indigo,
                  size: 26,
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
                  item['name'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${item['price']} tickets',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.orange,
                  ),
                ),
                if (item['note'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '« ${item['note']} »',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: LightPageColors.muted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildQtyControl(index),
        ],
      ),
    );
  }

  Widget _buildQtyControl(int index) {
    final item = _items[index];
    return Container(
      decoration: BoxDecoration(
        color: LightPageColors.bg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: LightPageColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyBtn(Icons.remove_rounded, () => _updateQty(index, -1)),
          Container(
            width: 28,
            alignment: Alignment.center,
            child: Text(
              '${item['quantity']}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
          ),
          _qtyBtn(Icons.add_rounded, () => _updateQty(index, 1)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon, size: 16, color: LightPageColors.text2),
        ),
      ),
    );
  }

  Widget _buildPackagingOption() {
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                color: LightPageColors.indigo,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Options de retrait',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _packagingRow(
            icon: Icons.restaurant_outlined,
            title: 'Sur place',
            subtitle: 'Service en salle — ticket 0',
            price: 0,
            selected: true,
          ),
          const SizedBox(height: 8),
          _packagingRow(
            icon: Icons.takeout_dining_outlined,
            title: 'À emporter',
            subtitle: 'Boîte biodégradable — +100 tickets',
            price: 100,
            selected: false,
          ),
        ],
      ),
    );
  }

  Widget _packagingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required int price,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: selected
            ? LightPageColors.orangeLight.withValues(alpha: 0.6)
            : LightPageColors.bg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: selected
              ? LightPageColors.orange.withValues(alpha: 0.5)
              : LightPageColors.border,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: selected
                  ? LightPageColors.orange.withValues(alpha: 0.18)
                  : LightPageColors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 16,
              color: selected ? LightPageColors.orange : LightPageColors.text2,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: LightPageColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? LightPageColors.orange : LightPageColors.white,
              border: Border.all(
                color: selected
                    ? LightPageColors.orange
                    : LightPageColors.border,
                width: 2,
              ),
            ),
            child: selected
                ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return LightCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _summaryRow('Sous-total', '$_totalPrice tickets'),
          const SizedBox(height: 10),
          _summaryRow('Frais de service', '0 tickets', isFree: true),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: LightPageColors.border,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.text,
                ),
              ),
              Text(
                '$_totalPrice tickets',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: LightPageColors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: LightPageColors.text2,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isFree ? LightPageColors.green : LightPageColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: LightPageColors.white,
        border: Border(
          top: BorderSide(color: LightPageColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: LightPageColors.indigoLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16,
                    color: LightPageColors.indigo,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Solde disponible',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: LightPageColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '$_userBalance tickets',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: _hasEnough
                              ? LightPageColors.green
                              : LightPageColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_hasEnough ? '✓' : '⚠'}  ${(_userBalance - _totalPrice).abs()}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _hasEnough ? LightPageColors.green : LightPageColors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LightButton(
              text: _hasEnough
                  ? 'Payer avec les tickets'
                  : 'Solde insuffisant — Recharger',
              icon: _hasEnough
                  ? Icons.payment_rounded
                  : Icons.add_circle_outline_rounded,
              isPrimary: _hasEnough,
              onPressed: _hasEnough
                  ? () => context.push('/payment')
                  : () => context.push('/recharge/step1'),
            ),
          ],
        ),
      ),
    );
  }
}
