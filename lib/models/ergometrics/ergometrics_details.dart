import 'package:athlete_hub/helpers/imports.dart';

class ErgometricsDetails extends Equatable {
  final Session? session;
  final Somatometrics? somatometrics;
  final Goniometrics? goniometrics;
  final Dynamometrics? dynamometrics;
  final Jumping? jumpingAbility;
  final Agility? agilitySpeed;
  final Endurance? endurance;
  final List<Squat> overheadSquatAssessmentItems;

  const ErgometricsDetails({
    this.session,
    this.somatometrics,
    this.goniometrics,
    this.dynamometrics,
    this.jumpingAbility,
    this.agilitySpeed,
    this.endurance,
    this.overheadSquatAssessmentItems = const [],
  });

  factory ErgometricsDetails.initial() {
    return const ErgometricsDetails(
      session: null,
      somatometrics: null,
      goniometrics: null,
      dynamometrics: null,
      jumpingAbility: null,
      agilitySpeed: null,
      endurance: null,
      overheadSquatAssessmentItems: [],
    );
  }

  factory ErgometricsDetails.fromMap(Map<String, dynamic> map) {
    return ErgometricsDetails(
      session: map['session'] != null
          ? Session.fromMap(map['session'] as Map<String, dynamic>)
          : null,
      somatometrics: map['somatometrics'] != null
          ? Somatometrics.fromMap(map['somatometrics'] as Map<String, dynamic>)
          : null,
      goniometrics: map['goniometrics'] != null
          ? Goniometrics.fromMap(map['goniometrics'] as Map<String, dynamic>)
          : null,
      dynamometrics: map['dynamometrics'] != null
          ? Dynamometrics.fromMap(map['dynamometrics'] as Map<String, dynamic>)
          : null,
      jumpingAbility: map['jumping_ability'] != null
          ? Jumping.fromMap(map['jumping_ability'] as Map<String, dynamic>)
          : null,
      agilitySpeed: map['agility_speed'] != null
          ? Agility.fromMap(map['agility_speed'] as Map<String, dynamic>)
          : null,
      endurance: map['endurance'] != null
          ? Endurance.fromMap(map['endurance'] as Map<String, dynamic>)
          : null,
      overheadSquatAssessmentItems:
          (map['overhead_squat_assessment_items'] as List<dynamic>? ?? [])
              .map((e) => Squat.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'session': session?.toMap(),
      'somatometrics': somatometrics?.toMap(),
      'goniometrics': goniometrics?.toMap(),
      'dynamometrics': dynamometrics?.toMap(),
      'jumping_ability': jumpingAbility?.toMap(),
      'agility_speed': agilitySpeed?.toMap(),
      'endurance': endurance?.toMap(),
      'overhead_squat_assessment_items': overheadSquatAssessmentItems
          .map((e) => e.toMap())
          .toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ErgometricsDetails.fromJson(String source) =>
      ErgometricsDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  ErgometricsDetails copyWith({
    Session? session,
    Somatometrics? somatometrics,
    Goniometrics? goniometrics,
    Dynamometrics? dynamometrics,
    Jumping? jumpingAbility,
    Agility? agilitySpeed,
    Endurance? endurance,
    List<Squat>? overheadSquatAssessmentItems,
  }) {
    return ErgometricsDetails(
      session: session ?? this.session,
      somatometrics: somatometrics ?? this.somatometrics,
      goniometrics: goniometrics ?? this.goniometrics,
      dynamometrics: dynamometrics ?? this.dynamometrics,
      jumpingAbility: jumpingAbility ?? this.jumpingAbility,
      agilitySpeed: agilitySpeed ?? this.agilitySpeed,
      endurance: endurance ?? this.endurance,
      overheadSquatAssessmentItems:
          overheadSquatAssessmentItems ?? this.overheadSquatAssessmentItems,
    );
  }

  @override
  List<Object?> get props => [
    session,
    somatometrics,
    goniometrics,
    dynamometrics,
    jumpingAbility,
    agilitySpeed,
    endurance,
    overheadSquatAssessmentItems,
  ];

  @override
  bool get stringify => true;
}
