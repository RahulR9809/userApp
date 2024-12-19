
import 'package:flutter/foundation.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class UserSocketService {
  static final UserSocketService _instance = UserSocketService._internal();
  late IO.Socket socket;
  Map<String, dynamic> latestRideData = {}; // Store the latest ride data

  final RideBloc rideBloc = RideBloc(); // Initialize your RideBloc
  // Factory constructor to return the singleton instance
  factory UserSocketService() {
    return _instance;
  }

  // Private constructor
  UserSocketService._internal();

  // Initialize the socket
  void initializeSocket() {
    if (kDebugMode) {
      print('Initializing socket connection...');
    }
    socket = IO.io('http://192.168.24.158:3003', <String, dynamic>{
      'path': '/socket.io/',
      'transports': ['websocket'],
      'autoConnect': false,
      'timeout': 5000,
    });

    // Listen for connection events
    socket.onConnect((_) {
      if (kDebugMode) {
        print('Socket connected to server');
      }
    });

    // Listen for errors
    socket.onConnectError((error) {
      if (kDebugMode) {
        print("Connection error: $error");
      }
    });

    // Listen for disconnection events
    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Socket disconnected from the server');
      }
    });

    // Handle messages from the server (optional)
    socket.on('message', (data) {
      if (kDebugMode) {
        print('Received message: $data');
      }
    });

    // Listen for the 'rideAccepted' event
   socket.on('rideAccepted', (data) {
  if (kDebugMode) {
    print('Dispatching RideAcceptedEvent with data: $data');
  }
        latestRideData = data;

});

  }

  // Connect the socket
  void connectSocket(String userId) {
    if (kDebugMode) {
      print('Attempting to connect with userId: $userId');
    }
    socket.connect();

    socket.onConnect((_) {
      socket.emit('user-connected', userId);  // Emit userId to server
      if (kDebugMode) {
        print('User ID sent to server: $userId');
      }
    });
  }

  // Disconnect the socket
  void disconnectSocket() {
    if (kDebugMode) {
      print('Disconnecting from server...');
    }
    socket.disconnect();
    if (kDebugMode) {
      print('User disconnected');
    }
  }
}
