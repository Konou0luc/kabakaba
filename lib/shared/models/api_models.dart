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
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        userId: json['userId'] as String,
        canteenName: json['canteenName'] as String,
        logoUrl: json['logoUrl'] as String?,
        bannerUrl: json['bannerUrl'] as String?,
        description: json['description'] as String?,
        balanceFcfa: (json['balanceFcfa'] as num?)?.toDouble() ?? 0.0,
        debtFcfa: (json['debtFcfa'] as num?)?.toDouble() ?? 0.0,
        isActive: json['isActive'] as bool? ?? true,
        isOpen: json['isOpen'] as bool? ?? false,
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
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        name: json['name'] as String,
        city: json['city'] as String,
        institution: json['institution'] as String,
        isActive: json['isActive'] as bool? ?? true,
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
  READY,
  CONFIRMED,
  REJECTED,
  CANCELLED,
  COMPLETED,
}

OrderStatus orderStatusFromJson(String value) =>
    OrderStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => OrderStatus.PENDING,
    );

String orderStatusToJson(OrderStatus status) => status.name;

class OrderModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String studentId;
  final String vendorId;
  final OrderStatus status;
  final int totalTickets;
  final double escrowAmount;
  final String? packagingOptionId;
  final String? reason;
  final DateTime? readyAt;
  final DateTime? confirmedAt;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.studentId,
    required this.vendorId,
    required this.status,
    required this.totalTickets,
    required this.escrowAmount,
    this.packagingOptionId,
    this.reason,
    this.readyAt,
    this.confirmedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        studentId: json['studentId'] as String,
        vendorId: json['vendorId'] as String,
        status: orderStatusFromJson(json['status'] as String),
        totalTickets: (json['totalTickets'] as num?)?.toInt() ?? 0,
        escrowAmount: (json['escrowAmount'] as num?)?.toDouble() ?? 0.0,
        packagingOptionId: json['packagingOptionId'] as String?,
        reason: json['reason'] as String?,
        readyAt: json['readyAt'] != null
            ? DateTime.parse(json['readyAt'] as String)
            : null,
        confirmedAt: json['confirmedAt'] != null
            ? DateTime.parse(json['confirmedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        'studentId': studentId,
        'vendorId': vendorId,
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
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        vendorId: json['vendorId'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        priceTickets: (json['priceTickets'] as num?)?.toInt() ?? 0,
        imageUrl: json['imageUrl'] as String?,
        isAvailable: json['isAvailable'] as bool? ?? true,
        category: json['category'] as String?,
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
      };
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
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        userId: json['userId'] as String,
        type: transactionTypeFromJson(json['type'] as String),
        amount: (json['amount'] as num?)?.toInt() ?? 0,
        status: transactionStatusFromJson(json['status'] as String),
        reference: json['reference'] as String?,
        counterpartyUserId: json['counterpartyUserId'] as String?,
        orderId: json['orderId'] as String?,
        metadata: json['metadata'] as String?,
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

  factory AmbassadorModel.fromJson(Map<String, dynamic> json) =>
      AmbassadorModel(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        userId: json['userId'] as String,
        promoCode: json['promoCode'] as String? ?? '',
        totalReferrals: (json['totalReferrals'] as num?)?.toInt() ?? 0,
        totalCommissionEarned:
            (json['totalCommissionEarned'] as num?)?.toInt() ?? 0,
        pendingCommission:
            (json['pendingCommission'] as num?)?.toInt() ?? 0,
        level: (json['level'] as num?)?.toInt() ?? 1,
        status: json['status'] as String? ?? 'ACTIVE',
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
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        userId: json['userId'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: notificationTypeFromJson(json['type'] as String? ?? 'SYSTEM'),
        isRead: json['isRead'] as bool? ?? false,
        relatedId: json['relatedId'] as String?,
        relatedType: json['relatedType'] as String?,
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
    return PaginatedResponse<T>(
      data: dataList
          .map((e) => itemFromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}
