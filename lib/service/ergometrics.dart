import 'package:athlete_hub/helpers/imports.dart';

class ErgometricsService {
  Future<ApiResponseObject<AthleteErgometricsData>> getErgometricsPerUser(
    String athleteId,
  ) async {
    try {
      final res = await ApiClient.dio.get(
        '/ergometrics/getfullPerAthl?athlete_id=$athleteId',
      );

      final body = res.data as Map<String, dynamic>;

      final api = ApiResponseObject<AthleteErgometricsData>.fromJson(
        body,
        (data) => AthleteErgometricsData.fromMap(data),
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
