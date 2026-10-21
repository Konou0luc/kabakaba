import 'package:flutter/services.dart';

String toTogoLocalDigits(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  final local = digits.startsWith('228') && digits.length > 3
      ? digits.substring(3)
      : digits;
  return local.length > 8 ? local.substring(0, 8) : local;
}

String toTogoE164(String raw) {
  return '+228${toTogoLocalDigits(raw)}';
}

/// Format d’envoi initiate selon l’opérateur :
/// - FLOOZ → `+228XXXXXXXX`
/// - MIXX  → `XXXXXXXX` (sans 228, doc FedaPay togocel)
String toMobileMoneyPhone(String raw, String operator) {
  final local = toTogoLocalDigits(raw);
  if (operator.toUpperCase() == 'MIXX') return local;
  return '+228$local';
}

String formatTogoDisplay(String raw) {
  final local = toTogoLocalDigits(raw);
  if (local.length <= 2) return local;
  if (local.length <= 4)
    return '${local.substring(0, 2)} ${local.substring(2)}';
  if (local.length <= 6) {
    return '${local.substring(0, 2)} ${local.substring(2, 4)} ${local.substring(4)}';
  }
  return '${local.substring(0, 2)} ${local.substring(2, 4)} ${local.substring(4, 6)} ${local.substring(6)}';
}

class TogoPhoneInputFormatter extends TextInputFormatter {
  const TogoPhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = formatTogoDisplay(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
