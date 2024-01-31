//TODO: This class is temporal, remove it when the backend is ready
import 'package:api_client/api_client.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MockInterceptor extends ApiRequestInterceptor {
  @override
  bool canIntercept(Request httpRequest) => true;

  @override
  bool canModify(Request httpRequest) => false;

  @override
  Future<http.Response?> intercept(
    http.Request httpRequest, {
    required http.Client client,
  }) async {
    try {
      final path = httpRequest.url.path;
      var assetPath = 'assets/responses$path';

      if (httpRequest.url.query.isNotEmpty == true) {
        var params = httpRequest.url.query.replaceAll('=', '/');
        assetPath += '/${params.toLowerCase()}';
      }

      final response = await rootBundle.loadString(
        '$assetPath.json',
      );

      var result = http.Response(
        response,
        200,
      );

      return result;
    } catch (e) {
      return null;
    }
  }
}
