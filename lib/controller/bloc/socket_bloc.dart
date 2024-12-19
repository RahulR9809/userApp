// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/controller/user_socket.dart';
// import 'socket_event.dart';
// import 'socket_state.dart';

// class SocketBloc extends Bloc<SocketEvent, SocketState> {
//   final UserSocketService userSocketService;

//   SocketBloc(this.userSocketService) : super(SocketInitialState());

//   Stream<SocketState> mapEventToState(SocketEvent event) async* {
//     if (event is ConnectSocketEvent) {
//       // Initialize and connect socket
//       userSocketService.initializeSocket();
//       userSocketService.connectSocket(event.userId);

//       // Yield connected state
//       yield SocketConnectedState(event.userId);
//     } else if (event is DisconnectSocketEvent) {
//       // Disconnect the socket
//       userSocketService.disconnectSocket();

//       // Yield disconnected state
//       yield SocketDisconnectedState();
//     }
//   }
// }



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/controller/chat_usersoketcontroller.dart';
import 'package:rideuser/controller/user_socket.dart';
import 'socket_event.dart';
import 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final UserSocketService userSocketService;
final UserChatSocketService userChatSocketService;
  SocketBloc(this.userSocketService, this.userChatSocketService) : super(SocketInitialState()) {
    on<ConnectSocketEvent>(_onConnectSocket);
    // on<DisconnectSocketEvent>(_onDisconnectSocket);
    on<ChatConnectevent>(_onChatSocket);
    on<DisconnectChatEvent>(_onchatDisconnet);
  }

  // Method for handling ConnectSocketEvent
  void _onConnectSocket(
    ConnectSocketEvent event,
    Emitter<SocketState> emit,
  ) {
    // Initialize and connect socket
    userSocketService.connectSocket(event.userId);

    // Emit connected state
    emit(SocketConnectedState(event.userId));
  }

  // Method for handling DisconnectSocketEvent
  // void _onDisconnectSocket(
  //   DisconnectSocketEvent event,
  //   Emitter<SocketState> emit,
  // ) {
  //   // Disconnect the socket
  //   userSocketService.disconnectSocket();

  //   // Emit disconnected state
  //   emit(SocketDisconnectedState());
  // }

  void _onChatSocket(ChatConnectevent event, Emitter<SocketState> emit) {

    // Initialize and connect socket
    userChatSocketService.connectChatSocket(event.userid);

    // Emit connected state
    emit(ChatConnectedState(event.userid));

  }

void _onchatDisconnet(DisconnectChatEvent event, Emitter<SocketState> emit) {
   userChatSocketService.disconnect();
   emit(ChatDisconnectedState());
  
  }
}
