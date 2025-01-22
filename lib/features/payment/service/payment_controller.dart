
// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rideuser/features/auth/service/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController {
  late final String baseUrl = 'http://$ipconfig:3001/api/payment/user';

  // Create Stripe Checkout Session
  Future<dynamic> createCheckoutSession({
    required String userId,
    required String driverId,
    required String tripId,
    required String fare,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final googletoken = prefs.getString('googletoken');
    final emailtoken = prefs.getString('emailtoken');
    final token = googletoken ?? emailtoken;
    final response = await http.post(
      Uri.parse('$baseUrl/payment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
        'tripId': tripId,
        'fare': fare,
        'paymentMethod': 'Online-Payment',
        'driverId': driverId,
      }),
    );
if (kDebugMode) {
  print(response.statusCode);
}
    if (response.statusCode == 201||response.statusCode == 200) {
          final data = jsonDecode(response.body);
 
  final String checkoutUrl = data['payment']['url'];
      final String paymentID = data['payment']['id'];
                 SharedPreferences prefs = await SharedPreferences.getInstance();
    final paymentId = prefs.setString('paymentid',paymentID);
        final paymentUrl = prefs.setString('paymentUrl',checkoutUrl);


      if (kDebugMode) {
        print('data: $data');
      }
if (kDebugMode) {
  print(' this si the url:$checkoutUrl');
}
  return data;
    } else {
      throw Exception('Failed to create checkout session');
    }
  }

  Future<Map<String, dynamic>> makePayment({
    required String userId,
    required String tripId,
    required String driverId,
    required String paymentMethod,
    required String fare,
        required String sessionId,

  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final googletoken = prefs.getString('googletoken');
    final emailtoken = prefs.getString('emailtoken');
    final token = googletoken ?? emailtoken;
   

    final url = Uri.parse('$baseUrl/stripe/confirmpayment');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

     try {
      final body = {
        "userId": userId,
        "tripId": tripId,
        "driverId": driverId,
        "paymentMethod": paymentMethod,
        "fare": fare,
        "sessionId": sessionId,
      };

      final response = await http.post(url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print('paymentcompleted:$data');
        }
        final status =data['paymentStatus'];
        if (kDebugMode) {
          print('payment status:$status');
        }
        if (data['success'] == true && data['paymentStatus'] == "paid") {
          return {"success": true, "message": "Payment Successful"};
        } else {
          return {"success": false, "message": "Payment Failed"};
        }
      } else {
        return {"success": false, "message": "Failed to confirm payment"};
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }



Future<Map<String, dynamic>> getTripDetailById(String tripId) async {
  final url = Uri.parse('http://$ipconfig:3005/api/payment/user/trip-details/$tripId');
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final googletoken = prefs.getString('googletoken');
  final emailtoken = prefs.getString('emailtoken');
  final token = googletoken ?? emailtoken;

  if (token == null) {
    throw Exception('Authentication token not found');
  }

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    if (kDebugMode) {
      print(data);
    } 
    return data ;
  } else {
    throw Exception('Failed to load trip details: ${response.reasonPhrase}');
  }
}

}
