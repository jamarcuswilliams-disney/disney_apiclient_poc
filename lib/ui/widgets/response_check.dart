import 'package:api_client/api_client.dart' as api;
import 'package:api_client/api_client.dart';
import 'package:chassis_networking/chassis_networking.dart' as chassis;
import 'package:disney_apiclient_poc/api_client/exceptions/api_call_exception.dart';
import 'package:disney_apiclient_poc/chassis_networking/exceptions/api_call_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/constants/vas_endpoints.dart';
import '../../shared/providers/providers_core.dart';

class ResponseChecker extends ConsumerStatefulWidget {
  const ResponseChecker({super.key});

  @override
  ConsumerState createState() => _ResponseCheckerState();
}

class _ResponseCheckerState extends ConsumerState<ResponseChecker> {
  @override
  Widget build(BuildContext context) {
    final baseClient = ref.watch(baseClientProvider);
    final chassisClient = ref.watch(cnClientProvider);
    final baseStatus = ref.watch(apiStatusProvider);
    final chassisStatus = ref.watch(chassisStatusProvider);

    final screenSize = MediaQuery.of(context).size;

    var chassisProxy = chassisClient.proxy;
    var baseProxy = baseClient.proxy;

    var buttonEnabled = true;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                  height: screenSize.height / 2.25,
                  width: screenSize.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ColoredBox(
                      color: baseStatus.value.color,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'API Client',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text('Testing:\n${VASEndpoints.baseUrl}'),
                            Text('Status: ${baseStatus.value.message}'),
                            Text('Api_Client Proxy: ${baseProxy.value}')
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                  height: screenSize.height / 2.25,
                  width: screenSize.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ColoredBox(
                      color: chassisStatus.value.color,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Chassis Networking Client',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text('Testing:\n${VASEndpoints.baseUrl}'),
                            Text('Status: ${chassisStatus.value.message}'),
                            Text('Chassis Proxy: ${chassisProxy.value}')
                          ],
                        ),
                      ),
                    ),
                  )),
              Visibility(
                visible: buttonEnabled,
                child: ElevatedButton(
                    key: const Key('testButton'),
                    onPressed: () async {
                      try {
                        setState(() => buttonEnabled = false);
                        final apiRequest =
                            api.ApiRequest(url: VASEndpoints.baseUrl);

                        final chassisRequest =
                            chassis.ApiRequest(url: VASEndpoints.baseUrl);

                        setState(() {
                          baseStatus.value.load();
                        });
                        var isApiClientSuccessful = false;

                        await baseClient.execute(apiRequest: apiRequest).then(
                            (value) => isApiClientSuccessful =
                                value.statusCode == 200);

                        setState(() => isApiClientSuccessful
                            ? baseStatus.value.finished()
                            : baseStatus.value.failed());

                        setState(() {
                          chassisStatus.value.load();
                        });

                        var isChassisClientSuccessful = false;

                        await chassisClient
                            .execute(apiRequest: chassisRequest)
                            .then((value) => isChassisClientSuccessful =
                                value.statusCode == 200);

                        setState(() => isChassisClientSuccessful
                            ? chassisStatus.value.finished()
                            : chassisStatus.value.failed());
                      } on BaseApiCallException catch (e) {
                        setState(() {
                          baseStatus.value.failed();
                          debugPrint(e.message);
                          setState(() => buttonEnabled = true);
                        });
                      } on ChassisApiCallException catch (e) {
                        chassisStatus.value.failed();
                        debugPrint(e.message);
                        setState(() => buttonEnabled = true);
                      } on ApiException catch (e) {
                        baseStatus.value.failed();
                        chassisStatus.value.failed();
                        debugPrint(e.message);
                        setState(() => buttonEnabled = true);
                      }

                      setState(() => buttonEnabled = true);
                    },
                    child: const Text('Test Connection')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
