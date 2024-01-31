import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

extension AuthBaseRequest on http.Request {
  String get conversationId => const Uuid().v4();

  String get correlationId => const Uuid().v4();

  String get source => 'Mobile';
}
