// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class UserSocketService {
//   late IO.Socket socket;

//   // Initialize the socket
//   void initializeSocket() {
//     print('Initializing socket connection...');
//     socket = IO.io('http://10.0.2.2:3003', <String, dynamic>{
//       'path': '/socket.io/', // Match server path
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'timeout': 5000, // Set the connection timeout to 5 seconds
//     });

//     // Listen for connection events
//     socket.onConnect((_) {
//       print('Socket connected to server');
//     });

//     // Listen for errors
//     socket.onConnectError((error) {
//       print("Connection error: $error");
//     });

//     // Listen for disconnection events
//     socket.onDisconnect((_) {
//       print('Socket disconnected from the server');
//     });

//     // Handle messages from the server (optional)
//     socket.on('message', (data) {
//       print('Received message: $data');
//     });
//   }

//   // Connect the socket
//   void connectSocket(String userId) {
//     print('Attempting to connect with userId: $userId');
//     socket.connect();

//     socket.onConnect((_) {
//       socket.emit('user-connected', userId);  // Emit userId to server
//       print('User ID sent to server: $userId');
//     });
//   }

//   void emitRideRequest(Map<String, dynamic> rideRequest) {
//     if (socket.connected) {
//       socket.emit('ride_request', rideRequest);
//       print('Ride request emitted: $rideRequest');
//     } else {
//       print('Socket is not connected. Cannot emit ride request.');
//     }
//   }


//   // Disconnect the socket
//   void disconnectSocket() {
//     print('Disconnecting from server...');
//     socket.disconnect();
//     print('User disconnected');
//   }
// }
 



// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class UserSocketService {
//   late IO.Socket socket;

//   // Initialize the socket
//   void initializeSocket() {
//     print('Initializing socket connection...');
//     socket = IO.io('http://192.168.1.35:3003', <String, dynamic>{
//       'path': '/socket.io/', // Match server path
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'timeout': 5000, // Set the connection timeout to 5 seconds
//     });

//     // Listen for connection events
//     socket.onConnect((_) {
//       print('Socket connected to server');
//     });

//     // Listen for errors
//     socket.onConnectError((error) {
//       print("Connection error: $error");
//     });

//     // Listen for disconnection events
//     socket.onDisconnect((_) {
//       print('Socket disconnected from the server');
//     });

//     // Handle messages from the server (optional)
//     socket.on('message', (data) {
//       print('Received message: $data');
//     });
//   }

//   // Connect the socket
//   void connectSocket(String userId) {
//     print('Attempting to connect with userId: $userId');
//     socket.connect();

//     socket.onConnect((_) {
//       socket.emit('user-connected', userId);  // Emit userId to server
//       print('User ID sent to server: $userId');
//     });
//   }

//   // Emit a ride request to the driver
//   void emitRideRequestToDriver(String driverId, String tripId, Map<String, dynamic> rideRequest) {
//     if (socket.connected) {
//       // Include both driverId and tripId in the emitted data
//       Map<String, dynamic> dataToEmit = {
//         'driverId': driverId,
//         'tripId': tripId,
//         ...rideRequest,  // Spread the rest of the rideRequest data
//       };

//       socket.emit('ride-request', dataToEmit);
//       print('Ride request emitted to driver: $dataToEmit');
//     } else {
//       print('Socket is not connected. Cannot emit ride request.');
//     }
//   }

//   // Emit driver response after accepting, rejecting, or canceling the ride
//   void emitDriverResponse(String tripId, String driverId, String responseStatus) {
//     if (socket.connected) {
//       socket.emit('driver-response', {
//         'tripId': tripId,
//         'driverId': driverId,
//         'responseStatus': responseStatus, // accepted, rejected, or cancelled
//       });
//       print('Driver response emitted: tripId: $tripId, driverId: $driverId, responseStatus: $responseStatus');
//     } else {
//       print('Socket is not connected. Cannot emit driver response.');
//     }
//   }

//   // Disconnect the socket
//   void disconnectSocket() {
//     print('Disconnecting from server...');
//     socket.disconnect();
//     print('User disconnected');
//   }
// }


import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserSocketService {
  static final UserSocketService _instance = UserSocketService._internal();
  late IO.Socket socket;

  // Factory constructor to return the singleton instance
  factory UserSocketService() {
    return _instance;
  }

  // Private constructor
  UserSocketService._internal();

  // Initialize the socket
  void initializeSocket() {
    print('Initializing socket connection...');
    socket = IO.io('http://192.168.24.130:3003', <String, dynamic>{
      'path': '/socket.io/',
      'transports': ['websocket'],
      'autoConnect': false,
      'timeout': 5000, // Set the connection timeout to 5 seconds
    });

    // Listen for connection events
    socket.onConnect((_) {
      print('Socket connected to server');
    });

    // Listen for errors
    socket.onConnectError((error) {
      print("Connection error: $error");
    });

    // Listen for disconnection events
    socket.onDisconnect((_) {
      print('Socket disconnected from the server');
    });

    // Handle messages from the server (optional)
    socket.on('message', (data) {
      print('Received message: $data');
    });
  }

  // Connect the socket
  void connectSocket(String userId) {
    print('Attempting to connect with userId: $userId');
    socket.connect();

    socket.onConnect((_) {
      socket.emit('user-connected', userId);  // Emit userId to server
      print('User ID sent to server: $userId');
    });
  }

  // Check if socket is connected
  bool isConnected() {
    return socket.connected;
  }



  // Disconnect the socket
  void disconnectSocket() {
    print('Disconnecting from server...');
    socket.disconnect();
    print('User disconnected');
  }
}
