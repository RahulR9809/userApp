// import 'package:flutter/foundation.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class UserChatSocketService {
//   static final UserChatSocketService _instance = UserChatSocketService._internal();
//   late IO.Socket socket;

//   // Factory constructor to return the singleton instance
//   factory UserChatSocketService() {
//     return _instance;
//   }

//   // Private constructor
//   UserChatSocketService._internal();

//   // Initialize the socket
//   void initializeChatSocket() {
//     if (kDebugMode) {
//       print('Initializing chat socket connection...');
//     }
//     socket = IO.io('http://192.168.24.158:3004', IO.OptionBuilder()
//       .setTransports(['websocket'])
//       .disableAutoConnect()
//       .build());

//     // Listen for connection events
//     socket.onConnect((_) {
//       if (kDebugMode) {
//         print('chat Socket connected to server');
//       }
//     });

//     // Listen for connection errors
//     socket.onConnectError((error) {
//       if (kDebugMode) {
//         print('Connection error: $error');
//       }
//     });

//     // Listen for disconnection events
//     socket.onDisconnect((_) {
//       if (kDebugMode) {
//         print('Socket disconnected from server');
//       }
//     });

//     // Handle messages from the server (optional)
//     socket.on('latestMessage', (data) {
//       if (kDebugMode) {
//         print('Received message: $data');
//       }
//     });
//   }

//   // Connect the socket
//   void connectchatsocket(String userId) {
//     if (kDebugMode) {
//       print('Attempting to connect with userId: $userId');
//     }
//     socket.connect();

//     socket.onConnect((_) {
//       socket.emit('user-chat-connect', {'userId': userId});
//       if (kDebugMode) {
//         print('User ID sent to server: $userId');
//       }
//     });
//   }

//   // Disconnect the socket
//   void disconnect() {
//     if (kDebugMode) {
//       print('Disconnecting from server...');
//     }
//     socket.disconnect();
//     if (kDebugMode) {
//       print('User disconnected');
//     }
//   }





import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserChatSocketService {
  static final UserChatSocketService _instance = UserChatSocketService._internal();
  late IO.Socket socket;

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
    socket = IO.io('http://192.168.24.58:3004', IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
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

    // Handle incoming messages
    socket.on('latestMessage', (data) {
      if (kDebugMode) {
        print('Received message: $data');
      }
      _handleIncomingMessage(data);
    });
  }

  // Connect the socket
  void connectChatSocket(String userId) {
    if (kDebugMode) {
      print('Attempting to connect with userId: $userId');
    }
    socket.connect();

    socket.onConnect((_) {
      socket.emit('user-chat-connect', {'userId': userId});
      if (kDebugMode) {
        print('User ID sent to server: $userId');
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

  // Handle incoming messages
  void _handleIncomingMessage(dynamic data) {
    if (data != null && data is Map<String, dynamic>) {
      // Extract message and sender details
      final String message = data['message'] ?? '';
      final String senderId = data['senderId'] ?? '';
      if (kDebugMode) {
        print('Message from $senderId: $message');
      }
      // Notify the UI or BLoC about the new message
      // Use a callback, event, or state management approach to pass this message
    }
  }

  // Add a listener for incoming messages
  void addMessageListener(Function(Map<String, dynamic>) onMessageReceived) {
    socket.on('latestMessage', (data) {
      if (data != null && data is Map<String, dynamic>) {
        onMessageReceived(data);
      }
    });
  }
}
