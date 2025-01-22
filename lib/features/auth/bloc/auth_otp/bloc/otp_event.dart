part of 'otp_bloc.dart';

@immutable
sealed class OtpEvent {}

class ResendOtPEvent extends OtpEvent{
  final String email;

  ResendOtPEvent({required this.email});


}

