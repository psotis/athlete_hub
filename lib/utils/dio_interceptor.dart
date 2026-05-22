import 'package:athlete_hub/helpers/imports.dart';
import 'package:flutter/foundation.dart';

bool _isLoggingOut = false;

class ApiClient {
  static String get _baseUrl {
    final isAndroidEmulator =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final host = isAndroidEmulator ? '10.0.2.2' : '10.72.1.198';
    return 'http://$host:4001/api';
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static void init({
    required Future<String?> Function() getToken,
    required void Function() onUnauthorized,
  }) {
    dio.interceptors.clear();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['access_token'] =
              'traiOyCCTQ9XkgIab40ui5x8mhdnNe9X9Qds52K4';

          final token = await getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401 && !_isLoggingOut) {
            _isLoggingOut = true;
            onUnauthorized();
            Future.microtask(() => _isLoggingOut = false);
          }
          handler.next(e);
        },
      ),
    );
  }
}
