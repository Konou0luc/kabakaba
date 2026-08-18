import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
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
    required int totalTickets,
    required double escrowAmount,
    String? packagingOptionId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.orders,
      data: {
        'vendorId': vendorId,
        'totalTickets': totalTickets,
        'escrowAmount': escrowAmount,
        if (packagingOptionId != null) 'packagingOptionId': packagingOptionId,
      },
    );
    return OrderModel.fromJson(response.data as Map<String, dynamic>);
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
      response.data as Map<String, dynamic>,
      OrderModel.fromJson,
    );
  }

  Future<OrderModel> getOrderById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.orderById(id));
    return OrderModel.fromJson(response.data as Map<String, dynamic>);
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
      response.data as Map<String, dynamic>,
      MenuItemModel.fromJson,
    );
  }

  Future<MenuItemModel> getMenuItemById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.catalogMenuItemById(id));
    return MenuItemModel.fromJson(response.data as Map<String, dynamic>);
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
      response.data as Map<String, dynamic>,
      TransactionModel.fromJson,
    );
  }

  Future<TransactionModel> getTransactionById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.transactionById(id));
    return TransactionModel.fromJson(response.data as Map<String, dynamic>);
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TransactionRepository(apiClient);
});

class AmbassadorRepository {
  final ApiClient _apiClient;

  AmbassadorRepository(this._apiClient);

  Future<AmbassadorModel> getMyAmbassadorProfile() async {
    final response = await _apiClient.get(ApiEndpoints.ambassadorsMe);
    return AmbassadorModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AmbassadorModel> getAmbassadorById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.ambassadorById(id));
    return AmbassadorModel.fromJson(response.data as Map<String, dynamic>);
  }
}

final ambassadorRepositoryProvider = Provider<AmbassadorRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AmbassadorRepository(apiClient);
});

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required int ticketsReceived,
    required String operator,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.paymentsIntent,
      data: {
        'amount': amount,
        'ticketsReceived': ticketsReceived,
        'operator': operator,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> initiatePayment({
    required String paymentId,
    required String phoneNumber,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.paymentInitiate(paymentId),
      data: {'phoneNumber': phoneNumber},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<PaginatedResponse<Map<String, dynamic>>> findAllPayments({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.payments,
      queryParameters: {'page': page, 'limit': limit},
    );
    return PaginatedResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );
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
      response.data as Map<String, dynamic>,
      NotificationModel.fromJson,
    );
  }

  Future<NotificationModel> getNotificationById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.notificationById(id));
    return NotificationModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<NotificationModel> updateNotification({
    required String id,
    bool? isRead,
  }) async {
    final response = await _apiClient.patch(
      ApiEndpoints.notificationById(id),
      data: {
        if (isRead != null) 'isRead': isRead,
      },
    );
    return NotificationModel.fromJson(response.data as Map<String, dynamic>);
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRepository(apiClient);
});
