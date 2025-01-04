
import 'package:flutter/foundation.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


// class UserSocketService {
//   static final UserSocketService _instance = UserSocketService._internal();
//   late IO.Socket socket;
//   Map<String, dynamic> latestRideData = {};
//   Function? onRideAcceptedCallback;

//   factory UserSocketService() {
//     return _instance;
//   }

//   // Private constructor
//   UserSocketService._internal();

//   // Initialize the socket
//   void initializeSocket() {
//     if (kDebugMode) {
//       print('Initializing socket connection...');
//     }
//     socket = IO.io('http://10.0.2.2:3003', <String, dynamic>{
//       'path': '/socket.io/',
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'timeout': 5000,
//     });

//     // Listen for connection events
//     socket.onConnect((_) {
//       if (kDebugMode) {
//         print('Socket connected to server');
//       }
//     });

//     // Listen for errors
//     socket.onConnectError((error) {
//       if (kDebugMode) {
//         print("Connection error: $error");
//       }
//     });

//     // Listen for disconnection events
//     socket.onDisconnect((_) {
//       if (kDebugMode) {
//         print('Socket disconnected from the server');
//       }
//     });

//     // Handle messages from the server (optional)
//     socket.on('message', (data) {
//       if (kDebugMode) {
//         print('Received message: $data');
//       }
//     });

//     // Listen for the 'rideAccepted' event
//     socket.on('rideAccepted', (data) {
//       if (kDebugMode) {
//         print('Received rideAccepted event with data: $data');
//       }
//       latestRideData = data;
//       // Trigger the callback when new data is received
//       if (onRideAcceptedCallback != null) {
//         onRideAcceptedCallback!(data);
//       }
//     });
//   }

//   Function(Map<String, dynamic>)? _rideAcceptedCallback;

//   void setRideAcceptedCallback(Function(Map<String, dynamic>) callback) {
//     _rideAcceptedCallback = callback;
//   }

//   // Connect the socket
//   void connectSocket(String userId) {
//     if (kDebugMode) {
//       print('Attempting to connect with userId: $userId');
//     }
//     socket.connect();

//     socket.onConnect((_) {
//       socket.emit('user-connected', userId);  // Emit userId to server
//       if (kDebugMode) {
//         print('User ID sent to server: $userId');
//       }
//     });
//   }

//   // Disconnect the socket
//   void disconnectSocket() {
//     if (kDebugMode) {
//       print('Disconnecting from server...');
//     }
//     socket.disconnect();
//     if (kDebugMode) {
//       print('User disconnected');
//     }
//   }
// }


class UserSocketService {
  static final UserSocketService _instance = UserSocketService._internal();
  late IO.Socket socket;
  Map<String, dynamic> latestRideData = {};
  Function(Map<String, dynamic>)? _rideAcceptedCallback;

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
    socket = IO.io('http://10.0.2.2:3003', <String, dynamic>{
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
  }

  // Register the ride accepted callback
  void setRideAcceptedCallback(Function(Map<String, dynamic>) callback) {
    _rideAcceptedCallback = callback;
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
