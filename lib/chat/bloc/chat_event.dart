


part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}






class MessageReceived extends ChatEvent {
  final String message;
  final String senderid;
final String time;

  MessageReceived(this.message,this.senderid,this .time);
}

class SendMessage extends ChatEvent {
  final String message;
  final String? userid;
  final String? tripId;
  final String? token;

  SendMessage({
    required this.message,
    this.userid,
    this.tripId,
     this.token,
  });
}


class LoadMessages extends ChatEvent {
  final String? token;
  final String? tripId;

  LoadMessages({ this.token,  this.tripId});
}
