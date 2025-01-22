part of 'email_bloc.dart';

@immutable
sealed class EmailEvent {}

class SendOTpButtonClickedEvent extends EmailEvent{
  final String email;

  SendOTpButtonClickedEvent({required this.email});
}
