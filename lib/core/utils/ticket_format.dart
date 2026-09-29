import 'package:intl/intl.dart';

final _tickets = NumberFormat.decimalPattern('fr');

String formatTickets(num value) => _tickets.format(value.round());
