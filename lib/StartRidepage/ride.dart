
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;

// class RidePage extends StatefulWidget {
//   @override
//   _RidePageState createState() => _RidePageState();
// }

// class _RidePageState extends State<RidePage> {
//   final TextEditingController _currentLocationController =
//       TextEditingController();
//   final TextEditingController _destinationController = TextEditingController();
//   bool _isLoadingLocation = false;
// // static const IconData location = IconData(0xf6ee, fontFamily: iconFont, fontPackage: iconFontPackage);
//   // Coordinates of the current location
//   double? _currentLatitude;
//   double? _currentLongitude;
//   double? _destinationLatitude;
//   double? _destinationLongitude;
//   // Key for MapContainerCard to reference and update its state
//   final GlobalKey<_MapContainerCardState> _mapContainerKey = GlobalKey();

//   // Function to show a loading dialog
//   void _showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent dismissal by tapping outside
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

//   // Function to get current location
//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _currentLocationController.clear();
//       _isLoadingLocation = true;
//     });

//     _showLoadingDialog();

//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text(
//                 'Location services are disabled. Please enable them in settings.')),
//       );
//       setState(() {
//         _isLoadingLocation = false;
//       });
//       Navigator.pop(context);
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content:
//                   Text('Location permission denied. Please allow access.')),
//         );
//         setState(() {
//           _isLoadingLocation = false;
//         });
//         Navigator.pop(context);
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text(
//                 'Location permissions are permanently denied. Please enable them in settings.')),
//       );
//       setState(() {
//         _isLoadingLocation = false;
//       });
//       Navigator.pop(context);
//       return;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.bestForNavigation);

//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];

//         String address =
//             "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

//         setState(() {
//           _currentLatitude = position.latitude;
//           _currentLongitude = position.longitude;
//           _currentLocationController.text = address;
//         });

//         // Update map location with fetched coordinates
//         _mapContainerKey.currentState
//             ?.updateMapLocation(position.latitude, position.longitude);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching location: $e')),
//       );
//     }

//     setState(() {
//       _isLoadingLocation = false;
//     });

//     Navigator.pop(context);
//   }

//   // Function to update the map with the address entered in the TextField
//   Future<void> _updateMapLocationFromTextField() async {
//     if (_currentLocationController.text.isNotEmpty) {
//       try {
//         List<Location> locations =
//             await locationFromAddress(_currentLocationController.text);
//         if (locations.isNotEmpty) {
//           double latitude = locations[0].latitude;
//           double longitude = locations[0].longitude;

//           setState(() {
//             _currentLatitude = latitude;
//             _currentLongitude = longitude;
//           });

//           // Update map to the new location
//           _mapContainerKey.currentState?.updateMapLocation(latitude, longitude);
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating map location: $e')),
//         );
//       }
//     }
//   }

// Future<void> _updateDestinationLocation() async {
//   if (_destinationController.text.isNotEmpty) {
//     try {
//       // Get location from the entered address
//       List<Location> locations = await locationFromAddress(_destinationController.text);
//       if (locations.isNotEmpty) {
//         Location location = locations.first;

//         // Reverse geocode to get the full address
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//             location.latitude, location.longitude);

//         if (placemarks.isNotEmpty) {
//           Placemark place = placemarks[0];

//           // Create the full address from available fields
//           String fullAddress =
//               "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

//           // Update the destination text field with the full address
//           setState(() {
//             _destinationController.text = fullAddress;
//             _destinationLatitude = location.latitude;
//             _destinationLongitude = location.longitude;
//           });

     
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating destination location: $e')),
//       );
//     }
//   }
// }




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
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Current Location',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 // Wrap TextField in SizedBox to control its width
//                 SizedBox(
//                   width: 200, // Set your desired width here
//                   child: AbsorbPointer(
//                     absorbing: true, // Prevents interaction with the TextField
//                     child: TextField(
//                       controller: _currentLocationController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.grey.shade300),
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         hintText: 'Current location',
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                     width: 8), // Add spacing between TextField and IconButton
//                 IconButton(
//                   icon: Icon(Icons.location_city_outlined, color: Colors.blue),
//                   onPressed:
//                       _getCurrentLocation, // Calls the function to get the location
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Choose Destination',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 // Wrap TextField in SizedBox to control its width
//                 SizedBox(
//                   width: 200, // Set your desired width here
//                   child: TextField(
//                     controller: _destinationController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       hintText: 'choose location',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                     width: 8), // Add spacing between TextField and IconButton
//                 IconButton(
//                   icon: Icon(Icons.location_city_outlined, color: Colors.blue),
//                   onPressed: () {
//                     _updateDestinationLocation();
//                   },
//                 ),
//               ],
//             ),
               
//             const SizedBox(height: 20),
//             const Text(
//               'Available Electric Vehicles',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             VehicleCard(
//               vehicleName: 'Electric Car',
//               imageUrl: '',
//               vehicleType: 'Auto',
//             ),
//             VehicleCard(
//               vehicleName: 'Electric Bike',
//               imageUrl: '',
//               vehicleType: 'Bike',
//             ),
//             SizedBox(height: 15),
//             Expanded(
//               child: MapContainerCard(
//                 key: _mapContainerKey,
//                 latitude: _currentLatitude,
//                 longitude: _currentLongitude,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VehicleCard extends StatelessWidget {
//   final String vehicleName;
//   final String imageUrl;
//   final String vehicleType;

//   VehicleCard(
//       {required this.vehicleName,
//       required this.imageUrl,
//       required this.vehicleType});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       child: ListTile(
//         leading: imageUrl.isNotEmpty
//             ? Image.network(imageUrl)
//             : Icon(Icons.directions_car),
//         title: Text(vehicleName),
//         subtitle: Text(vehicleType),
//       ),
//     );
//   }
// }

// class MapContainerCard extends StatefulWidget {
//   final double? latitude;
//   final double? longitude;
//   final double? destinationLatitude;
//   final double? destinationLongitude;

//   MapContainerCard(
//       {Key? key,
//       this.latitude,
//       this.longitude,
//       this.destinationLatitude,
//       this.destinationLongitude})
//       : super(key: key);

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
//         iconImage: "assets/icon.png",
//         iconSize: 0.5,
//       ));
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: double.infinity,
//       child: MapboxMap(
//         accessToken:
//             "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
//         initialCameraPosition: CameraPosition(
//           target: widget.latitude != null && widget.longitude != null
//               ? LatLng(widget.latitude!, widget.longitude!)
//               : const LatLng(9.968677, 76.318354), 
//           zoom: 14.0,
//         ),
//         onMapCreated: _onMapCreated,
//         styleString: MapboxStyles.MAPBOX_STREETS,
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:rideuser/widgets/auth_widgets.dart';

class RidePage extends StatefulWidget {
  @override
  _RidePageState createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  final TextEditingController _currentLocationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  bool _isLoadingLocation = false;

  double? _currentLatitude;
  double? _currentLongitude;
  double? _destinationLatitude;
  double? _destinationLongitude;

  final GlobalKey<_MapContainerCardState> _mapContainerKey = GlobalKey();

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
                SizedBox(width: 20),
                Text('Fetching location...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentLocationController.clear();
      _isLoadingLocation = true;
    });

    _showLoadingDialog();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable them in settings.')),
      );
      setState(() {
        _isLoadingLocation = false;
      });
      Navigator.pop(context);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied. Please allow access.')),
        );
        setState(() {
          _isLoadingLocation = false;
        });
        Navigator.pop(context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied. Please enable them in settings.')),
      );
      setState(() {
        _isLoadingLocation = false;
      });
      Navigator.pop(context);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

        setState(() {
          _currentLatitude = position.latitude;
          _currentLongitude = position.longitude;
          _currentLocationController.text = address;
        });

        _mapContainerKey.currentState?.updateMapLocation(position.latitude, position.longitude);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }

    setState(() {
      _isLoadingLocation = false;
    });

    Navigator.pop(context);
  }

  Future<void> _updateDestinationLocation() async {
    if (_destinationController.text.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(_destinationController.text);
        if (locations.isNotEmpty) {
          Location location = locations.first;
          List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            String fullAddress = "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationInputField(
                label: 'Current Location',
                controller: _currentLocationController,
                hint: 'Fetching location...',
                icon: Icons.my_location,
                onPressed: _getCurrentLocation,
              ),
              SizedBox(height: 20),
              _buildLocationInputField(
                label: 'Choose Destination',
                controller: _destinationController,
                hint: 'Enter destination',
                icon: Icons.location_pin,
                onPressed: _updateDestinationLocation,
              ),
              SizedBox(height: 30),
              const Text(
                'Available Electric Vehicles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 VehicleCard(vehicleName: 'Electric Car', imageUrl: '', vehicleType: 'Car'),
              VehicleCard(vehicleName: 'Electric Auto', imageUrl: '', vehicleType: 'Auto'),
              ],
             ),
              SizedBox(height: 15),
              MapContainerCard(
                key: _mapContainerKey,
                latitude: _currentLatitude,
                longitude: _currentLongitude,
              ),
            
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: hint,
                ),
              ),
            ),
            IconButton(
              icon: Icon(icon, color: Colors.blue),
              onPressed: onPressed,
            ),
          ],
        ),
      ],
    );
  }
}


class VehicleCard extends StatelessWidget {
  final String vehicleName;
  final String imageUrl;
  final String vehicleType;

  VehicleCard({
    required this.vehicleName,
    required this.imageUrl,
    required this.vehicleType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 150,  // Set custom width
        height: 130, // Set custom height
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 100, // Adjust image height
                    width: 100,  // Adjust image width
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.directions_car, color: Colors.green, size: 60),
            SizedBox(height: 8.0),
            Text(
              vehicleName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              vehicleType,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class MapContainerCard extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double? destinationLatitude;
  final double? destinationLongitude;

  MapContainerCard({
    Key? key,
    this.latitude,
    this.longitude,
    this.destinationLatitude,
    this.destinationLongitude,
  }) : super(key: key);

  @override
  _MapContainerCardState createState() => _MapContainerCardState();
}

class _MapContainerCardState extends State<MapContainerCard> {
  MapboxMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    updateMapLocation(widget.latitude, widget.longitude);
  }

  void updateMapLocation(double? latitude, double? longitude) {
    if (_mapController != null && latitude != null && longitude != null) {
      LatLng newPosition = LatLng(latitude, longitude);
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14.0));
      _mapController!.clearSymbols();
      _mapController!.addSymbol(SymbolOptions(
        geometry: newPosition,
        iconImage: "assets/icon.png",
        iconSize: 0.5,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: MapboxMap(
        accessToken: "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
        initialCameraPosition: CameraPosition(
          target: widget.latitude != null && widget.longitude != null
              ? LatLng(widget.latitude!, widget.longitude!)
              : const LatLng(9.968677, 76.318354),
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
        styleString: MapboxStyles.MAPBOX_STREETS,
      ),
    );
  }
}
