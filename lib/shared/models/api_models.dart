import '../../core/network/json_reader.dart';

enum VendorCapacity { OPEN, BUSY, CLOSED }

VendorCapacity vendorCapacityFromJson(String value) {
  switch (value.toUpperCase()) {
    case 'OPEN':
      return VendorCapacity.OPEN;
    case 'BUSY':
      return VendorCapacity.BUSY;
    default:
      return VendorCapacity.CLOSED;
  }
}

class VendorModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? userId;
  final String canteenName;
  final String? logoUrl;
  final String? bannerUrl;
  final String? description;
  final bool isActive;
  final VendorCapacity capacityStatus;

  VendorModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.userId,
    required this.canteenName,
    this.logoUrl,
    this.bannerUrl,
    this.description,
    required this.isActive,
    required this.capacityStatus,
  });

  /// Accepts immediate orders.
  bool get acceptsOrders =>
      isActive && capacityStatus == VendorCapacity.OPEN;

  /// Display “ouverte” for OPEN (BUSY is still “busy”, CLOSED closed).
  bool get isOpen => capacityStatus == VendorCapacity.OPEN;

  String get capacityLabel => switch (capacityStatus) {
        VendorCapacity.OPEN => 'Ouverte',
        VendorCapacity.BUSY => 'Occupée',
        VendorCapacity.CLOSED => 'Fermée',
      };

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        userId: json.optionalString('userId'),
        canteenName: json.stringOr('canteenName', 'Cantine'),
        logoUrl: json.optionalString('logoUrl'),
        bannerUrl: json.optionalString('bannerUrl'),
        description: json.optionalString('description'),
        isActive: json.boolOr('isActive', true),
        capacityStatus: vendorCapacityFromJson(
          json.stringOr(
            'capacityStatus',
            json.boolOr('isOpen', false) ? 'OPEN' : 'CLOSED',
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        if (userId != null) 'userId': userId,
        'canteenName': canteenName,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (bannerUrl != null) 'bannerUrl': bannerUrl,
        if (description != null) 'description': description,
        'isActive': isActive,
        'capacityStatus': capacityStatus.name,
      };
}

class CampusModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String city;
  final String institution;
  final bool isActive;

  CampusModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.city,
    required this.institution,
    required this.isActive,
  });

  factory CampusModel.fromJson(Map<String, dynamic> json) => CampusModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        name: json.stringOr('name', 'Campus'),
        city: json.stringOr('city', ''),
        institution: json.stringOr('institution', ''),
        isActive: json.boolOr('isActive', true),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        'name': name,
        'city': city,
        'institution': institution,
        'isActive': isActive,
      };
}

enum OrderStatus {
  CONFIRMED,
  IN_PREPARATION,
  READY,
  RECEIVED,
  CANCELLED,
}

OrderStatus orderStatusFromJson(String value) {
  switch (value.toUpperCase()) {
    case 'IN_PREPARATION':
      return OrderStatus.IN_PREPARATION;
    case 'READY':
      return OrderStatus.READY;
    case 'RECEIVED':
      return OrderStatus.RECEIVED;
    case 'CANCELLED':
      return OrderStatus.CANCELLED;
    case 'CONFIRMED':
    default:
      return OrderStatus.CONFIRMED;
  }
}

bool orderIsActive(OrderStatus status) =>
    status == OrderStatus.CONFIRMED ||
    status == OrderStatus.IN_PREPARATION ||
    status == OrderStatus.READY;

bool orderIsHistory(OrderStatus status) =>
    status == OrderStatus.RECEIVED || status == OrderStatus.CANCELLED;

String orderStatusToJson(OrderStatus status) => status.name;

enum ConsumptionMode { ON_SITE, TAKEAWAY }

ConsumptionMode consumptionModeFromJson(String value) =>
    value.toUpperCase() == 'TAKEAWAY'
        ? ConsumptionMode.TAKEAWAY
        : ConsumptionMode.ON_SITE;

class OrderLinePreview {
  final String name;
  final int quantity;
  final String? menuId;
  final String? componentId;
  final String? imageUrl;
  final int priceTickets;

  const OrderLinePreview({
    required this.name,
    required this.quantity,
    this.menuId,
    this.componentId,
    this.imageUrl,
    this.priceTickets = 0,
  });
}

class OrderModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String studentId;
  final String vendorId;
  final String vendorName;
  final OrderStatus status;
  final String? orderNumber;
  final int totalTickets;
  final int takeawayFeeTickets;
  final ConsumptionMode consumptionMode;
  final String? takeawayOptionId;
  final String? takeawayOptionName;
  final String? cancellationReason;
  final String? cancelledBy;
  final DateTime? readyAt;
  final DateTime? receivedAt;
  final DateTime? cancelledAt;
  final DateTime? unclaimedAt;
  final int refundedTickets;
  final bool hasReview;
  final List<OrderLinePreview> items;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.studentId,
    required this.vendorId,
    required this.vendorName,
    required this.status,
    this.orderNumber,
    required this.totalTickets,
    this.takeawayFeeTickets = 0,
    this.consumptionMode = ConsumptionMode.ON_SITE,
    this.takeawayOptionId,
    this.takeawayOptionName,
    this.cancellationReason,
    this.cancelledBy,
    this.readyAt,
    this.receivedAt,
    this.cancelledAt,
    this.unclaimedAt,
    this.refundedTickets = 0,
    this.hasReview = false,
    this.items = const [],
  });

  /// Numéro affiché (A-00). Jamais l’identifiant base.
  String get displayCode {
    final code = orderNumber?.trim();
    if (code != null && code.isNotEmpty) return code.toUpperCase();
    return '—';
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final vendor = json.nested('vendor');
    final takeaway = json.nested('takeawayOption');
    final rawItems = json.nestedList('items');
    return OrderModel(
      id: json.requireString('id'),
      createdAt: json.dateTimeOrNow('createdAt'),
      updatedAt: json.dateTimeOrNow('updatedAt'),
      deletedAt: json.optionalDateTime('deletedAt'),
      studentId: json.stringOr('studentId', ''),
      vendorId: json.stringOr('vendorId', ''),
      vendorName:
          vendor?.stringOr('canteenName', 'Cantine') ??
          json.stringOr('vendorName', 'Cantine'),
      status: orderStatusFromJson(json.stringOr('status', 'CONFIRMED')),
      orderNumber: json.optionalString('orderNumber'),
      totalTickets: json.intOr('totalTickets', 0),
      takeawayFeeTickets: json.intOr('takeawayFeeTickets', 0),
      consumptionMode: consumptionModeFromJson(
        json.stringOr('consumptionMode', 'ON_SITE'),
      ),
      takeawayOptionId: json.optionalString('takeawayOptionId'),
      takeawayOptionName: takeaway?.optionalString('name'),
      cancellationReason: json.optionalString('cancellationReason') ??
          json.optionalString('reason'),
      cancelledBy: json.optionalString('cancelledBy'),
      readyAt: json.optionalDateTime('readyAt'),
      receivedAt: json.optionalDateTime('receivedAt'),
      cancelledAt: json.optionalDateTime('cancelledAt'),
      unclaimedAt: json.optionalDateTime('unclaimedAt'),
      refundedTickets: json.intOr('refundedTickets', 0),
      hasReview: json.nested('review') != null,
      items: rawItems.map((item) {
        return OrderLinePreview(
          menuId: item.optionalString('menuId'),
          componentId: item.optionalString('componentId'),
          name: item.stringOr('name', 'Article'),
          quantity: item.intOr('quantity', 1),
          imageUrl: item.optionalString('imageUrl'),
          priceTickets: item.intOr('unitPrice', item.intOr('priceTickets', 0)),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        'studentId': studentId,
        'vendorId': vendorId,
        'vendorName': vendorName,
        'status': orderStatusToJson(status),
        if (orderNumber != null) 'orderNumber': orderNumber,
        'totalTickets': totalTickets,
        'takeawayFeeTickets': takeawayFeeTickets,
        'consumptionMode': consumptionMode.name,
        if (takeawayOptionId != null) 'takeawayOptionId': takeawayOptionId,
        if (cancellationReason != null)
          'cancellationReason': cancellationReason,
      };
}

class MenuLineModel {
  final String componentId;
  final String name;
  final String unit;
  final int quantity;

  const MenuLineModel({
    required this.componentId,
    required this.name,
    required this.unit,
    required this.quantity,
  });

  factory MenuLineModel.fromJson(Map<String, dynamic> json) => MenuLineModel(
        componentId: json.stringOr('componentId', ''),
        name: json.stringOr('name', 'Composant'),
        unit: json.stringOr('unit', 'PORTION'),
        quantity: json.intOr('quantity', 1),
      );
}

class MissingComponentModel {
  final String id;
  final String name;

  const MissingComponentModel({required this.id, required this.name});

  factory MissingComponentModel.fromJson(Map<String, dynamic> json) =>
      MissingComponentModel(
        id: json.stringOr('id', ''),
        name: json.stringOr('name', ''),
      );
}

/// Precomposed menu (GET /menus/:vendorId).
class MenuModel {
  final String id;
  final String? vendorId;
  final String name;
  final String? description;
  final int priceTickets;
  final bool available;
  final List<MissingComponentModel> missingComponents;
  final List<MenuLineModel> lines;

  MenuModel({
    required this.id,
    this.vendorId,
    required this.name,
    this.description,
    required this.priceTickets,
    required this.available,
    this.missingComponents = const [],
    this.lines = const [],
  });

  bool get isAvailable => available;

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        id: json.requireString('id'),
        vendorId: json.optionalString('vendorId'),
        name: json.stringOr('name', 'Menu'),
        description: json.optionalString('description'),
        priceTickets: json.intOr('priceTickets', 0),
        available: json.boolOr('available', json.boolOr('isAvailable', true)),
        missingComponents: json
            .nestedList('missingComponents')
            .map(MissingComponentModel.fromJson)
            .toList(),
        lines: json.nestedList('lines').map(MenuLineModel.fromJson).toList(),
      );
}

/// Public component (GET /components/:vendorId) — no quantity.
class ComponentModel {
  final String id;
  final String name;
  final String? categoryId;
  final String unit;
  final int priceTickets;
  final bool available;
  final bool soldAlone;

  ComponentModel({
    required this.id,
    required this.name,
    this.categoryId,
    required this.unit,
    required this.priceTickets,
    required this.available,
    this.soldAlone = false,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) => ComponentModel(
        id: json.requireString('id'),
        name: json.stringOr('name', 'Composant'),
        categoryId: json.optionalString('categoryId'),
        unit: json.stringOr('unit', 'PORTION'),
        priceTickets: json.intOr('priceTickets', 0),
        available: json.boolOr('available', true),
        soldAlone: json.boolOr('soldAlone', false),
      );
}

class ComponentCategoryModel {
  final String id;
  final String vendorId;
  final String name;

  ComponentCategoryModel({
    required this.id,
    required this.vendorId,
    required this.name,
  });

  factory ComponentCategoryModel.fromJson(Map<String, dynamic> json) =>
      ComponentCategoryModel(
        id: json.requireString('id'),
        vendorId: json.stringOr('vendorId', ''),
        name: json.stringOr('name', 'Catégorie'),
      );
}

class TakeawayOptionModel {
  final String id;
  final String vendorId;
  final String name;
  final int priceTickets;
  final bool isActive;

  TakeawayOptionModel({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.priceTickets,
    required this.isActive,
  });

  factory TakeawayOptionModel.fromJson(Map<String, dynamic> json) =>
      TakeawayOptionModel(
        id: json.requireString('id'),
        vendorId: json.stringOr('vendorId', ''),
        name: json.stringOr('name', 'À emporter'),
        priceTickets: json.intOr('priceTickets', 0),
        isActive: json.boolOr('isActive', true),
      );
}

class ReferralMeModel {
  final String referralCode;
  final int referredCount;
  final int rewardedCount;
  final int totalRewardTickets;

  const ReferralMeModel({
    required this.referralCode,
    required this.referredCount,
    required this.rewardedCount,
    required this.totalRewardTickets,
  });

  factory ReferralMeModel.fromJson(Map<String, dynamic> json) =>
      ReferralMeModel(
        referralCode: json.stringOr('referralCode', ''),
        referredCount: json.intOr('referredCount', 0),
        rewardedCount: json.intOr('rewardedCount', 0),
        totalRewardTickets: json.intOr('totalRewardTickets', 0),
      );
}

enum ReportType {
  WRONG_MEAL,
  MISSING_COMPONENT,
  INCOMPLETE_ORDER,
  OTHER,
}

ReportType reportTypeFromJson(String value) => ReportType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => ReportType.OTHER,
    );

enum ReportStatus { OPEN, IN_PROGRESS, RESOLVED }

ReportStatus reportStatusFromJson(String value) =>
    ReportStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => ReportStatus.OPEN,
    );

class ReportModel {
  final String id;
  final String orderId;
  final String studentId;
  final String vendorId;
  final ReportType type;
  final String? comment;
  final ReportStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  ReportModel({
    required this.id,
    required this.orderId,
    required this.studentId,
    required this.vendorId,
    required this.type,
    this.comment,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json.requireString('id'),
        orderId: json.stringOr('orderId', ''),
        studentId: json.stringOr('studentId', ''),
        vendorId: json.stringOr('vendorId', ''),
        type: reportTypeFromJson(json.stringOr('type', 'OTHER')),
        comment: json.optionalString('comment'),
        status: reportStatusFromJson(json.stringOr('status', 'OPEN')),
        createdAt: json.dateTimeOrNow('createdAt'),
        resolvedAt: json.optionalDateTime('resolvedAt'),
      );
}

enum ScheduledOrderStatus { PENDING, PLACED, FAILED, CANCELLED }

ScheduledOrderStatus scheduledOrderStatusFromJson(String value) =>
    ScheduledOrderStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => ScheduledOrderStatus.PENDING,
    );

class ScheduledOrderModel {
  final String id;
  final String studentId;
  final String vendorId;
  final String vendorName;
  final DateTime scheduledFor;
  final ConsumptionMode consumptionMode;
  final String? takeawayOptionId;
  final ScheduledOrderStatus status;
  final String? orderId;
  final String? failureReason;
  final DateTime? processedAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final List<Map<String, dynamic>> items;

  ScheduledOrderModel({
    required this.id,
    required this.studentId,
    required this.vendorId,
    required this.vendorName,
    required this.scheduledFor,
    required this.consumptionMode,
    this.takeawayOptionId,
    required this.status,
    this.orderId,
    this.failureReason,
    this.processedAt,
    this.cancelledAt,
    required this.createdAt,
    this.items = const [],
  });

  factory ScheduledOrderModel.fromJson(Map<String, dynamic> json) {
    final vendor = json.nested('vendor');
    final rawItems = json['items'];
    return ScheduledOrderModel(
      id: json.requireString('id'),
      studentId: json.stringOr('studentId', ''),
      vendorId: json.stringOr('vendorId', ''),
      vendorName: vendor?.stringOr('canteenName', 'Cantine') ?? 'Cantine',
      scheduledFor: json.dateTimeOrNow('scheduledFor'),
      consumptionMode: consumptionModeFromJson(
        json.stringOr('consumptionMode', 'ON_SITE'),
      ),
      takeawayOptionId: json.optionalString('takeawayOptionId'),
      status: scheduledOrderStatusFromJson(json.stringOr('status', 'PENDING')),
      orderId: json.optionalString('orderId'),
      failureReason: json.optionalString('failureReason'),
      processedAt: json.optionalDateTime('processedAt'),
      cancelledAt: json.optionalDateTime('cancelledAt'),
      createdAt: json.dateTimeOrNow('createdAt'),
      items: rawItems is List
          ? [
              for (final item in rawItems.whereType<Map>())
                Map<String, dynamic>.from(item),
            ]
          : const [],
    );
  }
}

class RechargeQuote {
  final int amountFcfa;
  final int ticketsReceived;
  final int feeFcfa;
  final bool exact;
  final List<String> summaryLines;

  const RechargeQuote({
    required this.amountFcfa,
    required this.ticketsReceived,
    required this.feeFcfa,
    required this.exact,
    this.summaryLines = const [],
  });

  factory RechargeQuote.fromJson(Map<String, dynamic> json) => RechargeQuote(
        amountFcfa: json.intOr('amountFcfa', 0),
        ticketsReceived: json.intOr('ticketsReceived', 0),
        feeFcfa: json.intOr('feeFcfa', 0),
        exact: json.boolOr('exact', true),
        summaryLines: ((json['summaryLines'] ?? json['lines']) as List<dynamic>?)
                ?.map((line) => line.toString())
                .toList() ??
            const [],
      );
}

enum PaymentStatus { PENDING, SUCCESS, FAILED }

PaymentStatus paymentStatusFromJson(String value) =>
    PaymentStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => PaymentStatus.PENDING,
    );

class PaymentModel {
  final String id;
  final String operator;
  final int amountFcfa;
  final int ticketsReceived;
  final PaymentStatus status;
  final String? fedapayReference;

  PaymentModel({
    required this.id,
    required this.operator,
    required this.amountFcfa,
    required this.ticketsReceived,
    required this.status,
    this.fedapayReference,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json.requireString('id'),
        operator: json.stringOr('operator', 'FLOOZ'),
        amountFcfa: json.intOr('amountFcfa', 0),
        ticketsReceived: json.intOr('ticketsReceived', 0),
        status: paymentStatusFromJson(json.stringOr('status', 'PENDING')),
        fedapayReference: json.optionalString('fedapayReference'),
      );
}

enum TransactionType {
  DEPOSIT,
  PAYMENT,
  SALE,
  REFUND,
  WITHDRAWAL,
  REFERRAL_BONUS,
}

TransactionType transactionTypeFromJson(String value) {
  switch (value.toUpperCase()) {
    case 'DEPOSIT':
    case 'RECHARGE':
      return TransactionType.DEPOSIT;
    case 'PAYMENT':
    case 'ORDER_PAYMENT':
      return TransactionType.PAYMENT;
    case 'SALE':
      return TransactionType.SALE;
    case 'REFUND':
    case 'ORDER_REFUND':
      return TransactionType.REFUND;
    case 'WITHDRAWAL':
    case 'PAYOUT':
      return TransactionType.WITHDRAWAL;
    case 'REFERRAL_BONUS':
    case 'COMMISSION':
      return TransactionType.REFERRAL_BONUS;
    default:
      return TransactionType.DEPOSIT;
  }
}

String transactionTypeToJson(TransactionType type) => type.name;

enum TransactionStatus { PENDING, COMPLETED, FAILED, CANCELLED }

TransactionStatus transactionStatusFromJson(String value) =>
    TransactionStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => TransactionStatus.PENDING,
    );

String transactionStatusToJson(TransactionStatus status) => status.name;

bool _opaqueId(String value) {
  return RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-',
    caseSensitive: false,
  ).hasMatch(value.trim());
}

class TransactionModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String userId;
  final TransactionType type;
  final int amount;
  final TransactionStatus status;
  final String? reference;
  final String? description;
  final String? orderNumber;
  final String? counterpartyUserId;
  final String? orderId;
  final String? metadata;

  TransactionModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.userId,
    required this.type,
    required this.amount,
    required this.status,
    this.reference,
    this.description,
    this.orderNumber,
    this.counterpartyUserId,
    this.orderId,
    this.metadata,
  });

  /// Libellé lisible. Jamais l’identifiant technique.
  String get publicLabel {
    final code = orderNumber?.trim();
    if (code != null && code.isNotEmpty && !_opaqueId(code)) {
      return code.toUpperCase();
    }
    final ref = reference?.trim();
    if (ref != null && ref.isNotEmpty && !_opaqueId(ref)) return ref;
    return switch (type) {
      TransactionType.DEPOSIT => 'Recharge',
      TransactionType.PAYMENT => 'Commande',
      TransactionType.SALE => 'Vente',
      TransactionType.REFUND => 'Remboursement',
      TransactionType.WITHDRAWAL => 'Retrait',
      TransactionType.REFERRAL_BONUS => 'Bonus',
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        userId: json.stringOr('userId', ''),
        type: transactionTypeFromJson(json.stringOr('type', 'DEPOSIT')),
        amount: json.intOr('amount', 0),
        status: transactionStatusFromJson(json.stringOr('status', 'PENDING')),
        reference: json.optionalString('reference'),
        description: json.optionalString('description'),
        orderNumber: json.optionalString('orderNumber') ??
            json.nested('relatedOrder')?.optionalString('orderNumber'),
        counterpartyUserId: json.optionalString('counterpartyUserId'),
        orderId: json.optionalString('orderId'),
        metadata: json.optionalString('metadata'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        'userId': userId,
        'type': transactionTypeToJson(type),
        'amount': amount,
        'status': transactionStatusToJson(status),
        if (reference != null) 'reference': reference,
        if (description != null) 'description': description,
        if (orderNumber != null) 'orderNumber': orderNumber,
        if (counterpartyUserId != null)
          'counterpartyUserId': counterpartyUserId,
        if (orderId != null) 'orderId': orderId,
        if (metadata != null) 'metadata': metadata,
      };
}

enum NotificationType { INFO, SUCCESS, WARNING, ERROR }

NotificationType notificationTypeFromJson(String value, [String title = '']) {
  switch (value.toUpperCase()) {
    case 'SUCCESS':
      return NotificationType.SUCCESS;
    case 'WARNING':
      return NotificationType.WARNING;
    case 'ERROR':
      return NotificationType.ERROR;
    case 'INFO':
      return NotificationType.INFO;
    default:
      final needle = title.toLowerCase();
      if (needle.contains('prête') ||
          needle.contains('confirmée') ||
          needle.contains('recharge réussie') ||
          needle.contains('remboursement') ||
          needle.contains('bonus')) {
        return NotificationType.SUCCESS;
      }
      if (needle.contains('annul') || needle.contains('non passée')) {
        return NotificationType.WARNING;
      }
      if (needle.contains('échou')) {
        return NotificationType.ERROR;
      }
      return NotificationType.INFO;
  }
}

String notificationTypeToJson(NotificationType type) => type.name;

class NotificationModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final String? relatedId;
  final String? relatedType;

  NotificationModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.relatedId,
    this.relatedType,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        userId: json.stringOr('userId', ''),
        title: json.stringOr('title', 'Notification'),
        body: json.stringOr('body', json.stringOr('message', '')),
        type: notificationTypeFromJson(
          json.stringOr('type', 'INFO'),
          json.stringOr('title', ''),
        ),
        isRead: json.boolOr('isRead', false),
        relatedId: json.optionalString('relatedId'),
        relatedType: json.optionalString('relatedType'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        'userId': userId,
        'title': title,
        'body': body,
        'type': notificationTypeToJson(type),
        'isRead': isRead,
        if (relatedId != null) 'relatedId': relatedId,
        if (relatedType != null) 'relatedType': relatedType,
      };
}

class PaginatedResponse<T> {
  final List<T> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginatedResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final dataList = (json['data'] as List<dynamic>?) ??
        (json['items'] as List<dynamic>?) ??
        [];
    final meta = json['meta'] is Map
        ? Map<String, dynamic>.from(json['meta'] as Map)
        : json;
    return PaginatedResponse<T>(
      data: dataList
          .whereType<Map>()
          .map((e) => itemFromJson(Map<String, dynamic>.from(e)))
          .toList(),
      page: (meta['page'] as num?)?.toInt() ?? 1,
      limit: (meta['limit'] as num?)?.toInt() ?? dataList.length,
      total: (meta['total'] as num?)?.toInt() ?? dataList.length,
      totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Parse a bare JSON array response into typed models.
List<T> parseListResponse<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (raw is List) {
    return raw
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
  if (raw is Map) {
    return PaginatedResponse.fromJson(
      Map<String, dynamic>.from(raw),
      fromJson,
    ).data;
  }
  return const [];
}
