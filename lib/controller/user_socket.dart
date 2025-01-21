
import 'package:flutter/foundation.dart';
import 'package:rideuser/controller/auth_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserSocketService {
  static final UserSocketService _instance = UserSocketService._internal();
  late IO.Socket socket;
  Map<String, dynamic> latestRideData = {};
Map<String, dynamic> latestRidestartedData = {};
Map<String, dynamic> ridecompleted = {};


  Function(Map<String, dynamic>)? _rideAcceptedCallback;
  Function(Map<String, dynamic>)? _rideStartedCallback;
    Function(Map<String, dynamic>)? _RidecompletedCallback;


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
    socket = IO.io('http://$ipconfig:3003', <String, dynamic>{
      'path': '/socket.io/trip',
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

    // Listen for the 'rideAccepted' event
    socket.on('rideAccepted', (data) {
      if (kDebugMode) {
        print('Received rideAccepted event with data: $data');
      }
      latestRideData = Map<String, dynamic>.from(data);

      // Trigger the registered callback
      if (_rideAcceptedCallback != null) {
        _rideAcceptedCallback!(latestRideData);
      }
    });




socket.on('ride-started', (data) {
  print('Ride started data from socket: $data');
  latestRidestartedData = Map<String, dynamic>.from(data);
  if (_rideStartedCallback != null) {
    _rideStartedCallback!(latestRidestartedData);
  }
});





socket.on('ride-complete', (data){
print(' ride completed data from socket :$data');
  ridecompleted = Map<String, dynamic>.from(data);
if(_RidecompletedCallback!=null){
  _RidecompletedCallback!(ridecompleted);
}

});

  }

  // Register the ride accepted callback
  void setRideAcceptedCallback(Function(Map<String, dynamic>) callback) {
    _rideAcceptedCallback = callback;
  }
  


 void setRideStartedCallback(Function(Map<String, dynamic>) callback) {
    _rideStartedCallback = callback;
  }



   void ridecompletedCallback(Function(Map<String, dynamic>) callback) {
    _RidecompletedCallback = callback;
  }


  // Connect the socket
  void connectSocket(String userId) {
    if (kDebugMode) {
      print('Attempting to connect with userId: $userId');
    }
    socket.connect();

    socket.onConnect((_) {
      socket.emit('user-connected', userId);
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
