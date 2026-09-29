import '../../core/network/json_reader.dart';

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

  String get displayFirstName {
    final name = firstName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'Étudiant';
  }

  String get displayFullName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final full = '$first $last'.trim();
    return full.isEmpty ? displayFirstName : full;
  }

  String get initials {
    final first = firstName?.trim();
    final last = lastName?.trim();
    final a = (first != null && first.isNotEmpty) ? first[0] : '';
    final b = (last != null && last.isNotEmpty) ? last[0] : '';
    final value = '$a$b'.toUpperCase();
    return value.isEmpty ? 'É' : value;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json.requireString('id'),
        createdAt: json.dateTimeOrNow('createdAt'),
        updatedAt: json.dateTimeOrNow('updatedAt'),
        deletedAt: json.optionalDateTime('deletedAt'),
        phone: json.optionalString('phone'),
        email: json.optionalString('email'),
        firstName: json.optionalString('firstName'),
        lastName: json.optionalString('lastName'),
        avatarUrl: json.optionalString('avatarUrl'),
        role: userRoleFromJson(json.stringOr('role', 'STUDENT')),
        campusId: json.optionalString('campusId'),
        walletBalance: json.intOr('walletBalance', 0),
        escrowBalance: json.intOr('escrowBalance', 0),
        isSuspended: json.boolOr('isSuspended', false),
        suspensionUntil: json.optionalDateTime('suspensionUntil'),
        suspensionReason: json.optionalString('suspensionReason'),
        mustChangePassword: json.boolOr('mustChangePassword', false),
        notifyOrders: json.boolOr('notifyOrders', true),
        notifyAmbassador: json.boolOr('notifyAmbassador', true),
        notifyPromotions: json.boolOr('notifyPromotions', false),
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
