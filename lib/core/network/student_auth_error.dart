class WrongAppAccountException implements Exception {
  @override
  String toString() =>
      'Ce numéro appartient à une cantine. Utilise l’application vendeur.';
}
