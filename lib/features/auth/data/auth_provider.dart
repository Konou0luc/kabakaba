import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';

class AuthNotifier extends Notifier<bool> {
  static const String _authPrefKey = 'is_logged_in';

  @override
  bool build() {
    return _isLoggedIn();
  }

  bool _isLoggedIn() {
    try {
      final prefs = ref.watch(sharedPreferencesProvider);
      return prefs.getBool(_authPrefKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> login() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool(_authPrefKey, true);
      state = true;
    } catch (e) {
      state = true;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool(_authPrefKey, false);
      state = false;
    } catch (e) {
      state = false;
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
