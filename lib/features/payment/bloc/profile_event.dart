part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}


class UpdateProfileEvent extends ProfileEvent{
  final String name;
  final String email;
  final String phone;
final String id;
final XFile profileimage;
  UpdateProfileEvent( {required this.profileimage,required this.name, required this.email, required this.phone,required this.id,});
}