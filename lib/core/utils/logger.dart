import 'package:flutter/foundation.dart';

/// Lightweight development logging utility.
///
/// Avoid using `print()` directly in Flutter applications because:
/// 1. It can leak sensitive debug logs into production console.
/// 2. It triggers lint warnings (`avoid_print`).
///
/// Use [AppLogger] instead, which runs only in debug mode.
class AppLogger {
  AppLogger._();

  static void info(String message, [String? tag]) {
    _log('INFO', message, tag);
  }

  static void warning(String message, [String? tag]) {
    _log('WARN', message, tag);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('🚨 [ERROR] $tagPrefix$message');
      if (error != null) {
        debugPrint('   Details: $error');
      }
      if (stackTrace != null) {
        debugPrint('   StackTrace:\n$stackTrace');
      }
    }
  }

  static void _log(String level, String message, String? tag) {
    if (kDebugMode) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('[$level] $tagPrefix$message');
    }
  }
}
