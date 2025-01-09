// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:rideuser/controller/chat_controller.dart';
// import 'package:rideuser/controller/chat_usersoketcontroller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// part 'chat_event.dart';
// part 'chat_state.dart';

//   Future<String?> _getDriverId() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     return pref.getString('driverid');
//   }

//   Future<String?> _getUserId() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     return pref.getString('newUserId');
//   }

//   Future<String?> _getTripId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('tripid');
//   }
// ChatService chatService = ChatService();
// List<String> _messages = []; 
//   final UserChatSocketService _socketService = UserChatSocketService();

// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   ChatBloc() : super(ChatInitial()) {
    

//     on<SendMessage>(_onSendMessage);
//     on<MessageReceived>(_onMessageReceived);
//     on<LoadMessages>(_onLoadMessages);
    

//   _socketService.setOnMessageReceivedCallback((data) {
//       final message = data['message'] ?? '';
//       if (message.isNotEmpty && !_messages.contains(message)) {
//         add(MessageReceived(message));
//       }
//     });

//   }

//   // Handle the SendMessage event
//   FutureOr<void> _onSendMessage(
//       SendMessage event, Emitter<ChatState> emit) async {
//     String? driverId = await _getDriverId();
//     String? userId = await _getUserId();
//     String? tripid=await _getTripId();
//     print('driverid:$driverId');
//       print('usesrid:$userId');
//         print('tripid in chat:$tripid');

//     if (userId != null||driverId!=null||tripid!=null) {
//       chatService.sendMessage(
//         senderId: userId!,
//          recieverId:driverId!,
//           message: event.message,
//            tripId: tripid!,
//             senderType: 'user',
//              driverId: driverId,
//               userId: userId);
//       _messages.add(event.message);
//       emit(ChatMessagesLoaded(messages: _messages));
//     } else {
//       emit(ChatError(message: 'User ID not found'));
//     }
//   }



// FutureOr<void> _onLoadMessages(
//     LoadMessages event, Emitter<ChatState> emit) async {
//   emit(ChatLoading());
//   try {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     final token = pref.getString('accesstoken');
//     final tripId = await _getTripId();
    
//     // Fetch messages from the service
//     List<dynamic> messages = await chatService.getMessages(
//       token: token ?? 'get message token not found',
//       tripId: tripId ?? 'get message tripid not found',
//     );

//     // Extract only the 'message' field from each message
//     _messages = messages
//         .map((e) => e['message'] as String) // Extract the 'message' field
//         .toList();

//     print('this is from bloc: $_messages'); // For debugging
//     emit(ChatMessagesLoaded(messages: _messages));
//   } catch (e) {
//     emit(ChatError(message: 'Failed to load messages: $e'));
//   }
// }



//    FutureOr<void> _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
//     if (!_messages.contains(event.message)) {
//       _messages.add(event.message);
//       emit(ChatMessagesLoaded(messages: List.from(_messages)));
//       print('message from socket:${event.message}');
//     }
//   }

// }



// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:rideuser/controller/chat_controller.dart';
// import 'package:rideuser/controller/chat_usersoketcontroller.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// part 'chat_event.dart';
// part 'chat_state.dart';

// Future<String?> _getDriverId() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   return pref.getString('driverid');
// }

// Future<String?> _getUserId() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   return pref.getString('newUserId');
// }

// Future<String?> _getTripId() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('tripid');
// }

// ChatService chatService = ChatService();
// List<Map<String, dynamic>> _messages = []; // Store both message and sender info
// final UserChatSocketService _socketService = UserChatSocketService();

// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   ChatBloc() : super(ChatInitial()) {
//     on<SendMessage>(_onSendMessage);
//     on<MessageReceived>(_onMessageReceived);
//     on<LoadMessages>(_onLoadMessages);

//     _socketService.setOnMessageReceivedCallback((data) {
//       final message = data['message'] ?? '';
//       if (message.isNotEmpty) {
//         add(MessageReceived(message));
//       }
//     });
//   }

//   // Handle the SendMessage event
//   FutureOr<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
//     String? driverId = await _getDriverId();
//     String? userId = await _getUserId();
//     String? tripid = await _getTripId();

//     if (userId != null || driverId != null || tripid != null) {
//       chatService.sendMessage(
//         senderId: userId!,
//         recieverId: driverId!,
//         message: event.message,
//         tripId: tripid!,
//         senderType: 'user',
//         driverId: driverId,
//         userId: userId,
//       );
      
//       _messages.add({
//         'message': event.message,
//         'isSender': true, // Tag as sender message
//       });
//       emit(ChatMessagesLoaded(messages: _messages));
//     } else {
//       emit(ChatError(message: 'User ID not found'));
//     }
//   }

 

//   FutureOr<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
//   emit(ChatLoading());
//   try {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     final token = pref.getString('accesstoken');
//     final tripId = await _getTripId();

//     List<dynamic> messages = await chatService.getMessages(
//       token: token ?? 'get message token not found',
//       tripId: tripId ?? 'get message tripid not found',
//     );

//     _messages = messages.map((e) {
//       bool isSender = e['senderType'] == 'user'; // Check if the sender is the user
//       return {
//         'message': e['message'],
//         'isSender': isSender, // If senderType is 'user', message is from the user (right side)
//       };
//     }).toList();

//     emit(ChatMessagesLoaded(messages: _messages));
//   } catch (e) {
//     emit(ChatError(message: 'Failed to load messages: $e'));
//   }
// }


//   FutureOr<void> _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
//       _messages.add({
//         'message': event.message,
//         'isSender': false, // Tag as receiver message
//       });
//       emit(ChatMessagesLoaded(messages: List.from(_messages)));
//     }
//   }




import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rideuser/controller/chat_controller.dart';
import 'package:rideuser/controller/chat_usersoketcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';
part 'chat_state.dart';

Future<String?> _getDriverId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('driverid');
}

Future<String?> _getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('newUserId');
}

Future<String?> _getTripId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('tripid');
}

ChatService chatService = ChatService();
List<Map<String, dynamic>> _sentMessages = [];  // Store sent messages
List<Map<String, dynamic>> _receivedMessages = [];  // Store received messages
final UserChatSocketService _socketService = UserChatSocketService();


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<LoadMessages>(_onLoadMessages);

    _socketService.setOnMessageReceivedCallback((data) {
      final message = data['message'] ?? '';
      final senderId = data['senderId'] ?? '';

      if (message.isNotEmpty) {
        add(MessageReceived(message, senderId));
      }
    });
  }

  FutureOr<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    String? userId = await _getUserId();
    String? driverId = await _getDriverId();
    String? tripId = await _getTripId();

    if (userId != null && driverId != null && tripId != null) {
      chatService.sendMessage(
        senderId: userId,
        recieverId: driverId,
        message: event.message,
        tripId: tripId,
        senderType: 'user',
        driverId: driverId,
        userId: userId,
      );

      // Add the sent message immediately without triggering full rebuild
      _sentMessages.add({
        'message': event.message,
        'isSender': true,
      });

      // Only emit updated sent messages to avoid full UI rebuild
      emit(ChatSentMessagesUpdated(messages: _sentMessages));
    } else {
      emit(ChatError(message: 'User ID not found'));
    }
  }


  FutureOr<void> _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) async {
    String? userId = await _getUserId();

    // Add the received message
    _receivedMessages.add({
      'message': event.message,
      'isSender': event.senderid == userId,
    });

    // Emit the updated state with received messages
    emit(ChatReceivedMessagesUpdated(messages: _receivedMessages));
  }

  FutureOr<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('accesstoken');
      final tripId = await _getTripId();

      List<dynamic> messages = await chatService.getMessages(
        token: token ?? 'get message token not found',
        tripId: tripId ?? 'get message tripid not found',
      );

      String? userId = await _getUserId();

      _receivedMessages = messages.map((e) {
        return {
          'message': e['message'],
          'isSender': e['senderId'] == userId,
        };
      }).toList();

      emit(ChatReceivedMessagesUpdated(messages: _receivedMessages));
    } catch (e) {
      emit(ChatError(message: 'Failed to load messages: $e'));
    }
  }
}
