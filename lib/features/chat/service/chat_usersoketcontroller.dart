

import 'package:flutter/foundation.dart';
import 'package:rideuser/features/auth/service/auth_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserChatSocketService {
  static final UserChatSocketService _instance = UserChatSocketService._internal();
  late IO.Socket socket;

  Function(Map<String, dynamic>)? onMessageReceivedCallback;

  factory UserChatSocketService() {
    return _instance;
  }

  UserChatSocketService._internal();

  void initializeChatSocket() {
    if (kDebugMode) {
      print('Initializing chat socket connection...');
    }
    socket = IO.io('http://$ipconfig:3004', IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .setPath('/socket.io/chat')
      .build());

    socket.onConnect((_) {
      if (kDebugMode) {
        print('Chat socket connected to server');
      }
    });

    socket.onConnectError((error) {
      if (kDebugMode) {
        print('Connection error: $error');
      }
    });

    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Socket disconnected from server');
      }
    });

    socket.on('latestMessage', (data) {
      if (kDebugMode) {
        print('message from socketadasda:$data');
      }
      if (data != null && onMessageReceivedCallback != null) {
        onMessageReceivedCallback!(data);
      }
    });
  }

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

  void disconnect() {
    if (kDebugMode) {
      print('Disconnecting from server...');
    }
    socket.disconnect();
    if (kDebugMode) {
      print('User disconnected');
    }
  }

  void setOnMessageReceivedCallback(Function(Map<String, dynamic>) callback) {
    onMessageReceivedCallback = callback;
  }




  
}
