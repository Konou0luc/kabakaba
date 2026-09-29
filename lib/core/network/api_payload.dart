Map<String, dynamic> asJsonMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  throw FormatException('Réponse JSON inattendue: $raw');
}

/// Entité seule : `{id:…}` ou enveloppe `{data:{id:…}}`.
Map<String, dynamic> unwrapEntity(dynamic raw) {
  final map = asJsonMap(raw);
  final data = map['data'];
  if (data is Map && map['id'] == null && map['accessToken'] == null) {
    return Map<String, dynamic>.from(data);
  }
  return map;
}

Map<String, dynamic> unwrapPage(dynamic raw) => asJsonMap(raw);
