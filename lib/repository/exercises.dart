import 'package:athlete_hub/helpers/imports.dart';

class ExerciseRepository {
  final ExerciseService service;

  ExerciseRepository({ExerciseService? service})
      : service = service ?? ExerciseService();

  Future<List<ExerciseCategory>> getCategories() => service.getCategories();
  Future<List<ExerciseMuscleGroup>> getMuscleGroups() =>
      service.getMuscleGroups();
  Future<List<Exercise>> getExercises() => service.getExercises();
  Future<List<ExerciseProgram>> getPrograms({String? athleteId}) =>
      service.getPrograms(athleteId: athleteId);

  Future<ExerciseProgram> saveProgram({
    String? id,
    required String athleteId,
    required String title,
    required DateTime scheduledDate,
    String? notes,
    required String status,
    required List<ExerciseProgramItem> items,
  }) =>
      service.saveProgram(
        id: id,
        athleteId: athleteId,
        title: title,
        scheduledDate: scheduledDate,
        notes: notes,
        status: status,
        items: items,
      );

  Future<void> deleteProgram(String id) => service.deleteProgram(id);

  Future<ExerciseCategory> saveCategory({
    String? id,
    required String name,
    String? description,
  }) => service.saveCategory(id: id, name: name, description: description);

  Future<void> deleteCategory(String id) => service.deleteCategory(id);

  Future<ExerciseMuscleGroup> saveMuscleGroup({
    String? id,
    required String categoryId,
    required String name,
    String? description,
  }) => service.saveMuscleGroup(
        id: id,
        categoryId: categoryId,
        name: name,
        description: description,
      );

  Future<void> deleteMuscleGroup(String id) =>
      service.deleteMuscleGroup(id);

  Future<Exercise> saveExercise({
    String? id,
    required String muscleGroupId,
    required String name,
    String? photoUrl,
    String? videoUrl,
    String? description,
  }) =>
      service.saveExercise(
        id: id,
        muscleGroupId: muscleGroupId,
        name: name,
        photoUrl: photoUrl,
        videoUrl: videoUrl,
        description: description,
      );

  Future<void> deleteExercise(String id) => service.deleteExercise(id);
}
