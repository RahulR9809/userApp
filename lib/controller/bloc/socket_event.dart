abstract class SocketEvent {}

class ConnectSocketEvent extends SocketEvent {
  final String userId;
  ConnectSocketEvent(this.userId);
}

class DisconnectSocketEvent extends SocketEvent {}


class ChatConnectevent extends SocketEvent{
  final String userid;

  ChatConnectevent({required this.userid});
}
class DisconnectChatEvent extends SocketEvent {}
