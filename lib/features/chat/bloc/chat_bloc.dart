import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:rideuser/features/chat/service/chat_controller.dart';
import 'package:rideuser/features/chat/service/chat_usersoketcontroller.dart';
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
List<String> _messages = [];
List<Map<String, dynamic>> _sentMessages = []; // Store sent messages
List<Map<String, dynamic>> _receivedMessages = []; // Store received messages
final UserChatSocketService _socketService = UserChatSocketService();

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<LoadMessages>(_onLoadMessages);

    _socketService.setOnMessageReceivedCallback((data) {
      final message = data['message'] ?? '';
      final senderId = data['senderId'] ?? '';
      final time = _formatTime(DateTime.now());

      if (message.isNotEmpty) {
        add(MessageReceived(message, senderId, time));
      }
    });
  }

  FutureOr<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    String? userId = await _getUserId();
    String? driverId = await _getDriverId();
    String? tripId = await _getTripId();

    final time = _formatTime(DateTime.now());

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

      _sentMessages.add({
        'message': event.message,
        'isSender': true,
        'time': time,
      });


    } else {
      emit(ChatError(message: 'User ID not found'));
    }
  }

  FutureOr<void> _onMessageReceived(
      MessageReceived event, Emitter<ChatState> emit) async {
    String? userId = await _getUserId();

    _receivedMessages.add({
      'message': event.message,
      'isSender': event.senderid == userId,
      'time': event.time,
    });

    emit(ChatReceivedMessagesUpdated(messages: _receivedMessages));
  }

  FutureOr<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('accesstoken');
      final tripId = await _getTripId();
      if (kDebugMode) {
        print('token from get message:$token');
      }
      List<dynamic> messages = await chatService.getMessages(
        token: token ?? 'get message token not found',
        tripId: tripId ?? 'get message tripid not found',
      );
      if (kDebugMode) {
        print(' the getted message from database:$messages');
      }
    String? userId = await _getUserId();

      _receivedMessages = messages.map((e) {
        final timestamp = e['createdAt'] != null

            ? DateTime.parse(e['createdAt'])
                .toUtc()
                .add(const Duration(hours: 5, minutes: 30)) 

            : DateTime.now(); 

        return {
          'message': e['message'],
          'isSender': e['senderId'] == userId,
          'time': _formatTime(timestamp),
        };
      }).toList();

      emit(ChatReceivedMessagesUpdated(messages: _receivedMessages));
    } catch (e) {
      emit(ChatError(message: 'Failed to load messages: $e'));
    }
  }
}
