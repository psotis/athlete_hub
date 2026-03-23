import 'package:athlete_hub/helpers/imports.dart';

class MedicalService {
  Future<ApiResponse<MedicalHistory>> getMedicalPerUser(
    String athleteId,
  ) async {
    try {
      final res = await ApiClient.dio.get('/medical/get?athlete_id=$athleteId');

      final body = res.data as Map<String, dynamic>;

      return ApiResponse<MedicalHistory>.fromJson(
        body,
        (data) => MedicalHistory.fromMap(data),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 404) {
        return const ApiResponse<MedicalHistory>(
          status: 200,
          message: 'No medical history found',
          data: [],
        );
      }

      final data = e.response?.data;
      String message = 'Failed to fetch medical history';

      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }

      switch (code) {
        case 400:
          throw BadRequestException(message);
        case 401:
          throw UnauthorizedException(message);
        case 500:
          throw ServerException(message);
        default:
          throw AppException(message, statusCode: code);
      }
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  Future<ApiResponseObject<MedicalHistory>> createMedical({
    required String athleteId,
    required int itemType,
    required String title,
    required String description,
    required String startDate,
    String? endDate,
    required bool isActive,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/medical/create',
        data: {
          'athlete_id': athleteId,
          'item_type': itemType,
          'title': title,
          'description': description,
          'start_date': startDate,
          'end_date': endDate,
          'is_active': isActive,
        },
      );

      final body = res.data as Map<String, dynamic>;

      return ApiResponseObject<MedicalHistory>.fromJson(
        body,
        (data) => MedicalHistory.fromMap(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Create medical failed';

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
        case 500:
          throw ServerException(message);
        default:
          throw AppException(message, statusCode: code);
      }
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  Future<ApiResponseObject<MedicalHistory>> updateMedical({
    required String id,
    required String athleteId,
    required int itemType,
    required String title,
    required String description,
    required String startDate,
    String? endDate,
    required bool isActive,
  }) async {
    try {
      final res = await ApiClient.dio.put(
        '/medical/update/$athleteId/$id',
        data: {
          'item_type': itemType,
          'title': title,
          'description': description,
          'start_date': startDate,
          'end_date': endDate,
          'is_active': isActive,
        },
      );

      final body = res.data as Map<String, dynamic>;

      return ApiResponseObject<MedicalHistory>.fromJson(
        body,
        (data) => MedicalHistory.fromMap(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Update medical failed';

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

  Future<ApiResponseObject<bool>> deleteMedical({
    required String athleteId,
    required String id,
  }) async {
    try {
      final res = await ApiClient.dio.delete('/medical/delete/$athleteId/$id');

      final body = res.data as Map<String, dynamic>;

      return ApiResponseObject<bool>.fromJson(body, (data) {
        final map = data as Map<String, dynamic>?;
        return map?['deleted'] == true;
      });
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Delete medical failed';

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
