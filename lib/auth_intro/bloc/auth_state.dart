part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}


final class LoginLoading extends AuthState{}

final class GoogleAuthenticatedState extends AuthState{}

final class GoogleUnAuthenticatedState extends AuthState{}

final class EmailAuthenticatedState extends AuthState{}

final class EmailUnAuthenticatedState extends AuthState{}

final class ErrorState extends AuthState{
  final String message;

  ErrorState({required this.message});
}




final class UnauthenticatedState extends AuthState{}