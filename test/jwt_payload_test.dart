import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kabakaba/core/network/jwt_payload.dart';

void main() {
  String tokenWith(Map<String, dynamic> payload) {
    final encoded = base64Url.encode(utf8.encode(jsonEncode(payload)));
    return 'header.$encoded.sig';
  }

  test('reads student role and expiry', () {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final jwt = JwtPayload.tryParse(
      tokenWith({'sub': 'u1', 'role': 'STUDENT', 'exp': now + 900}),
    );
    expect(jwt?.isStudent, isTrue);
    expect(jwt?.isExpired(), isFalse);
  });

  test('vendor role is not a student session', () {
    final jwt = JwtPayload.tryParse(
      tokenWith({'sub': 'u1', 'role': 'VENDOR', 'exp': 9999999999}),
    );
    expect(jwt?.isStudent, isFalse);
  });
}
