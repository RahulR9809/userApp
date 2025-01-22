
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rideuser/features/auth/service/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic>? userdata;

class ProfileService {
  Future<String?> updateProfile(
      XFile? profileimage, String newname, String newemail, String newphone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final emailtoken =  prefs.getString('googletoken');
    final googletoken =  prefs.getString('emailtoken');
    final id = prefs.getString('userid');
    const baseUrl = 'http://$ipconfig:3001/api/auth/user/userProfileUpdate';
    final token = googletoken ?? emailtoken;

    if (token == null || id == null) {
      return 'Authentication error. Please log in again.';
    }

    final url = Uri.parse(baseUrl);
    final request = http.MultipartRequest('PUT', url);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['userId'] = id;
    request.fields['name'] = newname;
    request.fields['email'] = newemail;
    request.fields['phone'] = newphone;

    if (profileimage != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImg', profileimage.path));
    }

    try {
  final response = await request.send();

  if (response.statusCode == 200 || response.statusCode == 201) {
    final responseData = await response.stream.bytesToString();
    final data = jsonDecode(responseData);
    userdata = data['data'];
    return 'Profile updated successfully';
  } else {
    final errorData = await response.stream.bytesToString();
    if (kDebugMode) {
    }
    if (kDebugMode) {
      print('Error: $errorData');
    } 
    return 'Failed to update profile';
  }
} catch (e) {
  if (kDebugMode) {
    print('An unexpected error occurred: $e');
  }
  return 'An unexpected error occurred';
}

  }
}
