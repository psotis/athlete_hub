import 'package:athlete_hub/helpers/imports.dart';

class ExerciseService {
  Future<List<ExerciseCategory>> getCategories() =>
      _getList('/exercise/categories', ExerciseCategory.fromMap);

  Future<List<ExerciseMuscleGroup>> getMuscleGroups({String? categoryId}) =>
      _getList(
        '/exercise/muscle-groups',
        ExerciseMuscleGroup.fromMap,
        query: categoryId == null ? null : {'category_id': categoryId},
      );

  Future<List<Exercise>> getExercises({String? muscleGroupId}) => _getList(
    '/exercise/exercises',
    Exercise.fromMap,
    query: {'muscle_group_id': ?muscleGroupId, 'is_active': true},
  );

  Future<List<ExerciseProgram>> getPrograms({String? athleteId}) => _getList(
    '/exercise/programs',
    ExerciseProgram.fromMap,
    query: athleteId == null ? null : {'athlete_id': athleteId},
  );

  Future<ExerciseProgram> saveProgram({
    String? id,
    required String athleteId,
    required String title,
    required DateTime scheduledDate,
    String? notes,
    required String status,
    required List<ExerciseProgramItem> items,
  }) async {
    try {
      final data = {
        'athlete_id': athleteId,
        'title': title,
        'scheduled_date': DateFormat('yyyy-MM-dd').format(scheduledDate),
        'notes': notes,
        'status': status,
        'items': items.map((e) => e.toRequestMap()).toList(),
      };
      final response = id == null
          ? await ApiClient.dio.post('/exercise/programs', data: data)
          : await ApiClient.dio.put('/exercise/programs/$id', data: data);
      return _object(response.data, ExerciseProgram.fromMap);
    } on DioException catch (e) {
      throw _exception(e, 'Could not save exercise program');
    }
  }

  Future<void> deleteProgram(String id) async {
    try {
      await ApiClient.dio.delete('/exercise/programs/$id');
    } on DioException catch (e) {
      throw _exception(e, 'Could not delete exercise program');
    }
  }

  Future<ExerciseCategory> saveCategory({
    String? id,
    required String name,
    String? description,
  }) async {
    try {
      final data = {'name': name, 'description': description};
      final response = id == null
          ? await ApiClient.dio.post('/exercise/categories', data: data)
          : await ApiClient.dio.put('/exercise/categories/$id', data: data);
      return _object(response.data, ExerciseCategory.fromMap);
    } on DioException catch (e) {
      throw _exception(e, 'Could not save exercise category');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await ApiClient.dio.delete('/exercise/categories/$id');
    } on DioException catch (e) {
      throw _exception(e, 'Could not delete exercise category');
    }
  }

  Future<ExerciseMuscleGroup> saveMuscleGroup({
    String? id,
    required String categoryId,
    required String name,
    String? description,
  }) async {
    try {
      final data = {
        'category_id': categoryId,
        'name': name,
        'description': description,
      };
      final response = id == null
          ? await ApiClient.dio.post('/exercise/muscle-groups', data: data)
          : await ApiClient.dio.put('/exercise/muscle-groups/$id', data: data);
      return _object(response.data, ExerciseMuscleGroup.fromMap);
    } on DioException catch (e) {
      throw _exception(e, 'Could not save muscle group');
    }
  }

  Future<void> deleteMuscleGroup(String id) async {
    try {
      await ApiClient.dio.delete('/exercise/muscle-groups/$id');
    } on DioException catch (e) {
      throw _exception(e, 'Could not delete muscle group');
    }
  }

  Future<Exercise> saveExercise({
    String? id,
    required String muscleGroupId,
    required String name,
    String? photoUrl,
    String? videoUrl,
    String? description,
    bool isActive = true,
  }) async {
    try {
      final data = {
        'muscle_group_id': muscleGroupId,
        'name': name,
        'photo_url': photoUrl,
        'video_url': videoUrl,
        'description': description,
        'is_active': isActive,
      };
      final response = id == null
          ? await ApiClient.dio.post('/exercise/exercises', data: data)
          : await ApiClient.dio.put('/exercise/exercises/$id', data: data);
      return _object(response.data, Exercise.fromMap);
    } on DioException catch (e) {
      throw _exception(e, 'Could not save exercise');
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await ApiClient.dio.delete('/exercise/exercises/$id');
    } on DioException catch (e) {
      throw _exception(e, 'Could not delete exercise');
    }
  }

  Future<List<T>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) parser, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await ApiClient.dio.get(path, queryParameters: query);
      final body = response.data as Map<String, dynamic>;
      return (body['data'] as List? ?? const [])
          .map((e) => parser(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _exception(e, 'Could not load exercise data');
    }
  }

  T _object<T>(Object? raw, T Function(Map<String, dynamic>) parser) {
    final body = raw as Map<String, dynamic>;
    return parser(body['data'] as Map<String, dynamic>);
  }

  AppException _exception(DioException e, String fallback) {
    final data = e.response?.data;
    final message = data is Map<String, dynamic>
        ? data['message']?.toString() ?? fallback
        : e.message ?? fallback;
    return AppException(message, statusCode: e.response?.statusCode ?? 0);
  }
}
