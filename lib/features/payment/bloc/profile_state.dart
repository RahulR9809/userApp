part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String? name;
  final String? email;
  final String? phone;
  ProfileLoaded({required this.name, required this.email,required this.phone});
}

class UpdateProfileState extends ProfileState{}

class ProfileUpdatedState extends ProfileState{

}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}