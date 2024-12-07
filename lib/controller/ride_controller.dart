import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final userurl='192.168.24.130';

class RideService {


final String baseUrl = "http://$userurl:3001/api/trip/users/nearby-drivers"; 

Future<List<Map<String, dynamic>>> getNearByDrivers({
  required String userId,
  required double pickupLatitude,
  required double pickupLongitude,
  required double dropLatitude,
  required double dropLongitude,
  required String accessToken, String? vehicleType,
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
          var driverid=driver['_id'];
          print('this is the $driverid');
          // Add the extracted information to the list
          driverInfoList.add({
            'driver_id':driverid,
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
    final data=  jsonDecode(response.body);
        // final tripId = data['tripdata']['_id'];
      return data;
    } else {
      print("Failed to create ride request. Status: ${response.statusCode}");
      throw Exception('Failed to create ride request. Status: ${response.statusCode}');
    }
  } catch (error) {
    print("Error occurred: $error");
    throw Exception('Error occurred: $error');
  }
}
Future<List<String>> fetchPickupLocation(String search) async {
  // Fetch the access token from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('emailtoken') ?? prefs.getString('googletoken');

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
      print('Response data: $data');

      // Check if the key `searchResults` exists and is a list
      if (data is Map<String, dynamic> &&
          data.containsKey('searchResults') &&
          data['searchResults'] is List) {
        // Extracting the 'full_address' or 'name' from each entry in 'searchResults'
        List<String> suggestions = [];
        for (var result in data['searchResults']) {
          if (result['properties'] != null) {
            // Add either 'full_address' or 'name' depending on which you prefer
            suggestions.add(result['properties']['full_address'] ?? result['properties']['name']);
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


}