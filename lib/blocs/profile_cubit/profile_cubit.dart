import 'package:athlete_hub/blocs/profile_cubit/profile_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository userRepository;

  ProfileCubit({required this.userRepository}) : super(const ProfileInitial());

  Future<void> updateProfile({
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
      emit(const ProfileUpdateLoading());

      final updatedUser = await userRepository.updateUser(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        sport: sport,
        team: team,
        birthDate: birthDate,
      );

      emit(ProfileUpdateSuccess(updatedUser));
    } catch (e) {
      emit(ProfileUpdateFailure(e.toString()));
    }
  }
}
