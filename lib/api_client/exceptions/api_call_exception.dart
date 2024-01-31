class BaseApiCallException implements Exception {
  BaseApiCallException({
    required this.code,
    this.message,
    this.stackTrace,
  });

  final int code;
  final String? message;
  StackTrace? stackTrace;

  @override
  String toString() {
    return 'Api Call Exception: $message Code: $code \n causedBy: $stackTrace';
  }
}
