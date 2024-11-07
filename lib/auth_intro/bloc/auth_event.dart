part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}


class SigninClickedEvent extends AuthEvent{}

class SubmitOTPEvent extends AuthEvent{
  final String otp;
  SubmitOTPEvent( {required this.otp});

}


class CheckAuthStatusEvent extends AuthEvent {}