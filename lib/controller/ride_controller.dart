import 'dart:convert';
import 'package:http/http.dart' as http;

class DriverService {
  final String baseUrl = "http://10.0.2.2:3001/api/auth/user/nearby-drivers"; // Replace with your server URL

  Future<void> getNearByDrivers({
    required String userId,
    required double pickupLatitude,
    required double pickupLongitude,
    required double dropLatitude,
    required double dropLongitude,
  }) async {
    try {
      // Construct the URL with query parameters
      final url = Uri.parse(
        '$baseUrl/nearby-drivers?userId=$userId'
        '&pickupLatitude=$pickupLatitude&pickupLongitude=$pickupLongitude'
        '&dropLatitude=$dropLatitude&dropLongitude=$dropLongitude',
      );

      // Send the GET request
      final response = await http.get(url);

      // Check for a successful response
      if (response.statusCode == 201) {
        // Decode and process the JSON response
        final data = jsonDecode(response.body);
        print("Nearby Drivers: ${data['getNearByDrivers']}");
        print("Additional Trip Data: ${data['getAdditionalTripData']}");
      } else {
        print("Failed to load drivers. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching drivers: $e");
    }
  }
}
