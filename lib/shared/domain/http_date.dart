import 'package:intl/intl.dart';

extension HttpDate on DateTime {
  String toHTTPDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss ' 'GMT', 'en_US');
    return formatter.format(now.toUtc());
  }
}
