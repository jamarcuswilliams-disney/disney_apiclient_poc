/// (c) Disney. All rights reserved.

import 'package:chassis_networking/chassis_networking.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

//TODO: This class is temporal, remove it when the backend is ready
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
