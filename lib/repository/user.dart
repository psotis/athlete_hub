import 'package:athlete_hub/helpers/imports.dart';

class UserRepository {
  final UserService userService;

  UserRepository({required this.userService});

  Future<Users> updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? sport,
    String? team,
    DateTime? birthDate,
  }) async {
    final updatedUser = await userService.updateUser(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      sport: sport,
      team: team,
      birthDate: birthDate,
    );

    return updatedUser.data!;
  }
}
