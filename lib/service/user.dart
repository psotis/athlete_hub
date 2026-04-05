import 'package:athlete_hub/helpers/imports.dart';

class UserService {
  Future<ApiResponseObject<Users>> createUser({
    required String email,
    required String password,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/user/create',
        data: {"email": email, "password": password},
      );
      final body = res.data as Map<String, dynamic>;

      final api = ApiResponseObject<Users>.fromJson(
        body,
        (m) => Users.fromMap(m as Map<String, dynamic>),
      );

      return api;
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

  Future<ApiResponseObject<Users>> updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? sport,
    String? team,
    DateTime? birthDate,
  }) async {
    try {
      final res = await ApiClient.dio.put(
        '/user/update/$userId',
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "phone": phone,
          "sport": sport,
          "team": team,
          "birth_date": birthDate?.toIso8601String().split('T').first,
        },
      );

      final body = res.data as Map<String, dynamic>;

      final api = ApiResponseObject<Users>.fromJson(
        body,
        (m) => Users.fromMap(m as Map<String, dynamic>),
      );

      return api;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Update failed';

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

  Future<ApiResponseObject<List<Users>>> getCustomers() async {
    try {
      final res = await ApiClient.dio.get('/user/get/customers');
      final body = res.data as Map<String, dynamic>;

      final api = ApiResponseObject<List<Users>>.fromJson(
        body,
        (m) => (m as List)
            .map((e) => Users.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

      return api;
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
}
