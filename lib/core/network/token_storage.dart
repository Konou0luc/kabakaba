import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/theme_provider.dart';

class TokenStorage {
  final SharedPreferences _prefs;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _authenticatedAtKey = 'authenticated_at_ms';
  static const Duration pinSessionTtl = Duration(days: 7);

  TokenStorage(this._prefs);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
    await _prefs.setString(_userIdKey, userId);
  }

  /// Démarre les 7 jours de session — uniquement après PIN / OTP, pas au refresh.
  Future<void> markAuthenticated() async {
    await _prefs.setInt(
      _authenticatedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Première lecture après mise à jour : pose l'horloge sans reculer.
  Future<void> ensureAuthenticatedStamp() async {
    if (!hasTokens() || _prefs.containsKey(_authenticatedAtKey)) return;
    await markAuthenticated();
  }

  String? getAccessToken() => _prefs.getString(_accessTokenKey);
  String? getRefreshToken() => _prefs.getString(_refreshTokenKey);
  String? getUserId() => _prefs.getString(_userIdKey);

  bool hasTokens() {
    final accessToken = getAccessToken();
    final refreshToken = getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  /// Session locale : 7 jours après la dernière saisie du PIN / OTP.
  bool isSessionFresh() {
    if (!hasTokens()) return false;
    final stamped = _prefs.getInt(_authenticatedAtKey);
    if (stamped == null) return true;
    final age = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(stamped),
    );
    return age < pinSessionTtl;
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_authenticatedAtKey);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TokenStorage(prefs);
});
