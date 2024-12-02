import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final userId = '';  // Declare the userId variable globally

// Function to get the userId from SharedPreferences
id() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedUserId = prefs.getString('userid');
  
  // Check if the userId exists and print debug info
  if (storedUserId != null) {
    print('User ID found: $storedUserId');
    return storedUserId;
  } else {
    print('No User ID found in SharedPreferences');
    return null;  // Return null if no userId is found
  }
}

class UserSocketService {
  late IO.Socket socket;

  // Connect the user app to the server
  void connect(String userId) {
    print('Initializing socket connection for user...');

    socket = IO.io('http://10.0.2.2:3003', <String, dynamic>{
        'path': '/socket.io/', // Match server path
      'transports': ['websocket'],
      'autoConnect': false,
      'timeout': 10000, // Set the connection timeout to 5 seconds
    });

    // Attempt to connect to the server
    socket.connect();

    // Handle successful connection
    socket.onConnect((_) {
      print('User connected: $userId');
      socket.emit('user-connected', userId);  // Emit the user ID to the server
      print('User ID sent to server: $userId');
    });

    // Handle connection error
    socket.onConnectError((error) {
      print("Connection error: $error");
    });

    // Handle socket disconnection
    socket.onDisconnect((_) {
      print('User disconnected from the server');
    });

    // Handle socket connection events
    socket.on('connect', (_) {
      print('Socket connected to server');
    });

    // Handle messages from the server (if needed)
    socket.on('message', (data) {
      print('Received message: $data');
    });
  }

  // Disconnect the socket when done
  void disconnect() {
    print('Disconnecting user from server...');
    socket.disconnect();
    print('User disconnected');
  }
}
