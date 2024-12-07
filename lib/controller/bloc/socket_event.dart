abstract class SocketEvent {}

class ConnectSocketEvent extends SocketEvent {
  final String userId;
  ConnectSocketEvent(this.userId);
}

class DisconnectSocketEvent extends SocketEvent {}
