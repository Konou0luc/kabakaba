import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/token_storage.dart';
import '../../../shared/models/auth_models.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository(this._apiClient, this._tokenStorage);

  Future<SendOtpResponse> sendOtp({required String phone}) async {
    final response = await _apiClient.post(
      ApiEndpoints.authSendOtp,
      data: {'phone': phone},
    );
    return SendOtpResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.authVerifyOtp,
      data: {'phone': phone, 'code': code},
    );
    final authResponse = AuthResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    await _tokenStorage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      userId: authResponse.user.id,
    );

    return authResponse;
  }

  Future<AuthResponse> loginEmail({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.authLoginEmail,
      data: {'email': email, 'password': password},
    );
    final authResponse = AuthResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    await _tokenStorage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      userId: authResponse.user.id,
    );

    return authResponse;
  }

  Future<TokensResponse> refreshToken({required String refreshToken}) async {
    final response = await _apiClient.post(
      ApiEndpoints.authRefresh,
      data: {'refreshToken': refreshToken},
    );
    return TokensResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<LogoutResponse> logout() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.authLogout);
      return LogoutResponse.fromJson(response.data as Map<String, dynamic>);
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  Future<SuccessResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.authChangePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
    return SuccessResponse.fromJson(response.data as Map<String, dynamic>);
  }

  bool isAuthenticated() => _tokenStorage.hasTokens();
  String? getCurrentUserId() => _tokenStorage.getUserId();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRepository(apiClient, tokenStorage);
});
