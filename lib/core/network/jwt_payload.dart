import 'dart:convert';

class JwtPayload {
  final Map<String, dynamic> claims;

  const JwtPayload(this.claims);

  static JwtPayload? tryParse(String? token) {
    if (token == null || token.isEmpty) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final normalized = base64Url.normalize(parts[1]);
      final decoded = jsonDecode(utf8.decode(base64Url.decode(normalized)));
      if (decoded is! Map) return null;
      return JwtPayload(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  String? get role {
    final value = claims['role'];
    return value is String ? value.toUpperCase() : null;
  }

  bool get isStudent => role == 'STUDENT';

  DateTime? get expiresAt {
    final exp = claims['exp'];
    if (exp is int) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    }
    if (exp is num) {
      return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true);
    }
    return null;
  }

  bool isExpired({Duration skew = const Duration(seconds: 20)}) {
    final exp = expiresAt;
    if (exp == null) return true;
    return DateTime.now().toUtc().isAfter(exp.subtract(skew));
  }
}
