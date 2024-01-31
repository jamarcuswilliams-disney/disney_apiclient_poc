import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:disney_apiclient_poc/shared/domain/auth_base_request.dart';
import 'package:disney_apiclient_poc/shared/domain/http_date.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class BaseSecurity extends ApiSecurity {
  BaseSecurity({
    required this.secureStorage,
  });
  final FlutterSecureStorage secureStorage;

  @override
  Future<void> secure(
    Request httpRequest, {
    required Client client,
  }) async {
    final sessionString = await secureStorage.read(key: 'session') ?? '';

    if (sessionString.isNotEmpty == true) {
      final sessionJson = jsonDecode(sessionString);
      final token = sessionJson['token'];
      httpRequest.headers['Authorization'] = 'Bearer $token';
    }

    httpRequest.headers['Conversation-Id'] = httpRequest.conversationId;
    httpRequest.headers['Correlation-Id'] = httpRequest.correlationId;
    httpRequest.headers['x-date'] = DateTime.now().toHTTPDate();
    httpRequest.headers['X-Route'] = '/';
    httpRequest.headers['X-Source'] = httpRequest.source;
  }
}
