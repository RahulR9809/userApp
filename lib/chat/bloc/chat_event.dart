part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}



class SendMessage extends ChatEvent {
  final String message;
  final String? userid;

  SendMessage({required this.message,  this.userid});
}

class MessageReceived extends ChatEvent {
  final String message;

  MessageReceived(this.message);
}