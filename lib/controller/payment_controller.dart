// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class PaymentController {
//   final String ip = '10.0.2.2';
//   late final String baseUrl = 'http://$ip:3005/api/payment/user';

//   // Create Stripe Checkout Session
//   Future<String> createCheckoutSession(
//       {required String userId,
//       required String driverId,
//       required String tripId,
//       required int fare}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final googletoken = prefs.getString('googletoken');
//     final emailtoken = prefs.getString('emailtoken');
//     final token = googletoken ?? emailtoken;

//     final response = await http.post(
//       Uri.parse('$baseUrl/stripe/confirmpayment'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({
//         'sessionId':
//             'cs_test_a1lDATzJP6zlSH7KFiPUQEJEGZqwKDa2658jo0ylw2FN9dfShs6v38WAX4',
//         'userId': userId,
//         'tripId': tripId,
//         'fare': fare,
//         'paymentMethod': 'card',
//         'driverId': driverId
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print('checkout data:$data');
//       return data['stripeSession']['url'];
//     } else {
//       throw Exception('Failed to create checkout session');
//     }
//   }

//   Future<Map<String, dynamic>> makePayment({
//     required String userId,
//     required String tripId,
//     required String driverId,
//     required String paymentMethod,
//     required double fare,
//   }) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final googletoken = prefs.getString('googletoken');
//     final emailtoken = prefs.getString('emailtoken');
//     final token = googletoken ?? emailtoken;
//     final url = Uri.parse('$baseUrl/payment');
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     final body = {
//       'sessionId':
//           'cs_test_a1lDATzJP6zlSH7KFiPUQEJEGZqwKDa2658jo0ylw2FN9dfShs6v38WAX4',
//       'userId': userId,
//       'tripId': tripId,
//       'driverId': driverId,
//       'paymentMethod': paymentMethod,
//       'fare': fare,
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: headers,
//         body: jsonEncode(body),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         print('Payment succesfull:$data');
//         return data;
//       } else {
//         throw Exception('Failed to process payment: ${response.body}');
//       }
//     } catch (error) {
//       print('Error in payment: $error');
//       rethrow;
//     }
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rideuser/controller/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController {
  late final String baseUrl = 'http://$ipconfig:3005/api/payment/user';

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
print(response.statusCode);
    if (response.statusCode == 201||response.statusCode == 200) {
          final data = jsonDecode(response.body);
 
  final String checkoutUrl = data['payment']['url'];
      final String paymentID = data['payment']['id'];
                 SharedPreferences prefs = await SharedPreferences.getInstance();
    final paymentId = prefs.setString('paymentid',paymentID);
        final paymentUrl = prefs.setString('paymentUrl',checkoutUrl);


      print('data: ${data}');
print(' this si the url:$checkoutUrl');
      // Launch the checkout URL in the browser
  return data;
    } else {
      throw Exception('Failed to create checkout session');
    }
  }

  // Make Payment after successful checkout
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
      // Create the request body
      final body = {
        "userId": userId,
        "tripId": tripId,
        "driverId": driverId,
        "paymentMethod": paymentMethod,
        "fare": fare,
        "sessionId": sessionId,
      };

      // Send the POST request
      final response = await http.post(url,
        headers: headers,
        body: json.encode(body),
      );

      // Handle the response
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('paymentcompleted:$data');
        final status =data['paymentStatus'];
        print('payment status:$status');
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
  
  // Retrieve the token from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final googletoken = prefs.getString('googletoken');
  final emailtoken = prefs.getString('emailtoken');
  final token = googletoken ?? emailtoken;

  // Ensure token is not null
  if (token == null) {
    throw Exception('Authentication token not found');
  }

  // Perform the HTTP GET request with headers
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 201) {
    // Decode the response body to a Map
    final data = jsonDecode(response.body);
    print(data); // Debugging statement
    return data ;
  } else {
    // Handle non-200 status codes
    throw Exception('Failed to load trip details: ${response.reasonPhrase}');
  }
}

}
