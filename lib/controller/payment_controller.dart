

import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';



class PaymentController {
  final String ip = '10.0.2.2';
  late final String baseUrl = 'http://$ip:3005/api/payment/user';

  Future<Map<String, dynamic>> makePayment({
    required String userId,
    required String tripId,
    required String driverId,
    required String paymentMethod,
    required double fare,
  }) async {
         SharedPreferences prefs = await SharedPreferences.getInstance();
      final googletoken=prefs.getString('googletoken');
      final emailtoken=prefs.getString('emailtoken');
      final token=googletoken ?? emailtoken;
    final url = Uri.parse('$baseUrl/payment');
    final headers = {
      'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            

    };

    final body = {
      'userId': userId,
      'tripId': tripId,
      'driverId': driverId,
      'paymentMethod': paymentMethod,
      'fare': fare,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data=jsonDecode(response.body);
        print('Payment succesfull:$data');
        return data;
      } else {
        throw Exception('Failed to process payment: ${response.body}');
      }
    } catch (error) {
      print('Error in payment: $error');
      rethrow;
    }
  }
}



// import 'dart:convert';
// import 'package:http/http.dart' as http;

// const String baseUrl = '<base_url>'; // Replace with your base URL

// // Simple headers utility
// Map<String, String> headers = {'Content-Type': 'application/json'};

// // Stripe Payment Service
// Future<dynamic> stripePaymentService(Map<String, dynamic> data) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/payment/stripe-session'),
//     headers: headers,
//     body: jsonEncode(data),
//   );
//   return jsonDecode(response.body);
// }

// // Wallet Payment Service
// Future<dynamic> walletPaymentService(Map<String, dynamic> data) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/payment/wallet'),
//     headers: headers,
//     body: jsonEncode(data),
//   );
//   return jsonDecode(response.body);
// }

// // Add Money to Wallet Service
// Future<dynamic> addMoneyToWalletService(Map<String, dynamic> data) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/payment/wallet/addmoney'),
//     headers: headers,
//     body: jsonEncode(data),
//   );
//   return jsonDecode(response.body);
// }

// // Get Wallet Balance
// Future<dynamic> getWalletBalance(String userId) async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/payment/user/get-walletbalance/$userId'),
//     headers: headers,
//   );
//   return jsonDecode(response.body);
// }

// // Payment Service
// Future<dynamic> paymentService(Map<String, dynamic> data) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/payment/user/payment'),
//     headers: headers,
//     body: jsonEncode(data),
//   );
//   return jsonDecode(response.body);
// }

// // Get Wallet History Service
// Future<dynamic> getWalletHistoryService(String userId) async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/payment/user/wallethistory/$userId'),
//     headers: headers,
//   );
//   return jsonDecode(response.body);
// }
