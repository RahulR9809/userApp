

import 'package:flutter/foundation.dart';
import 'package:rideuser/controller/auth_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserChatSocketService {
  static final UserChatSocketService _instance = UserChatSocketService._internal();
  late IO.Socket socket;

  // Define a callback variable
  Function(Map<String, dynamic>)? onMessageReceivedCallback;

  // Factory constructor to return the singleton instance
  factory UserChatSocketService() {
    return _instance;
  }

  // Private constructor
  UserChatSocketService._internal();

  // Initialize the socket
  void initializeChatSocket() {
    if (kDebugMode) {
      print('Initializing chat socket connection...');
    }
    socket = IO.io('http://$ipconfig:3004', IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .setPath('/socket.io/chat')
      .build());

    // Listen for connection events
    socket.onConnect((_) {
      if (kDebugMode) {
        print('Chat socket connected to server');
      }
    });

    // Listen for connection errors
    socket.onConnectError((error) {
      if (kDebugMode) {
        print('Connection error: $error');
      }
    });

    // Listen for disconnection events
    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Socket disconnected from server');
      }
    });

    // Handle incoming messages directly and call the callback if available
    socket.on('latestMessage', (data) {
      print('message from socketadasda:$data');
      if (data != null && onMessageReceivedCallback != null) {
        onMessageReceivedCallback!(data);
      }
    });
  }

  // Connect the socket
  void connectChatSocket(String tripId) {
    if (kDebugMode) {
      print('Attempting to connect with tripId: $tripId');
    }
    socket.connect();

    socket.onConnect((_) {
      socket.emit('user-chat-connect', tripId);
      if (kDebugMode) {
        print('User ID sent to server: $tripId');
      }
    });
  }

  // Disconnect the socket
  void disconnect() {
    if (kDebugMode) {
      print('Disconnecting from server...');
    }
    socket.disconnect();
    if (kDebugMode) {
      print('User disconnected');
    }
  }

  // Set a callback to handle incoming messages
  void setOnMessageReceivedCallback(Function(Map<String, dynamic>) callback) {
    onMessageReceivedCallback = callback;
  }




  
}
