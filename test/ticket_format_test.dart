import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kabakaba/core/utils/ticket_format.dart';

void main() {
  setUpAll(() async {
    Intl.defaultLocale = 'fr';
    await initializeDateFormatting('fr');
  });

  test('formats thousands with a grouping separator', () {
    final formatted = formatTickets(1500);
    expect(formatted.replaceAll(RegExp(r'\D'), ''), '1500');
    expect(formatted.length, greaterThan(4));
  });

  test('rounds fractional values', () {
    expect(formatTickets(12.4), '12');
    expect(formatTickets(12.6), '13');
  });
}
