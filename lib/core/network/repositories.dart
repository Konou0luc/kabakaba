import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_payload.dart';
import '../../../shared/models/api_models.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository(this._apiClient);

  Future<OrderModel> createOrder({
    required String vendorId,
    required List<Map<String, dynamic>> items,
    required String consumptionMode,
    String? takeawayOptionId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.orders,
      data: {
        'vendorId': vendorId,
        'items': items,
        'consumptionMode': consumptionMode,
        if (takeawayOptionId != null) 'takeawayOptionId': takeawayOptionId,
      },
    );
    return OrderModel.fromJson(unwrapEntity(response.data));
  }

  Future<PaginatedResponse<OrderModel>> findAllOrders({
    int page = 1,
    int limit = 10,
    String? status,
    String? statuses,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.orders,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (statuses != null) 'statuses': statuses,
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

  Future<OrderModel> cancelOrder(String id, {String? reason}) async {
    final response = await _apiClient.post(
      ApiEndpoints.orderCancel(id),
      data: {
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      },
    );
    final map = unwrapEntity(response.data);
    final nested = map['order'];
    if (nested is Map) {
      return OrderModel.fromJson(Map<String, dynamic>.from(nested));
    }
    return OrderModel.fromJson(map);
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrderRepository(apiClient);
});

class CatalogRepository {
  final ApiClient _apiClient;

  CatalogRepository(this._apiClient);

  Future<List<MenuModel>> findMenus(String vendorId) async {
    final response = await _apiClient.get(ApiEndpoints.menusByVendor(vendorId));
    return parseListResponse(response.data, MenuModel.fromJson);
  }

  Future<List<ComponentModel>> findComponents(String vendorId) async {
    final response =
        await _apiClient.get(ApiEndpoints.componentsByVendor(vendorId));
    return parseListResponse(response.data, ComponentModel.fromJson);
  }

  Future<List<ComponentCategoryModel>> findComponentCategories(
    String vendorId,
  ) async {
    final response = await _apiClient
        .get(ApiEndpoints.componentCategoriesByVendor(vendorId));
    return parseListResponse(response.data, ComponentCategoryModel.fromJson);
  }

  Future<List<TakeawayOptionModel>> findTakeawayOptions(String vendorId) async {
    final response = await _apiClient.get(
      ApiEndpoints.takeawayOptionsByVendor(vendorId),
      queryParameters: {'page': 1, 'limit': 50},
    );
    return PaginatedResponse<TakeawayOptionModel>.fromJson(
      unwrapPage(response.data),
      TakeawayOptionModel.fromJson,
    ).data;
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CatalogRepository(apiClient);
});

class ReportRepository {
  final ApiClient _apiClient;

  ReportRepository(this._apiClient);

  Future<ReportModel> createReport({
    required String orderId,
    required String type,
    String? comment,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.reports,
      data: {
        'orderId': orderId,
        'type': type,
        if (comment != null && comment.trim().isNotEmpty)
          'comment': comment.trim(),
      },
    );
    return ReportModel.fromJson(unwrapEntity(response.data));
  }

  Future<PaginatedResponse<ReportModel>> findMyReports({
    int page = 1,
    int limit = 20,
    String? orderId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.reports,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (orderId != null) 'orderId': orderId,
      },
    );
    return PaginatedResponse<ReportModel>.fromJson(
      unwrapPage(response.data),
      ReportModel.fromJson,
    );
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportRepository(apiClient);
});

class ScheduledOrderRepository {
  final ApiClient _apiClient;

  ScheduledOrderRepository(this._apiClient);

  Future<ScheduledOrderModel> create({
    required String vendorId,
    required String scheduledFor,
    required List<Map<String, dynamic>> items,
    required String consumptionMode,
    String? takeawayOptionId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.scheduledOrders,
      data: {
        'vendorId': vendorId,
        'scheduledFor': scheduledFor,
        'items': items,
        'consumptionMode': consumptionMode,
        if (takeawayOptionId != null) 'takeawayOptionId': takeawayOptionId,
      },
    );
    return ScheduledOrderModel.fromJson(unwrapEntity(response.data));
  }

  Future<PaginatedResponse<ScheduledOrderModel>> findAll({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.scheduledOrders,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      },
    );
    return PaginatedResponse<ScheduledOrderModel>.fromJson(
      unwrapPage(response.data),
      ScheduledOrderModel.fromJson,
    );
  }

  Future<ScheduledOrderModel> getById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.scheduledOrderById(id));
    return ScheduledOrderModel.fromJson(unwrapEntity(response.data));
  }

  Future<ScheduledOrderModel> cancel(String id) async {
    final response =
        await _apiClient.post(ApiEndpoints.scheduledOrderCancel(id));
    return ScheduledOrderModel.fromJson(unwrapEntity(response.data));
  }
}

final scheduledOrderRepositoryProvider =
    Provider<ScheduledOrderRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ScheduledOrderRepository(apiClient);
});

class ReferralRepository {
  final ApiClient _apiClient;

  ReferralRepository(this._apiClient);

  Future<ReferralMeModel> getMine() async {
    final response = await _apiClient.get(ApiEndpoints.referralsMe);
    return ReferralMeModel.fromJson(unwrapEntity(response.data));
  }
}

final referralRepositoryProvider = Provider<ReferralRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReferralRepository(apiClient);
});

class TransactionRepository {
  final ApiClient _apiClient;

  TransactionRepository(this._apiClient);

  Future<PaginatedResponse<TransactionModel>> findAllTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.transactions,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (type != null) 'type': type,
        if (status != null) 'status': status,
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

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  /// Preview : tickets souhaités (recommandé) ou montant payé.
  Future<RechargeQuote> previewRecharge({
    int? ticketsDesired,
    int? amountFcfa,
  }) async {
    final data = <String, dynamic>{};
    if (ticketsDesired != null) {
      data['ticketsDesired'] = ticketsDesired;
    } else if (amountFcfa != null) {
      data['amountFcfa'] = amountFcfa;
    } else {
      throw ArgumentError('ticketsDesired ou amountFcfa requis');
    }
    final response = await _apiClient.post(
      ApiEndpoints.paymentsPreview,
      data: data,
    );
    return RechargeQuote.fromJson(unwrapEntity(response.data));
  }

  Future<({PaymentModel payment, RechargeQuote recap})> createPaymentIntent({
    int? ticketsReceived,
    int? amountFcfa,
    required String operator,
  }) async {
    final data = <String, dynamic>{'operator': operator};
    if (ticketsReceived != null) {
      data['ticketsReceived'] = ticketsReceived;
    } else if (amountFcfa != null) {
      data['amountFcfa'] = amountFcfa;
    } else {
      throw ArgumentError('ticketsReceived ou amountFcfa requis');
    }
    final response = await _apiClient.post(
      ApiEndpoints.paymentsIntent,
      data: data,
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

class DeviceRepository {
  final ApiClient _apiClient;

  DeviceRepository(this._apiClient);

  Future<void> register({
    required String deviceToken,
    required String platform,
  }) async {
    await _apiClient.post(
      ApiEndpoints.devices,
      data: {'deviceToken': deviceToken, 'platform': platform},
    );
  }

  Future<void> unregister(String deviceToken) async {
    try {
      await _apiClient.delete(
        ApiEndpoints.devices,
        queryParameters: {'deviceToken': deviceToken},
      );
    } catch (_) {}
  }
}

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DeviceRepository(apiClient);
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
