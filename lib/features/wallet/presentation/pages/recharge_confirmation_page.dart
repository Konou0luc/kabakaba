import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../core/utils/ticket_format.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class RechargeConfirmationPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  const RechargeConfirmationPage({super.key, required this.data});

  @override
  ConsumerState<RechargeConfirmationPage> createState() =>
      _RechargeConfirmationPageState();
}

class _RechargeConfirmationPageState
    extends ConsumerState<RechargeConfirmationPage> {
  PaymentStatus _status = PaymentStatus.PENDING;
  Timer? _poll;
  DateTime? _startedAt;
  bool _timeoutShown = false;

  String get _paymentId => widget.data['paymentId'] as String? ?? '';
  int get _amount => (widget.data['amountFcfa'] as num?)?.toInt() ?? 0;
  int get _tickets => (widget.data['ticketsReceived'] as num?)?.toInt() ?? 0;
  int get _fee => (widget.data['feeFcfa'] as num?)?.toInt() ?? 0;
  String get _operator => widget.data['operator'] as String? ?? 'FLOOZ';

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _pollStatus();
    _poll = Timer.periodic(const Duration(seconds: 4), (_) => _pollStatus());
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _pollStatus() async {
    if (_paymentId.isEmpty) return;
    try {
      final payment = await ref
          .read(paymentRepositoryProvider)
          .getPaymentById(_paymentId);
      if (!mounted) return;
      setState(() => _status = payment.status);
      if (payment.status != PaymentStatus.PENDING) {
        _poll?.cancel();
        ref.invalidate(meProvider);
        ref.invalidate(myTransactionsProvider);
      } else if (_startedAt != null &&
          DateTime.now().difference(_startedAt!) >
              const Duration(seconds: 90) &&
          !_timeoutShown) {
        _timeoutShown = true;
        _poll?.cancel();
        showKabaSnack(
          context,
          'Toujours en attente. Vérifie Flooz / Mixx, ou réessaie plus tard.',
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final success = _status == PaymentStatus.SUCCESS;
    final failed = _status == PaymentStatus.FAILED;
    final title = success
        ? 'Recharge réussie'
        : failed
            ? 'Paiement échoué'
            : 'Valide sur ton téléphone';
    final subtitle = success
        ? 'Tes tickets ont été crédités.'
        : failed
            ? 'Le paiement a été refusé ou annulé. Tu peux réessayer.'
            : 'Confirme la demande Flooz / Mixx. Les tickets arriveront ensuite.';

    return LightPageScaffold(
      title: title,
      showBackButton: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            Icon(
              success
                  ? Icons.check_circle_rounded
                  : failed
                      ? Icons.error_outline_rounded
                      : Icons.phone_android_rounded,
              size: 72,
              color: success
                  ? LightPageColors.green
                  : failed
                      ? LightPageColors.red
                      : LightPageColors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: LightPageColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: LightPageColors.muted,
              ),
            ),
            const SizedBox(height: 24),
            LightCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _row('Statut', success
                      ? 'Confirmé'
                      : failed
                          ? 'Échoué'
                          : 'En attente'),
                  const SizedBox(height: 10),
                  _row('Opérateur', _operator == 'MIXX' ? 'Mixx' : 'Flooz'),
                  const SizedBox(height: 10),
                  _row('Payé', '${formatTickets(_amount)} FCFA'),
                  const SizedBox(height: 10),
                  _row('Frais inclus', '${formatTickets(_fee)} FCFA'),
                  const SizedBox(height: 10),
                  _row('Tickets', formatTickets(_tickets), emphasize: true),
                  if (_paymentId.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _row('Référence', _paymentId.substring(0, 8).toUpperCase()),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: LightButton(
                text: success ? 'Retour au portefeuille' : 'Voir le portefeuille',
                onPressed: () => context.go('/wallet'),
              ),
            ),
            if (failed) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.go('/recharge/step1'),
                child: const Text('Réessayer'),
              ),
            ],
          ],
        ),
      ),
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
