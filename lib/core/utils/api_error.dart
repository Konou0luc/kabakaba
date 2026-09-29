import 'package:dio/dio.dart';
import '../network/student_auth_error.dart';

String apiErrorMessage(Object error) {
  if (error is WrongAppAccountException) return error.toString();
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Le serveur met trop de temps à répondre. Réessaie.';
      case DioExceptionType.connectionError:
        return 'Impossible de joindre le serveur. Vérifie ta connexion.';
      case DioExceptionType.cancel:
        return 'Requête annulée.';
      default:
        break;
    }
    final data = error.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
      if (message is List && message.isNotEmpty) {
        return message.map((item) => item.toString()).join(', ');
      }
    }
    if (error.response?.statusCode == 401) {
      return 'Session expirée. Reconnecte-toi.';
    }
    if (error.response?.statusCode == 503) {
      return 'Service temporairement indisponible. Réessaie dans un instant.';
    }
  }
  try {
    final message = (error as dynamic).response?.data?['message'];
    if (message is String && message.isNotEmpty) return message;
    if (message is List) return message.join(', ');
  } catch (_) {}
  return 'Une erreur est survenue';
}

bool isCampusRequiredError(Object error) {
  return apiErrorMessage(error).toLowerCase().contains('campus');
}

bool isOtpInvalidError(Object error) {
  final message = apiErrorMessage(error).toLowerCase();
  return message.contains('otp') ||
      message.contains('expiré') ||
      message.contains('expire') ||
      message.contains('trop de tentatives');
}
