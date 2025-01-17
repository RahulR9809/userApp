part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState{}




class ChatMessagesLoaded extends ChatState {
  final List<String> messages;
  ChatMessagesLoaded({required this.messages});
}

class ChatError extends ChatState{
  final String message;

  ChatError({required this.message});
}


class ChatSentMessagesUpdated extends ChatState {
  final List<Map<String, dynamic>> messages;
  ChatSentMessagesUpdated({required this.messages});
}

class ChatReceivedMessagesUpdated extends ChatState {
  final List<Map<String, dynamic>> messages;
  ChatReceivedMessagesUpdated({required this.messages});
}
