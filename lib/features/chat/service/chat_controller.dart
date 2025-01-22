import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rideuser/features/auth/service/auth_controller.dart';

class ChatService {
  final String baseUrl='http://$ipconfig:3001/api/chat';

Future<void> sendMessage({
  required String senderId,
  required String recieverId,
  required String message,
  required String tripId,
  required String senderType,
  required String driverId,
  required String userId,
}) async {
  try {
    // Debug print
    if (kDebugMode) {
      print('Request Body: ${{
      "senderId": senderId,
      "recieverId": tripId,
      "message": message,
      "tripId": tripId,
      "senderType": senderType,
      "driverId": tripId,
      "userId": tripId,
    }}');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/sendMessage'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "senderId": senderId,
        "recieverId": recieverId,
        "message": message,
        "tripId": tripId,
        "senderType": senderType,
        "driverId": driverId,
        "userId": tripId,
      }),
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print("Message sent successfully:");
      }
      if (kDebugMode) {
        print('Response Status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response Body: ${response.body}');
      }
    } else {
      if (kDebugMode) {
        print("Failed to send message: ${response.statusCode} - ${response.body}");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error sending message: $e");
    }
  }
}


  Future<List<dynamic>> getMessages({
    required String token,
    required String tripId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/messages/$tripId'), 
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final messages=data['messages']; 
        if (kDebugMode) {
          print('this is the data :$messages');
        }
        return messages;
        
      } else {
        if (kDebugMode) {
          print("Failed to fetch messages: ${response.body}");
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching messages: $e");
      }
      return [];
    }
  }
}