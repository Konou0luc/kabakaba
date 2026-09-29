import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'api_endpoints.dart';
import 'api_payload.dart';
import 'jwt_payload.dart';
import 'session_invalidation.dart';
import 'student_http_client.dart';
import 'token_storage.dart';

class ApiClient {
  final Dio _dio;
  final TokenStorage _tokenStorage;
  Future<bool>? _refreshInFlight;

  ApiClient(this._dio, this._tokenStorage) {
    _setupDio();
  }

  Dio get dio => _dio;

  void _setupDio() {
    attachStudentHttpAdapter(_dio);
    _dio.options.baseUrl = AppConfig.apiUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.addAll([
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_shouldSkipAuthRetryPath(options.path)) {
            return handler.next(options);
          }
          final current = _tokenStorage.getAccessToken();
          if (current != null &&
              JwtPayload.tryParse(current)?.isExpired(
                    skew: const Duration(seconds: 45),
                  ) ==
                  true) {
            await _refreshToken();
          }
          final accessToken = _tokenStorage.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          } else {
            options.headers.remove('Authorization');
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (_shouldSkipAuthRetry(error)) {
            return handler.next(error);
          }
          if (error.response?.statusCode != 401) {
            return handler.next(error);
          }
          if (error.requestOptions.extra['kabaRetried'] == true) {
            return handler.next(error);
          }

          final access = _tokenStorage.getAccessToken();
          final jwt = JwtPayload.tryParse(access);
          if (jwt != null && !jwt.isExpired()) {
            return handler.next(error);
          }

          final refreshed = await _refreshToken();
          if (!refreshed) {
            return handler.next(error);
          }

          final requestOptions = error.requestOptions;
          final accessToken = _tokenStorage.getAccessToken();
          if (accessToken == null) {
            return handler.next(error);
          }
          requestOptions.headers['Authorization'] = 'Bearer $accessToken';
          requestOptions.extra['kabaRetried'] = true;

          try {
            final response = await _dio.fetch(requestOptions);
            return handler.resolve(response);
          } on DioException catch (e) {
            return handler.next(e);
          }
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);
  }

  bool _shouldSkipAuthRetryPath(String path) {
    return path.contains('/auth/send-otp') ||
        path.contains('/auth/verify-otp') ||
        path.contains('/auth/login') ||
        path.contains('/auth/refresh');
  }

  bool _shouldSkipAuthRetry(DioException error) {
    if (error.type == DioExceptionType.cancel ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return true;
    }
    return _shouldSkipAuthRetryPath(error.requestOptions.path);
  }

  Future<bool> _refreshToken() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;
    final future = _refreshTokenOnce().whenComplete(() {
      _refreshInFlight = null;
    });
    _refreshInFlight = future;
    return future;
  }

  Future<bool> _refreshTokenOnce() async {
    final refreshToken = _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      attachStudentHttpAdapter(refreshDio);
      final response = await refreshDio.post(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = unwrapEntity(response.data);
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;
        final userId = _tokenStorage.getUserId() ?? '';

        if (newAccessToken != null && newRefreshToken != null) {
          await _tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            userId: userId,
          );
          return true;
        }
      }
      return false;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _tokenStorage.clearTokens();
        kabaOnSessionInvalid?.call();
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio();
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient(dio, tokenStorage);
});
