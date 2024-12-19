import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/controller/chat_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';
part 'chat_state.dart';

ChatService chatService = ChatService();
List<String> _messages = []; // List to hold chat messages

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
  }

  // Fetch the userId from SharedPreferences
  Future<String?> _getDriverId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('driverid');
  }

  Future<String?> _getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('userid');
  }

  Future<String?> _getTripId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('tripid');
  }

  // Handle the SendMessage event
  FutureOr<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    String? driverId = await _getDriverId();
    String? userId = await _getUserId();
    String? tripid=await _getTripId();
    print('driverid:$driverId');
      print('usesrid:$userId');
        print('tripid:$tripid');
    if (userId != null||driverId!=null||tripid!=null) {
      chatService.sendMessage(
        senderId: userId!,
         recieverId:driverId!,
          message: event.message,
           tripId: tripid!,
            senderType: 'user',
             driverId: driverId,
              userId: userId);
      _messages.add(event.message); // Add the sent message to the list
      emit(ChatMessagesLoaded(messages: _messages));
    } else {
      // Handle case where userId is not found
      emit(ChatError(message: 'User ID not found'));
    }
  }

  // Handle the MessageReceived event
  FutureOr<void> _onMessageReceived(
      MessageReceived event, Emitter<ChatState> emit) {
    _messages.add(event.message); // Add the received message to the list
    emit(ChatMessagesLoaded(messages: _messages));
  }
}
