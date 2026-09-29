import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../core/utils/phone_e164.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class RechargeStep3Page extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  const RechargeStep3Page({super.key, required this.data});

  @override
  ConsumerState<RechargeStep3Page> createState() => _RechargeStep3PageState();
}

class _RechargeStep3PageState extends ConsumerState<RechargeStep3Page> {
  String _operator = 'FLOOZ';
  late final TextEditingController _phone;
  bool _paying = false;

  int get _amount => (widget.data['amountFcfa'] as num?)?.toInt() ?? 0;
  int get _tickets => (widget.data['ticketsReceived'] as num?)?.toInt() ?? 0;
  int get _fee => (widget.data['feeFcfa'] as num?)?.toInt() ?? 0;

  @override
  void initState() {
    super.initState();
    final user = ref.read(meProvider).valueOrNull ?? ref.read(currentUserProvider);
    _phone = TextEditingController(
      text: user?.phone != null ? formatTogoDisplay(user!.phone!) : '',
    );
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    final phone = toTogoE164(_phone.text);
    if (phone.length < 12) {
      showKabaSnack(context, 'Indique le numéro Mobile Money.', error: true);
      return;
    }
    setState(() => _paying = true);
    try {
      final repo = ref.read(paymentRepositoryProvider);
      final created = await repo.createPaymentIntent(
        amountFcfa: _amount,
        operator: _operator,
      );
      await repo.initiatePayment(
        paymentId: created.payment.id,
        phoneNumber: phone,
      );
      if (!mounted) return;
      context.pushReplacement('/recharge/confirmation', extra: {
        'paymentId': created.payment.id,
        'amountFcfa': created.recap.amountFcfa,
        'ticketsReceived': created.recap.ticketsReceived,
        'feeFcfa': created.recap.feeFcfa,
        'operator': _operator,
        'phone': phone,
      });
    } catch (error) {
      if (mounted) showKabaSnack(context, apiErrorMessage(error), error: true);
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: 'Paiement Mobile Money',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stepBar(),
            const SizedBox(height: 16),
            LightCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _row('Montant débité', '${formatTickets(_amount)} FCFA'),
                  const SizedBox(height: 8),
                  _row('Frais inclus', '${formatTickets(_fee)} FCFA'),
                  const SizedBox(height: 8),
                  _row(
                    'Tickets crédités',
                    formatTickets(_tickets),
                    emphasize: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Opérateur',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _operatorTile('FLOOZ', 'Moov Flooz', Icons.phone_android_rounded),
            const SizedBox(height: 10),
            _operatorTile('MIXX', 'Mixx by Yas', Icons.sim_card_rounded),
            const SizedBox(height: 20),
            Text(
              'Numéro qui paie',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: LightPageColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LightPageColors.border),
              ),
              child: TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: LightPageColors.text,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixText: '+228  ',
                  prefixStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: LightPageColors.text,
                  ),
                  hintText: '90 12 34 56',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: LightPageColors.muted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const LightHintBox(
              text:
                  'Tu vas recevoir une demande de paiement sur ce numéro. Valide-la pour créditer tes tickets.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: LightButton(
                text: _paying
                    ? 'Envoi en cours…'
                    : 'Payer ${formatTickets(_amount)} FCFA',
                icon: Icons.lock_rounded,
                onPressed: _paying ? null : _pay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _operatorTile(String value, String label, IconData icon) {
    final selected = _operator == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _operator = value),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? LightPageColors.orangeLight
                : LightPageColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? LightPageColors.orange : LightPageColors.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: LightPageColors.indigo),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: LightPageColors.text,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? LightPageColors.orange : LightPageColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepBar() {
    return Row(
      children: [
        ...List.generate(3, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == 2 ? 0 : 8),
              height: 4,
              decoration: BoxDecoration(
                color: LightPageColors.orange,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
        const SizedBox(width: 12),
        LightBadge(
          text: 'Étape 3/3',
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
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
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
