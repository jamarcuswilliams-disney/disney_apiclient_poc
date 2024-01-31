import 'package:disney_apiclient_poc/ui/widgets/response_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(
    child: MaterialApp(
      home: ResponseChecker(),
    ),
  ));
}
