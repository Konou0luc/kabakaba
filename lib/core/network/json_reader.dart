class PayloadException implements Exception {
  final String message;
  const PayloadException(this.message);

  @override
  String toString() => 'PayloadException: $message';
}

extension JsonReader on Map<String, dynamic> {
  String requireString(String key) {
    final value = this[key];
    if (value is String && value.isNotEmpty) return value;
    throw PayloadException('Champ "$key" attendu comme texte, reçu : $value');
  }

  String? optionalString(String key) {
    final value = this[key];
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    return value.toString();
  }

  String stringOr(String key, String fallback) =>
      optionalString(key) ?? fallback;

  double decimalOr(String key, double fallback) =>
      _decimalOrNull(this[key]) ?? fallback;

  int intOr(String key, int fallback) => _intOrNull(this[key]) ?? fallback;

  bool boolOr(String key, bool fallback) {
    final value = this[key];
    if (value is bool) return value;
    if (value is String) {
      if (value == 'true') return true;
      if (value == 'false') return false;
    }
    return fallback;
  }

  DateTime? optionalDateTime(String key) {
    final value = this[key];
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  DateTime dateTimeOrNow(String key) => optionalDateTime(key) ?? DateTime.now();

  Map<String, dynamic>? nested(String key) {
    final value = this[key];
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  List<Map<String, dynamic>> nestedList(String key) {
    final value = this[key];
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}

double? _decimalOrNull(Object? value) => switch (value) {
  final num value => value.toDouble(),
  final String value => double.tryParse(value),
  _ => null,
};

int? _intOrNull(Object? value) => switch (value) {
  final int value => value,
  final num value => value.round(),
  final String value => int.tryParse(value) ?? double.tryParse(value)?.round(),
  _ => null,
};
