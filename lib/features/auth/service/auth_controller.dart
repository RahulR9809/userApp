


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const ipconfig='10.0.2.2';


Map<String, dynamic>? userdata;
class AuthService {
  Future<String?> getGoogleToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('googletoken');
  }

  Future<String?> getEmailToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('emailtoken');
  }

  Future<void> storeSessionCookie(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_cookie', cookie);
  }

  Future<String?> getSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_cookie');
  }

  String baseUrl = "http://$ipconfig:3001/api/auth/user/login/email";
  Future<String?> getOTP(String email) async {
    final url = Uri.parse(baseUrl);

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({"email": email});

    debugPrint('Request body: $body');
    debugPrint('email to verify: $email');

    final response = await http.post(url, headers: headers, body: body);

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    debugPrint('Response head: ${response.headers["set-cookie"]}');

    if (response.statusCode == 200) {
      final cookie = response.headers['set-cookie'];
      if (cookie != null) {
        await storeSessionCookie(cookie);
        debugPrint('Stored session cookie: $cookie');
      }
      final data = json.decode(response.body);
      debugPrint('OTP sent: ${data['message']}');
      return data['message'];
    } else {
      throw Exception('Failed to get OTP: ${response.body}');
    }
  }

  final verifyurl = 'http://$ipconfig:3001/api/auth/user/verify-otp';
  Future<String?> verifyOtp(String otp) async {
    final url = Uri.parse(verifyurl);

    final cookie = await getSessionCookie();

    final headers = {
      'Content-Type': 'application/json',
      if (cookie != null) 'Cookie': cookie,
    };

    final body = jsonEncode({"otp": otp});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      final String emailtoken = data?['accessToken'];
        userdata = data['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
               await prefs.setString('userid', userdata?['id']);

              await prefs.setString('name', userdata?['name']);
        await prefs.setString('email', userdata?['email']);
      await prefs.setString('emailtoken', emailtoken);
      debugPrint('OTP verification successful: ${data?['message']}');
      debugPrint('Response: ${response.body}');

      
      return emailtoken;
    } else {
      debugPrint('Failed to verify OTP. Status code: ${response.statusCode}');
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  
 final GoogleSignIn googleSignIn = GoogleSignIn();
  final String googlebaseUrl = 'http://$ipconfig:3001/api/auth/user/login/google';

  Future<Map<String, dynamic>?> signInWithGoogle(BuildContext context) async {
    try {
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;

      final response = await http.post(
        Uri.parse(googlebaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"token": accessToken}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('googletoken', data['accessToken']);
        await prefs.setString('userid', data['data']['id']);
        await prefs.setString('name', data['data']['name']);
        await prefs.setString('email', data['data']['email']);

        return data;
      } else if (response.statusCode == 403) {
        debugPrint('Forbidden: ${response.body}');
        return {'error': '403'};
      } else {
        debugPrint('Failed to authenticate with backend: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      debugPrint('Sign in failed: $error');
      return null;
    }
  }
}
