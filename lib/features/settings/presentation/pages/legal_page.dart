import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

enum LegalKind { terms, privacy, mentions, cookies }

class LegalPage extends StatelessWidget {
  final String title;
  final LegalKind kind;

  const LegalPage({super.key, required this.title, required this.kind});

  String get _body => switch (kind) {
        LegalKind.terms => '''
KabaKaba est un portefeuille de tickets pour la restauration sur campus.

Les tickets achetés via Mobile Money (Flooz / Mixx) servent uniquement à payer des commandes chez les cantines partenaires. Ils ne sont pas convertibles en argent.

Une commande peut être annulée tant que le vendeur ne l’a pas acceptée. Une fois acceptée, l’annulation n’est plus possible côté étudiant.

Quand ta commande passe au statut « Prête », tu confirmes le retrait dans l’app. Passé le délai indiqué par le vendeur, la réception peut être confirmée automatiquement.

KabaKaba ne te demandera jamais ton code OTP par appel ou SMS hors de l’application.
''',
        LegalKind.privacy => '''
Nous conservons les données nécessaires au compte étudiant : téléphone, nom, campus, commandes, tickets et notifications.

Ces données servent à authentifier ton compte, exécuter les commandes et les recharges, et t’informer du statut de tes tickets.

Les avis laissés après un retrait sont internes : ils aident kabakaba et le vendeur, ils ne sont pas affichés aux autres étudiants.

Tu peux demander la clôture de ton compte via le centre d’aide. Les obligations légales de conservation des transactions restent applicables.
''',
        LegalKind.mentions => '''
KabaKaba — application étudiante de tickets campus.

Éditeur : projet kabakaba, Lomé, Togo.
Contact : hello@kabakaba.app

Les cantines, menus, soldes et commissions affichés proviennent du serveur kabakaba. Aucun montant n’est inventé côté application.

Version de l’app : 1.0.0
''',
        LegalKind.cookies => '''
KabaKaba n’utilise pas de cookies publicitaires.

Sur mobile, l’app stocke localement le jeton de session et le panier en cours, uniquement pour te reconnecter et retrouver tes articles.

Tu peux vider le panier depuis l’écran Panier. La déconnexion efface la session.
''',
      };

  @override
  Widget build(BuildContext context) {
    return LightPageScaffold(
      title: title,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text(
            _body.trim(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              height: 1.55,
              color: LightPageColors.text2,
            ),
          ),
        ],
      ),
    );
  }
}
