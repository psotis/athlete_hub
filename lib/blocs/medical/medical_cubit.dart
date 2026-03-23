import 'package:athlete_hub/blocs/medical/medical_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class MedicalCubit extends Cubit<MedicalState> {
  final MedicalRepository _repository;

  MedicalCubit(this._repository) : super(MedicalState.initial());

  Future<void> getMedicalPerUser(String athleteId) async {
    emit(state.copyWith(status: MedicalStatus.loading, clearError: true));

    try {
      final response = await _repository.getMedicalPerUser(athleteId);

      emit(
        state.copyWith(
          status: MedicalStatus.success,
          data: response,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MedicalStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> createMedical({
    required String athleteId,
    required int itemType,
    required String title,
    required String description,
    required String startDate,
    String? endDate,
    required bool isActive,
  }) async {
    emit(
      state.copyWith(
        actionStatus: MedicalActionStatus.loading,
        clearActionMessage: true,
      ),
    );

    try {
      final created = await _repository.createMedical(
        athleteId: athleteId,
        itemType: itemType,
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        isActive: isActive,
      );

      if (created == null) {
        emit(
          state.copyWith(
            actionStatus: MedicalActionStatus.failure,
            actionMessage: 'Failed to create medical history',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          actionStatus: MedicalActionStatus.success,
          actionMessage: 'Medical history created',
          data: [created, ...state.data],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: MedicalActionStatus.failure,
          actionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateMedical({
    required String id,
    required String athleteId,
    required int itemType,
    required String title,
    required String description,
    required String startDate,
    String? endDate,
    required bool isActive,
  }) async {
    emit(
      state.copyWith(
        actionStatus: MedicalActionStatus.loading,
        clearActionMessage: true,
      ),
    );

    try {
      final updated = await _repository.updateMedical(
        id: id,
        athleteId: athleteId,
        itemType: itemType,
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        isActive: isActive,
      );

      if (updated == null) {
        emit(
          state.copyWith(
            actionStatus: MedicalActionStatus.failure,
            actionMessage: 'Failed to update medical history',
          ),
        );
        return;
      }

      final newList = state.data.map((item) {
        return item.id == updated.id ? updated : item;
      }).toList();

      emit(
        state.copyWith(
          actionStatus: MedicalActionStatus.success,
          actionMessage: 'Medical history updated',
          data: newList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: MedicalActionStatus.failure,
          actionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteMedical({
    required String athleteId,
    required String id,
  }) async {
    emit(
      state.copyWith(
        actionStatus: MedicalActionStatus.loading,
        clearActionMessage: true,
      ),
    );

    try {
      final ok = await _repository.deleteMedical(athleteId: athleteId, id: id);

      if (!ok) {
        emit(
          state.copyWith(
            actionStatus: MedicalActionStatus.failure,
            actionMessage: 'Failed to delete medical history',
          ),
        );
        return;
      }

      final newList = state.data.where((item) => item.id != id).toList();

      emit(
        state.copyWith(
          actionStatus: MedicalActionStatus.success,
          actionMessage: 'Medical history deleted',
          data: newList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: MedicalActionStatus.failure,
          actionMessage: e.toString(),
        ),
      );
    }
  }

  void clearMedical() {
    emit(MedicalState.initial());
  }

  void clearActionState() {
    emit(
      state.copyWith(
        actionStatus: MedicalActionStatus.initial,
        clearActionMessage: true,
      ),
    );
  }
}
