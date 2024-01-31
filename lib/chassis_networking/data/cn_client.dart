import 'dart:async';

import 'package:chassis_networking/chassis_networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_system_proxy/flutter_system_proxy.dart';

import '../../shared/constants/status_colors.dart';
import '../exceptions/api_call_exception.dart';
import 'cn_security.dart';

class CNClient {
  CNClient({
    required this.httpClient,
    required this.indicator,
  });

  final ApiClient httpClient;
  final ValueNotifier<StatusIndicator> indicator;
  ValueNotifier<String> proxy = ValueNotifier('');

  static const Key chassisNetworking = Key('Chassis Networking');

  Future<ApiResponse> execute({
    required ApiRequest apiRequest,
    ApiSecurity? apiSecurity,
  }) async {
    final ApiResponse response;

    try {
      indicator.value.load();
      apiSecurity ??= CNSecurity(secureStorage: const FlutterSecureStorage());

      proxy.value =
          await FlutterSystemProxy.findProxyFromEnvironment(apiRequest.url);
      debugPrint('BIG_PROXY: ${proxy.value.toString()}');
      final apiProxy = proxy.value != 'DIRECT'
          ? ApiClientProxy(
              ignoreBadCertificate: true, url: proxy.value.toString())
          : null;
      debugPrint('API_PROXY: $apiProxy');
      ApiClient.proxy = apiProxy;

      response = await httpClient.execute(
        apiSecurity: apiSecurity,
        request: apiRequest,
      );

      if (response.statusCode != 200) {
        throw ChassisApiCallException(
          code: response.statusCode!,
          message: response.body,
        );
      }
    } on TimeoutException catch (_) {
      indicator.value.failed();
      return const ApiResponse(body: '', headers: {}, statusCode: 500);
    } on Exception catch (_) {
      indicator.value.failed();
      rethrow;
    }

    indicator.value.finished();
    return response;
  }
}
