import 'package:flutter/material.dart';
import 'referral_page.dart';

/// Données d’ancienne candidature — conservé pour compat routes.
class AmbassadorApplicationData {
  const AmbassadorApplicationData();

  factory AmbassadorApplicationData.fromMap(Map<String, dynamic> map) =>
      const AmbassadorApplicationData();
}

class AmbassadorConditionsPage extends StatelessWidget {
  const AmbassadorConditionsPage({super.key});

  @override
  Widget build(BuildContext context) => const ReferralProgramPage();
}

class AmbassadorPromoCodePage extends StatelessWidget {
  final AmbassadorApplicationData applicationData;

  const AmbassadorPromoCodePage({super.key, required this.applicationData});

  @override
  Widget build(BuildContext context) => const ReferralProgramPage();
}

class AmbassadorRecapPage extends StatelessWidget {
  final AmbassadorApplicationData applicationData;

  const AmbassadorRecapPage({super.key, required this.applicationData});

  @override
  Widget build(BuildContext context) => const ReferralProgramPage();
}

class AmbassadorPendingPage extends StatelessWidget {
  final String promoCode;

  const AmbassadorPendingPage({super.key, required this.promoCode});

  @override
  Widget build(BuildContext context) => const ReferralProgramPage();
}
