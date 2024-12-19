part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}



class ChatMessageSent extends ChatState {}

// class ChatMessageReceived extends ChatState {
//   final String message;

//   ChatMessageReceived(this.message);
// }

class ChatMessagesLoaded extends ChatState {
  final List<String> messages;
  ChatMessagesLoaded({required this.messages});
}

class ChatError extends ChatState{
  final String message;

  ChatError({required this.message});
}