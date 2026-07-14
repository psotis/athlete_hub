import 'package:athlete_hub/helpers/imports.dart';

class ExerciseCategory extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<ExerciseMuscleGroup> muscleGroups;

  const ExerciseCategory({
    required this.id,
    required this.name,
    this.description,
    this.muscleGroups = const [],
  });

  factory ExerciseCategory.fromMap(Map<String, dynamic> map) =>
      ExerciseCategory(
        id: map['id'].toString(),
        name: map['name']?.toString() ?? '',
        description: map['description']?.toString(),
        muscleGroups: (map['muscle_groups'] as List? ?? const [])
            .map((e) => ExerciseMuscleGroup.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [id, name, description, muscleGroups];
}

class ExerciseMuscleGroup extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final ExerciseCategory? category;
  final List<Exercise> exercises;

  const ExerciseMuscleGroup({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    this.category,
    this.exercises = const [],
  });

  factory ExerciseMuscleGroup.fromMap(Map<String, dynamic> map) =>
      ExerciseMuscleGroup(
        id: map['id'].toString(),
        categoryId: map['category_id']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        description: map['description']?.toString(),
        category: map['category'] is Map<String, dynamic>
            ? ExerciseCategory.fromMap(map['category'] as Map<String, dynamic>)
            : null,
        exercises: (map['exercises'] as List? ?? const [])
            .map((e) => Exercise.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [id, categoryId, name, description, category];
}

class Exercise extends Equatable {
  final String id;
  final String muscleGroupId;
  final String name;
  final String? photoUrl;
  final String? videoUrl;
  final String? description;
  final bool isActive;
  final ExerciseMuscleGroup? muscleGroup;

  const Exercise({
    required this.id,
    required this.muscleGroupId,
    required this.name,
    this.photoUrl,
    this.videoUrl,
    this.description,
    this.isActive = true,
    this.muscleGroup,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
        id: map['id'].toString(),
        muscleGroupId: map['muscle_group_id']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        photoUrl: map['photo_url']?.toString(),
        videoUrl: map['video_url']?.toString(),
        description: map['description']?.toString(),
        isActive: map['is_active'] as bool? ?? true,
        muscleGroup: map['muscle_group'] is Map<String, dynamic>
            ? ExerciseMuscleGroup.fromMap(
                map['muscle_group'] as Map<String, dynamic>,
              )
            : null,
      );

  @override
  List<Object?> get props => [
        id,
        muscleGroupId,
        name,
        photoUrl,
        videoUrl,
        description,
        isActive,
      ];
}

class ExerciseProgramItem extends Equatable {
  final String id;
  final String exerciseId;
  final int sortOrder;
  final int? sets;
  final int? reps;
  final int? durationSeconds;
  final int? restSeconds;
  final String? notes;
  final Exercise exercise;

  const ExerciseProgramItem({
    this.id = '',
    required this.exerciseId,
    required this.sortOrder,
    this.sets,
    this.reps,
    this.durationSeconds,
    this.restSeconds,
    this.notes,
    required this.exercise,
  });

  factory ExerciseProgramItem.fromMap(Map<String, dynamic> map) =>
      ExerciseProgramItem(
        id: map['id']?.toString() ?? '',
        exerciseId: map['exercise_id']?.toString() ?? '',
        sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
        sets: (map['sets'] as num?)?.toInt(),
        reps: (map['reps'] as num?)?.toInt(),
        durationSeconds: (map['duration_seconds'] as num?)?.toInt(),
        restSeconds: (map['rest_seconds'] as num?)?.toInt(),
        notes: map['notes']?.toString(),
        exercise: Exercise.fromMap(
          map['exercise'] as Map<String, dynamic>? ?? const {},
        ),
      );

  Map<String, dynamic> toRequestMap() => {
        'exercise_id': exerciseId,
        'sort_order': sortOrder,
        'sets': sets,
        'reps': reps,
        'duration_seconds': durationSeconds,
        'rest_seconds': restSeconds,
        'notes': notes,
      };

  @override
  List<Object?> get props => [
        id,
        exerciseId,
        sortOrder,
        sets,
        reps,
        durationSeconds,
        restSeconds,
        notes,
      ];
}

class ExerciseProgram extends Equatable {
  final String id;
  final String athleteId;
  final String? assignedById;
  final String title;
  final DateTime? scheduledDate;
  final String? notes;
  final String status;
  final Users? athlete;
  final Users? assignedBy;
  final List<ExerciseProgramItem> items;

  const ExerciseProgram({
    required this.id,
    required this.athleteId,
    this.assignedById,
    required this.title,
    this.scheduledDate,
    this.notes,
    required this.status,
    this.athlete,
    this.assignedBy,
    this.items = const [],
  });

  factory ExerciseProgram.fromMap(Map<String, dynamic> map) => ExerciseProgram(
        id: map['id'].toString(),
        athleteId: map['athlete_id']?.toString() ?? '',
        assignedById: map['assigned_by_id']?.toString(),
        title: map['title']?.toString() ?? '',
        scheduledDate: map['scheduled_date'] == null
            ? null
            : DateTime.tryParse(map['scheduled_date'].toString()),
        notes: map['notes']?.toString(),
        status: map['status']?.toString() ?? 'active',
        athlete: map['athlete'] is Map<String, dynamic>
            ? Users.fromMap(map['athlete'] as Map<String, dynamic>)
            : null,
        assignedBy: map['assigned_by'] is Map<String, dynamic>
            ? Users.fromMap(map['assigned_by'] as Map<String, dynamic>)
            : null,
        items: (map['items'] as List? ?? const [])
            .map((e) => ExerciseProgramItem.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [id, athleteId, title, scheduledDate, status, items];
}
