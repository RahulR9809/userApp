part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}


final class LoginLoading extends AuthState{}

// final class GoogleAuthenticatedState extends AuthState{}

final class GoogleUnAuthenticatedState extends AuthState{}

final class EmailAuthenticatedState extends AuthState{}

final class EmailUnAuthenticatedState extends AuthState{}

final class ErrorState extends AuthState{
  final String message;

  ErrorState({required this.message});
}



class AuthBlocked extends AuthState {}

final class UnauthenticatedState extends AuthState{}





class GoogleAuthenticatedState extends AuthState {
  final String? token;
  final Map<String, dynamic>? userData;

  GoogleAuthenticatedState({ this.token,  this.userData});
}


class GoogleAuthError extends AuthState {
  final String message;

  GoogleAuthError({required this.message});
}
