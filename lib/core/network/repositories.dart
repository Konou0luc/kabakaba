import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_payload.dart';
import '../../../shared/models/api_models.dart';
import '../../../shared/models/auth_models.dart';

class WalletRepository {
  final ApiClient _apiClient;

  WalletRepository(this._apiClient);

  Future<SuccessResponse> sendMoney({
    required String recipientPhone,
    required int amount,
    String? description,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.walletSend,
      data: {
        'recipientPhone': recipientPhone,
        'amount': amount,
        if (description != null) 'description': description,
      },
    );
    return SuccessResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository(this._apiClient);

  Future<OrderModel> createOrder({
    required String vendorId,
    required List<Map<String, dynamic>> items,
    String? packagingOptionId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.orders,
      data: {
        'vendorId': vendorId,
        'items': items,
        if (packagingOptionId != null) 'packagingOptionId': packagingOptionId,
      },
    );
    return OrderModel.fromJson(unwrapEntity(response.data));
  }

  Future<PaginatedResponse<OrderModel>> findAllOrders({
    int page = 1,
    int limit = 10,
    String? status,
    String? vendorId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.orders,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (vendorId != null) 'vendorId': vendorId,
      },
    );
    return PaginatedResponse<OrderModel>.fromJson(
      unwrapPage(response.data),
      OrderModel.fromJson,
    );
  }

  Future<OrderModel> getOrderById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.orderById(id));
    return OrderModel.fromJson(unwrapEntity(response.data));
  }

  Future<OrderModel> cancelOrder(String id) async {
    final response = await _apiClient.post(ApiEndpoints.orderCancel(id));
    return OrderModel.fromJson(unwrapEntity(response.data));
  }

  Future<OrderModel> confirmReceive(String id) async {
    final response = await _apiClient.post(ApiEndpoints.orderReceive(id));
    return OrderModel.fromJson(unwrapEntity(response.data));
  }

  Future<void> createDispute({
    required String orderId,
    required String type,
    required String description,
  }) async {
    await _apiClient.post(
      ApiEndpoints.orderDispute(orderId),
      data: {
        'type': type,
        'description': description,
      },
    );
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrderRepository(apiClient);
});

class CatalogRepository {
  final ApiClient _apiClient;

  CatalogRepository(this._apiClient);

  Future<PaginatedResponse<MenuItemModel>> findAllMenuItems({
    int page = 1,
    int limit = 50,
    String? vendorId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.catalogMenuItems,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (vendorId != null) 'vendorId': vendorId,
      },
    );
    return PaginatedResponse<MenuItemModel>.fromJson(
      unwrapPage(response.data),
      MenuItemModel.fromJson,
    );
  }

  Future<MenuItemModel> getMenuItemById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.catalogMenuItemById(id));
    return MenuItemModel.fromJson(unwrapEntity(response.data));
  }

  Future<List<MenuComponentModel>> findComponents(String itemId) async {
    final response = await _apiClient.get(
      ApiEndpoints.catalogMenuComponents(itemId),
      queryParameters: {'page': 1, 'limit': 50},
    );
    return PaginatedResponse<MenuComponentModel>.fromJson(
      unwrapPage(response.data),
      MenuComponentModel.fromJson,
    ).data;
  }

  Future<List<PackagingOptionModel>> findPackagingOptions(String itemId) async {
    final response = await _apiClient.get(
      ApiEndpoints.catalogPackagingOptions(itemId),
      queryParameters: {'page': 1, 'limit': 20},
    );
    return PaginatedResponse<PackagingOptionModel>.fromJson(
      unwrapPage(response.data),
      PackagingOptionModel.fromJson,
    ).data;
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CatalogRepository(apiClient);
});

class TransactionRepository {
  final ApiClient _apiClient;

  TransactionRepository(this._apiClient);

  Future<PaginatedResponse<TransactionModel>> findAllTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
    String? userId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.transactions,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (type != null) 'type': type,
        if (status != null) 'status': status,
        if (userId != null) 'userId': userId,
      },
    );
    return PaginatedResponse<TransactionModel>.fromJson(
      unwrapPage(response.data),
      TransactionModel.fromJson,
    );
  }

  Future<TransactionModel> getTransactionById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.transactionById(id));
    return TransactionModel.fromJson(unwrapEntity(response.data));
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TransactionRepository(apiClient);
});

class AmbassadorRepository {
  final ApiClient _apiClient;

  AmbassadorRepository(this._apiClient);

  Future<AmbassadorModel> submitApplication({
    required String institution,
    required String facultyId,
    required String schoolCardUrl,
    String? promoCode,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.ambassadorsApply,
      data: {
        'institution': institution,
        'facultyId': facultyId,
        'schoolCardUrl': schoolCardUrl,
        if (promoCode != null && promoCode.isNotEmpty) 'promoCode': promoCode,
      },
    );
    return AmbassadorModel.fromJson(unwrapEntity(response.data));
  }

  Future<AmbassadorModel?> getMyAmbassadorProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.ambassadorsMe);
      return AmbassadorModel.fromJson(unwrapEntity(response.data));
    } catch (error) {
      final status = (error as dynamic).response?.statusCode;
      if (status == 404) return null;
      rethrow;
    }
  }

  Future<String> uploadSchoolCard(String filePath) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _apiClient.post(
      ApiEndpoints.ambassadorsSchoolCard,
      data: form,
    );
    final json = unwrapEntity(response.data);
    return json['url'] as String? ?? '';
  }
}

final ambassadorRepositoryProvider = Provider<AmbassadorRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AmbassadorRepository(apiClient);
});

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  Future<RechargeQuote> previewRecharge(int amountFcfa) async {
    final response = await _apiClient.post(
      ApiEndpoints.paymentsPreview,
      data: {'amountFcfa': amountFcfa},
    );
    return RechargeQuote.fromJson(unwrapEntity(response.data));
  }

  Future<({PaymentModel payment, RechargeQuote recap})> createPaymentIntent({
    required int amountFcfa,
    required String operator,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.paymentsIntent,
      data: {'amountFcfa': amountFcfa, 'operator': operator},
    );
    final json = unwrapEntity(response.data);
    final paymentJson = json['payment'] is Map
        ? Map<String, dynamic>.from(json['payment'] as Map)
        : json;
    final recapJson = json['recap'] is Map
        ? Map<String, dynamic>.from(json['recap'] as Map)
        : json;
    return (
      payment: PaymentModel.fromJson(paymentJson),
      recap: RechargeQuote.fromJson(recapJson),
    );
  }

  Future<void> initiatePayment({
    required String paymentId,
    required String phoneNumber,
  }) async {
    await _apiClient.post(
      ApiEndpoints.paymentInitiate(paymentId),
      data: {'phoneNumber': phoneNumber},
    );
  }

  Future<PaymentModel> getPaymentById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.paymentById(id));
    return PaymentModel.fromJson(unwrapEntity(response.data));
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PaymentRepository(apiClient);
});

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  Future<PaginatedResponse<NotificationModel>> findAllNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.notifications,
      queryParameters: {'page': page, 'limit': limit},
    );
    return PaginatedResponse<NotificationModel>.fromJson(
      unwrapPage(response.data),
      NotificationModel.fromJson,
    );
  }

  Future<NotificationModel> getNotificationById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.notificationById(id));
    return NotificationModel.fromJson(unwrapEntity(response.data));
  }

  Future<NotificationModel> updateNotification({
    required String id,
    bool? isRead,
  }) async {
    final response = await _apiClient.patch(
      ApiEndpoints.notificationById(id),
      data: {if (isRead != null) 'isRead': isRead},
    );
    return NotificationModel.fromJson(unwrapEntity(response.data));
  }

  Future<void> markAllRead(List<NotificationModel> items) async {
    for (final item in items.where((n) => !n.isRead)) {
      await updateNotification(id: item.id, isRead: true);
    }
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRepository(apiClient);
});

class ReviewRepository {
  final ApiClient _apiClient;

  ReviewRepository(this._apiClient);

  Future<void> createReview({
    required String orderId,
    required String vendorId,
    required int rating,
    String? comment,
  }) async {
    await _apiClient.post(
      ApiEndpoints.reviews,
      data: {
        'orderId': orderId,
        'vendorId': vendorId,
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
  }
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReviewRepository(apiClient);
});
