import 'user_model.dart';

class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}

class TokensResponse {
  final String accessToken;
  final String refreshToken;

  TokensResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokensResponse.fromJson(Map<String, dynamic> json) => TokensResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}

class SendOtpResponse {
  final String message;

  SendOtpResponse({required this.message});

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      SendOtpResponse(message: json['message'] as String);

  Map<String, dynamic> toJson() => {'message': message};
}

class LogoutResponse {
  final String message;

  LogoutResponse({required this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      LogoutResponse(message: json['message'] as String);

  Map<String, dynamic> toJson() => {'message': message};
}

class SuccessResponse {
  final bool success;
  final String? message;

  SuccessResponse({required this.success, this.message});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) =>
      SuccessResponse(
        success: json['success'] as bool? ?? true,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        if (message != null) 'message': message,
      };
}
