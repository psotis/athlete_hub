import 'package:athlete_hub/helpers/imports.dart';

class AuthService {
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );

      final body = res.data as Map<String, dynamic>;

      final api = ApiResponseObject<LoginResponse>.fromJson(
        body,
        (m) => LoginResponse.fromJson(m as Map<String, dynamic>),
      );

      return api.data!;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Login failed';
      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }

      final code = e.response?.statusCode ?? 0;

      switch (code) {
        case 400:
          throw BadRequestException(message);
        case 401:
          throw UnauthorizedException(message);
        case 404:
          throw NotFoundException(message);
        case 500:
          throw ServerException(message);
        default:
          throw AppException(message, statusCode: code);
      }
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  Future<void> signup({required String email, required String password}) async {
    try {
      final res = await ApiClient.dio.post(
        '/api/auth/signup',
        data: {"email": "psotakos@gmail.com", "password": "12345678"},
      );

      debugPrint('LOGIN RESPONSE: ${res.data}');

      final token = res.data['data']?['token'] as String?;
      if (token == null || token.isEmpty) {
        return;
      }

      final storage = SecureTokenStorage();
      await storage.saveToken(token);
    } on DioException catch (e) {
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
    }
  }

  Future<void> logout() async {
    try {
      final res = await ApiClient.dio.post('/api/auth/logout');

      debugPrint('LOGIN RESPONSE: ${res.data}');

      final token = res.data['data']?['token'] as String?;
      if (token == null || token.isEmpty) {
        return;
      }

      final storage = SecureTokenStorage();
      await storage.saveToken(token);
    } on DioException catch (e) {
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
    }
  }
}
