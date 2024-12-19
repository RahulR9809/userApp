abstract class SocketState {}

class SocketInitialState extends SocketState {}

class SocketConnectedState extends SocketState {
  final String userId;
  SocketConnectedState(this.userId);
}

class SocketDisconnectedState extends SocketState {}



class ChatConnectedState extends SocketState {
  final String userId;
  ChatConnectedState(this.userId);
}

class ChatDisconnectedState extends SocketState {}
