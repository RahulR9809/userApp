part of 'email_bloc.dart';

@immutable
sealed class EmailState {}

final class EmailInitial extends EmailState {}

class LoadingState extends EmailState{}

class LoadedState extends EmailState{}

class ErrorState extends EmailState{
  final String message;

  ErrorState({required this.message});
}