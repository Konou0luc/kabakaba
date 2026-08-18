import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/theme_provider.dart';

class TokenStorage {
  final SharedPreferences _prefs;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

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

  String? getAccessToken() => _prefs.getString(_accessTokenKey);
  String? getRefreshToken() => _prefs.getString(_refreshTokenKey);
  String? getUserId() => _prefs.getString(_userIdKey);

  bool hasTokens() {
    final accessToken = getAccessToken();
    final refreshToken = getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TokenStorage(prefs);
});
