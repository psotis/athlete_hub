import 'package:athlete_hub/helpers/imports.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileUpdateLoading extends ProfileState {
  const ProfileUpdateLoading();
}

final class ProfileUpdateSuccess extends ProfileState {
  final Users user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class ProfileUpdateFailure extends ProfileState {
  final String message;

  const ProfileUpdateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
