import 'package:api_client/api_client.dart' as api;
import 'package:chassis_networking/chassis_networking.dart' as chassis;
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api_client/data/base_client.dart';
import '../../api_client/data/mock_interceptor.dart' as api_interceptor;
import '../../chassis_networking/data/cn_client.dart';
import '../../chassis_networking/data/mock_interceptor.dart'
    as chassis_interceptor;
import '../constants/status_colors.dart';

part 'providers_core.g.dart';

final apiClientProvider = Provider<api.ApiClient>((ref) =>
    api.ApiClient(requestInterceptor: api_interceptor.MockInterceptor()));

final chassisClientProvider = Provider<chassis.ApiClient>((ref) =>
    chassis.ApiClient(
        requestInterceptor: chassis_interceptor.MockInterceptor()));

final chassisStatusProvider =
    Provider((ref) => ValueNotifier(StatusIndicator()));

final apiStatusProvider = Provider((ref) => ValueNotifier(StatusIndicator()));

@riverpod
BaseClient baseClient(BaseClientRef ref) {
  return BaseClient(
    httpClient: ref.watch(apiClientProvider),
    indicator: ref.watch(apiStatusProvider),
  );
}

@riverpod
CNClient cnClient(CnClientRef ref) {
  return CNClient(
    httpClient: ref.watch(chassisClientProvider),
    indicator: ref.watch(chassisStatusProvider),
  );
}
