import 'package:sentry_flutter/sentry_flutter.dart';

class SentryUtils {
  static Future<T> trackOperation<T>({
    required String operation,
    required Future<T> Function() operationFn,
    Map<String, dynamic>? additionalData,
  }) async {
    final transaction = Sentry.startTransaction(
      operation,
      'task',
      bindToScope: true,
    );

    try {
      final result = await operationFn();
      transaction.finish(status: SpanStatus.ok());
      return result;
    } catch (e, stackTrace) {
      transaction.finish(status: SpanStatus.internalError());
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          if (additionalData != null) {
            additionalData.forEach((key, value) {
              scope.setExtra(key, value);
            });
          }
        },
      );
      rethrow;
    }
  }

  static Future<void> trackScreenLoad(String screenName) async {
    final transaction = Sentry.startTransaction(
      'screen_load',
      'ui.load',
      bindToScope: true,
    );

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      transaction.finish(status: SpanStatus.ok());
    } catch (e, stackTrace) {
      transaction.finish(status: SpanStatus.internalError());
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('screen', screenName);
        },
      );
    }
  }
} 