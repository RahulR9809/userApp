import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/controller/user_socket.dart';
import 'socket_event.dart';
import 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final UserSocketService userSocketService;

  SocketBloc(this.userSocketService) : super(SocketInitialState());

  @override
  Stream<SocketState> mapEventToState(SocketEvent event) async* {
    if (event is ConnectSocketEvent) {
      // Initialize and connect socket
      userSocketService.initializeSocket();
      userSocketService.connectSocket(event.userId);

      // Yield connected state
      yield SocketConnectedState(event.userId);
    } else if (event is DisconnectSocketEvent) {
      // Disconnect the socket
      userSocketService.disconnectSocket();

      // Yield disconnected state
      yield SocketDisconnectedState();
    }
  }
}
