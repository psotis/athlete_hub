import 'package:athlete_hub/helpers/imports.dart';

class SessionService {
  Future<ApiResponseObject<Session>> startSession(
    String athleteId,
    String userId,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        '/measurement/create',
        data: {
          "athlete_id": athleteId,
          "measured_by_id": userId,
          "measurement_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
      );

      final body = res.data as Map<String, dynamic>;

      final api = ApiResponseObject<Session>.fromJson(
        body,
        (data) => Session.fromMap(data as Map<String, dynamic>),
      );

      return api;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = data['message'];
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

  Future<void> bulkCreateSessionEntries(Map<String, dynamic> payload) async {
    try {
      await ApiClient.dio.post(
        '/ergometrics/entries/bulk-create',
        data: payload,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to save session entries';

      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }

      throw AppException(message, statusCode: e.response?.statusCode);
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }
}
