import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_payload.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/models/api_models.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<UserModel> createUser({
    String? phone,
    String? email,
    String? password,
    required String firstName,
    required String lastName,
    String? avatarUrl,
    String? campusId,
    bool? notifyOrders,
    bool? notifyAmbassador,
    bool? notifyPromotions,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.users,
      data: {
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        'firstName': firstName,
        'lastName': lastName,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        if (campusId != null) 'campusId': campusId,
        if (notifyOrders != null) 'notifyOrders': notifyOrders,
        if (notifyAmbassador != null) 'notifyAmbassador': notifyAmbassador,
        if (notifyPromotions != null) 'notifyPromotions': notifyPromotions,
      },
    );
    return UserModel.fromJson(unwrapEntity(response.data));
  }

  Future<UserModel> getMe() async {
    final response = await _apiClient.get(ApiEndpoints.usersMe);
    return UserModel.fromJson(unwrapEntity(response.data));
  }

  Future<UserModel> getUserById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.userById(id));
    return UserModel.fromJson(unwrapEntity(response.data));
  }

  Future<PaginatedResponse<UserModel>> findAllUsers({
    int page = 1,
    int limit = 10,
    String? role,
    String? campusId,
    bool? isSuspended,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.users,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (role != null) 'role': role,
        if (campusId != null) 'campusId': campusId,
        if (isSuspended != null) 'isSuspended': isSuspended,
      },
    );
    return PaginatedResponse<UserModel>.fromJson(
      unwrapPage(response.data),
      UserModel.fromJson,
    );
  }

  Future<UserModel> updateUser({
    required String id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? campusId,
    bool? notifyOrders,
    bool? notifyAmbassador,
    bool? notifyPromotions,
    bool? isSuspended,
    DateTime? suspensionUntil,
    String? suspensionReason,
  }) async {
    final response = await _apiClient.patch(
      ApiEndpoints.userById(id),
      data: {
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        if (campusId != null) 'campusId': campusId,
        if (notifyOrders != null) 'notifyOrders': notifyOrders,
        if (notifyAmbassador != null) 'notifyAmbassador': notifyAmbassador,
        if (notifyPromotions != null) 'notifyPromotions': notifyPromotions,
        if (isSuspended != null) 'isSuspended': isSuspended,
        if (suspensionUntil != null)
          'suspensionUntil': suspensionUntil.toIso8601String(),
        if (suspensionReason != null) 'suspensionReason': suspensionReason,
      },
    );
    return UserModel.fromJson(unwrapEntity(response.data));
  }

  Future<String> uploadAvatar(String filePath) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _apiClient.post(
      ApiEndpoints.usersMeAvatar,
      data: form,
    );
    final json = unwrapEntity(response.data);
    return json['url'] as String? ??
        json['avatarUrl'] as String? ??
        '';
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
});
