enum UserRole { STUDENT, VENDOR, ADMIN, SUPER_ADMIN }

UserRole userRoleFromJson(String value) =>
    UserRole.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => UserRole.STUDENT,
    );

String userRoleToJson(UserRole role) => role.name;

class UserModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? phone;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final UserRole role;
  final String? campusId;
  final int walletBalance;
  final int escrowBalance;
  final bool isSuspended;
  final DateTime? suspensionUntil;
  final String? suspensionReason;
  final bool mustChangePassword;
  final bool notifyOrders;
  final bool notifyAmbassador;
  final bool notifyPromotions;

  UserModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.phone,
    this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    required this.role,
    this.campusId,
    required this.walletBalance,
    required this.escrowBalance,
    required this.isSuspended,
    this.suspensionUntil,
    this.suspensionReason,
    required this.mustChangePassword,
    required this.notifyOrders,
    required this.notifyAmbassador,
    required this.notifyPromotions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        role: userRoleFromJson(json['role'] as String),
        campusId: json['campusId'] as String?,
        walletBalance: (json['walletBalance'] as num?)?.toInt() ?? 0,
        escrowBalance: (json['escrowBalance'] as num?)?.toInt() ?? 0,
        isSuspended: json['isSuspended'] as bool? ?? false,
        suspensionUntil: json['suspensionUntil'] != null
            ? DateTime.parse(json['suspensionUntil'] as String)
            : null,
        suspensionReason: json['suspensionReason'] as String?,
        mustChangePassword: json['mustChangePassword'] as bool? ?? false,
        notifyOrders: json['notifyOrders'] as bool? ?? true,
        notifyAmbassador: json['notifyAmbassador'] as bool? ?? true,
        notifyPromotions: json['notifyPromotions'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        'role': userRoleToJson(role),
        if (campusId != null) 'campusId': campusId,
        'walletBalance': walletBalance,
        'escrowBalance': escrowBalance,
        'isSuspended': isSuspended,
        if (suspensionUntil != null)
          'suspensionUntil': suspensionUntil!.toIso8601String(),
        if (suspensionReason != null) 'suspensionReason': suspensionReason,
        'mustChangePassword': mustChangePassword,
        'notifyOrders': notifyOrders,
        'notifyAmbassador': notifyAmbassador,
        'notifyPromotions': notifyPromotions,
      };

  UserModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? phone,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    UserRole? role,
    String? campusId,
    int? walletBalance,
    int? escrowBalance,
    bool? isSuspended,
    DateTime? suspensionUntil,
    String? suspensionReason,
    bool? mustChangePassword,
    bool? notifyOrders,
    bool? notifyAmbassador,
    bool? notifyPromotions,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      campusId: campusId ?? this.campusId,
      walletBalance: walletBalance ?? this.walletBalance,
      escrowBalance: escrowBalance ?? this.escrowBalance,
      isSuspended: isSuspended ?? this.isSuspended,
      suspensionUntil: suspensionUntil ?? this.suspensionUntil,
      suspensionReason: suspensionReason ?? this.suspensionReason,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      notifyOrders: notifyOrders ?? this.notifyOrders,
      notifyAmbassador: notifyAmbassador ?? this.notifyAmbassador,
      notifyPromotions: notifyPromotions ?? this.notifyPromotions,
    );
  }
}
