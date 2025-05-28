import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ApiLoggerInterceptor extends Interceptor {
  final GetStorage storage = GetStorage();
  final String storageKey = 'api_logs';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log('REQUEST: [${options.method}] ${options.uri}', options.data);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log('RESPONSE: [${response.statusCode}] ${response.requestOptions.uri}', response.data);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _log('ERROR: [${err.response?.statusCode}] ${err.requestOptions.uri}', err.message);
    super.onError(err, handler);
  }

  void _log(String title, dynamic data) {
    final logs = storage.read<List>('api_logs') ?? [];
    final entry = {
      'time': DateTime.now().toIso8601String(),
      'title': title,
      'data': data.toString(),
    };
    logs.insert(0, entry);
    if (logs.length > 100) logs.removeLast(); // optional: limit log size
    storage.write(storageKey, logs);
  }
}
