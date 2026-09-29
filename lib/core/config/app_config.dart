import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const _defaultUrl = 'https://kabakaba-backend.vercel.app/api/v1';

  static String get apiUrl {
    const fromDefine = String.fromEnvironment('KABAKABA_API_URL');
    if (fromDefine.isNotEmpty) return _ensureV1(fromDefine);

    final fromEnv = dotenv.env['API_URL'];
    if (fromEnv != null && fromEnv.isNotEmpty) return _ensureV1(fromEnv);

    return _defaultUrl;
  }

  static String _ensureV1(String url) {
    final trimmed = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    if (trimmed.endsWith('/api/v1')) return trimmed;
    if (trimmed.endsWith('/api')) return '$trimmed/v1';
    return trimmed;
  }
}
