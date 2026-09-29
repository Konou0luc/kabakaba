import '../../core/network/json_reader.dart';

class VendorModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String userId;
  final String canteenName;
  final String? logoUrl;
  final String? bannerUrl;
  final String? description;
  final double balanceFcfa;
  final double debtFcfa;
  final bool isActive;
  final bool isOpen;

  VendorModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.userId,
    required this.canteenName,
    this.logoUrl,
    this.bannerUrl,
    this.description,
    required this.balanceFcfa,
    required this.debtFcfa,
    required this.isActive,
    required this.isOpen,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        userId: json.stringOr('userId', ''),
        canteenName: json.stringOr('canteenName', 'Cantine'),
        logoUrl: json.optionalString('logoUrl'),
        bannerUrl: json.optionalString('bannerUrl'),
        description: json.optionalString('description'),
        balanceFcfa: json.decimalOr('balanceFcfa', 0),
        debtFcfa: json.decimalOr('debtFcfa', 0),
        isActive: json.boolOr('isActive', true),
        isOpen: json.boolOr('isOpen', false),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        'userId': userId,
        'canteenName': canteenName,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (bannerUrl != null) 'bannerUrl': bannerUrl,
        if (description != null) 'description': description,
        'balanceFcfa': balanceFcfa,
        'debtFcfa': debtFcfa,
        'isActive': isActive,
        'isOpen': isOpen,
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
  PENDING,
  ACCEPTED,
  IN_PREPARATION,
  READY,
  RECEIVED,
  AUTO_RECEIVED,
  REFUSED,
  CANCELLED_VENDOR,
  CANCELLED_STUDENT,
  REFUNDED,
  CONFIRMED,
  REJECTED,
  CANCELLED,
  COMPLETED,
}

OrderStatus orderStatusFromJson(String value) {
  switch (value.toUpperCase()) {
    case 'IN_PREPARATION':
      return OrderStatus.IN_PREPARATION;
    case 'RECEIVED':
      return OrderStatus.RECEIVED;
    case 'AUTO_RECEIVED':
      return OrderStatus.AUTO_RECEIVED;
    case 'REFUSED':
    case 'REJECTED':
      return OrderStatus.REFUSED;
    case 'CANCELLED_VENDOR':
      return OrderStatus.CANCELLED_VENDOR;
    case 'CANCELLED_STUDENT':
    case 'CANCELLED':
      return OrderStatus.CANCELLED_STUDENT;
    case 'REFUNDED':
      return OrderStatus.REFUNDED;
    case 'READY':
      return OrderStatus.READY;
    case 'ACCEPTED':
    case 'CONFIRMED':
      return OrderStatus.ACCEPTED;
    case 'COMPLETED':
      return OrderStatus.RECEIVED;
    default:
      return OrderStatus.PENDING;
  }
}

bool orderIsPending(OrderStatus status) =>
    status == OrderStatus.PENDING || status == OrderStatus.ACCEPTED;

bool orderIsPreparing(OrderStatus status) =>
    status == OrderStatus.IN_PREPARATION || status == OrderStatus.READY;

bool orderIsHistory(OrderStatus status) =>
    status == OrderStatus.RECEIVED ||
    status == OrderStatus.AUTO_RECEIVED ||
    status == OrderStatus.REFUSED ||
    status == OrderStatus.CANCELLED_VENDOR ||
    status == OrderStatus.CANCELLED_STUDENT ||
    status == OrderStatus.REFUNDED ||
    status == OrderStatus.CANCELLED ||
    status == OrderStatus.COMPLETED;

String orderStatusToJson(OrderStatus status) => status.name;

class OrderLinePreview {
  final String name;
  final int quantity;
  final String? menuItemId;
  final String? imageUrl;
  final int priceTickets;

  const OrderLinePreview({
    required this.name,
    required this.quantity,
    this.menuItemId,
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
  final int totalTickets;
  final double escrowAmount;
  final String? packagingOptionId;
  final String? reason;
  final DateTime? readyAt;
  final DateTime? confirmedAt;
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
    required this.totalTickets,
    required this.escrowAmount,
    this.packagingOptionId,
    this.reason,
    this.readyAt,
    this.confirmedAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final vendor = json.nested('vendor');
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
      status: orderStatusFromJson(json.stringOr('status', 'PENDING')),
      totalTickets: json.intOr('totalTickets', 0),
      escrowAmount: json.decimalOr('escrowAmount', 0),
      packagingOptionId: json.optionalString('packagingOptionId'),
      reason: json.optionalString('reason'),
      readyAt: json.optionalDateTime('readyAt'),
      confirmedAt: json.optionalDateTime('confirmedAt'),
      items: rawItems.map((item) {
        final menu = item.nested('menuItem');
        return OrderLinePreview(
          menuItemId:
              item.optionalString('menuItemId') ?? menu?.optionalString('id'),
          name: menu?.stringOr('name', 'Plat') ?? item.stringOr('name', 'Plat'),
          quantity: item.intOr('quantity', 1),
          imageUrl: menu?.optionalString('imageUrl') ??
              item.optionalString('imageUrl'),
          priceTickets: item.intOr(
            'priceTickets',
            menu?.intOr('priceTickets', 0) ?? 0,
          ),
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
        'totalTickets': totalTickets,
        'escrowAmount': escrowAmount,
        if (packagingOptionId != null) 'packagingOptionId': packagingOptionId,
        if (reason != null) 'reason': reason,
        if (readyAt != null) 'readyAt': readyAt!.toIso8601String(),
        if (confirmedAt != null) 'confirmedAt': confirmedAt!.toIso8601String(),
      };
}

class MenuItemModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String vendorId;
  final String name;
  final String? description;
  final int priceTickets;
  final String? imageUrl;
  final bool isAvailable;
  final String? category;
  final String type;

  MenuItemModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.vendorId,
    required this.name,
    this.description,
    required this.priceTickets,
    this.imageUrl,
    required this.isAvailable,
    this.category,
    this.type = 'FIXED',
  });

  bool get isCustomizable => type.toUpperCase() == 'CUSTOMIZABLE';

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        vendorId: json.stringOr('vendorId', ''),
        name: json.stringOr('name', 'Plat'),
        description: json.optionalString('description'),
        priceTickets: json.intOr('priceTickets', 0),
        imageUrl: json.optionalString('imageUrl'),
        isAvailable: json.boolOr('isAvailable', true),
        category: json.optionalString('category'),
        type: json.stringOr('type', 'FIXED'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        'vendorId': vendorId,
        'name': name,
        if (description != null) 'description': description,
        'priceTickets': priceTickets,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'isAvailable': isAvailable,
        if (category != null) 'category': category,
        'type': type,
      };
}

class MenuComponentModel {
  final String id;
  final String itemId;
  final String name;
  final int unitPriceTickets;
  final int minQty;
  final int maxQty;

  MenuComponentModel({
    required this.id,
    required this.itemId,
    required this.name,
    required this.unitPriceTickets,
    required this.minQty,
    required this.maxQty,
  });

  factory MenuComponentModel.fromJson(Map<String, dynamic> json) =>
      MenuComponentModel(
        id: json.requireString('id'),
        itemId: json.stringOr('itemId', ''),
        name: json.stringOr('name', 'Extra'),
        unitPriceTickets: json.intOr('unitPriceTickets', 0),
        minQty: json.intOr('minQty', 0),
        maxQty: json.intOr('maxQty', 10),
      );
}

class PackagingOptionModel {
  final String id;
  final String itemId;
  final String name;
  final int extraCost;
  final bool required;

  PackagingOptionModel({
    required this.id,
    required this.itemId,
    required this.name,
    required this.extraCost,
    required this.required,
  });

  factory PackagingOptionModel.fromJson(Map<String, dynamic> json) =>
      PackagingOptionModel(
        id: json.requireString('id'),
        itemId: json.stringOr('itemId', ''),
        name: json.stringOr('name', 'Emballage'),
        extraCost: json.intOr('extraCost', 0),
        required: json.boolOr('required', false),
      );
}

class FacultyModel {
  final String id;
  final String campusId;
  final String name;
  final bool active;

  FacultyModel({
    required this.id,
    required this.campusId,
    required this.name,
    required this.active,
  });

  factory FacultyModel.fromJson(Map<String, dynamic> json) => FacultyModel(
        id: json.requireString('id'),
        campusId: json.stringOr('campusId', ''),
        name: json.stringOr('name', 'Faculté'),
        active: json.boolOr('active', true),
      );
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
  RECHARGE,
  TRANSFER_SENT,
  TRANSFER_RECEIVED,
  ORDER_PAYMENT,
  ORDER_REFUND,
  COMMISSION,
  PAYOUT,
  ADJUSTMENT,
}

TransactionType transactionTypeFromJson(String value) =>
    TransactionType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => TransactionType.RECHARGE,
    );

String transactionTypeToJson(TransactionType type) => type.name;

enum TransactionStatus { PENDING, COMPLETED, FAILED, CANCELLED }

TransactionStatus transactionStatusFromJson(String value) =>
    TransactionStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => TransactionStatus.PENDING,
    );

String transactionStatusToJson(TransactionStatus status) => status.name;

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
    this.counterpartyUserId,
    this.orderId,
    this.metadata,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        userId: json.stringOr('userId', ''),
        type: transactionTypeFromJson(json.stringOr('type', 'RECHARGE')),
        amount: json.intOr('amount', 0),
        status: transactionStatusFromJson(json.stringOr('status', 'PENDING')),
        reference: json.optionalString('reference'),
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
        if (counterpartyUserId != null)
          'counterpartyUserId': counterpartyUserId,
        if (orderId != null) 'orderId': orderId,
        if (metadata != null) 'metadata': metadata,
      };
}

class AmbassadorModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String userId;
  final String promoCode;
  final int totalReferrals;
  final int totalCommissionEarned;
  final int pendingCommission;
  final int level;
  final String status;

  AmbassadorModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.userId,
    required this.promoCode,
    required this.totalReferrals,
    required this.totalCommissionEarned,
    required this.pendingCommission,
    required this.level,
    required this.status,
  });

  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isActive => status.toUpperCase() == 'ACTIVE';

  factory AmbassadorModel.fromJson(Map<String, dynamic> json) =>
      AmbassadorModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        userId: json.stringOr('userId', ''),
        promoCode: json.stringOr('promoCode', ''),
        totalReferrals: json.intOr('totalReferrals', 0),
        totalCommissionEarned: json.intOr('totalCommissionEarned', 0),
        pendingCommission: json.intOr('pendingCommission', 0),
        level: json.intOr('level', 1),
        status: json.stringOr('status', 'PENDING'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        'userId': userId,
        'promoCode': promoCode,
        'totalReferrals': totalReferrals,
        'totalCommissionEarned': totalCommissionEarned,
        'pendingCommission': pendingCommission,
        'level': level,
        'status': status,
      };
}

enum NotificationType {
  ORDER,
  PAYMENT,
  AMBASSADOR,
  PROMOTION,
  SYSTEM,
}

NotificationType notificationTypeFromJson(String value) =>
    NotificationType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => NotificationType.SYSTEM,
    );

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
        body: json.stringOr('body', ''),
        type: notificationTypeFromJson(json.stringOr('type', 'SYSTEM')),
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
