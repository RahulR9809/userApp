// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:rideuser/Ridepage/ride_start.dart';
// import 'package:rideuser/controller/ride_controller.dart';
// import 'package:rideuser/widgets/auth_widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RidePage extends StatefulWidget {
//   const RidePage({super.key});

//   @override
//   _RidePageState createState() => _RidePageState();
// }

// class _RidePageState extends State<RidePage> {
//   final TextEditingController _currentLocationController =
//       TextEditingController();
//   final TextEditingController _destinationController = TextEditingController();
//   bool _isLoadingLocation = false;
//   final RideController _rideController = RideController();

//   double? _currentLatitude = 9.938618;
//   double? _currentLongitude = 76.32700;
//   double? _destinationLatitude;
//   double? _destinationLongitude;

//   final GlobalKey<_MapContainerCardState> _mapContainerKey = GlobalKey();
//   final RideService _rideService = RideService();
// final LocationService locationService=LocationService();
//   List<Map<String, dynamic>> _nearbyDrivers = [];
//   String? _selectedVehicleType;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the current location field with the default address
//     _initializeDefaultLocation();
//   }

//   Future<void> _initializeDefaultLocation() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         _currentLatitude!,
//         _currentLongitude!,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         String address =
//             "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

//         setState(() {
//           _currentLocationController.text = address;
//         });

//         // Update the map with the default location
//         _mapContainerKey.currentState
//             ?.updateMapLocation(_currentLatitude!, _currentLongitude!);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error initializing location: $e')),
//       );
//     }
//   }

//   void _showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: const Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//                 ),
//                 SizedBox(width: 20),
//                 Text('Fetching location...', style: TextStyle(fontSize: 16)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _updateDestinationLocation() async {
//     if (_destinationController.text.isNotEmpty) {
//       try {
//         List<Location> locations =
//             await locationFromAddress(_destinationController.text);
//         if (locations.isNotEmpty) {
//           Location location = locations.first;
//           List<Placemark> placemarks = await placemarkFromCoordinates(
//             location.latitude,
//             location.longitude,
//           );

//           if (placemarks.isNotEmpty) {
//             Placemark place = placemarks[0];
//             String fullAddress =
//                 "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

//             setState(() {
//               _destinationController.text = fullAddress;
//               _destinationLatitude = location.latitude;
//               _destinationLongitude = location.longitude;
//             });
//           }
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating destination location: $e')),
//         );
//       }
//     }
//   }
//   ///////////////////////////////////
// ///////  // Future<void> _getCurrentLocation() async {
//   //   setState(() {
//   //     _currentLocationController.clear();
//   //     _isLoadingLocation = true;
//   //   });

//   //   _showLoadingDialog();

//   //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if (!serviceEnabled) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //           content: Text(
//   //               'Location services are disabled. Please enable them in settings.')),
//   //     );
//   //     setState(() {
//   //       _isLoadingLocation = false;
//   //     });
//   //     Navigator.pop(context);
//   //     return;
//   //   }

//   //   LocationPermission permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.denied) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(
//   //             content:
//   //                 Text('Location permission denied. Please allow access.')),
//   //       );
//   //       setState(() {
//   //         _isLoadingLocation = false;
//   //       });
//   //       Navigator.pop(context);
//   //       return;
//   //     }
//   //   }

//   //   if (permission == LocationPermission.deniedForever) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //           content: Text(
//   //               'Location permissions are permanently denied. Please enable them in settings.')),
//   //     );
//   //     setState(() {
//   //       _isLoadingLocation = false;
//   //     });
//   //     Navigator.pop(context);
//   //     return;
//   //   }

//   //   try {
//   //     Position position = await Geolocator.getCurrentPosition(
//   //       desiredAccuracy: LocationAccuracy.bestForNavigation,
//   //     );

//   //     List<Placemark> placemarks = await placemarkFromCoordinates(
//   //       position.latitude,
//   //       position.longitude,
//   //     );
//   //     if (placemarks.isNotEmpty) {
//   //       Placemark place = placemarks[0];
//   //       String address =
//   //           "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

//   //       setState(() {
//   //         _currentLatitude = position.latitude;
//   //         _currentLongitude = position.longitude;
//   //         _currentLocationController.text = address;
//   //       });

//   //       _mapContainerKey.currentState
//   //           ?.updateMapLocation(position.latitude, position.longitude);
//   //     }
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Error fetching location: $e')),
//   //     );
//   //   }

//   //   setState(() {
//   //     _isLoadingLocation = false;
//   //   });

//   //   Navigator.pop(context);
//   // }
// ///////////////////////////////////////
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

//   void _updateMapWithDrivers() {
//     for (var driver in _nearbyDrivers) {
//       double latitude = driver['latitude'];
//       double longitude = driver['longitude'];
//       _mapContainerKey.currentState?.addDriverMarker(latitude, longitude);
//     }
//   }

//   void _selectVehicle(String vehicleType) {
//     setState(() {
//       _selectedVehicleType = vehicleType;
//     });

//     if (_currentLatitude != null && _currentLongitude != null) {
//       _fetchNearbyDrivers(_currentLatitude!, _currentLongitude!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ride Booking'),
//         backgroundColor: Colors.green,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.green.shade700, Colors.greenAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               _buildLocationInputField(
//                 label: 'Current Location',
//                 controller: _currentLocationController,
//                 hint: 'Fetching location...',
//                 icon: Icons.my_location,
//                 onPressed: locationService.getCurrentLocation ,
//               ),
//               const SizedBox(height: 20),
//               _buildLocationInputField(
//                 label: 'Choose Destination',
//                 controller: _destinationController,
//                 hint: 'Enter destination',
//                 icon: Icons.location_pin,
//                 onPressed: _updateDestinationLocation,
//               ),
//               const SizedBox(height: 30),
//               ReusableButton(
//                 text: 'Search',
//                 onPressed: () async {
//                   if (_currentLatitude != null && _currentLongitude != null) {
//                     _fetchNearbyDrivers(
//                       _currentLatitude!,
//                       _currentLongitude!,
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text(
//                               'Please allow location access or wait for location to be fetched.')),
//                     );

//                     await locationService.getCurrentLocation();
//                   }
//                 },
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
//                     onSelect: _selectVehicle, isSelected: _selectedVehicleType=='Car',
//                   ),
//                   VehicleCard(
//                     vehicleName: 'Electric Auto',
//                     imageUrl: '',
//                     vehicleType: 'Auto',
//                     onSelect: _selectVehicle,
//                      isSelected: _selectedVehicleType=='Auto'
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               ReusableButton(
//                 text: 'Request Ride',
//                 onPressed: () async {
//                   double distance = _rideController.calculateDistance(
//                       _currentLatitude!,
//                       _currentLongitude!,
//                       _destinationLatitude!,
//                       _destinationLongitude!);

//                   double fare = _rideController.calculateFare(distance);

//                   SharedPreferences prefs =
//                       await SharedPreferences.getInstance();
//                   final userId = prefs.getString('userid');
//                   final paymentMethod = 'Online-Payment';
//                       await _rideService.createRideRequest(
//                     userId: userId!,
//                     fare: fare,
//                     distance: distance,
//                     duration: distance * 2,
//                     pickUpCoords: [_currentLatitude!, _currentLongitude!],
//                     dropCoords: [_destinationLatitude!, _destinationLongitude!],
//                     vehicleType: _selectedVehicleType ?? 'Car',
//                     pickupLocation: _currentLocationController.text,
//                     dropLocation: _destinationController.text,
//                     paymentMethod: paymentMethod,
//                   );

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Ride requested successfully!')),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationInputField({
//     required String label,
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(icon),
//               onPressed: onPressed,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class MapContainerCard extends StatefulWidget {
//   final double? latitude;
//   final double? longitude;
//   final double? destinationLatitude;
//   final double? destinationLongitude;

//   const MapContainerCard({
//     super.key,
//     this.latitude,
//     this.longitude,
//     this.destinationLatitude,
//     this.destinationLongitude,
//   });

//   @override
//   _MapContainerCardState createState() => _MapContainerCardState();
// }

// class _MapContainerCardState extends State<MapContainerCard> {
//   MapboxMapController? _mapController;

//   @override
//   void dispose() {
//     _mapController?.dispose();
//     super.dispose();
//   }

//   void _onMapCreated(MapboxMapController controller) {
//     _mapController = controller;
//     updateMapLocation(widget.latitude, widget.longitude);
//   }

//   void updateMapLocation(double? latitude, double? longitude) {
//     if (_mapController != null && latitude != null && longitude != null) {
//       LatLng newPosition = LatLng(latitude, longitude);
//       _mapController!
//           .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14.0));
//       _mapController!.clearSymbols();
//       _mapController!.addSymbol(SymbolOptions(
//         geometry: newPosition,
//         iconImage: "assets/liveLocation.png",
//         iconSize: 0.5,
//       ));
//     }
//   }

//   // Method to add driver markers to the map
//   void addDriverMarker(double latitude, double longitude) {
//     _mapController?.addSymbol(SymbolOptions(
//       geometry: LatLng(latitude, longitude),
//       iconImage: "assets/liveLocation.png", // Example image for driver
//       iconSize: 0.5,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onVerticalDragUpdate: (details) {},
//       child: SizedBox(
//         height: 300,
//         width: double.infinity,
//         child: MapboxMap(
//           accessToken:
//               "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ", // Use your Mapbox token
//           initialCameraPosition: CameraPosition(
//             target: widget.latitude != null && widget.longitude != null
//                 ? LatLng(widget.latitude!, widget.longitude!)
//                 : const LatLng(9.968677, 76.318354),
//             zoom: 14,
//           ),
//           onMapCreated: _onMapCreated,
//           styleString: MapboxStyles.MAPBOX_STREETS,
//         ),
//       ),
//     );
//   }
// }
// //////////////////
// //////////// class VehicleCard extends StatelessWidget {
// //   final String vehicleName;
// //   final String imageUrl;
// //   final String vehicleType;
// //   final bool isSelected;  // Add isSelected to track selection
// //   final void Function(String vehicleType) onSelect;

// //   const VehicleCard({
// //     Key? key,
// //     required this.vehicleName,
// //     required this.imageUrl,
// //     required this.vehicleType,
// //     required this.isSelected,
// //     required this.onSelect,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         onSelect(vehicleType);  // Notify parent when selected
// //       },
// //       child: Card(
// //         margin: const EdgeInsets.symmetric(vertical: 8.0),
// //         color: isSelected ? Colors.green.shade200 : Colors.white,  // Change color based on selection
// //         child: Container(
// //           width: 150, // Set custom width
// //           height: 130, // Set custom height
// //           padding: const EdgeInsets.all(8.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               imageUrl.isNotEmpty
// //                   ? Image.network(
// //                       imageUrl,
// //                       height: 100, // Adjust image height
// //                       width: 100, // Adjust image width
// //                       fit: BoxFit.cover,
// //                     )
// //                   : const Icon(Icons.directions_car,
// //                       color: Colors.green, size: 60),
// //               const SizedBox(height: 8.0),
// //               Text(
// //                 vehicleName,
// //                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //               ),
// //               Text(
// //                 vehicleType,
// //                 style: const TextStyle(fontSize: 14, color: Colors.grey),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class RideController {
// //   // Method to calculate the distance between two coordinates in kilometers
// //   double calculateDistance(double startLatitude, double startLongitude,
// //       double endLatitude, double endLongitude) {
// //     const double radiusOfEarthKm = 6371;
// //     double latDistance = (endLatitude - startLatitude) * pi / 180;
// //     double lonDistance = (endLongitude - startLongitude) * pi / 180;

// //     double a = sin(latDistance / 2) * sin(latDistance / 2) +
// //         cos(startLatitude * pi / 180) *
// //             cos(endLatitude * pi / 180) *
// //             sin(lonDistance / 2) *
// //             sin(lonDistance / 2);
// //     double c = 2 * atan2(sqrt(a), sqrt(1 - a));

// //     return radiusOfEarthKm * c; // Distance in km
// //   }

// //   // Method to calculate fare based on the distance
// //   double calculateFare(double distanceInKm) {
// //     if (distanceInKm <= 2) {
// //       return 40; // Flat rate for 2 km or less
// //     } else {
// //       return 40 +
// //           ((distanceInKm - 2) * 20); // Additional Rs. 20 per km after 2 km
// //     }
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rideuser/Ridepage/ride_start.dart';
import 'package:rideuser/controller/ride_controller.dart';
import 'package:rideuser/widgets/auth_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  _RidePageState createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  bool _isLoadingLocation = false;
  final RideController _rideController = RideController();

  double? _currentLatitude = 9.938618;
  double? _currentLongitude = 76.32700;
  double? _destinationLatitude;
  double? _destinationLongitude;

  final GlobalKey<_MapContainerCardState> _mapContainerKey = GlobalKey();
  final RideService _rideService = RideService();
  final LocationService locationService = LocationService();
  List<Map<String, dynamic>> _nearbyDrivers = [];
  String? _selectedVehicleType;

  @override
  void initState() {
    super.initState();
    // Initialize the current location field with the default address
    _initializeDefaultLocation();
  }

Future<void> _initializeDefaultLocation() async {
  if (_currentLatitude == null || _currentLongitude == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Current location is not set.')),
    );
    return;
  }

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentLatitude!,
      _currentLongitude!,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String address =
          "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

      setState(() {
        _currentLocationController.text = address;
      });

      // Update the map with the default location
      _mapContainerKey.currentState
          ?.updateMapLocation(_currentLatitude!, _currentLongitude!);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error initializing location: $e')),
    );
  }
}


  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                SizedBox(width: 20),
                Text('Fetching location...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateDestinationLocation() async {
    if (_destinationController.text.isNotEmpty) {
      try {
        List<Location> locations =
            await locationFromAddress(_destinationController.text);
        if (locations.isNotEmpty) {
          Location location = locations.first;
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            String fullAddress =
                "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

            setState(() {
              _destinationController.text = fullAddress;
              _destinationLatitude = location.latitude;
              _destinationLongitude = location.longitude;
            });
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating destination location: $e')),
        );
      }
    }
  }

Future<void> _fetchNearbyDrivers(double latitude, double longitude) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userid');
    final token = prefs.getString('googletoken');
    final drivers = await _rideService.getNearByDrivers(
      userId: id!,
      pickupLatitude: latitude,
      pickupLongitude: longitude,
      dropLatitude: _destinationLatitude ?? latitude,
      dropLongitude: _destinationLongitude ?? longitude,
      accessToken: token!,
    );

    // Filter drivers based on the selected vehicle type
    final filteredDrivers = drivers.where((driver) {
      return driver['vehicleType'] == _selectedVehicleType;
    }).toList();

    setState(() {
      _nearbyDrivers = filteredDrivers;
    });

    if (_nearbyDrivers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No vehicles found around you.')),
      );
      _mapContainerKey.currentState?.clearMarkers(); // Clear any previous markers
    } else {
      // If vehicles are found, update the map with the driver markers
      _updateMapWithDrivers();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching nearby drivers: $e')),
    );
  }
}

void _updateMapWithDrivers() {
  _mapContainerKey.currentState?.clearMarkers(); // Clear existing markers first
  for (var driver in _nearbyDrivers) {
    double latitude = driver['latitude'];
    double longitude = driver['longitude'];

    // Choose an icon based on the vehicle type
    String iconImage;
    switch (driver['vehicleType']) {
      case 'Car':
        iconImage = "assets/vehicleLocation.png";
        break;
      case 'Auto':
        iconImage = "assets/vehicleLocation.png";
        break;
      default:
        iconImage = "assets/vehicleLocation.png";
    }

    _mapContainerKey.currentState?.addDriverMarker(latitude, longitude, iconImage);
  }
}


  void _selectVehicle(String vehicleType) {
    setState(() {
      _selectedVehicleType = vehicleType;
    });

    if (_currentLatitude != null && _currentLongitude != null) {
      _fetchNearbyDrivers(_currentLatitude!, _currentLongitude!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Booking'),
        backgroundColor: Colors.green,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LocationInputField(
                label: 'Current Location',
                controller: _currentLocationController,
                hint: 'Fetching location...',
                icon: Icons.my_location,
                onPressed: () async {
                  Position? position =
                      await locationService.getCurrentLocation();
                  if (position != null) {
                    setState(() {
                      _currentLatitude = position.latitude;
                      _currentLongitude = position.longitude;
                    });
                    _initializeDefaultLocation();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Unable to fetch current location.')),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              LocationInputField(
                label: 'Choose Destination',
                controller: _destinationController,
                hint: 'Enter destination',
                icon: Icons.location_pin,
                onPressed: _updateDestinationLocation,
              ),
              const SizedBox(height: 30),
              ReusableButton(
                text: 'Search',
                onPressed: () async {
                  if (_currentLatitude != null && _currentLongitude != null) {
                    _fetchNearbyDrivers(
                      _currentLatitude!,
                      _currentLongitude!,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please allow location access or wait for location to be fetched.')),
                    );

                    await locationService.getCurrentLocation();
                  }
                },
              ),
              const SizedBox(height: 30),
              MapContainerCard(
                key: _mapContainerKey,
                latitude: _currentLatitude,
                longitude: _currentLongitude,
              ),
              const SizedBox(height: 15),
              const Text(
                'Available Electric Vehicles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  VehicleCard(
                    vehicleName: 'Electric Car',
                    imageUrl: '',
                    vehicleType: 'Car',
                    onSelect: _selectVehicle,
                    isSelected: _selectedVehicleType == 'Car',
                  ),
                  VehicleCard(
                      vehicleName: 'Electric Auto',
                      imageUrl: '',
                      vehicleType: 'Auto',
                      onSelect: _selectVehicle,
                      isSelected: _selectedVehicleType == 'Auto'),
                ],
              ),
              const SizedBox(height: 15),
              ReusableButton(
                text: 'Request Ride',
                onPressed: () async {
                  double distance = _rideController.calculateDistance(
                      _currentLatitude!,
                      _currentLongitude!,
                      _destinationLatitude!,
                      _destinationLongitude!);

                  double fare = _rideController.calculateFare(distance);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final userId = prefs.getString('userid');
                  final paymentMethod = 'Online-Payment';
                  await _rideService.createRideRequest(
                    userId: userId!,
                    fare: fare,
                    distance: distance,
                    duration: distance * 2,
                    pickUpCoords: [_currentLatitude!, _currentLongitude!],
                    dropCoords: [_destinationLatitude!, _destinationLongitude!],
                    vehicleType: _selectedVehicleType ?? 'Car',
                    pickupLocation: _currentLocationController.text,
                    dropLocation: _destinationController.text,
                    paymentMethod: paymentMethod,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ride requested successfully!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}


// class MapContainerCard extends StatefulWidget {
//   final double? latitude;
//   final double? longitude;
//   final double? destinationLatitude;
//   final double? destinationLongitude;

//   const MapContainerCard({
//     super.key,
//     this.latitude,
//     this.longitude,
//     this.destinationLatitude,
//     this.destinationLongitude,
//   });

//   @override
//   _MapContainerCardState createState() => _MapContainerCardState();
// }

// class _MapContainerCardState extends State<MapContainerCard> {
//   MapboxMapController? _mapController;

//   @override
//   void dispose() {
//     _mapController?.dispose();
//     super.dispose();
//   }

//   void _onMapCreated(MapboxMapController controller) {
//     _mapController = controller;
//     updateMapLocation(widget.latitude, widget.longitude);
//   }

//   void updateMapLocation(double? latitude, double? longitude) {
//     if (_mapController != null && latitude != null && longitude != null) {
//       LatLng newPosition = LatLng(latitude, longitude);
//       _mapController!
//           .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 16.0));
//       _mapController!.clearSymbols();
//       _mapController!.addSymbol(SymbolOptions(
//         geometry: newPosition,
//         iconImage: "assets/liveLocation.png",
//         iconSize: 0.5,
//       ));
//     }
//   }

//   // Method to add driver markers to the map
// void addDriverMarker(double latitude, double longitude, String iconImage) {
//   _mapController?.addSymbol(SymbolOptions(
//     geometry: LatLng(latitude, longitude),
//     iconImage: iconImage,
//     iconSize: 0.5,
//   ));
// }

// void clearMarkers() {
//   _mapController?.clearSymbols();
// }


//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onVerticalDragUpdate: (details) {},
//       child: SizedBox(
//         height: 300,
//         width: double.infinity,
//         child: MapboxMap(
//           accessToken:
//               "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ", // Use your Mapbox token
//           initialCameraPosition: CameraPosition(
//             target: widget.latitude != null && widget.longitude != null
//                 ? LatLng(widget.latitude!, widget.longitude!)
//                 : const LatLng(9.968677, 76.318354),
//             zoom: 24,
//           ),
//           onMapCreated: _onMapCreated,
//           styleString: MapboxStyles.MAPBOX_STREETS,
//         ),
//       ),
//     );
//   }
// }


class MapContainerCard extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const MapContainerCard({super.key, this.latitude, this.longitude});

  @override
  _MapContainerCardState createState() => _MapContainerCardState();
}
class _MapContainerCardState extends State<MapContainerCard> {
  MapboxMapController? _mapController;
  bool _noVehiclesFound = false;

  void updateMapLocation(double? latitude, double? longitude) {
    if (_mapController != null && latitude != null && longitude != null) {
      LatLng newPosition = LatLng(latitude, longitude);
      _mapController!
          .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 16.0));
      _mapController!.clearSymbols();
      _mapController!.addSymbol(SymbolOptions(
        geometry: newPosition,
        iconImage: "assets/liveLocation.png",
        iconSize: 0.5,
      ));
    }
  }

  void addDriverMarker(double latitude, double longitude, String iconImage) {
    setState(() {
      _noVehiclesFound = false; // Reset the flag when adding a driver marker
    });
    _mapController?.addSymbol(SymbolOptions(
      geometry: LatLng(latitude, longitude),
      iconImage: iconImage,
      iconSize: 0.5,
    ));
  }

  void clearMarkers() {
    _mapController?.clearSymbols();
    setState(() {
      _noVehiclesFound = true; // Set flag to true if no markers are added
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: MapboxMap(
            accessToken:
                "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ", // Use your Mapbox token
            initialCameraPosition: CameraPosition(
              target: widget.latitude != null && widget.longitude != null
                  ? LatLng(widget.latitude!, widget.longitude!)
                  : const LatLng(9.968677, 76.318354),
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            styleString: MapboxStyles.MAPBOX_STREETS,
          ),
        ),
        if (_noVehiclesFound)
          Center(
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'No vehicles found around you.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }
}
