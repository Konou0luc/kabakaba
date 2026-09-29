import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

void attachStudentHttpAdapter(Dio dio) {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient()..idleTimeout = const Duration(seconds: 15);
      client.findProxy = (_) => 'DIRECT';
      return client;
    },
  );
}
