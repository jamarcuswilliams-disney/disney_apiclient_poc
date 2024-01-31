import 'package:flutter/material.dart';

class StatusIndicator {
  StatusIndicator();

  Color _status = _inactive;
  String _statusMessage = '...Waiting';
  Color get color => _status;
  String get message => _statusMessage;

  static const Color _failed = Colors.red;
  static const Color _succeeded = Colors.green;
  static const Color _loading = Colors.purple;
  static const Color _inactive = Colors.grey;

  load() {
    _statusMessage = 'Loading...';
    _status = _loading;
  }

  finished() {
    _statusMessage = 'OK!';
    _status = _succeeded;
  }

  failed() {
    _statusMessage = 'Failed';
    _status = _failed;
  }
}
