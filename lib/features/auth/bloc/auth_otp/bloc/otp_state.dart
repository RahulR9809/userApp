part of 'otp_bloc.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class LoadingState extends OtpState{}

final class LoadedState extends OtpState{}

final class OtpErrorState extends OtpState{
  final String message;

  OtpErrorState({required this.message});
}
