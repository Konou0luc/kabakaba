import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_payload.dart';
import '../../../shared/models/api_models.dart';

class VendorRepository {
  final ApiClient _apiClient;

  VendorRepository(this._apiClient);

  Future<PaginatedResponse<VendorModel>> findAllVendors({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.vendors,
      queryParameters: {'page': page, 'limit': limit},
    );
    return PaginatedResponse<VendorModel>.fromJson(
      unwrapPage(response.data),
      VendorModel.fromJson,
    );
  }

  Future<VendorModel> getVendorById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.vendorById(id));
    return VendorModel.fromJson(unwrapEntity(response.data));
  }
}

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VendorRepository(apiClient);
});

class CampusRepository {
  final ApiClient _apiClient;

  CampusRepository(this._apiClient);

  Future<PaginatedResponse<CampusModel>> findAllCampuses({
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.campuses,
      queryParameters: {'page': page, 'limit': limit},
    );
    return PaginatedResponse<CampusModel>.fromJson(
      unwrapPage(response.data),
      CampusModel.fromJson,
    );
  }

  Future<CampusModel> getCampusById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.campusById(id));
    return CampusModel.fromJson(unwrapEntity(response.data));
  }

  Future<List<FacultyModel>> findFaculties(String campusId) async {
    final response = await _apiClient.get(ApiEndpoints.campusFaculties(campusId));
    final raw = response.data;
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((item) => FacultyModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return PaginatedResponse<FacultyModel>.fromJson(
      unwrapPage(raw),
      FacultyModel.fromJson,
    ).data;
  }
}

final campusRepositoryProvider = Provider<CampusRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CampusRepository(apiClient);
});
