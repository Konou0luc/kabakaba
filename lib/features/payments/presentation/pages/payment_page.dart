import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const PaymentPage({super.key, this.data});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;
  int _selectedMethod = 0;
  bool _useBiometric = false;
  final _promoController = TextEditingController();
  bool _promoApplied = false;

  final int walletBalance = 25000;

  int get _totalPrice => widget.data?['totalPrice'] as int? ?? 3700;
  int get _deliveryFee => 500;
  int get _serviceFee => (_totalPrice * 0.05).round();
  int get _subtotal => _totalPrice + _deliveryFee + _serviceFee;
  int get _promoDiscount => _promoApplied ? (_subtotal * 0.15).round() : 0;
  int get _finalTotal => _subtotal - _promoDiscount;

  final _payMethods = const [
    {
      'name': 'Portefeuille KabaKaba',
      'subtitle': 'Solde disponible',
      'icon': Icons.account_balance_wallet_rounded,
      'tag': 'Recommandé',
      'color': Color(0xFF1B2A6B),
      'bgColor': Color(0xFFEEF1FA),
    },
    {
      'name': 'Moov Money',
      'subtitle': '+228 91 XX XX XX',
      'icon': Icons.phone_android_rounded,
      'tag': null,
      'color': Color(0xFF0E9F6E),
      'bgColor': Color(0xFFF0FDF4),
    },
    {
      'name': 'Togocel Money',
      'subtitle': '+228 90 XX XX XX',
      'icon': Icons.sim_card_rounded,
      'tag': null,
      'color': Color(0xFFDC2626),
      'bgColor': Color(0xFFFEF2F2),
    },
    {
      'name': 'Carte bancaire',
      'subtitle': 'Visa •••• 4242',
      'icon': Icons.credit_card_rounded,
      'tag': 'Nouveau',
      'color': Color(0xFF6366F1),
      'bgColor': Color(0xFFEEF2FF),
    },
  ];

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sufficientBalance = walletBalance >= _finalTotal;
    return LightPageScaffold(
      title: 'Paiement',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: LightIconButton(
            icon: Icons.support_agent_rounded,
            onTap: () => context.push('/help-support'),
          ),
        ),
      ],
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWalletCard(sufficientBalance),
                const SizedBox(height: 18),
                LightSectionTitle(
                  title: 'Méthode de paiement',
                  action: 'Ajouter',
                ),
                const SizedBox(height: 6),
                ...List.generate(_payMethods.length, (i) {
                  final m = _payMethods[i];
                  final selected = _selectedMethod == i;
                  final disabled = i == 0 && !sufficientBalance;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildMethodCard(m, selected, disabled, i),
                  );
                }),
                const SizedBox(height: 18),
                LightSectionTitle(title: 'Code promo'),
                const SizedBox(height: 6),
                _buildPromoInput(),
                const SizedBox(height: 18),
                LightSectionTitle(title: 'Récapitulatif de la commande'),
                const SizedBox(height: 6),
                _buildOrderSummary(),
                const SizedBox(height: 18),
                LightCard(
                  padding: const EdgeInsets.all(12),
                  borderRadius: 14,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: LightPageColors.indigoLight,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.fingerprint_rounded,
                          size: 18,
                          color: LightPageColors.indigo,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paiement biométrique',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.text,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Utiliser l\'empreinte pour confirmer',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: LightPageColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      LightSwitch(
                        value: _useBiometric,
                        onChanged: (v) => setState(() => _useBiometric = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 110),
              ],
            ),
          ),
          _buildStickyCta(sufficientBalance),
        ],
      ),
    );
  }

  Widget _buildWalletCard(bool sufficient) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: sufficient
              ? const [Color(0xFF1B2A6B), Color(0xFF3D4A8E), Color(0xFF6366F1)]
              : const [Color(0xFF475569), Color(0xFF64748B), Color(0xFF94A3B8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (sufficient ? LightPageColors.indigo : LightPageColors.muted)
                .withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Mon portefeuille',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: sufficient
                      ? LightPageColors.green.withValues(alpha: 0.92)
                      : LightPageColors.warning,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      sufficient ? Icons.check_circle : Icons.warning_rounded,
                      size: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sufficient ? 'Solde suffisant' : 'Insuffisant',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Solde disponible',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.72),
              letterSpacing: 0.03,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$walletBalance',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'FCFA',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.push('/recharge-wallet'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Recharger',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.push('/wallet'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.history_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Historique',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildMethodCard(
    Map<String, dynamic> m,
    bool selected,
    bool disabled,
    int index,
  ) {
    final color = m['color'] as Color;
    final bgColor = m['bgColor'] as Color;
    final tag = m['tag'] as String?;
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: LightCard(
        onTap: disabled ? null : () => setState(() => _selectedMethod = index),
        padding: const EdgeInsets.all(13),
        borderRadius: 15,
        border: Border.all(
          color: selected ? LightPageColors.orange : LightPageColors.border,
          width: selected ? 1.8 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: LightPageColors.orange.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(13),
              ),
              alignment: Alignment.center,
              child: Icon(m['icon'] as IconData, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        m['name'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.text,
                        ),
                      ),
                      if (tag != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tag == 'Recommandé'
                                ? LightPageColors.orangeLight
                                : LightPageColors.indigoLight,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              color: tag == 'Recommandé'
                                  ? LightPageColors.orange
                                  : LightPageColors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    index == 0
                        ? '${m['subtitle']} : $walletBalance FCFA'
                        : m['subtitle'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: disabled
                          ? LightPageColors.red
                          : LightPageColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selected ? LightPageColors.orange : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? LightPageColors.orange
                      : LightPageColors.border,
                  width: 1.8,
                ),
              ),
              alignment: Alignment.center,
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoInput() {
    return Container(
      decoration: BoxDecoration(
        color: LightPageColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _promoApplied ? LightPageColors.green : LightPageColors.border,
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            _promoApplied ? Icons.verified_rounded : Icons.local_offer_outlined,
            size: 17,
            color: _promoApplied
                ? LightPageColors.green
                : LightPageColors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _promoController,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: LightPageColors.text,
              ),
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                hintText: _promoApplied
                    ? 'WELCOME15 appliqué ✓'
                    : 'Entrer le code promo',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: _promoApplied
                      ? LightPageColors.green
                      : LightPageColors.muted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _promoApplied
                  ? () => setState(() {
                      _promoApplied = false;
                      _promoController.clear();
                    })
                  : () {
                      final code = _promoController.text.trim().toUpperCase();
                      if (code.isNotEmpty &&
                          ['WELCOME15', 'KABA20', 'ETU10'].contains(code)) {
                        setState(() => _promoApplied = true);
                      }
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _promoApplied
                      ? LightPageColors.redLight
                      : LightPageColors.orange,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _promoApplied
                      ? null
                      : [
                          BoxShadow(
                            color: LightPageColors.orange.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Text(
                  _promoApplied ? 'Retirer' : 'Appliquer',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: _promoApplied ? LightPageColors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final orderItems = [
      {'name': 'Plat Attiéké Deluxe', 'qty': 1, 'price': _totalPrice},
      {'name': 'Frais de livraison', 'qty': null, 'price': _deliveryFee},
      {'name': 'Frais de service (5%)', 'qty': null, 'price': _serviceFee},
    ];
    return LightCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 15,
      child: Column(
        children: [
          ...orderItems.map(
            (o) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          o['name'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: LightPageColors.text2,
                          ),
                        ),
                        if (o['qty'] != null)
                          Text(
                            ' × ${o['qty']}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: LightPageColors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${o['price']} FCFA',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: LightPageColors.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_promoApplied)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer_rounded,
                          size: 12,
                          color: LightPageColors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Remise 15%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: LightPageColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '-$_promoDiscount FCFA',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      color: LightPageColors.green,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 6),
            color: LightPageColors.border,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Total à payer',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: LightPageColors.text,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: LightPageColors.orangeLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_finalTotal FCFA',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: LightPageColors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyCta(bool sufficientBalance) {
    final canPay = sufficientBalance || _selectedMethod != 0;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(context).padding.bottom + 12,
        ),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 1),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$_finalTotal',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: LightPageColors.text,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: Text(
                              'FCFA',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: LightPageColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: LightButton(
                      text: _isLoading
                          ? 'Traitement…'
                          : canPay
                          ? 'Confirmer le paiement'
                          : 'Recharger pour payer',
                      icon: _isLoading
                          ? null
                          : _useBiometric
                          ? Icons.fingerprint_rounded
                          : Icons.lock_outline_rounded,
                      onPressed: _isLoading
                          ? null
                          : canPay
                          ? _doPayment
                          : () => context.push('/recharge-wallet'),
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: 11,
                    color: LightPageColors.muted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Paiement sécurisé via KabaKaba Pay · Chiffré SSL',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: LightPageColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doPayment() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.pushReplacement('/order-history');
  }
}
