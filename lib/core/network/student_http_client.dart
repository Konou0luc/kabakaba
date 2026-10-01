import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

void attachStudentHttpAdapter(Dio dio) {
  dio.httpClientAdapter = _SerialHttpClientAdapter(
    IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient()..idleTimeout = const Duration(seconds: 15);
        client.findProxy = (_) => 'DIRECT';
        return client;
      },
    ),
  );
}

/// One in-flight HTTP call for the whole app, including token refresh.
class _SerialHttpClientAdapter implements HttpClientAdapter {
  _SerialHttpClientAdapter(this._inner);

  final HttpClientAdapter _inner;
  static Future<void> _queue = Future<void>.value();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    final done = Completer<void>();
    final previous = _queue;
    _queue = done.future;
    return previous
        .catchError((_) {})
        .then(
          (_) => _inner.fetch(options, requestStream, cancelFuture),
        )
        .whenComplete(() {
          if (!done.isCompleted) done.complete();
        });
  }

  @override
  void close({bool force = false}) => _inner.close(force: force);
}
