import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RideService {


final String baseUrl = "http://10.0.2.2:3001/api/trip/users/nearby-drivers"; 

Future<List<Map<String, dynamic>>> getNearByDrivers({
  required String userId,
  required double pickupLatitude,
  required double pickupLongitude,
  required double dropLatitude,
  required double dropLongitude,
  required String accessToken,
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
      print('Successfully fetched nearest driver');

      // Decode the response body
      final data = jsonDecode(response.body);

      // Check if the response contains 'getNearByDrivers' key and it has data
      if (data['getNearByDrivers'] != null) {
        // Extract relevant details (vehicle type and coordinates) for each driver
        List<Map<String, dynamic>> driverInfoList = [];
        for (var driver in data['getNearByDrivers']) {
          var vehicleType = driver['vehicleDetails']['vehicle_type'];
          var coordinates = driver['currentLocation']['coordinates'];

          // Add the extracted information to the list
          driverInfoList.add({
            'vehicle_type': vehicleType,
            'coordinates': coordinates,
          });
        }
print('this is the listdata:$driverInfoList');
print(data);
        // Return the list of vehicle details and coordinates
        return driverInfoList;
      } else {
        throw Exception('No nearby drivers found.');
      }
    } else {
      throw Exception('Failed to load nearby drivers. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching drivers: $e');
  }
}


final String apiUrl = 'http://10.0.2.2:3001/api/trip/users/request-ride';

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
       String? accessToken= prefs.getString('emailtoken');
       if(accessToken==null){
        accessToken=prefs.getString('googletoken');
       }
       print('ride controller $accessToken');
    // Printing all data for debugging
    print("API URL: $apiUrl");
    print("User ID: $userId");
    print("Fare: $fare");
    print("Distance: $distance km");
    print("Duration: $duration minutes");
    print("Pickup Coordinates: $pickUpCoords");
    print("Drop Coordinates: $dropCoords");
    print("Vehicle Type: $vehicleType");
    print("Pickup Location: $pickupLocation");
    print("Drop Location: $dropLocation");
    print("Payment Method: $paymentMethod");

     
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

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Ride request created successfully!");
      return jsonDecode(response.body);
    } else {
      print("Failed to create ride request. Status: ${response.statusCode}");
      throw Exception('Failed to create ride request. Status: ${response.statusCode}');
    }
  } catch (error) {
    print("Error occurred: $error");
    throw Exception('Error occurred: $error');
  }
}

}