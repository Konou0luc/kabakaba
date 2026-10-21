import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class RechargeStep2SelfPage extends ConsumerStatefulWidget {
  const RechargeStep2SelfPage({super.key});

  @override
  ConsumerState<RechargeStep2SelfPage> createState() =>
      _RechargeStep2SelfPageState();
}

class _RechargeStep2SelfPageState extends ConsumerState<RechargeStep2SelfPage> {
  /// Tickets souhaités (frais ajoutés côté serveur → montant à payer).
  static const _presets = [500, 1000, 2000, 5000, 9000];
  static const _minTickets = 400;
  static const _maxTickets = 9500;
  int? _selectedTickets;
  final _customController = TextEditingController();
  RechargeQuote? _quote;
  bool _loadingQuote = false;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  int get _tickets =>
      _selectedTickets ?? (int.tryParse(_customController.text) ?? 0);

  Future<void> _refreshQuote() async {
    final tickets = _tickets;
    if (tickets < _minTickets || tickets > _maxTickets) {
      setState(() => _quote = null);
      return;
    }
    setState(() => _loadingQuote = true);
    try {
      final quote = await ref
          .read(paymentRepositoryProvider)
          .previewRecharge(ticketsDesired: tickets);
      if (mounted) setState(() => _quote = quote);
    } catch (error) {
      if (!mounted) return;
      setState(() => _quote = null);
      showKabaSnack(context, apiErrorMessage(error), error: true);
    } finally {
      if (mounted) setState(() => _loadingQuote = false);
    }
  }

  void _continue() {
    if (_quote == null) {
      showKabaSnack(
        context,
        'Choisis les tickets que tu veux recevoir (400 à 9 500).',
        error: true,
      );
      return;
    }
    context.push('/recharge/step3', extra: {
      'amountFcfa': _quote!.amountFcfa,
      'ticketsReceived': _quote!.ticketsReceived,
      'feeFcfa': _quote!.feeFcfa,
    });
  }

  @override
  Widget build(BuildContext context) {
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final name = [
      user?.firstName,
      user?.lastName,
    ].where((part) => part != null && part.isNotEmpty).join(' ');

    return LightPageScaffold(
      title: 'Tickets à créditer',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stepBar(2),
            const SizedBox(height: 16),
            LightCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: LightPageColors.indigoLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: LightPageColors.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'Mon portefeuille' : name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: LightPageColors.text,
                          ),
                        ),
                        Text(
                          user?.phone ?? 'Tickets crédités sur ce compte',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: LightPageColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  LightBadge(text: formatTickets(user?.walletBalance ?? 0)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tickets à recevoir. Les frais s’ajoutent au paiement.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: LightPageColors.muted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tickets souhaités',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.25,
              children: List.generate(_presets.length, (i) {
                final tickets = _presets[i];
                final selected = _selectedTickets == tickets;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTickets = tickets;
                        _customController.clear();
                      });
                      _refreshQuote();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? LightPageColors.orangeLight
                            : LightPageColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? LightPageColors.orange
                              : LightPageColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatTickets(tickets),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: selected
                                  ? LightPageColors.orange
                                  : LightPageColors.text,
                            ),
                          ),
                          Text(
                            'tickets',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: LightPageColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (30 * i).ms, begin: 0.8),
                );
              }),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _customController,
              keyboardType: TextInputType.number,
              onChanged: (_) {
                setState(() => _selectedTickets = null);
                _refreshQuote();
              },
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: LightPageColors.text,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: LightPageColors.white,
                hintText: 'Tickets personnalisés (400 à 9 500)',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: LightPageColors.muted,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: LightPageColors.border,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: LightPageColors.border,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: LightPageColors.orange,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            if (_loadingQuote) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_quote != null) ...[
              const SizedBox(height: 16),
              LightCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _row(
                      'Tickets crédités',
                      formatTickets(_quote!.ticketsReceived),
                    ),
                    const SizedBox(height: 8),
                    _row(
                      'Frais de service',
                      '${formatTickets(_quote!.feeFcfa)} FCFA',
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    _row(
                      'Tu paies',
                      '${formatTickets(_quote!.amountFcfa)} FCFA',
                      emphasize: true,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: LightButton(
                text: _quote == null
                    ? 'Continuer vers le paiement'
                    : 'Payer ${formatTickets(_quote!.amountFcfa)} FCFA',
                icon: Icons.arrow_forward_rounded,
                isPrimary: _quote != null,
                onPressed: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBar(int step) {
    return Row(
      children: [
        ...List.generate(3, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == 2 ? 0 : 8),
              height: 4,
              decoration: BoxDecoration(
                color: i < step ? LightPageColors.orange : LightPageColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
        const SizedBox(width: 12),
        LightBadge(
          text: 'Étape $step/3',
          bgColor: LightPageColors.orangeLight,
          color: LightPageColors.orange,
        ),
      ],
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: LightPageColors.text2,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: emphasize ? 16 : 12.5,
            fontWeight: FontWeight.w800,
            color: emphasize ? LightPageColors.orange : LightPageColors.text,
          ),
        ),
      ],
    );
  }
}
