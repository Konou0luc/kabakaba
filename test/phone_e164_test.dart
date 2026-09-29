import 'package:flutter_test/flutter_test.dart';
import 'package:kabakaba/core/utils/phone_e164.dart';

void main() {
  group('toTogoLocalDigits', () {
    test('keeps 8 local digits', () {
      expect(toTogoLocalDigits('90 12 34 56'), '90123456');
    });

    test('strips country code 228', () {
      expect(toTogoLocalDigits('+22890123456'), '90123456');
    });

    test('caps at 8 digits', () {
      expect(toTogoLocalDigits('90123456789'), '90123456');
    });
  });

  group('toTogoE164', () {
    test('prefixes +228', () {
      expect(toTogoE164('90 12 34 56'), '+22890123456');
    });
  });

  group('formatTogoDisplay', () {
    test('groups by pairs', () {
      expect(formatTogoDisplay('90123456'), '90 12 34 56');
    });
  });
}
