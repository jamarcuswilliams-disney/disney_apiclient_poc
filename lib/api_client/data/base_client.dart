import 'package:api_client/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_system_proxy/flutter_system_proxy.dart';

import '../../shared/constants/status_colors.dart';
import '../exceptions/api_call_exception.dart';
import 'base_security.dart';

class BaseClient {
  BaseClient({required this.httpClient, required this.indicator});

  final ApiClient httpClient;
  final ValueNotifier<StatusIndicator> indicator;
  ValueNotifier<String> proxy = ValueNotifier('');

  static const Key baseNetworking = Key('Api Client Networking');

  Future<ApiResponse> execute({
    required ApiRequest apiRequest,
    ApiSecurity? apiSecurity,
  }) async {
    final ApiResponse response;

    try {
      indicator.value.load();
      apiSecurity ??= BaseSecurity(secureStorage: const FlutterSecureStorage());

      proxy.value =
          await FlutterSystemProxy.findProxyFromEnvironment(apiRequest.url);
      debugPrint('BIG_PROXY: ${proxy.value}');
      final apiProxy = proxy.value != 'DIRECT'
          ? ApiClientProxy(ignoreBadCertificate: true, url: proxy.value)
          : null;
      debugPrint('API_PROXY: $apiProxy');
      ApiClient.proxy = apiProxy;

      response = await httpClient.execute(
        apiSecurity: apiSecurity,
        request: apiRequest,
      );

      if (response.statusCode != 200) {
        throw BaseApiCallException(
          code: response.statusCode!,
          message: response.body,
        );
      }
    } on Exception catch (_) {
      indicator.value.failed();
      rethrow;
    }
    indicator.value.finished();
    return response;
  }
}
