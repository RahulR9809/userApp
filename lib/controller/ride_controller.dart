import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const userurl = '10.0.2.2';

class RideService {
  final String baseUrl = "http://$userurl:3001/api/trip/users/nearby-drivers";

  Future<List<Map<String, dynamic>>> getNearByDrivers({
    required String userId,
    required double pickupLatitude,
    required double pickupLongitude,
    required double dropLatitude,
    required double dropLongitude,
    required String accessToken,
    String? vehicleType,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl?userId=$userId'
        '&pickupLatitude=$pickupLatitude&pickupLongitude=$pickupLongitude'
        '&dropLatitude=$dropLatitude&dropLongitude=$dropLongitude',
      );

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('Successfully fetched nearest driver');
        }

        // Decode the response body
        final data = jsonDecode(response.body);

        // Check if the response contains 'getNearByDrivers' key and it has data
        if (data['getNearByDrivers'] != null) {
          // Extract relevant details (vehicle type and coordinates) for each driver
          List<Map<String, dynamic>> driverInfoList = [];
          for (var driver in data['getNearByDrivers']) {
            var vehicleType = driver['vehicleDetails']['vehicle_type'];
            var coordinates = driver['currentLocation']['coordinates'];
            var driverid = driver['_id'];
            if (kDebugMode) {
              print('this is the $driverid');
            }
            // Add the extracted information to the list
            driverInfoList.add({
              'driver_id': driverid,
              'vehicle_type': vehicleType,
              'coordinates': coordinates,
            });
          }
          if (kDebugMode) {
            print('this is the listdata:$driverInfoList');
          }
          if (kDebugMode) {
            print(data);
          }
          // Return the list of vehicle details and coordinates
          return driverInfoList;
        } else {
          throw Exception('No nearby drivers found.');
        }
      } else {
        throw Exception(
            'Failed to load nearby drivers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching drivers: $e');
    }
  }

  final String apiUrl = 'http://$userurl:3001/api/trip/users/request-ride';

  Future<Map<String, dynamic>> createRideRequest({
    required String userId,
    required double fare,
    required double distance,
    required double duration,
    required List<double> pickUpCoords,
    required List<double> dropCoords,
    required String vehicleType,
    required String pickupLocation,
    required String dropLocation,
    required String paymentMethod,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('emailtoken');
      accessToken ??= prefs.getString('googletoken');
      if (kDebugMode) {
        print('ride controller $accessToken');
      }
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'userId': userId,
          'fare': fare,
          'distance': distance,
          'duration': duration,
          'pickUpCoords': pickUpCoords,
          'dropCoords': dropCoords,
          'vehicleType': vehicleType,
          'pickupLocation': pickupLocation,
          'dropLocation': dropLocation,
          'paymentMethod': paymentMethod,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print("Ride request created successfully!");
        }
        final data = jsonDecode(response.body);
        print(data);
        final tripId = data['tripdata']['_id'];
        final userid=data['tripdata']['userId'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('tripid', tripId);
        prefs.setString('newUserId',userid);
        print('this is the tripid here$tripId');
        return data;
      } else {
        if (kDebugMode) {
          print(
              "Failed to create ride request. Status: ${response.statusCode}");
        }
        throw Exception(
            'Failed to create ride request. Status: ${response.statusCode}');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error occurred: $error");
      }
      throw Exception('Error occurred: $error');
    }
  }

  Future<List<String>> fetchPickupLocation(String search) async {
    // Fetch the access token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken =
        prefs.getString('emailtoken') ?? prefs.getString('googletoken');

    if (accessToken == null) {
      throw Exception('Access token is missing');
    }

    // API URL
    final url = Uri.parse(
        'http://$userurl:3001/api/trip/users/pickup-location-autocomplete?search=$search');

    try {
      // Send GET request with Authorization header
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Check the response status code
      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        // Debugging: Log the response structure
        if (kDebugMode) {
          print('Response data: $data');
        }

        // Check if the key `searchResults` exists and is a list
        if (data is Map<String, dynamic> &&
            data.containsKey('searchResults') &&
            data['searchResults'] is List) {
          // Extracting the 'full_address' or 'name' from each entry in 'searchResults'
          List<String> suggestions = [];
          for (var result in data['searchResults']) {
            if (result['properties'] != null) {
              // Add either 'full_address' or 'name' depending on which you prefer
              suggestions.add(result['properties']['full_address'] ??
                  result['properties']['name']);
            }
          }
          return suggestions;
        } else {
          throw Exception(
              'Unexpected response format: "searchResults" key missing or invalid');
        }
      } else {
        throw Exception('Failed to fetch suggestions: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<bool> cancelRide(
      String userId, String tripId, String cancelReason) async {
    final url = Uri.parse('http://$userurl:3001/api/trip/users/cancel-ride');
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken =
        prefs.getString('emailtoken') ?? prefs.getString('googletoken');
    final body = {
      'userId': userId,
      'tripId': tripId,
      'cancelReason': cancelReason,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('Ride cancelled successfully.');
        return true;
      } else {
        print('Failed to cancel ride: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error cancelling ride: $error');
      return false;
    }
  }
}
