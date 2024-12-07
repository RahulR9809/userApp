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









  
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/bloc/ride_bloc.dart';
// import 'package:rideuser/Ridepage/bloc/ride_event.dart';
// import 'package:rideuser/Ridepage/bloc/ride_state.dart';
// import 'package:rideuser/Ridepage/searchpage.dart';
// import 'package:rideuser/controller/ride_controller.dart';
// import 'package:rideuser/core/colors.dart';
// import 'package:rideuser/widgets/auth_widgets.dart';
// import 'package:rideuser/widgets/ride_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RidePage extends StatefulWidget {
//   const RidePage({Key? key}) : super(key: key);

//   @override
//   _RidePageState createState() => _RidePageState();
// }

// class _RidePageState extends State<RidePage> {
//   final TextEditingController _currentLocationController =
//       TextEditingController();
//   final TextEditingController _destinationController = TextEditingController();
//   final RideController _rideController = RideController();

//   double? _currentLatitude;
//   double? _currentLongitude;
//   double? _destinationLatitude;
//   double? _destinationLongitude;

//   final GlobalKey<MapContainerCardState> _mapContainerKey =
//       GlobalKey<MapContainerCardState>();
//   final RideService _rideService = RideService();

//   List<Map<String, dynamic>> _nearbyDrivers = [];
//   String? _selectedVehicleType;

//   void _onLocationSelected(
//       double latitude, double longitude, String fullAddress) {
//     setState(() {
//       _destinationLatitude = latitude;
//       _destinationLongitude = longitude;
//       _destinationController.text = fullAddress;
//     });
//   }

//   Future<void> _fetchNearbyDrivers(double latitude, double longitude) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final id = prefs.getString('userid');
//       final token = prefs.getString('googletoken');
//       final drivers = await _rideService.getNearByDrivers(
//         userId: id!,
//         pickupLatitude: latitude,
//         pickupLongitude: longitude,
//         dropLatitude: _destinationLatitude ?? latitude,
//         dropLongitude: _destinationLongitude ?? longitude,
//         vehicleType: _selectedVehicleType,
//         accessToken: token!,
//       );

//       setState(() {
//         _nearbyDrivers = drivers;
//       });

//       _updateMapWithDrivers();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching nearby drivers: $e')),
//       );
//     }
//   }

//   Map<String, dynamic> _getNearestDriver(List<Map<String, dynamic>> drivers) {
//     double nearestDistance = double.infinity;
//     Map<String, dynamic> nearestDriver = {};

//     for (var driver in drivers) {
//       double driverLatitude = driver['coordinates'][1];
//       double driverLongitude = driver['coordinates'][0];

//       // Calculate the distance to the driver
//       double distance = _rideController.calculateDistance(
//         _currentLatitude!,
//         _currentLongitude!,
//         driverLatitude,
//         driverLongitude,
//       );

//       if (distance < nearestDistance) {
//         nearestDistance = distance;
//         nearestDriver = driver;
//       }
//     }

//     return nearestDriver;
//   }

//   void _updateMapWithDrivers() {
//     for (var driver in _nearbyDrivers) {
//       double latitude = driver['coordinates'][1];
//       double longitude = driver['coordinates'][0];
//       String vehicleType = driver['vehicle_type'];

//       _mapContainerKey.currentState
//           ?.addDriverMarker(latitude, longitude, vehicleType);
//     }
//   }

//   void _selectVehicle(String vehicleType) {
//     setState(() {
//       _selectedVehicleType = vehicleType.trim();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ThemeColors.charcoalGray,
//       appBar: AppBar(
//         title: const Text('Ride Booking'),
//         backgroundColor: ThemeColors.royalPurple,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               BlocBuilder<RideBloc, RideState>(
//                 builder: (context, state) {
//                   if (state is LocationLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is LocationLoaded) {
//                     _currentLatitude = state.latitude;
//                     _currentLongitude = state.longitude;
//                     _currentLocationController.text = state.address;

//                     // Update map only if the current location changes
//                     if (!_mapContainerKey.currentState!.isCurrentLocationMarker(
//                       state.latitude,
//                       state.longitude,
//                     )) {
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         _mapContainerKey.currentState?.updateMapLocation(
//                           state.latitude,
//                           state.longitude,
//                         );
//                       });
//                     }

//                     return buildLocationInputField(
//                       label: 'Current Location',
//                       controller: _currentLocationController,
//                       hint: state.address,
//                       icon: Icons.my_location,
//                       onPressed: () {
//                         BlocProvider.of<RideBloc>(context)
//                             .add(FetchCurrentLocation(context: context));
//                       },
//                     );
//                   } else if (state is LocationError) {
//                     return buildLocationInputField(
//                       label: 'Current Location',
//                       controller: _currentLocationController,
//                       hint: 'Error: ${state.message}',
//                       icon: Icons.error,
//                       onPressed: () {
//                         BlocProvider.of<RideBloc>(context)
//                             .add(FetchCurrentLocation(context: context));
//                       },
//                     );
//                   }

//                   return buildLocationInputField(
//                     label: 'Current Location',
//                     controller: _currentLocationController,
//                     hint: 'Fetching location...',
//                     icon: Icons.my_location,
//                     onPressed: () {
//                       BlocProvider.of<RideBloc>(context)
//                           .add(FetchCurrentLocation(context: context));
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               BlocProvider(
//                 create: (_) => RideBloc(),
//                 child: DestinationSearchField(
//                   onLocationSelected: _onLocationSelected,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               BlocListener<RideBloc, RideState>(
//                 listener: (context, state) {
//                   if (state is NearbyDriversLoaded) {
//                     // Update map with the fetched drivers
//                     for (var driver in state.drivers) {
//                       final latitude = driver['coordinates'][1];
//                       final longitude = driver['coordinates'][0];
//                       final vehicleType = driver['vehicle_type'];
//                       _mapContainerKey.currentState?.addDriverMarker(
//                         latitude,
//                         longitude,
//                         vehicleType,
//                       );
//                     }
//                   } else if (state is NearbyDriversError) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.message)),
//                     );
//                   }
//                 },
//                 child: BlocBuilder<RideBloc, RideState>(
//                   builder: (context, state) {
//                     if (state is NearbyDriversLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     return ReusableButton(
//                       text: 'Search Nearby Drivers',
//                       onPressed: () {
//                         print('nearbydrivers$_nearbyDrivers');
//                         if (_currentLatitude != null &&
//                             _currentLongitude != null) {
//                           BlocProvider.of<RideBloc>(context).add(
//                             FetchNearbyDrivers(
//                               latitude: _currentLatitude!,
//                               longitude: _currentLongitude!,
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                   'Please wait for the current location to be fetched.'),
//                             ),
//                           );
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 30),
//               MapContainerCard(
//                 key: _mapContainerKey,
//                 latitude: _currentLatitude,
//                 longitude: _currentLongitude,
//               ),
//               const SizedBox(height: 15),
//               const Text(
//                 'Available Electric Vehicles',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   VehicleCard(
//                     vehicleName: 'Electric Car',
//                     imageUrl: '',
//                     vehicleType: 'Car',
//                     onSelect: _selectVehicle,
//                     isSelected: _selectedVehicleType == 'Car',
//                   ),
//                   VehicleCard(
//                     vehicleName: 'Electric Auto',
//                     imageUrl: '',
//                     vehicleType: 'Auto',
//                     onSelect: _selectVehicle,
//                     isSelected: _selectedVehicleType == 'Auto',
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               ReusableButton(
//                 text: 'Request Ride',
//                 onPressed: () async {
//                   // Calculate distance
//                   double distance = _rideController.calculateDistance(
//                     _currentLatitude!,
//                     _currentLongitude!,
//                     _destinationLatitude!,
//                     _destinationLongitude!,
//                   );
//                   driver.clear();
//                   // Calculate fare
//                   double fare = _rideController.calculateFare(distance);

//                   SharedPreferences prefs =
//                       await SharedPreferences.getInstance();
//                   final userId = prefs.getString('userid');
//                   final paymentMethod = 'Online-Payment';
//                   BlocProvider.of<RideBloc>(context).add(RequestRide(
//                     userId: userId!,
//                     fare: fare,
//                     distance: distance,
//                     duration: distance * 2, // Assuming duration is 2x distance
//                     pickUpCoords: [_currentLatitude!, _currentLongitude!],
//                     dropCoords: [_destinationLatitude!, _destinationLongitude!],
//                     vehicleType: _selectedVehicleType ?? 'Car',
//                     pickupLocation: _currentLocationController.text,
//                     dropLocation: _destinationController.text,
//                     paymentMethod: paymentMethod,
//                   ));

//     //               SharedPreferences socketids =
//     //                   await SharedPreferences.getInstance();

//     //               final tripId = socketids.getString('tripid');
//     //               final driverId = socketids.getString('nearestDriverId');

//     //               final rideRequestData = {
//     //                 'userId': userId,
//     //                 'fare': fare,
//     //                 'distance': distance,
//     //                 'duration': distance * 2,
//     //                 'pickUpCoords': [_currentLatitude!, _currentLongitude!],
//     //                 'dropCoords': [
//     //                   _destinationLatitude!,
//     //                   _destinationLongitude!
//     //                 ],
//     //                 'vehicleType': _selectedVehicleType ?? 'Car',
//     //                 'pickupLocation': _currentLocationController.text,
//     //                 'dropLocation': _destinationController.text,
//     //                 'paymentMethod': paymentMethod,
//     //               };
//     //                     await Future.delayed(Duration(seconds: 2));

//     //                   final userSocketService = UserSocketService();
//     //                       print('from button :$driverId');
//     //                   print('from button :$tripId');
//     //                   print('from button :$rideRequestData');
//     // if (userSocketService.socket.connected) {
//     //     userSocketService.emitRideRequestToDriver(driverId!, tripId!, rideRequestData);
//     //   } else {
//     //     // Handle socket disconnection error
//     //     ScaffoldMessenger.of(context).showSnackBar(
//     //       const SnackBar(content: Text('Socket is not connected. Please try again later.')),
//     //     );
//     //   }                  
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('Ride requested successfully!')),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

