import 'package:athlete_hub/helpers/imports.dart';

class MedicalRepository {
  final MedicalService medicalService;

  MedicalRepository({required this.medicalService});

  Future<List<MedicalHistory>> getMedicalPerUser(String athleteId) async {
    final medical = await medicalService.getMedicalPerUser(athleteId);
    return medical.data;
  }

  Future<MedicalHistory?> createMedical({
    required String athleteId,
    required int itemType,
    required String title,
    required String description,
    required String startDate,
    String? endDate,
    required bool isActive,
  }) async {
    final res = await medicalService.createMedical(
      athleteId: athleteId,
      itemType: itemType,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
    );

    return res.data;
  }

  Future<MedicalHistory?> updateMedical({
    required String id,
    required String athleteId,
    required int itemType,
    required String title,
    required String description,
    required String startDate,
    String? endDate,
    required bool isActive,
  }) async {
    final res = await medicalService.updateMedical(
      id: id,
      athleteId: athleteId,
      itemType: itemType,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
    );

    return res.data;
  }

  Future<bool> deleteMedical({
    required String athleteId,
    required String id,
  }) async {
    final res = await medicalService.deleteMedical(
      athleteId: athleteId,
      id: id,
    );
    return res.data ?? false;
  }
}
