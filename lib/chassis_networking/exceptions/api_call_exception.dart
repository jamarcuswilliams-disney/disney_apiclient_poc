class ChassisApiCallException implements Exception {
  ChassisApiCallException({
    required this.code,
    this.message,
    this.stackTrace,
  });

  final int code;
  final String? message;
  StackTrace? stackTrace;

  @override
  String toString() {
    return 'Chassis Api Call Exception: $message Code: $code \n causedBy: $stackTrace';
  }
}
