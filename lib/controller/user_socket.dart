
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// class UserSocketService {
//   static final UserSocketService _instance = UserSocketService._internal();
//   late IO.Socket socket;

//   // Factory constructor to return the singleton instance
//   factory UserSocketService() {
//     return _instance;
//   }

//   // Private constructor
//   UserSocketService._internal();

//   // Initialize the socket
//   void initializeSocket() {
//     print('Initializing socket connection...');
//     socket = IO.io('http://192.168.1.22:3003', <String, dynamic>{
//       'path': '/socket.io/',
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

//   // Check if socket is connected
//   bool isConnected() {
//     return socket.connected;
//   }






//   // Disconnect the socket
//   void disconnectSocket() {
//     print('Disconnecting from server...');
//     socket.disconnect();
//     print('User disconnected');
//   }
// }










// class UserSocketService {
//   static final UserSocketService _instance = UserSocketService._internal();
//   late IO.Socket socket;

//   final RideBloc rideBloc = RideBloc(); // Initialize your RideBloc

//   // Factory constructor to return the singleton instance
//   factory UserSocketService() {
//     return _instance;
//   }

//   // Private constructor
//   UserSocketService._internal();

//   // Initialize the socket
//   void initializeSocket() {
//     print('Initializing socket connection...');
//     socket = IO.io('http://192.168.1.22:3003', <String, dynamic>{
//       'path': '/socket.io/',
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

//   socket.on('rideAccepted', (data) {
//       print('Ride Accepted: $data');
//       // Handle the ride accepted data here
//       // Update the UI or show a notification
//       _handleRideAccepted(data);
//     });
//   }

//   // Handle the ride accepted event
//   void _handleRideAccepted(Map<String, dynamic> data) {
//     // Update your UI with the received ride acceptance data
//     print('Driver: ${data['driverDetails']['name']} accepted the ride');
//     // You could show a dialog, update the status, or notify the user.
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

//   // Check if socket is connected
//   bool isConnected() {
//     return socket.connected;
//   }


//   // Disconnect the socket
//   void disconnectSocket() {
//     print('Disconnecting from server...');
//     socket.disconnect();
//     print('User disconnected');
//   }
// }





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
    print('Initializing socket connection...');
    socket = IO.io('http://192.168.24.213:3003', <String, dynamic>{
      'path': '/socket.io/',
      'transports': ['websocket'],
      'autoConnect': false,
      'timeout': 5000,
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

    // Listen for the 'rideAccepted' event
   socket.on('rideAccepted', (data) {
  print('Dispatching RideAcceptedEvent with data: $data');
        latestRideData = data;

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

  // Disconnect the socket
  void disconnectSocket() {
    print('Disconnecting from server...');
    socket.disconnect();
    print('User disconnected');
  }
}
