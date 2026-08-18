import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
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
      response.data as Map<String, dynamic>,
      VendorModel.fromJson,
    );
  }

  Future<VendorModel> getVendorById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.vendorById(id));
    return VendorModel.fromJson(response.data as Map<String, dynamic>);
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
      response.data as Map<String, dynamic>,
      CampusModel.fromJson,
    );
  }

  Future<CampusModel> getCampusById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.campusById(id));
    return CampusModel.fromJson(response.data as Map<String, dynamic>);
  }
}

final campusRepositoryProvider = Provider<CampusRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CampusRepository(apiClient);
});
