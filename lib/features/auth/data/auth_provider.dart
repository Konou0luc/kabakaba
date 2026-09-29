import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/session_invalidation.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/models/auth_models.dart';
import 'auth_repository.dart';

enum AuthState { loading, authenticated, unauthenticated, error }

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  UserModel? _currentUser;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  @override
  AuthState build() {
    AuthNotifier._active = this;
    kabaOnSessionInvalid = AuthNotifier._onSessionInvalid;
    ref.onDispose(() {
      if (AuthNotifier._active == this) {
        AuthNotifier._active = null;
      }
    });
    Future.microtask(() async {
      await _authRepository.discardNonStudentSession();
      if (state != _checkAuthStatus()) {
        state = _checkAuthStatus();
      }
    });
    return _checkAuthStatus();
  }

  static AuthNotifier? _active;

  static void _onSessionInvalid() {
    _active?.expireSession();
  }

  void expireSession() {
    if (_authRepository.isAuthenticated()) return;
    _currentUser = null;
    if (state != AuthState.unauthenticated) {
      state = AuthState.unauthenticated;
    }
  }

  AuthState _checkAuthStatus() {
    final isAuthenticated = _authRepository.isAuthenticated();
    return isAuthenticated
        ? AuthState.authenticated
        : AuthState.unauthenticated;
  }

  Future<void> sendOtp({required String phone}) async {
    _errorMessage = null;
    try {
      await _authRepository.sendOtp(phone: phone);
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      rethrow;
    }
  }

  Future<AuthResponse?> verifyOtp({
    required String phone,
    required String code,
    String? campusId,
    String? referralCode,
  }) async {
    _errorMessage = null;
    try {
      final response = await _authRepository.verifyOtp(
        phone: phone,
        code: code,
        campusId: campusId,
        referralCode: referralCode,
      );
      _currentUser = response.user;
      state = AuthState.authenticated;
      return response;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      state = AuthState.error;
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<AuthResponse?> loginEmail({
    required String email,
    required String password,
  }) async {
    _errorMessage = null;
    try {
      final response = await _authRepository.loginEmail(
        email: email,
        password: password,
      );
      _currentUser = response.user;
      state = AuthState.authenticated;
      return response;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      state = AuthState.error;
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<void> logout() async {
    _errorMessage = null;
    try {
      await _authRepository.logout();
    } catch (e) {
      // Ignore cleanup failure during logout; still clear local auth state.
      _errorMessage = _extractErrorMessage(e);
    } finally {
      _currentUser = null;
      state = AuthState.unauthenticated;
    }
  }

  Future<void> hydrateUser(UserModel user) async {
    _currentUser = user;
    state = AuthState.authenticated;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _errorMessage = null;
    try {
      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      rethrow;
    }
  }

  void updateCurrentUser(UserModel user) {
    _currentUser = user;
    state = AuthState.authenticated;
  }

  String _extractErrorMessage(dynamic error) {
    try {
      final message = error?.response?.data?['message'];
      if (message is String) return message;
      if (message is List) return message.join(', ');
    } catch (_) {}
    return error?.toString() ?? 'Une erreur est survenue';
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  return authNotifier.currentUser;
});

final authErrorProvider = Provider<String?>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  return authNotifier.errorMessage;
});
