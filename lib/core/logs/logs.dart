import 'dart:convert';
import 'package:logger/logger.dart';

// Defines strucuture for log events
class JsonLogPrinter extends LogPrinter {
  final String className;

  JsonLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final logMap = {
      'timestamp': DateTime.now().toIso8601String(),
      'level': event.level.toString().split('.').last,
      'message': event.message,
      'class': className,
      'error': event.error?.toString(),
      'stackTrace': event.stackTrace?.toString(),
    };

    return [jsonEncode(logMap)];
  }
}
