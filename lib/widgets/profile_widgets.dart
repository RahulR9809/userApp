//  Future<void> _getRoute() async {
//   if (_currentLatitude != null &&
//       _currentLongitude != null &&
//       _destinationLatitude != null &&
//       _destinationLongitude != null) {
//     const int maxRetries = 3;
//     int attempt = 0;
//     bool requestSuccessful = false;

//     final String url =
//         'https://api.mapbox.com/directions/v5/mapbox/driving/$_currentLongitude,$_currentLatitude;$_destinationLongitude,$_destinationLatitude?steps=true&geometries=geojson&access_token=pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ';

//     while (attempt < maxRetries && !requestSuccessful) {
//       try {
//         final response = await http.get(Uri.parse(url));

//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);

//           // Ensure data is available in the expected structure
//           if (data['routes'] != null &&
//               data['routes'].isNotEmpty &&
//               data['routes'][0]['geometry'] != null) {
//             final geometry = data['routes'][0]['geometry']['coordinates'];

//             // Decode coordinates directly if geometry is already in a coordinate list format
//             final List<LatLng> route = geometry
//                 .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
//                 .toList();

//             _mapContainerKey.currentState?.drawRoute(route);
//             requestSuccessful = true;
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Route not found.')),
//             );
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to get route.')),
//           );
//         }
//       } on SocketException catch (_) {
//         attempt++;
//         if (attempt >= maxRetries) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text(
//                     'Network error. Please check your connection and try again.')),
//           );
//         } else {
//           await Future.delayed(Duration(seconds: 2));
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error occurred: $e')),
//         );
//         break; // Exit loop for non-network-related errors
//       }
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Location coordinates are not set')),
//     );
//   }
// }

//   List<LatLng> _decodePolyline(String polyline) {
//     List<LatLng> coordinates = [];
//     int index = 0;
//     int len = polyline.length;
//     int lat = 0;
//     int lng = 0;

//     while (index < len) {
//       int shift = 0;
//       int result = 0;
//       int byte;
//       do {
//         byte = polyline.codeUnitAt(index) - 63;
//         result |= (byte & 0x1f) << shift;
//         shift += 5;
//         index++;
//       } while (byte >= 0x20);
//       int dLat = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
//       lat += dLat;

//       shift = 0;
//       result = 0;
//       do {
//         byte = polyline.codeUnitAt(index) - 63;
//         result |= (byte & 0x1f) << shift;
//         shift += 5;
//         index++;
//       } while (byte >= 0x20);
//       int dLng = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
//       lng += dLng;

//       coordinates.add(LatLng(lat / 1E5, lng / 1E5));
//     }
//     return coordinates;
//   }



  // void updateMapWithDestination(double? destLatitude, double? destLongitude) {
  //   if (_mapController != null &&
  //       destLatitude != null &&
  //       destLongitude != null) {
  //     LatLng destinationPosition = LatLng(destLatitude, destLongitude);
  //     _mapController!.addSymbol(SymbolOptions(
  //       geometry: destinationPosition,
  //       iconImage: "assets/icon.png",
  //       iconSize: 0.5,
  //     ));
  //   }
  // }

  // void drawRoute(List<LatLng> route) {
  //   if (_mapController != null && route.isNotEmpty) {
  //     _mapController!.addLine(
  //       LineOptions(
  //         geometry: route,
  //         lineColor: "#FF5733",
  //         lineWidth: 5.0,
  //       ),
  //     );
  //   }
  // }